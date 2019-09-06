//
//  LPTextUndoRedoDemo.swift
//  LPText
//
//  Created by pengli on 2019/9/5.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPTextUndoRedoDemo: UIViewController, YYTextViewDelegate {
    private var textView = YYTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let text = "You can shake the device to undo and redo."
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.size = view.size
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.delegate = self
        textView.allowsUndoAndRedo = true /// Undo and Redo
        textView.maximumUndoLevel = 10 /// Undo level
        textView.keyboardDismissMode = .interactive
        
        textView.contentInset = UIEdgeInsets(top: lp_topSafeArea, left: 0, bottom: 0, right: 0)
        textView.scrollIndicatorInsets = textView.contentInset
        view.addSubview(textView)
        
        textView.selectedRange = NSRange(location: text.count, length: 0)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(editBtnClicked))
    }

    func textViewDidEndEditing(_ textView: YYTextView) {
        navigationItem.rightBarButtonItem = nil
    }
}
