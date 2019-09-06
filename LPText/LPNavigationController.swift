//
//  LPNavigationController.swift
//  LPText
//
//  Created by pengli on 2019/9/3.
//  Copyright © 2019 pengli. All rights reserved.
//

import UIKit

class LPNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [LPTextDemoList(style: .plain)]
    }
}
