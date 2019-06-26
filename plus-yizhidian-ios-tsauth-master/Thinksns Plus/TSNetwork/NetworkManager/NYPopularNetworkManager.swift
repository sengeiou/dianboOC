//
//  NYPopularNetworkManager.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/18.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import Alamofire

class NYPopularNetworkManager {
    
}

// MARK: --热门内容 - 圈子
extension NYPopularNetworkManager {
    
    /// 热门内容- 包含 10明星
    /// PopularNetworkRequest
    ///   - complete: 结果
    class func getPopularData(complete: @escaping ([StarsHotModel]?, String?, Bool) -> Void) {
        // 1.请求 url
        var request = PopularNetworkRequest().starsHot
        request.urlPath = request.fullPathWith(replacers: [])
        // 3.发起请求
        RequestNetworkData.share.text(request: request) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(nil, "网络请求错误", false)
            case .failure(let failure):
                complete(nil, failure.message, false)
            case .success(let data):
                complete(data.models, nil, true)
            }
        }
    }
    
    /// 热门内容- 批量获取明星
    /// PopularNetworkRequest
    ///   - complete: 结果
    class func getStarsListData(complete: @escaping (Dictionary<String, Any>?, String?, Bool) -> Void) {
        // 1.请求 url
        var request = PopularNetworkRequest().starsList
        request.urlPath = request.fullPathWith(replacers: [])
        try! RequestNetworkData.share.textRequest(method: .get, path: request.urlPath, parameter: nil, complete: { (data: NetworkResponse?, status: Bool) in
            // 1. 网络请求失败
            guard status else {
                let message = TSCommonNetworkManager.getNetworkErrorMessage(with: data)
                complete(nil, "网络请求错误", false)
                return
            }
            // 2. 数据格式错误
            guard let datas = data as? [[String: Any]] else {
                complete(nil, "服务器返回数据错误", false)
                return
            }
            var dict = NSMutableDictionary()
//            var list:[StarsKeyValue]? = NSMutableArray() as! [StarsKeyValue]
            for item in datas
            {
                let key = item["key"] as! String
                let stars = item["star"] as! [[String: Any]]
                var index = 0
                var star_List:NSMutableArray?
                var skvModel:StarsKeyValue?
                for obj in stars
                {
                    if index == 0
                    {
                        skvModel = StarsKeyValue()
                        skvModel?.keyName = key
                        star_List = NSMutableArray()
                    }
                    let star = StarsHotModel(JSON: obj)
                    star_List!.add(star)
                    index += 1
                    if index==4
                    {
                        index = 0
                        skvModel?.valueList = star_List as? [StarsHotModel]
                        if dict[skvModel?.keyName] != nil
                        {
                           let  mtArray = dict[skvModel?.keyName] as! NSMutableArray
                            mtArray.add(skvModel)
                        }
                        else
                        {
                            let mtArray = NSMutableArray()
                            mtArray.add(skvModel)
                            dict[skvModel?.keyName] = mtArray
                        }
                    }
                }
                if index != 4
                {
                    skvModel?.valueList = star_List as? [StarsHotModel]
                    if dict[skvModel?.keyName] != nil
                    {
                        let  mtArray = dict[skvModel?.keyName] as! NSMutableArray
                        mtArray.add(skvModel)
                    }
                    else
                    {
                        let mtArray = NSMutableArray()
                        mtArray.add(skvModel)
                        dict[skvModel?.keyName] = mtArray
                    }
                }
            }
            //排序
//            NSArray *keyArray = dic.allKeys;
//            NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) { return [obj1 compare:obj2 options:NSNumericSearch]; }];
            
            complete(dict as! Dictionary<String, Any>, "服务器返回数据错误", true)
        })
    }
    
    /// 热门内容- 批量获取频道
    /// PopularNetworkRequest
    ///   - complete: 结果
    class func getChannelsListData(complete: @escaping ([ChannelsModel]?,[ChannelsModel]?, String?, Bool) -> Void) {
        // 1.请求 url
        var request = PopularNetworkRequest().channelsList
        request.urlPath = request.fullPathWith(replacers: [])
        try! RequestNetworkData.share.textRequest(method: .get, path: request.urlPath, parameter: nil, complete: { (data: NetworkResponse?, status: Bool) in
            // 1. 网络请求失败
            guard status else {
                let message = TSCommonNetworkManager.getNetworkErrorMessage(with: data)
                 complete(nil,nil, "网络请求错误", false)
                return
            }
            // 2. 数据格式错误
            guard let datas = data as? [String: Any] else {
                complete(nil,nil, "服务器返回数据错误", false)
                return
            }
            // 3. 正常解析数据
            let users = datas["user_channels"] as? [[String: Any]]
            let others = datas["other_channels"] as? [[String: Any]]
            var users_list:[ChannelsModel]? = nil
            var other_list:[ChannelsModel]? = nil
            if (users != nil)&&users!.count>0
            {
                users_list = NSMutableArray() as! [ChannelsModel]
                for obj in users!
                {
                    let channel = ChannelsModel(JSON: (obj as? [String: Any])! )
                    users_list?.append(channel!)
                }
            }
            if (others != nil)&&others!.count>0
            {
                other_list = NSMutableArray() as! [ChannelsModel]
                for obj in others!
                {
                    let channel = ChannelsModel(JSON: (obj as? [String: Any])! )
                    other_list?.append(channel!)
                }
            }
            complete(users_list,other_list, "ok", false)
        })
    }
    
    /// 新增 或 删除
    /// add：+，del：-
    class func upDelChannel(channel_id: Int, act: String = "add",  complete: @escaping ((_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = PopularNetworkRequest().channelsList
        request.urlPath = request.fullPathWith(replacers: [])
        let parameters: [String: Any] = ["channel_id": channel_id, "act": act]
        try! RequestNetworkData.share.textRequest(method: .patch, path: request.urlPath, parameter: parameters, complete: { (data: NetworkResponse?, status: Bool) in
            // 1. 网络请求失败
            guard status else {
                let message = TSCommonNetworkManager.getNetworkErrorMessage(with: data)
                complete("网络请求错误", false)
                return
            }
            // 2. 数据格式错误
            guard let datas = data as? [String: Any] else {
                complete( "服务器返回数据错误", false)
                return
            }
            let message = datas["message"] as! String
            complete(message, false)
        })
    }
    
    /// 热门内容- 热门帖子
    ///
    /// - Parameters:
    ///    - limit: 数据返回条数 默认10条
    ///    - offset: 偏移量 默认为0
    ///   - complete: 结果
    class func getHotPostListData(limit: Int = TSAppConfig.share.localInfo.limit, offset: Int, complete: @escaping ([HotTopicModel]?, String?, Bool) -> Void) {
        // 1.请求 url
        var request = PopularNetworkRequest().hotPostList
        request.urlPath = request.fullPathWith(replacers: [])
        // 2.配置参数
        let parameters: [String: Any] = ["offset": offset, "limit": limit]
        request.parameter = parameters
        // 3.发起请求
        RequestNetworkData.share.text(request: request) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(nil, "网络请求错误", false)
            case .failure(let failure):
                complete(nil, failure.message, false)
            case .success(let data):
                complete(data.models, nil, true)
            }
        }
    }
    
    /// 获取视频列表
    /// channel_id
    class func getVideosListData(channel_id: Int,keyword:String ,tags:String ,after: Int = 0, limit: Int =
        TSAppConfig.share.localInfo.limit, complete: @escaping (([NYVideosModel]?,_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = PopularNetworkRequest().getVideosList
        request.urlPath = request.fullPathWith(replacers: [])
        // 2.配置参数
        let parameters: [String: Any] = ["channel_id": channel_id, "after": after, "limit": limit, "keyword": keyword, "tags": tags]
        request.parameter = parameters
        // 3.发起请求
        RequestNetworkData.share.text(request: request) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(nil, "网络请求错误", false)
            case .failure(let failure):
                complete(nil, failure.message, false)
            case .success(let data):
                complete(data.models, nil, true)
            }
        }
    }
    
    /// 获取视频详细
    /// video_id
    class func getVideosListData(video_id: Int ,complete: @escaping ((NYVideosModel?,_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = PopularNetworkRequest().getVideobyId
        request.urlPath = request.fullPathWith(replacers: ["\(video_id)"])
//        // 2.配置参数
//        let parameters: [String: Any] = ["channel_id": channel_id, "after": after, "limit": limit, "keyword": keyword, "tags": tags]
//        request.parameter = parameters
        // 3.发起请求
        RequestNetworkData.share.text(request: request) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete(nil, "网络请求错误", false)
            case .failure(let failure):
                complete(nil, failure.message, false)
            case .success(let data):
                complete(data.model, nil, true)
            }
        }
        
    }
    /// 推荐视频
    /// id
    class func getRecommendVideosData(_id: Int ,complete: @escaping (([NYVideosModel]?,_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = PopularNetworkRequest().getVideoRecommend
        request.urlPath = request.fullPathWith(replacers: ["\(_id)"])
        try! RequestNetworkData.share.textRequest(method: .get, path: request.urlPath, parameter: nil, complete: { (data: NetworkResponse?, status: Bool) in
            // 1. 网络请求失败
            guard status else {
                let message = TSCommonNetworkManager.getNetworkErrorMessage(with: data)
                complete(nil, "网络请求错误", false)
                return
            }
            // 2. 数据格式错误
            guard let datas = data as? [[String: Any]] else {
                complete(nil, "服务器返回数据错误", false)
                return
            }
            // 3. 正常解析数据
            var list:[NYVideosModel]? = NSMutableArray() as! [NYVideosModel]
            for obj in datas
            {
                let video = obj["video"] as? [String: Any]
                let vm = NYVideosModel(JSON: video! )
                list?.append(vm!)
            }
            complete(list, "ok", true)
        })

    }
    
    /// 批量获取视频评论
    /// id   
    class func getCommentsVideosData(_id: Int ,complete: @escaping (([FeedListCommentModel]?,_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = PopularNetworkRequest().getVideoComments
        request.urlPath = request.fullPathWith(replacers: ["\(_id)"])
        try! RequestNetworkData.share.textRequest(method: .get, path: request.urlPath, parameter: nil, complete: { (data: NetworkResponse?, status: Bool) in
            // 1. 网络请求失败
            guard status else {
                let message = TSCommonNetworkManager.getNetworkErrorMessage(with: data)
                complete(nil, "网络请求错误", false)
                return
            }
            // 2. 数据格式错误
            guard let datas = data as? [String: Any] else {
                complete(nil, "服务器返回数据错误", false)
                return
            }
            // 3. 正常解析数据
            let array = datas["comments"] as? [[String: Any]]
            var list:[FeedListCommentModel]? = NSMutableArray() as! [FeedListCommentModel]
            for obj in array!
            {
                let vm = FeedListCommentModel(JSON: (obj as? [String: Any])! )
                list?.append(vm!)
            }
            complete(list, "ok", true)
        })
        
    }
//    /// 批量获取视频评论
//    /// id
//    class func getStarsListData(_id: Int ,complete: @escaping (([StarsHotModel]?,_ msg: String?, _ status: Bool) -> Void)) -> Void {
//        // 1.请求 url
//        var request = PopularNetworkRequest().getStarsList
//
//        try! RequestNetworkData.share.textRequest(method: .get, path: request.urlPath, parameter: nil, complete: { (data: NetworkResponse?, status: Bool) in
//            // 1. 网络请求失败
//            guard status else {
//                let message = TSCommonNetworkManager.getNetworkErrorMessage(with: data)
//                complete(nil, "网络请求错误", false)
//                return
//            }
//            // 2. 数据格式错误
//            guard let datas = data as? [String: Any] else {
//                complete(nil, "服务器返回数据错误", false)
//                return
//            }
//            // 3. 正常解析数据
//            let array = datas["comments"] as? [[String: Any]]
//            var list:[FeedListCommentModel]? = NSMutableArray() as! [FeedListCommentModel]
//            for obj in array!
//            {
//                let vm = FeedListCommentModel(JSON: (obj as? [String: Any])! )
//                list?.append(vm!)
//            }
//            complete(list, "ok", true)
//        })
//    }
}
