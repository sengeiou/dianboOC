//
//  NYVideosModel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/18.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import ObjectMapper

class NYtagModel: Mappable {
    
    /// 动态数据id
    var id = 0
    /// 名称
    var name = ""
    ///
    var weight = 0
    /// category_id
    var tag_category_id = 0
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        weight <- map["weight"]
        tag_category_id <- map["tag_category_id"]
    }
}

class NYVideosModel: Mappable {
    
    /// 动态数据id
    var id = 0
    /// 名称
    var name = ""
    /// 动态内容
    var summary = ""
    /// 动态数据id
    var channel_id = 0

    var sort = 0
    var view_count = 0
    var collect_count = 0
    var comment_count = 0
    var cover = ""
    var play_url = ""
    var upload_type = ""
    /// 创建时间
    var created_at = Date()
    /// 更新时间
    var updated_at = Date()
    var comment_updated_at = Date()
    /// 删除时间
    var deleted_at: Date?
    var cover_size = 0
    var video_size = 0
    var user_id = 0
    var duration = 0
    var tags:[NYtagModel]?
    /// 是否已经收藏
    var has_collect:Bool=false

    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        sort <- map["sort"]
        channel_id <- map["channel_id"]
        summary <- map["summary"]
        view_count <- map["view_count"]
        collect_count <- map["collect_count"]
        comment_count <- map["comment_count"]
        cover <- map["cover"]
        play_url <- map["play_url"]
        upload_type <- map["upload_type"]
        cover_size <- map["cover_size"]
        video_size <- map["video_size"]
        user_id <- map["user_id"]
        tags <- map["tags"]
        duration <- map["duration"]
        has_collect <- map["has_collect"]
        
        created_at <- (map["created_at"], TSDateTransfrom())
        updated_at <- (map["updated_at"], TSDateTransfrom())
        deleted_at <- (map["deleted_at"], TSDateTransfrom())
        deleted_at <- (map["comment_updated_at"], TSDateTransfrom())
    }
}
