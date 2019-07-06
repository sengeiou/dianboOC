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
    
}
