//
//  StarsHotModel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/18.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import ObjectMapper

class StarsHotModel: Mappable
{
    /// 明星 id
    var id = 0
    /// 分类
    var group_id = 0
    var name = ""
    var sort = 0
    /// 头像
    var avatar = ""
    /// 创建时间
    var created_at = Date()
    /// 更新时间
    var updated_at = Date()
    /// 删除时间
    var deleted_at: Date?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        group_id <- map["group_id"]
        name <- map["name"]
        sort <- map["sort"]
        avatar <- map["avatar"]
        created_at <- (map["created_at"], TSDateTransfrom())
        updated_at <- (map["updated_at"], TSDateTransfrom())
        deleted_at <- (map["deleted_at"], TSDateTransfrom())
    }
}
