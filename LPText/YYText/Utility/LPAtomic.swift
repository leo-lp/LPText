//
//  LPAtomic.swift
//  LPText
//
//  Created by pengli on 2019/9/5.
//  Copyright © 2019 pengli. All rights reserved.
//

import Foundation

/// https://www.objc.io/blog/2018/12/18/atomic-variables/
/// https://github.com/apple/swift/blob/master/test/stmt/yield.swift
/// https://github.com/apple/swift-evolution/blob/master/proposals/0030-property-behavior-decls.md
/// eg: var x = LPAtomic<Int>(5)
struct LPAtomic<R> {
    private let queue = DispatchQueue(label: "com.lp.atomic.serial")
    private var _rawValue: R

    init(_ rawValue: R) {
        _rawValue = rawValue
    }
    
    var rawValue: R {
        get { return queue.sync { _rawValue } }
        set { queue.sync { _rawValue = newValue } } // BAD IDEA (x.value += 1)
    }
    
//    var rawValue: R { return queue.sync { _rawValue } }
//    /// let x = LPAtomic<Int>(5)
//    /// x.mutate { $0 += 1 }
//    mutating func mutate(_ transform: (inout R) -> ()) {
//        queue.sync { transform(&_rawValue) }
//    }
}
