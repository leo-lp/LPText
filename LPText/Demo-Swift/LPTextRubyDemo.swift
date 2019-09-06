//
//  LPTextRubyDemo.swift
//  LPText
//
//  Created by pengli on 2019/9/5.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

/// Ruby Annotation
/// See: http://www.w3.org/TR/ruby/
class LPTextRubyDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let text = NSMutableAttributedString()
        
        var one = NSMutableAttributedString(string: "这是用汉语写的一段文字。")
        one.yy_font = UIFont.boldSystemFont(ofSize: 30)
        
        var ruby: YYTextRubyAnnotation
        ruby = YYTextRubyAnnotation()
        ruby.textBefore = "hàn yŭ"
        one.yy_setTextRubyAnnotation(ruby, range: (one.string as NSString).range(of: "汉语"))
        
        ruby = YYTextRubyAnnotation()
        ruby.textBefore = "wén"
        one.yy_setTextRubyAnnotation(ruby, range: (one.string as NSString).range(of: "文"))
        
        ruby = YYTextRubyAnnotation()
        ruby.textBefore = "zì"
        ruby.alignment = CTRubyAlignment.center
        one.yy_setTextRubyAnnotation(ruby, range: (one.string as NSString).range(of: "字"))
        
        text.append(one)
        text.append(padding)
        
        one = NSMutableAttributedString(string: "日本語で書いた作文です。")
        one.yy_font = UIFont.boldSystemFont(ofSize: 30)
        
        ruby = YYTextRubyAnnotation()
        ruby.textBefore = "に"
        one.yy_setTextRubyAnnotation(ruby, range: (one.string as NSString).range(of: "日"))
        
        ruby = YYTextRubyAnnotation()
        ruby.textBefore = "ほん"
        one.yy_setTextRubyAnnotation(ruby, range: (one.string as NSString).range(of: "本"))
        
        ruby = YYTextRubyAnnotation()
        ruby.textBefore = "ご"
        one.yy_setTextRubyAnnotation(ruby, range: (one.string as NSString).range(of: "語"))
        
        ruby = YYTextRubyAnnotation()
        ruby.textBefore = "か"
        one.yy_setTextRubyAnnotation(ruby, range: (one.string as NSString).range(of: "書"))
        
        ruby = YYTextRubyAnnotation()
        ruby.textBefore = "さく"
        one.yy_setTextRubyAnnotation(ruby, range: (one.string as NSString).range(of: "作"))
        
        ruby = YYTextRubyAnnotation()
        ruby.textBefore = "ぶん"
        one.yy_setTextRubyAnnotation(ruby, range: (one.string as NSString).range(of: "文"))
        text.append(one)
        
        let label = YYLabel()
        label.attributedText = text
        label.width = view.width - 60
        label.centerX = view.width / 2
        label.height = view.height - lp_topSafeArea - 60
        label.top = lp_topSafeArea + 30
        label.textAlignment = NSTextAlignment.center
        label.textVerticalAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = UIColor(white: 0.933, alpha: 1)
        view.addSubview(label)
    }
    
    var padding: NSAttributedString {
        let pad = NSMutableAttributedString(string: "\n\n")
        pad.yy_font = UIFont.systemFont(ofSize: 30)
        return pad
    }
}
