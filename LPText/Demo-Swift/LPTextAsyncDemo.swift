//
//  LPTextAsyncDemo.swift
//  LPText
//
//  Created by pengli on 2019/9/5.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

private var kCellID = "LPTextAsyncDemoCell"
private let kCellHeight: CGFloat = 34
private class LPTextAsyncDemoCell: UITableViewCell {
    private var uiLabel = UILabel()
    private var yyLabel = YYLabel()
    
    var isAsync: Bool = true {
        didSet {
            guard isAsync != oldValue else { return }
            uiLabel.isHidden = isAsync
            yyLabel.isHidden = !isAsync
        }
    }
    
    func setAyncText(_ text: Any) {
        if isAsync {
            yyLabel.layer.contents = nil
            yyLabel.textLayout = text as? YYTextLayout
        } else {
            uiLabel.attributedText = text as? NSAttributedString
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiLabel.font = UIFont.systemFont(ofSize: 8)
        uiLabel.numberOfLines = 0
        uiLabel.size = CGSize(width: UIScreen.main.bounds.width, height: kCellHeight)
        uiLabel.isHidden = true
        
        yyLabel.font = uiLabel.font
        yyLabel.numberOfLines = UInt(uiLabel.numberOfLines)
        yyLabel.size = uiLabel.size
        yyLabel.displaysAsynchronously = true /// enable async display
        
        contentView.addSubview(uiLabel)
        contentView.addSubview(yyLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class LPTextAsyncDemo: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var isAsync = true {
        didSet {
            tableView.visibleCells.forEach {
                guard let cell = $0 as? LPTextAsyncDemoCell else { return }
                cell.isAsync = isAsync
                guard let indexPath = tableView.indexPath(for: cell) else { return }
                if isAsync {
                    cell.setAyncText(layouts[indexPath.row])
                } else {
                    cell.setAyncText(strings[indexPath.row])
                }
            }
        }
    }
    private var strings: [NSMutableAttributedString] = []
    private var layouts: [YYTextLayout] = []
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LPTextAsyncDemoCell.self, forCellReuseIdentifier: kCellID)
        view.addSubview(tableView)
        
        for i in 0..<500 {
            let str = "\(i) Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫"
            
            let text = NSMutableAttributedString(string: str)
            text.yy_font = UIFont.systemFont(ofSize: 10)
            text.yy_lineSpacing = 0
            text.yy_strokeWidth = NSNumber(value: -3)
            text.yy_strokeColor = UIColor.red
            text.yy_lineHeightMultiple = 1
            text.yy_maximumLineHeight = 12
            text.yy_minimumLineHeight = 12
            
            let shadow = NSShadow()
            shadow.shadowBlurRadius = 1
            shadow.shadowColor = UIColor.red
            shadow.shadowOffset = CGSize(width: 0, height: 1)
            strings.append(text)
            
            // it better to do layout in background queue...
            let container = YYTextContainer(size: CGSize(width: UIScreen.main.bounds.width, height: kCellHeight))
            let layout = YYTextLayout(container: container, text: text)
            layouts.append(layout!)
        }
        
        let toolbar = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        toolbar.size = CGSize(width: UIScreen.main.bounds.width, height: 40)
        toolbar.top = lp_topSafeArea
        view.addSubview(toolbar)
        
        let fps = LPFPSLabel()
        fps.centerY = toolbar.height / 2.0
        fps.left = 5
        toolbar.contentView.addSubview(fps)
        
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.text = "UILabel/LPLabel(Async): "
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.centerY = toolbar.height / 2.0
        label.left = fps.right + 10
        toolbar.contentView.addSubview(label)
        
        let switcher = UISwitch()
        switcher.sizeToFit()
        switcher.isOn = true
        switcher.centerY = toolbar.height / 2.0
        switcher.left = label.right + 10
        switcher.addBlock(for: .valueChanged, block: { [weak self] switcher in
            guard let `self` = self, let switcher = switcher as? UISwitch else { return }
            self.isAsync = switcher.isOn
        })
        toolbar.contentView.addSubview(switcher)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellID, for: indexPath) as! LPTextAsyncDemoCell
        cell.isAsync = isAsync
        if isAsync {
            cell.setAyncText(layouts[indexPath.row])
        } else {
            cell.setAyncText(strings[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
