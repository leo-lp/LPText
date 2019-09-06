//
//  LPTextDemoList.swift
//  LPText
//
//  Created by pengli on 2019/9/3.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPTextDemoList: UITableViewController {
    private lazy var dataSources: [(String, UIViewController.Type)] = {
        return [("Text Attributes 1",       LPTextAttributeDemo.self),
                ("Text Attributes 2",       LPTextTagDemo.self),
                ("Text Attachments",        LPTextAttachmentDemo.self),
                ("Text Edit",               LPTextEditDemo.self),
                ("Text Parser (Markdown)",  LPTextMarkdownDemo.self),
                ("Text Parser (Emoticon)",  LPTextEmoticonDemo.self),
                ("Text Binding",            LPTextBindingDemo.self),
                ("Copy and Paste",          LPTextCopyPasteDemo.self),
                ("Undo and Redo",           LPTextUndoRedoDemo.self),
                ("Ruby Annotation",         LPTextRubyDemo.self),
                ("Async Display",           LPTextAsyncDemo.self),]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "✎      LPText Demo       ✎"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSources[indexPath.row].0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(dataSources[indexPath.row].1.init(), animated: true)
    }
}
