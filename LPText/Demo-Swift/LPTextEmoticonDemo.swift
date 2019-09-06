//
//  LPTextEmoticonDemo.swift
//  LPText
//
//  Created by pengli on 2019/9/5.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPTextEmoticonDemo: UIViewController, YYTextViewDelegate {
    private var textView = YYTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        var mapper = [String : UIImage]()
        mapper[":smile:"] = image(withName: "002")
        mapper[":cool:"] = image(withName: "013")
        mapper[":biggrin:"] = image(withName: "047")
        mapper[":arrow:"] = image(withName: "007")
        mapper[":confused:"] = image(withName: "041")
        mapper[":cry:"] = image(withName: "010")
        mapper[":wink:"] = image(withName: "085")
        
        let parser = YYTextSimpleEmoticonParser()
        parser.emoticonMapper = mapper
        
        let mod = YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 22
        
        textView.text = "Hahahah:smile:, it\'s emoticons::cool::arrow::cry::wink:\n\nYou can input \":\" + \"smile\" + \":\" to display smile emoticon, or you can copy and paste these emoticons.\n"
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textParser = parser
        textView.size = view.size
        textView.linePositionModifier = mod
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.delegate = self
        textView.keyboardDismissMode = .interactive
        
        textView.contentInset = UIEdgeInsets(top: lp_topSafeArea, left: 0, bottom: 0, right: 0)
        textView.scrollIndicatorInsets = textView.contentInset
        view.addSubview(textView)
        
        textView.becomeFirstResponder()
    }
    
    func image(withName name: String?) -> UIImage? {
        let bundle = Bundle(url: Bundle.main.url(forResource: "EmoticonQQ", withExtension: "bundle")!)!
        let path = bundle.path(forScaledResource: name, ofType: "gif")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let image = YYImage(data: data, scale: 2)
        image?.preloadAllAnimatedImageFrames = true
        return image
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
