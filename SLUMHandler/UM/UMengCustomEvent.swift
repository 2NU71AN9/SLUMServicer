//
//  UMengCustomEvent.swift
//  FZXLive
//
//  Created by 孙梁 on 2020/7/31.
//  Copyright © 2020 znclass. All rights reserved.
//

import UIKit

@objc enum CustomEvent: Int {
    case TEST = 0
}

extension CustomEvent {
    var name: String {
        switch self {
        case .TEST:
            return "TEST"
        }
    }
}
