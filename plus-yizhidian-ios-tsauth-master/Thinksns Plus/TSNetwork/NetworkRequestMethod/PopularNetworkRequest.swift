//
//  PopularNetworkRequest.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/18.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit


class PopularNetworkRequest {
    
    /// 明星协议
    let starsHot = Request<StarsHotModel>(method: .get, path: "dianbo/starsHot", replacers: [])
    /// 批量明星协议
    let starsList = Request<StarsHotModel>(method: .get, path: "dianbo/stars", replacers: [])
    /// 获取频道
    let channelsList = Request<ChannelsModel>(method: .get, path: "dianbo/channels", replacers: [])
    
    /// 获取频道-删除添加
     let channelsAddDel = Request<ChannelsModel>(method: .get, path: "dianbo/channels", replacers: [])
    
    /// 获取热门帖子
    ///
    /// - RouteParameter: None
    /// - RequestParameter:
    ///    - limit: 数据返回条数 默认10条
    ///    - offset: 偏移量 默认为0
    let hotPostList = Request<HotTopicModel>(method: .get, path: "plus-group/post-hot", replacers: [])
    
    /// 获取视频列表
    ///
    /// - RouteParameter: None
    /// - RequestParameter:
    ///    - limit: 数据返回条数 默认10条
    ///    - offset: 偏移量 默认为0
    let getVideosList = Request<NYVideosModel>(method: .get, path: "dianbo/getVideos", replacers: [])
    
    /// 获取视频详细
    let getVideobyId = Request<NYVideosModel>(method: .get, path: "dianbo/getVideo/(id)", replacers: ["(id)"])
    
    /// 推荐视频
    let getVideoRecommend = Request<NYVideosModel>(method: .get, path: "dianbo/getRecommendVideos/(id)", replacers: ["(id)"])
    
    /// 视频评论
    let getVideoComments = Request<FeedListCommentModel>(method: .get, path: "dianbo/(id)/comments", replacers: ["(id)"])
    
    /// 明星数据
    let getStarsList = Request<NYVideosModel>(method: .get, path: "dianbo/stars", replacers: [])
    
    /// 获取所有标签
    let getTagsList = Request<NYTagsMModel>(method: .get, path: "tags", replacers: [])
}
