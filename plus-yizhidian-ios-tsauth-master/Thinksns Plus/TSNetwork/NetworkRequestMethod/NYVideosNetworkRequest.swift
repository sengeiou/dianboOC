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
}

