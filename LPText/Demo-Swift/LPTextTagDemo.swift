//
//  LPTextTagDemo.swift
//  LPText
//
//  Created by pengli on 2019/9/4.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPTextTagDemo: UIViewController, YYTextViewDelegate {
    private lazy var textView = YYTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let text = NSMutableAttributedString()
        let tags = ["◉red", "◉orange", "◉yellow", "◉green", "◉blue", "◉purple", "◉gray"]
        let tagStrokeColors = [#colorLiteral(red: 0.9803921569, green: 0.2470588235, blue: 0.2235294118, alpha: 1), #colorLiteral(red: 0.9568627451, green: 0.5607843137, blue: 0.1450980392, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.7529411765, blue: 0.1725490196, alpha: 1), #colorLiteral(red: 0.3294117647, green: 0.737254902, blue: 0.1803921569, alpha: 1), #colorLiteral(red: 0.1607843137, green: 0.662745098, blue: 0.9333333333, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.4431372549, blue: 0.8470588235, alpha: 1), #colorLiteral(red: 0.5058823529, green: 0.5568627451, blue: 0.568627451, alpha: 1)]
        let tagFillColors   = [#colorLiteral(red: 0.9843137255, green: 0.3960784314, blue: 0.3764705882, alpha: 1), #colorLiteral(red: 0.9647058824, green: 0.6470588235, blue: 0.3137254902, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.8, blue: 0.337254902, alpha: 1), #colorLiteral(red: 0.462745098, green: 0.7882352941, blue: 0.3411764706, alpha: 1), #colorLiteral(red: 0.3254901961, green: 0.7294117647, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.8039215686, green: 0.5529411765, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6549019608, alpha: 1)]
        let font = UIFont.boldSystemFont(ofSize: 16)
        for i in 0..<tags.count {
            let tag = tags[i]
            let tagStrokeColor: UIColor? = tagStrokeColors[i]
            let tagFillColor: UIColor? = tagFillColors[i]
            let tagText = NSMutableAttributedString(string: tag)
            tagText.yy_insertString("   ", at: 0)
            tagText.yy_appendString("   ")
            tagText.yy_font = font
            tagText.yy_color = UIColor.white
            tagText.yy_setTextBinding(YYTextBinding(deleteConfirm: false), range: tagText.yy_rangeOfAll())
            
            let border = YYTextBorder()
            border.strokeWidth = 1.5
            border.strokeColor = tagStrokeColor
            border.fillColor = tagFillColor
            border.cornerRadius = 100 // a huge value
            border.lineJoin = .bevel
            
            border.insets = UIEdgeInsets(top: -2, left: -5.5, bottom: -2, right: -8)
            tagText.yy_setTextBackgroundBorder(border, range: (tagText.string as NSString).range(of: tag))
            
            text.append(tagText)
        }
        text.yy_lineSpacing = 10
        text.yy_lineBreakMode = .byWordWrapping
        
        text.yy_appendString("\n")
        text.append(text) // repeat for test
        
        textView.attributedText = text
        textView.size = view.size
        textView.textContainerInset = UIEdgeInsets(top: 10 + lp_topSafeArea, left: 10, bottom: 10, right: 10)
        textView.allowsCopyAttributedString = true
        textView.allowsPasteAttributedString = true
        textView.delegate = self
        textView.keyboardDismissMode = .interactive
        
        textView.scrollIndicatorInsets = textView.contentInset
        textView.selectedRange = NSRange(location: text.length, length: 0)
        view.addSubview(textView)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: { [weak self] in
            self?.textView.becomeFirstResponder()
        })
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
}
