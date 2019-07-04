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
    
    /**
     *  比较两个时间得出 小时 差
     *
     *  date2 - date1
     *
     *  @return 时长字符串
     */
    static func getCountDateHour(date1:Date,date2:Date)-> Int
    {
        var gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var result = gregorian?.components(NSCalendar.Unit.hour, from: date1, to: date2, options: NSCalendar.Options(rawValue: 0))
        return result!.hour!
    }
    
    /**
     *  根据时长求出字符串
     *
     *  @param time 时长
     *
     *  @return 时长字符串
     */
    static func durationStringWithTime
        (time:Int) -> String
    {
        // 获取分钟
        let min = String(format: "%02d", time / 60)
        // 获取秒数
        let sec = String(format: "%02d", time % 60)
        return String(format: "%@:%@", min, sec)
    }

}
