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
}
