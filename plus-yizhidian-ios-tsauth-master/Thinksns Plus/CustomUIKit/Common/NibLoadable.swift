//
//  NibLoadable.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/22.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

// 协议
protocol NibLoadable {
    // 具体实现写到extension内
}

// 加载nib
extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
