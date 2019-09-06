//
//  LPTextMarkdownDemo.swift
//  LPText
//
//  Created by pengli on 2019/9/5.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPTextMarkdownDemo: UIViewController, YYTextViewDelegate {
    private var textView = YYTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let text = "#Markdown Editor\nThis is a simple markdown editor based on `YYTextView`.\n\n*********************************************\nIt\'s *italic* style.\n\nIt\'s also _italic_ style.\n\nIt\'s **bold** style.\n\nIt\'s ***italic and bold*** style.\n\nIt\'s __underline__ style.\n\nIt\'s ~~deleteline~~ style.\n\n\nHere is a link: [github](https://github.com/)\n\nHere is some code:\n\n\tif(a){\n\t\tif(b){\n\t\t\tif(c){\n\t\t\t\tprintf(\"haha\");\n\t\t\t}\n\t\t}\n\t}\n"
        
        let parser = YYTextSimpleMarkdownParser()
        parser.setColorWithDarkTheme()
        
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textParser = parser
        textView.size = view.size
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.delegate = self
        textView.keyboardDismissMode = .interactive
        
        textView.backgroundColor = UIColor(white: 0.134, alpha: 1.000)
        textView.contentInset = UIEdgeInsets(top: lp_topSafeArea, left: 0, bottom: 0, right: 0)
        textView.scrollIndicatorInsets = textView.contentInset
        textView.selectedRange = NSRange(location: text.count, length: 0)
        view.addSubview(textView)
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
