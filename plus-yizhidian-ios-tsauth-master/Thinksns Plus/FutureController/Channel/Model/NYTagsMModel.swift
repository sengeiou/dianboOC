//
//  NYTagsMModel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/27.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import ObjectMapper

class NYTagsMModel: Mappable {
    
    /// 动态数据id
    var id = 0
    /// 名称
    var name = ""
    ///
    var weight = 0
    /// tags
    var tags:[NYtagModel]?
    
    init() {
        
    }
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        weight <- map["weight"]
        tags <- map["tags"]
    }
    
}


