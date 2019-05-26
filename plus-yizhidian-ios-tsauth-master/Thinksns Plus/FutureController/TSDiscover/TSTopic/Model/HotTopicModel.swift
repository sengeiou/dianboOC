//
//  HotTopicModel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/25.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class HotTopicModel: Mappable
{
    var id = 0
    /// 分类
    var group_id = 0
    var title = ""
    var user_id = 0
    var summary = ""
    var likes_count = 0  //喜欢量
    var comments_count = 0  //评论量
    var views_count = 0 //分享量
    var excellent_at : Date?
    var hot = 0
    var collected = false //收藏
    var liked = false  //喜欢的
    
    ///提交时间
    var comment_updated_at = Date()
    /// 创建时间
    var created_at = Date()
    /// 更新时间
    var updated_at = Date()
    /// 删除时间
    var deleted_at: Date?
    
    /// 评论信息
    var comments: [TopicPostListCommentModel] = []
    /// 图片信息
    var images: [TopicPostImageModel] = []
    /// 用户信息
    var userInfo = TSUserInfoModel()
    /// 圈子信息
    var groupInfo = TopicModel()
    
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        group_id <- map["group_id"]
        title <- map["title"]
        user_id <- map["user_id"]
        title <- map["title"]
        // 需要替换调@image等标签为空格
        summary <- map["summary"]
        summary = summary.ts_customMarkdownToClearString()
        likes_count <- map["likes_count"]
        comments_count <- map["comments_count"]
        views_count <- map["views_count"]
        excellent_at <- map["excellent_at"]
        hot <- map["hot"]
        collected <- map["collected"]
        liked <- map["liked"]
        created_at <- (map["created_at"], TSDateTransfrom())
        updated_at <- (map["updated_at"], TSDateTransfrom())
        deleted_at <- (map["deleted_at"], TSDateTransfrom())
        userInfo <- map["user"]
        groupInfo <- map["group"]
        images <- map["images"]
        comments <- map["comments"]
    }
    
}
