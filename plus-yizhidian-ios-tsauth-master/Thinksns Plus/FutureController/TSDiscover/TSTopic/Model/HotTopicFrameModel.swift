//
//  HotTopicFrameModel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/25.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class HotTopicFrameModel: Mappable
{
    
    ///头像
    var headViewF:CGRect?
    
    ///昵称
    var nickViewF:CGRect?
    
    ///time
    var timeViewF:CGRect?
    
    ///来自
    var fromTxtViewF:CGRect?
    
    ///内容
    var contentViewF:CGRect?
    
    ///查看全文
    var allTxtViewF:CGRect?
    
    ///视频
    var videoViewF:CGRect?
    
    ///分享
    var shareViewF:CGRect?
    
    ///评论
    var commentViewF:CGRect?
    
    ///喜欢
    var likeViewF:CGRect?
    
    ///line
    var lineListF=NSMutableArray()
    
    ///9图 数组
    var imgListF:NSMutableArray?
    
    ///背景图
    var bgViewF:CGRect?
    
    ///cell 高度
    var cellHeight:CGFloat?
    
    ///热门cell 模型
    var hotTopicModel:HotTopicModel?
    
    init() {
    }
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        
    }
    
    func setFeedListCellModel(feedModel:FeedListCellModel)
    {
        let hotModel = HotTopicModel()
        hotModel.id = feedModel.cellTopicId
        hotModel.group_id = feedModel.fromGroupID
        hotModel.title = feedModel.title
        hotModel.user_id = feedModel.userId
        hotModel.summary = feedModel.content
        hotModel.likes_count = 1
        hotModel.comments_count = feedModel.comments.count
        hotModel.views_count = 1
        hotModel.userInfo = feedModel.postListModel.userInfo
        hotModel.created_at = feedModel.postListModel.create
        hotModel.comment_updated_at = feedModel.postListModel.update
        setHotTopicModel(hotTModel: hotModel)
    }
    
    func setHotTopicModel(hotTModel:HotTopicModel)
    {
        hotTopicModel = hotTModel
//
        //计算 frame
        let maring:CGFloat = 12
        ///头像
        let headWH:CGFloat = 50
        headViewF = CGRect(x:maring,y:CGFloat(15),width:headWH,height:headWH)
        
        ///昵称
        let nickW:CGFloat = 150
        let nickH:CGFloat = 20
        nickViewF = CGRect(x:CGFloat((headViewF?.maxX)!+15),y:CGFloat(15),width:nickW,height:nickH)
        
        ///time
        let timeH:CGFloat = 20
        let timeW:CGFloat = 100
//            (titleArray[0].sizeOfString(usingFont: UIFont.systemFont(ofSize: TSFont.Title.headline.rawValue))).width
        timeViewF = CGRect(x:CGFloat((headViewF?.maxX)!+15),y:CGFloat((nickViewF?.maxY)!+5),width:timeW,height:timeH)
        
        ///来自
        let fromW:CGFloat = 200
        let fromH:CGFloat = 20
        fromTxtViewF = CGRect(x:((timeViewF?.maxX)!+10),y:(timeViewF?.origin.y)!,width:fromW,height:fromH)
        
        ///内容
        let contentW:CGFloat = ScreenWidth-maring*2
        let contentH:CGFloat = 50
        contentViewF = CGRect(x:maring,y:(headViewF?.maxY)!+5,width:contentW,height:contentH)
        
        ///查看全文
        let allTxtW:CGFloat = 100
        let allTxtH:CGFloat = 30
        let allTxtY:CGFloat = (contentViewF?.maxY)! - allTxtH
        let allTxtX:CGFloat = (contentViewF?.maxX)! - allTxtW
        allTxtViewF = CGRect(x:allTxtX,y:allTxtY,width:allTxtW,height:allTxtH)
        
        ///视频
        let videoW:CGFloat = contentW
        let videoH:CGFloat = contentW*0.4
        let videoY:CGFloat = (allTxtViewF?.maxY)!+5
        let videoX:CGFloat = maring
        videoViewF = CGRect(x:videoX,y:videoY,width:videoW,height:videoH)
        
        ///分享
        let shareW:CGFloat = ScreenWidth/3.0
        let shareH:CGFloat = 40
        let shareY:CGFloat = (videoViewF?.maxY)!+5
        let shareX:CGFloat = maring
        shareViewF = CGRect(x:shareX,y:shareY,width:shareW,height:shareH)
        
        ///评论
        commentViewF = CGRect(x:shareW,y:shareY,width:shareW,height:shareH)
        
        ///喜欢
        likeViewF = CGRect(x:shareW*2,y:shareY,width:shareW,height:shareH)
        
        let lineY:CGFloat = shareY+10
        let lineW:CGFloat = 1
        let lineH:CGFloat = shareH-20
        lineListF.addObjects(from: [CGRect(x:shareW*1,y:lineY,width:lineW,height:lineH),
                                    CGRect(x:shareW*2,y:lineY,width:lineW,height:lineH)])
        
        ///9图 数组
//        var imgListF:NSMutableArray?
        
        ///cell 高度
        cellHeight = (likeViewF?.maxY)! + 15
        
        ///背景图
        let bgY:CGFloat = 15
        bgViewF = CGRect(x:0,y:bgY,width:ScreenWidth,height:cellHeight!-bgY)
    }
    
}
