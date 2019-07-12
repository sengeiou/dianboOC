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
    /** 字符串中某几个字段显示不同颜色 */
    static func superStringAttributedStringList
        (superString:String,highlightedStrList:[String],colorList:[UIColor]) -> NSMutableAttributedString
    {
        let attributedText = NSMutableAttributedString(string: superString)
        //        let Srange = superString.range(of: highlightedStr)
        let str = NSString(string: superString)
        for (index,item) in highlightedStrList.enumerated()
        {
            let theRange = str.range(of: item)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: colorList[index], range: theRange)
        }
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


/********************************************************************************/
extension Float {
    
    /** 战斗力值转换 */
    var combatValues: String {
        
        if (self / 10000) > 1 {
            
            let temp = self / 10000
            
            if fmodf(Float(temp), 1) == 0 {
                
                let str = String.init(format: "%.0f", temp)
                
                return str + "万"
                
            }else if fmodf(Float(temp) * 10, 1) == 0 {
                
                let str = String.init(format: "%.1f", temp)
                
                return str + "万"
                
            }else{
                
                let str = String.init(format: "%.2f", temp)
                
                let decimal = str.components(separatedBy: ".")
                
                let arrayString = decimal[1]
                
                if arrayString == "00" {
                    
                    return decimal[0] + "万"
                }
                
                return str + "万"
                
            }
            
        }
        
        if (self / 100000000) > 1 {
            
            let temp = self / 100000000
            
            if fmodf(Float(temp), 1) == 0 {
                
                let str = String.init(format: "%.0f", temp)
                
                return str + "亿"
                
            }else if fmodf(Float(temp) * 10, 1) == 0 {
                
                let str = String.init(format: "%.1f", temp)
                
                return str + "亿"
                
            }else{
                
                let str = String.init(format: "%.2f", temp)
                
                let decimal = str.components(separatedBy: ".")
                
                let arrayString = decimal[1]
                
                if arrayString == "00" {
                    
                    return decimal[0] + "亿"
                }
                
                return str + "亿"
                
            }
            
        }
        
        let decimal = String.init(self).components(separatedBy: ".")
        
        let arrayString = decimal[1]
        
        if arrayString == "0" {
            
            return decimal[0]
        }
        
        return String.init(self)
        
    }
    
}
/********************************************************************************/
extension String {
    
    func attributedString(font:CGFloat)->NSMutableAttributedString{
        
        let attributedS = NSMutableAttributedString(string: self)
        
        if self.contains("万") || self.contains("亿") {
            
            let normalAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: font)]
            
            attributedS.addAttributes(normalAttributes, range: NSMakeRange(self.characters.count - 1,1))
            
        }
        
        return attributedS
        
    }
    
}
