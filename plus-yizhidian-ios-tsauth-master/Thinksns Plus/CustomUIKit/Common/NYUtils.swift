//
//  NYUtils.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/16.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYUtils: NSObject
{
    /** 字符串中某几个字段显示不同颜色 */
    static func superStringAttributedString
        (superString:String,highlightedStr:String,color:UIColor) -> NSMutableAttributedString
    {
        let attributedText = NSMutableAttributedString(string: superString)
//        let Srange = superString.range(of: highlightedStr)
        let str = NSString(string: superString)
        let theRange = str.range(of: highlightedStr)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: color, range: theRange)
        return attributedText
    }
}
