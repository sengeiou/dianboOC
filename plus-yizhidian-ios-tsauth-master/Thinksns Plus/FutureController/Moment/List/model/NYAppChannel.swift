//
//  NYAppChannel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/12.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import ObjectMapper

class NYAppChannel: Mappable {
    
    var channel_id = 0

    var channel_tag:[String]?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        channel_id <- map["channel_id"]
        channel_tag <- map["channel_tag"]
    }

}
