//
//  UIViewController+Extension.swift
//  LPText
//
//  Created by pengli on 2019/9/4.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

extension UIViewController {
    var lp_topSafeArea: CGFloat {
        return UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
    }
}
