//
//  NYMXVideosModel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/27.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import ObjectMapper

    
class NYMXVideosModel: Mappable {

    /// 动态数据id
    var id = 0
    /// 视频ID
    var video_id = 0
    /// 明星ID
    var star_id = 0
    /// 创建时间
    var created_at = Date()
    /// 更新时间
    var updated_at = Date()
    /// 明星
    var star:StarsHotModel?
    /// 视频
    var video:NYVideosModel?
    /// 标签
    var tags:[NYtagModel]?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        star_id <- map["star_id"]
        video_id <- map["video_id"]
        created_at <- (map["created_at"], TSDateTransfrom())
        updated_at <- (map["updated_at"], TSDateTransfrom())
        star <- map["star"]
        video <- map["video"]
        tags <- map["tags"]
    }
    
}
