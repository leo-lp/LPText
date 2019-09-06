//
//  LPTextAttributeDemo.swift
//  LPText
//
//  Created by pengli on 2019/9/3.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPTextAttributeDemo: UIViewController {
    
    deinit {
        print("\(self) release memory.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        LPTextDemoHelper.addDebugOption(to: self)
        
        let text = NSMutableAttributedString()
        do {
            let one = NSMutableAttributedString(string: "Shadow")
            one.yy_font = UIFont.boldSystemFont(ofSize: 30)
            one.yy_color = UIColor.white
            let shadow = YYTextShadow()
            shadow.color = UIColor(white: 0, alpha: 0.49)
            shadow.offset = CGSize(width: 0, height: 1)
            shadow.radius = 5
            one.yy_textShadow = shadow
            text.append(one)
            text.append(padding)
        }
        do {
            let one = NSMutableAttributedString(string: "Inner Shadow")
            one.yy_font = UIFont.boldSystemFont(ofSize: 30)
            one.yy_color = UIColor.white
            let shadow = YYTextShadow()
            shadow.color = UIColor(white: 0, alpha: 0.4)
            shadow.offset = CGSize(width: 0, height: 1)
            shadow.radius = 1
            one.yy_textShadow = shadow
            text.append(one)
            text.append(padding)
        }
        do {
            let one = NSMutableAttributedString(string: "Multiple Shadows")
            one.yy_font = UIFont.boldSystemFont(ofSize: 30)
            one.yy_color = UIColor(red: 1, green: 0.795, blue: 0.014, alpha: 1)
            let shadow = YYTextShadow()
            shadow.color = UIColor(white: 0, alpha: 0.2)
            shadow.offset = CGSize(width: 0, height: -1)
            shadow.radius = 1.5
            
            let subShadow = YYTextShadow()
            subShadow.color = UIColor(white: 1, alpha: 0.99)
            subShadow.offset = CGSize(width: 0, height: 1)
            subShadow.radius = 1.5
            shadow.sub = subShadow
            one.yy_textShadow = shadow
            
            let innerShadow = YYTextShadow()
            innerShadow.color = UIColor(red: 0.851, green: 0.311, blue: 0, alpha: 0.78)
            innerShadow.offset = CGSize(width: 0, height: 1)
            innerShadow.radius = 1
            one.yy_textInnerShadow = innerShadow
            text.append(one)
            text.append(padding)
        }
        do {
            let one = NSMutableAttributedString(string: "Background Image")
            one.yy_font = UIFont.boldSystemFont(ofSize: 30)
            one.yy_color = UIColor(red: 1, green: 0.795, blue: 0.014, alpha: 1)
            let size = CGSize(width: 20, height: 20)
            let background = UIImage.yy_image(with: size) { (context) in
                guard let context = context else { return }
                let c0 = UIColor(red: 0.054, green: 0.879, blue: 0.00, alpha: 1)
                let c1 = UIColor(red: 0.869, green: 1.000, blue: 0.03, alpha: 1)
                c0.setFill()
                context.fill(CGRect(origin: .zero, size: size))
                c1.setStroke()
                context.setLineWidth(2)
                
                var i: CGFloat = 0
                while i < size.width * 2 {
                    context.move(to: CGPoint(x: i, y: -2))
                    context.addLine(to: CGPoint(x: i - size.height, y: size.height + 2))
                    i += 4
                }
                context.strokePath()
            }
            
            one.yy_color = UIColor(patternImage: background!)
            text.append(one)
            text.append(padding)
        }
        do {
            let one = NSMutableAttributedString(string: "Border")
            one.yy_font = UIFont.boldSystemFont(ofSize: 30)
            one.yy_color = UIColor(red: 1, green: 0.029, blue: 0.651, alpha: 1)
            
            let border = YYTextBorder()
            border.strokeColor = UIColor(red: 1, green: 0.029, blue: 0.651, alpha: 1)
            border.strokeWidth = 3
            border.lineStyle = YYTextLineStyle.patternCircleDot
            border.cornerRadius = 3
            border.insets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: -4)
            one.yy_textBackgroundBorder = border
            
            text.append(padding)
            text.append(one)
            text.append(padding)
            text.append(padding)
            text.append(padding)
            text.append(padding)
        }
        do {
            let one = NSMutableAttributedString(string: "Link")
            one.yy_font = UIFont.boldSystemFont(ofSize: 30)
            one.yy_underlineStyle = .single
            
            /// 1. you can set a highlight with these code
            /*
             one.yy_color = UIColor(red: 0.093, green: 0.492, blue: 1.000, alpha: 1.000)
             
             let border = YYTextBorder()
             border.cornerRadius = 3
             border.insets = UIEdgeInsets(top: -2, left: -1, bottom: -2, right: -1)
             border.fillColor = UIColor(white: 0, alpha: 0.22)
             
             let highlight = TextHighlight()
             highlight.border = border
             highlight.tapAction = { containerView, text, range, rect in
             _self?.showMessage("Tap: \((text?.string as NSString?)?.substring(with: range) ?? "")")
             }
             one.yy_set(textHighlight: highlight, range: one.bs_rangeOfAll)
             */
            
            /// 2. or you can use the convenience method
            one.yy_setTextHighlight(one.yy_rangeOfAll(), color: UIColor(red: 0.093, green: 0.492, blue: 1.000, alpha: 1.000), backgroundColor: UIColor(white: 0.000, alpha: 0.220), userInfo: nil, tapAction: { [weak self](containerView, text, range, rect) in
                self?.showMessage("Tap: \(text.attributedSubstring(from: range).string)")
            }, longPressAction: nil)
            text.append(one)
            text.append(padding)
        }

        do {
            let one = NSMutableAttributedString(string: "Another Link")
            one.yy_font = UIFont.boldSystemFont(ofSize: 30)
            one.yy_color = UIColor.red
            
            let border = YYTextBorder()
            border.cornerRadius = 50
            border.insets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -10)
            border.strokeWidth = 0.5
            border.strokeColor = one.yy_color
            border.lineStyle = .single
            one.yy_textBackgroundBorder = border
            
            let highlightBorder = border.copy() as! YYTextBorder
            highlightBorder.strokeWidth = 0
            highlightBorder.strokeColor = one.yy_color
            highlightBorder.fillColor = one.yy_color
            
            let highlight = YYTextHighlight()
            highlight.setColor(UIColor.white)
            highlight.setBackgroundBorder(highlightBorder)
            highlight.tapAction = { [weak self](containerView, text, range, rect) in
                self?.showMessage("Tap: \(text.attributedSubstring(from: range).string)")
            }
            one.yy_setTextHighlight(highlight, range: one.yy_rangeOfAll())
            
            text.append(one)
            text.append(padding)
        }
        do {
            let one = NSMutableAttributedString(string: "Yet Another Link")
            one.yy_font = UIFont.boldSystemFont(ofSize: 30)
            one.yy_color = UIColor.white
            
            let shadow = YYTextShadow()
            shadow.color = UIColor(white: 0, alpha: 0.49)
            shadow.offset = CGSize(width: 0, height: 1)
            shadow.radius = 5
            one.yy_textShadow = shadow
            
            let shadow0 = YYTextShadow()
            shadow0.color = UIColor(white: 0, alpha: 0.2)
            shadow0.offset = CGSize(width: 0, height: -1)
            shadow0.radius = 1.5
            let shadow1 = YYTextShadow()
            shadow1.color = UIColor(white: 1, alpha: 0.99)
            shadow1.offset = CGSize(width: 0, height: 1)
            shadow1.radius = 1.5
            shadow0.sub = shadow1
            
            let innerShadow0 = YYTextShadow()
            innerShadow0.color = UIColor(red: 0.851, green: 0.311, blue: 0, alpha: 0.78)
            innerShadow0.offset = CGSize(width: 0, height: 1)
            innerShadow0.radius = 1
            
            let highlight = YYTextHighlight()
            highlight.setColor(UIColor(red: 1, green: 0.795, blue: 0.014, alpha: 1))
            highlight.setShadow(shadow0)
            highlight.setInnerShadow(innerShadow0)
            one.yy_setTextHighlight(highlight, range: one.yy_rangeOfAll())
            
            text.append(one)
        }
        
        let label = YYLabel()
        label.attributedText = text
        label.width = view.width
        label.height = view.height - lp_topSafeArea
        label.top = lp_topSafeArea
        label.textAlignment = .center
        label.textVerticalAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = UIColor(white: 0.933, alpha: 1.000)
        view.addSubview(label)
        
        /*
         If the 'highlight.tapAction' is not nil, the label will invoke 'highlight.tapAction'
         and ignore 'label.highlightTapAction'.
         
         If the 'highlight.tapAction' is nil, you can use 'highlightTapAction' to handle
         all tap action in this label.
         */
        label.highlightTapAction = { [weak self](containerView, text, range, rect) in
            self?.showMessage("Tap: \(text.attributedSubstring(from: range).string)")
        }
    }
    
    private var padding: NSAttributedString {
        let pad = NSMutableAttributedString(string: "\n\n")
        pad.yy_font = UIFont.systemFont(ofSize: 4)
        return pad
    }
    
    private func showMessage(_ msg: String) {
        let padding: CGFloat = 10
        
        let label = YYLabel()
        label.text = msg
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(red: 0.033, green: 0.685, blue: 0.978, alpha: 0.73)
        label.width = view.width
        label.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        label.height = msg.height(for: label.font, width: label.width) + 2 * padding
        
        label.bottom = lp_topSafeArea
        view.addSubview(label)
        UIView.animate(withDuration: 0.3, animations: {
            label.top = self.lp_topSafeArea
        }) { [weak self] finished in
            guard let `self` = self else { return }
            UIView.animate(withDuration: 0.2, delay: 2, options: .curveEaseInOut, animations: {
                label.bottom = self.lp_topSafeArea
            }) { finished in
                label.removeFromSuperview()
            }
        }
    }
}
