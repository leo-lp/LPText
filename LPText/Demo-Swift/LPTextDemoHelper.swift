//
//  LPTextDemoHelper.swift
//  LPText
//
//  Created by pengli on 2019/9/3.
//  Copyright © 2019 pengli. All rights reserved.
//

import Foundation

struct LPTextDemoHelper {
    static private(set) var isDebugEnabled: Bool = false
    
    static func addDebugOption(to vc: UIViewController) {
        let switcher = UISwitch()
        switcher.layer.setValue(0.8, forKey: "transform.scale")
        switcher.isOn = LPTextDemoHelper.isDebugEnabled
        switcher.addBlock(for: UIControl.Event.valueChanged) { (sender) in
            guard let switcher = sender as? UISwitch else { return }
            LPTextDemoHelper.setDebug(switcher.isOn)
        }
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switcher)
    }
    
    static func setDebug(_ debug: Bool) {
        let debugOptions = YYTextDebugOption()
        if debug {
            debugOptions.baselineColor = UIColor.red
            debugOptions.ctFrameBorderColor = UIColor.red
            debugOptions.ctLineFillColor = UIColor(red: 0, green: 0.463, blue: 1, alpha: 0.18)
            debugOptions.cgGlyphBorderColor = UIColor(red: 1, green: 0.524, blue: 0, alpha: 0.2)
        } else {
            debugOptions.clear()
        }
        YYTextDebugOption.setShared(debugOptions)
        LPTextDemoHelper.isDebugEnabled = debug
    }
}
