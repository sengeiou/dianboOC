//
//  StarsHotModel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/18.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import SwiftyJSON
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
    var avatar: TSNetFileModel?
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
        avatar <- (map["avatar"], TSNetFileModelTransfrom())
        created_at <- (map["created_at"], TSDateTransfrom())
        updated_at <- (map["updated_at"], TSDateTransfrom())
        deleted_at <- (map["deleted_at"], TSDateTransfrom())
    }
    
    /// TSNetFileModel 兼容处理
    class TSNetFileModelTransfrom: TransformType {
        typealias Object = TSNetFileModel
        typealias JSON = String
        
        func transformFromJSON(_ value: Any?) -> Object? {
            if let string = value as? String {
                /// 构建一个TSNetFileModel
                let model = TSNetFileModel(JSON: ["vendor": "local", "url": string, "mime": ""])
                return model
            }
            if let string = value as? Dictionary<String, Any> {
                return TSNetFileModel(JSON: string)
            }
            return nil
        }
        
        func transformToJSON(_ value: Object?) -> JSON? {
            if let model = value {
                return TSUtil.praseTSNetFileUrl(netFile: model)
            }
            return nil
        }
    }
}
