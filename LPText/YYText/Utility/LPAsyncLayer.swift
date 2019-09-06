//
//  LPTextAsyncLayer.swift
//  LPText
//
//  Created by pengli on 2019/9/5.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

/// The LPAsyncLayer's delegate protocol. The delegate of the LPAsyncLayer (typically a UIView)
/// must implements the method in this protocol.
@objc protocol LPAsyncLayerDelegate: class {
    /// This method is called to return a new display task when the layer's contents need update.
    @objc var newAsyncDisplayTask: LPAsyncLayerDisplayTask { get }
}

/// A display task used by YYTextAsyncLayer to render the contents in background queue.
class LPAsyncLayerDisplayTask: NSObject {
    // This block will be called before the asynchronous drawing begins.
    // It will be called on the main thread.
    //
    // block param layer: The layer.
    @objc var willDisplay: ((_ layer: CALayer) -> Void)?
    
    // This block is called to draw the layer's contents.
    //
    // @discussion This block may be called on main thread or background thread,
    // so is should be thread-safe.
    //
    // block param context:      A new bitmap content created by layer.
    // block param size:         The content size (typically same as layer's bound size).
    // block param isCancelled:  If this block returns `YES`, the method should cancel the
    // drawing process and return as quickly as possible.
    @objc var display: ((_ context: CGContext?, _ size: CGSize, _ isCancelled: (() -> Bool)) -> Void)?
    
    // This block will be called after the asynchronous drawing finished.
    // It will be called on the main thread.
    //
    // block param layer:  The layer.
    // block param finished:  If the draw process is cancelled, it's `NO`, otherwise it's `YES`;
    @objc var didDisplay: ((_ layer: CALayer, _ finished: Bool) -> Void)?
}

/// The YYTextAsyncLayer class is a subclass of CALayer used for render contents asynchronously.
///
/// @discussion When the layer need update it's contents, it will ask the delegate
/// for a async display task to render the contents in a background queue.
class LPAsyncLayer: CALayer {
    /// Whether the render code is executed in background. Default is true.
    @objc var isDisplaysAsynchronously = true
    private var sentinel = LPTextSentinel()
    
    deinit {
        sentinel.increase()
        print("LPAsyncLayer -> release memory.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentsScale = UIScreen.main.scale
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        contentsScale = UIScreen.main.scale
    }
    
    override init() {
        super.init()
        contentsScale = UIScreen.main.scale
    }
    
    override class func defaultValue(forKey key: String) -> Any? {
        if key == "isDisplaysAsynchronously" {
            return true
        } else {
            return super.defaultValue(forKey: key)
        }
    }
    
    override func setNeedsDisplay() {
        cancelAsyncDisplay()
        super.setNeedsDisplay()
    }
    
    override func display() {
        super.contents = super.contents
        display(async: isDisplaysAsynchronously)
    }
    
    private func display(async: Bool) {
        guard let delegate = delegate as? LPAsyncLayerDelegate else {
            return assert(false, "override class var layerClass: AnyClass { return LPAsyncLayer.self }")
        }
        
        let task = delegate.newAsyncDisplayTask
        if task.display == nil {
            task.willDisplay?(self)
            contents = nil
            task.didDisplay?(self, true)
            return
        }
        if async {
            task.willDisplay?(self)
            let sentinel = self.sentinel
            let value = sentinel.value.rawValue
            let isCancelled: () -> Bool = { return value != sentinel.value.rawValue }
            let size = bounds.size
            let opaque = isOpaque
            let scale = contentsScale
            let bgColor = opaque ? backgroundColor : nil
            
            if size.width < 1 || size.height < 1 {
                contents = nil
                task.didDisplay?(self, true)
                return
            }
            
            DispatchQueue.lp_asyncLayerGetDisplayQueue.async {
                if isCancelled() { return }
                UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
                
                let context = UIGraphicsGetCurrentContext()
                if let context = context, opaque {
                    context.saveGState()
                    if bgColor == nil || bgColor!.alpha < 1 {
                        context.setFillColor(UIColor.white.cgColor)
                        context.addRect(CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale))
                        context.fillPath()
                    }
                    if let bgColor = bgColor {
                        context.setFillColor(bgColor)
                        context.addRect(CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale))
                        context.fillPath()
                    }
                    context.restoreGState()
                }
                task.display?(context, size, isCancelled)
                
                if isCancelled() {
                    UIGraphicsEndImageContext()
                    DispatchQueue.main.async { [weak self] in
                        guard let `self` = self else { return }
                        task.didDisplay?(self, false)
                    }
                    return
                }
                
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if isCancelled() {
                    DispatchQueue.main.async { [weak self] in
                        guard let `self` = self else { return }
                        task.didDisplay?(self, false)
                    }
                    return
                }
                
                DispatchQueue.main.async {  [weak self] in
                    guard let `self` = self else { return }
                    if isCancelled() {
                        task.didDisplay?(self, false)
                    } else {
                        self.contents = image?.cgImage
                        task.didDisplay?(self, true)
                    }
                }
            }
        } else {
            sentinel.increase()
            task.willDisplay?(self)
            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, contentsScale)
            let context = UIGraphicsGetCurrentContext()
            if let context = context, isOpaque {
                var size = bounds.size
                size.width *= contentsScale
                size.height *= contentsScale
                context.saveGState()
                if backgroundColor == nil || backgroundColor!.alpha < 1 {
                    context.setFillColor(UIColor.white.cgColor)
                    context.addRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    context.fillPath()
                }
                if let bgColor = backgroundColor {
                    context.setFillColor(bgColor)
                    context.addRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    context.fillPath()
                }
                context.restoreGState()
            }
            
            task.display?(context, bounds.size, { return false })
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            contents = image?.cgImage
            task.didDisplay?(self, true)
        }
    }
    
    private func cancelAsyncDisplay() {
        sentinel.increase()
    }
}

// MARK: - LPTextSentinel

/// a thread safe incrementing counter.
private class LPTextSentinel {
    /// Returns the current value of the counter.
    var value: LPAtomic<Int32> = LPAtomic(0)
    
    /// Increase the value atomically. @return The new value.
    func increase() {
        OSAtomicIncrement32(&value.rawValue)
    }
    
    deinit {
        print("LPTextSentinel -> release memory.")
    }
}

// MARK: - Global display queue, used for content rendering.

extension DispatchQueue {
    /// Global display queue, used for content rendering.
    static fileprivate var lp_asyncLayerGetDisplayQueue: DispatchQueue {
        return lp_queues[Int(OSAtomicIncrement32(&lp_counter)) % lp_queueCount]
    }
    static private let lp_queues: [DispatchQueue] = {
        var queues: [DispatchQueue] = []
        for i in 0..<lp_queueCount {
            let qos = DispatchQoS(qosClass: .userInitiated, relativePriority: 0)
            queues.append(DispatchQueue(label: "com.lp.text.render", qos: qos))
        }
        return queues
    }()
    static private let lp_queueCount: Int = {
        let count = ProcessInfo().activeProcessorCount
        return count < 1 ? 1 : (count > 16 ? 16 : count)
    }()
    static private var lp_counter: Int32 = 0
}
