//
//  NYKeywordModel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/28.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import ObjectMapper
  
class NYKeywordModel: Mappable {

    /// 动态数据id
    var id = 0
    ///
    var user_id = 0
    /// keyword
    var keyword = ""
    var isShow = 0
    /// 创建时间
    var created_at = Date()
    /// 更新时间
    var updated_at = Date()
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        keyword <- map["keyword"]
        isShow <- map["isShow"]
        created_at <- (map["created_at"], TSDateTransfrom())
        updated_at <- (map["updated_at"], TSDateTransfrom())
    }
}
