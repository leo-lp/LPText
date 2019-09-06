//
//  LPTextAttachmentDemo.swift
//  LPText
//
//  Created by pengli on 2019/9/4.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPTextAttachmentDemo: UIViewController, UIGestureRecognizerDelegate {
    private lazy var label = YYLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        LPTextDemoHelper.addDebugOption(to: self)
        
        let text = NSMutableAttributedString()
        let font = UIFont.systemFont(ofSize: 16)
        do {
            let title = "This is UIImage attachment:"
            text.append(NSAttributedString(string: title, attributes: nil))
            
            var image = UIImage(named: "dribbble64_imageio")!
            image = UIImage(cgImage: image.cgImage!, scale: 2, orientation: .up)
            
            let attachText = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: image.size, alignTo: font, alignment: .center)
            text.append(attachText)
            text.append(NSAttributedString(string: "\n", attributes: nil))
        }
        do {
            let title = "This is UIView attachment: "
            text.append(NSAttributedString(string: title, attributes: nil))
            
            let switcher = UISwitch()
            switcher.sizeToFit()
            
            let attachText = NSMutableAttributedString.yy_attachmentString(withContent: switcher, contentMode: .center, attachmentSize: switcher.size, alignTo: font, alignment: .center)
            text.append(attachText)
            text.append(NSAttributedString(string: "\n", attributes: nil))
        }
        do {
            let title = "This is Animated Image attachment:"
            text.append(NSAttributedString(string: title, attributes: nil))
            
            let names = ["001@2x", "022@2x", "019@2x", "056@2x", "085@2x"]
            for name: String in names {
                let fileURL = Bundle.main.url(forResource: name, withExtension: "gif", subdirectory: "EmoticonQQ.bundle")!
                let data = try! Data(contentsOf: fileURL)
                let image = YYImage(data: data, scale: 2)
                image?.preloadAllAnimatedImageFrames = true
                let imageView = YYAnimatedImageView(image: image)
                let attachText = NSMutableAttributedString.yy_attachmentString(withContent: imageView, contentMode: .center, attachmentSize: imageView.size, alignTo: font, alignment: .center)
                text.append(attachText)
            }
            
            let image = YYImage(named: "pia")
            image?.preloadAllAnimatedImageFrames = true
            let imageView = YYAnimatedImageView(image: image)
            imageView.autoPlayAnimatedImage = false
            imageView.startAnimating()
            
            let attachText = NSMutableAttributedString.yy_attachmentString(withContent: imageView, contentMode: .center, attachmentSize: imageView.size, alignTo: font, alignment: .bottom)
            text.append(attachText)
            text.append(NSAttributedString(string: "\n", attributes: nil))
        }
        
        text.yy_font = font
        
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.textVerticalAlignment = .top
        label.size = CGSize(width: 260, height: 260)
        label.center = CGPoint(x: view.width / 2, y: view.height / 2)
        label.attributedText = text
        addSeeMoreButton()
        view.addSubview(label)
        
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor(red: 0.000, green: 0.463, blue: 1.000, alpha: 1.000).cgColor
        
        let dot = newDotView()
        dot.center = CGPoint(x: label.width, y: label.height)
        dot.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        label.addSubview(dot)
        
        let gesture = YYGestureRecognizer()
        gesture.action = { [weak self](gesture, state) in
            guard state == .moved else { return }
            let width = gesture!.currentPoint.x
            let height = gesture!.currentPoint.y
            self?.label.size = CGSize(width: width < 30 ? 30 : width, height: height < 30 ? 30 : height)
        }
        gesture.delegate = self
        label.addGestureRecognizer(gesture)
    }
    
    private func addSeeMoreButton() {
        let text = NSMutableAttributedString(string: "...more")
        
        let hi = YYTextHighlight()
        hi.setColor(UIColor(red: 0.578, green: 0.79, blue: 1, alpha: 1))
        hi.tapAction = { [weak self] (containerView, text, range, rect) in
            self?.label.sizeToFit()
        }
        
        text.yy_setColor(UIColor(red: 0.000, green: 0.449, blue: 1.000, alpha: 1.000), range: ((text.string as NSString).range(of: "more")))
        text.yy_setTextHighlight(hi, range: ((text.string as NSString).range(of: "more")))
        text.yy_font = label.font
        
        let seeMore = YYLabel()
        seeMore.attributedText = text
        seeMore.sizeToFit()
        
        label.truncationToken = NSAttributedString.yy_attachmentString(withContent: seeMore, contentMode: .center, attachmentSize: seeMore.size, alignTo: text.yy_font!, alignment: .center)
    }
    
    private func newDotView() -> UIView {
        let view = UIView()
        view.size = CGSize(width: 50, height: 50)
        
        let dot = UIView()
        dot.size = CGSize(width: 10, height: 10)
        dot.backgroundColor = UIColor(red: 0, green: 0.463, blue: 1, alpha: 1)
        dot.clipsToBounds = true
        dot.layer.cornerRadius = dot.height / 2
        dot.center = CGPoint(x: view.width / 2, y: view.height / 2)
        view.addSubview(dot)
        return view
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let p = gestureRecognizer.location(in: label)
        if p.x < label.width - 20 || p.y < label.height - 20 {
            return false
        }
        return true
    }
}
