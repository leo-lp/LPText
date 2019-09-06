//
//  LPTextEditDemo.swift
//  LPText
//
//  Created by pengli on 2019/9/5.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPTextEditDemo: UIViewController, YYTextViewDelegate, YYTextKeyboardObserver {
    private var textView = YYTextView()
    private var imageView: UIImageView?
    private var verticalSwitch = UISwitch()
    private var debugSwitch = UISwitch()
    private var exclusionSwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let data = NSData(named: "dribbble256_imageio.png")! as Data
        let image = YYImage(data: data, scale: 2)
        imageView = YYAnimatedImageView(image: image)

        imageView?.clipsToBounds = true
        imageView?.isUserInteractionEnabled = true
        imageView?.layer.cornerRadius = imageView!.height / 2.0
        imageView?.center = CGPoint(x: UIScreen.main.bounds.width / 2.0, y: UIScreen.main.bounds.width / 2.0)
        
        imageView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler)))
        
        let toolbar = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        toolbar.size = CGSize(width: UIScreen.main.bounds.width, height: 40)
        toolbar.top = lp_topSafeArea
        view.addSubview(toolbar)
        
        let text = NSMutableAttributedString(string: "It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the season of light, it was the season of darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us. We were all going direct to heaven, we were all going direct the other way.\n\n这是最好的时代，这是最坏的时代；这是智慧的时代，这是愚蠢的时代；这是信仰的时期，这是怀疑的时期；这是光明的季节，这是黑暗的季节；这是希望之春，这是失望之冬；人们面前有着各样事物，人们面前一无所有；人们正在直登天堂，人们正在直下地狱。")
        text.yy_font = UIFont(name: "Times New Roman", size: 20)
        text.yy_lineSpacing = 4
        text.yy_firstLineHeadIndent = 20
        
        textView.attributedText = text
        textView.size = view.size
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.delegate = self
        textView.keyboardDismissMode = .interactive
        
        textView.contentInset = UIEdgeInsets(top: toolbar.bottom, left: 0, bottom: 0, right: 0)
        textView.scrollIndicatorInsets = textView.contentInset
        textView.selectedRange = NSRange(location: text.length, length: 0)
        view.insertSubview(textView, belowSubview: toolbar)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.textView.becomeFirstResponder()
        })
        
        //------------------------------ Toolbar ---------------------------------
        var label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Vertical:"
        label.size = CGSize(width: label.text!.width(for: label.font) + 2, height: toolbar.height)
        label.left = 10
        
        toolbar.contentView.addSubview(label)
        
        
        verticalSwitch.sizeToFit()
        verticalSwitch.centerY = toolbar.height / 2
        verticalSwitch.left = label.right - 5
        verticalSwitch.addBlock(for: .valueChanged) { [weak self](switcher) in
            guard let `self` = self, let switcher = switcher as? UISwitch else { return }
            self.textView.endEditing(true)
            if switcher.isOn {
                self.setExclusionPathEnabled(false)
                self.exclusionSwitch.isOn = false
            }
            self.exclusionSwitch.isEnabled = !switcher.isOn
            self.textView.isVerticalForm = switcher.isOn /// Set vertical form
        }
        toolbar.contentView.addSubview(verticalSwitch)
        
        label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Debug:"
        label.size = CGSize(width: label.text!.width(for: label.font) + 2, height: toolbar.height)
        label.left = verticalSwitch.right + 5
        toolbar.contentView.addSubview(label)
        
        debugSwitch.sizeToFit()
        debugSwitch.isOn = LPTextDemoHelper.isDebugEnabled
        debugSwitch.centerY = toolbar.height / 2
        debugSwitch.left = label.right - 5
        debugSwitch.addBlock(for: .valueChanged, block: { switcher in
            LPTextDemoHelper.setDebug((switcher as! UISwitch).isOn)
        })
        toolbar.contentView.addSubview(debugSwitch)
        
        label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Exclusion:"
        label.size = CGSize(width: label.text!.width(for: label.font) + 2, height: toolbar.height)
        label.left = debugSwitch.right + 5
        toolbar.contentView.addSubview(label)
        
        
        exclusionSwitch.sizeToFit()
        exclusionSwitch.centerY = toolbar.height / 2
        exclusionSwitch.left = label.right - 5
        exclusionSwitch.addBlock(for: .valueChanged, block: { switcher in
            self.setExclusionPathEnabled((switcher as! UISwitch).isOn)
        })
        toolbar.contentView.addSubview(exclusionSwitch)
        
        YYTextKeyboardManager.default()?.add(self)
    }
    
    deinit {
        YYTextKeyboardManager.default()?.remove(self)
        print("\(self) release memory.")
    }
    
    private func setExclusionPathEnabled(_ enabled: Bool) {
        if enabled {
            guard let imageView = imageView else { return }
            textView.addSubview(imageView)
            let path = UIBezierPath(roundedRect: imageView.frame, cornerRadius: imageView.layer.cornerRadius)
            textView.exclusionPaths = [path] /// Set exclusion paths
        } else {
            imageView?.removeFromSuperview()
            textView.exclusionPaths = nil
        }
    }
    
    @objc private func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        guard let imageView = imageView else { return }
        imageView.center = sender.location(in: textView)
        let path = UIBezierPath(roundedRect: imageView.frame, cornerRadius: imageView.layer.cornerRadius)
        textView.exclusionPaths = [path]
    }
    
    @objc private func editBtnClicked() {
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    func textViewDidBeginEditing(_ textView: YYTextView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(editBtnClicked))
    }
    
    func textViewDidEndEditing(_ textView: YYTextView) {
        navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - keyboard
    
    func keyboardChanged(with transition: YYTextKeyboardTransition) {
        var clipped = false
        if textView.isVerticalForm && transition.toVisible.boolValue {
            let rect = YYTextKeyboardManager.default()!.convert(transition.toFrame, to: view)
            if rect.maxY == view.height {
                var textFrame: CGRect = view.bounds
                textFrame.size.height -= rect.size.height
                textView.frame = textFrame
                clipped = true
            }
        }
        
        if !clipped {
            textView.frame = view.bounds
        }
    }
}
