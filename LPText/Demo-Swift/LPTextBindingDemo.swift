//
//  LPTextBindingDemo.swift
//  LPText
//
//  Created by pengli on 2019/9/5.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

private class LPTextDemoEmailBindingParser: NSObject, YYTextParser {
    private var regex = try? NSRegularExpression(pattern: "[-_a-zA-Z@\\.]+[ ,\\n]", options: [])
    
    func parseText(_ text: NSMutableAttributedString?, selectedRange: NSRangePointer?) -> Bool {
        guard let text = text else { return false }
        
        var changed = false
        regex?.enumerateMatches(in: text.string, options: .withoutAnchoringBounds, range: text.yy_rangeOfAll(), using: { (result, flags, stop) in
            guard let result = result else { return }
            
            if result.range.location == NSNotFound || result.range.length < 1 { return }
            if text.attribute(NSAttributedString.Key(YYTextBindingAttributeName), at: result.range.location, effectiveRange: nil) != nil {
                return
            }
            let bindlingRange = NSRange(location: result.range.location, length: result.range.length - 1)
            let binding = YYTextBinding(deleteConfirm: true)
            text.yy_setTextBinding(binding, range: bindlingRange) // Text binding
            text.yy_setColor(UIColor(red: 0, green: 0.519, blue: 1, alpha: 1), range: bindlingRange)
            changed = true
        })
        return changed
    }
}

class LPTextBindingDemo: UIViewController, YYTextViewDelegate {
    private var textView = YYTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let text = NSMutableAttributedString(string: "sjobs@apple.com, apple@apple.com, banana@banana.com, pear@pear.com ")
        text.yy_font = UIFont.systemFont(ofSize: 17)
        text.yy_lineSpacing = 5
        text.yy_color = UIColor.black
        
        textView.attributedText = text
        textView.textParser = LPTextDemoEmailBindingParser()
        textView.size = view.size
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.delegate = self
        textView.keyboardDismissMode = .interactive
        
        textView.contentInset = UIEdgeInsets(top: lp_topSafeArea, left: 0, bottom: 0, right: 0)
        textView.scrollIndicatorInsets = textView.contentInset
        view.addSubview(textView)
        
        textView.becomeFirstResponder()
    }
    
    @objc private func editBtnClicked() {
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    func textViewDidBeginEditing(_ textView: YYTextView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editBtnClicked))
    }
    
    func textViewDidEndEditing(_ textView: YYTextView) {
        navigationItem.rightBarButtonItem = nil
    }
    
    func textViewDidChange(_ textView: YYTextView) {
        if textView.text.count == 0 {
            textView.textColor = UIColor.black
        }
    }
}
