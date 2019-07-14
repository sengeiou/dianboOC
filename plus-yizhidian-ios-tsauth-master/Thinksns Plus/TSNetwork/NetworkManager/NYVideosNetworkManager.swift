//
//  NYVideosNetworkManager.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/5.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import Alamofire

class NYVideosNetworkManager {
    
}

// MARK: --视频 收藏
extension NYVideosNetworkManager {
    
    /// 收藏
    ///
    class func postVideoCollections(video_id:Int,  complete: @escaping ((_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = NYVideosNetworkRequest().postVideoCollections
        request.urlPath = request.fullPathWith(replacers: ["\(video_id)"])
        
        try! RequestNetworkData.share.textRequest(method: .post, path: request.urlPath, parameter: nil, complete: { (data: NetworkResponse?, status: Bool) in
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
            complete(message, true)
        })
    }
    
    /// 取消收藏视频
    class func postVideoUncollect(video_id:Int,  complete: @escaping ((_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = NYVideosNetworkRequest().postVideoUncollect
        request.urlPath = request.fullPathWith(replacers: ["\(video_id)"])
        
        try! RequestNetworkData.share.textRequest(method: .post, path: request.urlPath, parameter: nil, complete: { (data: NetworkResponse?, status: Bool) in
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
            complete(message, true)
        })
    }
    
    /// 发布视频评论
    /// body 评论内容  reply_user 被回复人id，选填，当评论为子评论，且回复某用户时必填
    /// reply_comment_id 被回复的评论id（父级评论id)，选填，当评论为子评论时必填
    class func postVideoCommentsdo(video_id:Int,body:String,reply_user:String = "", reply_comment_id:String = "", complete: @escaping ((_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = NYVideosNetworkRequest().postVideoComments
        request.urlPath = request.fullPathWith(replacers: ["\(video_id)"])
        var parameters: [String: Any] = ["body": body]
        if reply_user.count>0 {
            parameters.updateValue(reply_user, forKey: "reply_user")
        }
        if reply_comment_id.count>0 {
            parameters.updateValue(reply_comment_id, forKey: "reply_comment_id")
        }
            //,"reply_user": reply_user,"reply_comment_id": reply_comment_id]
        try! RequestNetworkData.share.textRequest(method: .post, path: request.urlPath, parameter: parameters, complete: { (data: NetworkResponse?, status: Bool) in
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
            let message = datas["message"] as! [String]
            let comment = datas["comment"] as! [String: Any]
            complete(message[0], true)
        })
    }
    /// 批量获取视频评论
    class func getVideoComments(video_id:Int,  complete: @escaping (([FeedListCommentModel]?,_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = NYVideosNetworkRequest().postVideoComments
        request.urlPath = request.fullPathWith(replacers: ["\(video_id)"])
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

    /// 评论取消点赞
    class func delVideoCommentLike(comment_id:Int,  complete: @escaping ((_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = NYVideosNetworkRequest().videoCommentLike
        request.urlPath = request.fullPathWith(replacers: [])
        let parameters: [String: Any] = ["comment_id": comment_id]
        try! RequestNetworkData.share.textRequest(method: .delete, path: request.urlPath, parameter: parameters, complete: { (data: NetworkResponse?, status: Bool) in
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
            complete(message, true)
        })
    }
    /// 评论点赞
    class func postVideoCommentLike(comment_id:Int,  complete: @escaping ((_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = NYVideosNetworkRequest().videoCommentLike
        request.urlPath = request.fullPathWith(replacers: [])
        request.parameter = ["comment_id": comment_id]
        request.method = .post
        // 3.发起请求
        RequestNetworkData.share.text(request: request) { (networkResult) in
            switch networkResult {
            case .error(_):
                complete("网络请求错误", false)
            case .failure(let failure):
                complete(failure.message, false)
            case .success(let data):
                complete(data.message, true)
            }
        }
    }
    /// 视频评论的更多回复
    class func getVideoCommentGetChildren(video_id:Int,comment_id:Int,  complete: @escaping ((_ msg: String?, _ status: Bool) -> Void)) -> Void {
        // 1.请求 url
        var request = NYVideosNetworkRequest().videoCommentGetChildren
        request.urlPath = request.fullPathWith(replacers: ["\(video_id)"])
        let parameters: [String: Any] = ["comment_id": comment_id]
        try! RequestNetworkData.share.textRequest(method: .post, path: request.urlPath, parameter: parameters, complete: { (data: NetworkResponse?, status: Bool) in
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
            complete(message, true)
        })
    }
    
}
