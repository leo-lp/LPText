//
//  LPFPSLabel.swift
//  LPText
//
//  Created by pengli on 2019/9/5.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

/// Show Screen FPS...
///
/// The maximum fps in OSX/iOS Simulator is 60.00.
/// The maximum fps on iPhone is 59.97.
/// The maxmium fps on iPad is 60.0.
class LPFPSLabel: UILabel {
    private static let kSize = CGSize(width: 55, height: 20)
    private var link: CADisplayLink?
    private var subFont: UIFont?
    private var lastTime: TimeInterval = 0
    private var count: UInt = 0
    
    override init(frame: CGRect) {
        var frame = frame
        if frame.size == .zero {
            frame.size = LPFPSLabel.kSize
        }
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        clipsToBounds = true
        textAlignment = .center
        isUserInteractionEnabled = false
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        font = UIFont(name: "Menlo", size: 14)
        if (font != nil) {
            subFont = UIFont(name: "Menlo", size: 4)
        } else {
            font = UIFont(name: "Courier", size: 14)
            subFont = UIFont(name: "Courier", size: 4)
        }
        
        link = CADisplayLink(target: LPWeakProxy(self), selector: #selector(LPWeakProxy.onTick))
        link?.add(to: .main, forMode: .common)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        link?.invalidate()
        #if DEBUG
        print("\(self) release memory.")
        #endif
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return LPFPSLabel.kSize
    }
    
    @objc fileprivate func tick(_ link: CADisplayLink) {
        if lastTime == 0 {
            return lastTime = link.timestamp
        }
        
        count += 1
        let delta: TimeInterval = link.timestamp - lastTime
        if delta < 1 {
            return
        }
        lastTime = link.timestamp
        let fps = Double(count) / delta
        count = 0
        
        let progress = CGFloat(fps / 60.0)
        let color = UIColor(hue: 0.27 * (progress - 0.2), saturation: 1, brightness: 0.9, alpha: 1)
        
        let text = NSMutableAttributedString(string: "\(Int(round(fps))) FPS")
        text.yy_setColor(color, range: NSRange(location: 0, length: text.length - 3))
        text.yy_setColor(UIColor.white, range: NSRange(location: text.length - 3, length: 3))
        text.yy_font = font
        text.yy_setFont(subFont, range: NSRange(location: text.length - 4, length: 1))
        attributedText = text
    }
    
    private class LPWeakProxy {
        private weak var target: LPFPSLabel?
        init(_ target: LPFPSLabel?) {
            self.target = target
        }
        @objc func onTick(_ link: CADisplayLink) {
            target?.tick(link)
        }
    }
}
