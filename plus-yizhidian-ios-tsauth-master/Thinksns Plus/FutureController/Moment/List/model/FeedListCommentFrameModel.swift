//
//  FeedListCommentFrameModel.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/22.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class FeedListCommentFrameModel: NSObject {

    ///头像
    var user_imageViewF:CGRect!
    
    ///昵称
    var user_nameViewF:CGRect!
    
    ///time
    var com_dateViewF:CGRect!
    
    /// 评论
    var commentButtonF:CGRect!
    
    /// 点赞
    var like_CountF:CGRect!
    
    /// line
    var line1F:CGRect!
    
    /// line
    var lineLF:CGRect!
    
    /// 内容
    var commentF:CGRect!
    
    /// line
    var line2F:CGRect!
    
    ///跟评论view
    var reply_listF:CGRect!
    ///跟评背景
    var reply_imagebgF:CGRect!
    ///跟评背景 = nil
    var replyLabListF:NSMutableArray!
    ///查看全文
    var allTxtViewF:CGRect!
    
    ///cell 高度
    var cellHeight:CGFloat!
    /// 数据模型
    var _commentModel:FeedListCommentModel!
    
    func setListCommentModel(commentModel:FeedListCommentModel) {
        _commentModel = commentModel
        
        //用户头像
        let userImgWH:CGFloat = 45
        let userImgX:CGFloat = 10
        let userImgY:CGFloat = 15
        self.user_imageViewF = CGRect(x:userImgX,y:userImgY,width:userImgWH,height:userImgWH)

        //用户名称
        let userNameW:CGFloat = 180
        let userNameH:CGFloat = 22
        let userNameX:CGFloat = self.user_imageViewF.maxX+10
        let userNameY:CGFloat = userImgY+2
        self.user_nameViewF = CGRect(x:userNameX,y:userNameY,width:userNameW,height:userNameH)
  
        //评论时间
        let dateW:CGFloat = 180
        let dateH:CGFloat = 20
        let dateX:CGFloat = userNameX
        let dateY:CGFloat = self.user_nameViewF.maxY
        self.com_dateViewF = CGRect(x:dateX,y:dateY,width:dateW,height:dateH)
        
        //点赞数
        let likeW:CGFloat = 70
        let likeH:CGFloat = 30
        let likeX:CGFloat = ScreenWidth - userImgX - likeW
        let likeY:CGFloat = 20
        self.like_CountF = CGRect(x:likeX,y:likeY,width:likeW,height:likeH)
        // zline
        let L_W:CGFloat = 0.5
        let L_H:CGFloat = 15
        let L_X:CGFloat = self.like_CountF.minX - 3
        let L_Y:CGFloat = 28
        self.lineLF = CGRect(x:L_X,y:L_Y,width:L_W,height:L_H)
        //评论按钮
        let combWH:CGFloat = 35
        let combX:CGFloat = self.lineLF.minX-4-combWH
        let combY:CGFloat = 20
        self.commentButtonF = CGRect(x:combX,y:combY,width:combWH,height:combWH)
        
        //line 1
        let L1_W:CGFloat = (self.like_CountF?.maxX)! - (self.user_nameViewF?.minX)!
        let L1_H:CGFloat = 0.5
        let L1_X:CGFloat = userNameX
        let L1_Y:CGFloat = self.com_dateViewF.maxY+4
        self.line1F = CGRect(x:L1_X,y:L1_Y,width:L1_W,height:L1_H)
        
        //内容
        let com_size = commentModel.body.size(maxSize: CGSize(width:L1_W,height:CGFloat(MAXFLOAT)), font: UIFont.systemFont(ofSize: 12))
        
        let commentW:CGFloat = L1_W
        let commentH:CGFloat = com_size.height+10
        let commentX:CGFloat = L1_X
        let commentY:CGFloat = L1_Y+10
        self.commentF = CGRect(x:commentX,y:commentY,width:commentW,height:commentH)
        //line 2
        let L2_W:CGFloat = ScreenWidth - userImgX*2
        let L2_H:CGFloat = 0.5
        let L2_X:CGFloat = userImgX
        var L2_Y:CGFloat = self.commentF.maxY+10
        self.line2F = CGRect(x:L2_X,y:L2_Y,width:L2_W,height:L2_H)
        self.cellHeight = self.line2F.maxY+5
        
        replyLabListF = NSMutableArray()
        //跟评论
        var itemH:CGFloat = 20
        let itemW:CGFloat = commentW-20
        let itemX:CGFloat = 10
        if (commentModel.comment_children != nil)&&(commentModel.comment_children?.count)!>0
        {
            for (index,data) in (commentModel.comment_children?.enumerated())!
            {
                let namebody_size = commentModel.nameBody.size(maxSize: CGSize(width:L1_W,height:CGFloat(MAXFLOAT)), font: UIFont.systemFont(ofSize: 12))
                if namebody_size.height > itemH
                {
                    itemH = namebody_size.height
                }
                let itemY:CGFloat = 20+itemH*CGFloat(index)
                let itemF =  CGRect(x:itemX,y:itemY,width:itemW,height:itemH)
                replyLabListF?.add(itemF)
            }
            let lastF = replyLabListF.lastObject as! CGRect
            //全部
            let allW:CGFloat = commentW
            let allH:CGFloat = 20
            let allX:CGFloat = lastF.minX
            let allY:CGFloat = lastF.maxY+4
            self.allTxtViewF = CGRect(x:allX,y:allY,width:allW,height:allH)
            //跟评论view
            let reply_listW:CGFloat = commentW
            let reply_listH:CGFloat = self.allTxtViewF.maxY+10
            let reply_listX:CGFloat = commentX
            let reply_listY:CGFloat = self.commentF.maxY+4
            self.reply_listF = CGRect(x:reply_listX,y:reply_listY,width:reply_listW,height:reply_listH)
            //跟评背景
            self.reply_imagebgF = CGRect(x:0,y:0,width:reply_listW,height:reply_listH)
            //line 2
            L2_Y = self.reply_listF.maxY+10
            self.line2F = CGRect(x:L2_X,y:L2_Y,width:L2_W,height:L2_H)
            
            self.cellHeight = self.line2F.maxY+5
        }
    
    }
}
