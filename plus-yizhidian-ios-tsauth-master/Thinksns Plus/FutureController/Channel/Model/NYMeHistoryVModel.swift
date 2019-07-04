//
//  NYMeHistoryVModel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/3.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import ObjectMapper

class NYMeHistoryVModel: Mappable {
    
    /// 动态数据id
    var id = 0
    ///
    var video_id = 0
    /// user_id
    var user_id = 0
    ///
    var progress = 0.0
    /// seven_time
    var seven_time = true
    /// 创建时间
    var created_at = Date()
    /// 更新时间
    var updated_at = Date()
    /// 明星
    var user:TSUserInfoModel?
    /// 视频
    var video:NYVideosModel?
    
    ///
    var select:Bool = false
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        video_id <- map["video_id"]
        user_id <- map["user_id"]
        progress <- map["progress"]
        seven_time <- map["tag_category_id"]
        user <- map["user"]
        video <- map["video"]
        created_at <- (map["created_at"], TSDateTransfrom())
        updated_at <- (map["updated_at"], TSDateTransfrom())
    }
}
