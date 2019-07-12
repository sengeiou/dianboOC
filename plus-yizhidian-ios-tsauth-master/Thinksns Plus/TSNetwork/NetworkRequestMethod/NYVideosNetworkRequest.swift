//
//  NYVideosNetworkRequest.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/5.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYVideosNetworkRequest {

    /// 视频收藏
    let postVideoCollections = Request<NYVideosModel>(method: .get, path: "dianbo/videos/(id)/collections", replacers: ["(id)"])

    /// 取消视频收藏
    let postVideoUncollect = Request<NYVideosModel>(method: .get, path: "dianbo/videos/(id)/uncollect", replacers: ["(id)"])
    
    /// 发布视频评论 /// 批量获取视频评论
    let postVideoComments = Request<FeedListCommentModel>(method: .get, path: "dianbo/(id)/comments", replacers: ["(id)"])
    
    /// 评论取消点赞 /// 评论点赞
    let videoCommentLike = Request<FeedListCommentModel>(method: .get, path: "dianbo/commentLike", replacers: [])
    /// 视频评论的更多回复
    let videoCommentGetChildren = Request<FeedListCommentModel>(method: .get, path: "dianbo/(id)/comments/getChildren", replacers: ["(id)"])
}

