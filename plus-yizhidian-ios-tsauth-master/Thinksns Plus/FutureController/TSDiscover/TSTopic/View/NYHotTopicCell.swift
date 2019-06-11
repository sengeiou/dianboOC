//
//  NYHotTopicCell.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/25.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit


protocol NYHotTopicCellDelegate: NSObjectProtocol {
    func cell(_ cell: TSTableViewCell, operateBtn: TSButton, indexPathRow: NSInteger)
}

class NYHotTopicCell: UITableViewCell {

    var hotTopicFrameModel:HotTopicFrameModel?
    ///bgview
    let bgView = UIView()
    /// 头像
    var headerImageButton: UIButton?
    /// 昵称
    var nickNameLabel: TSLabel?
    /// 时间
    var timeLabel: TSLabel?
    /// 来自
    var fromLabel: TSLabel?
    /// 内容
    var contentLabel: TSLabel?
    /// 查看全文
    var alltxtButton:UIButton?
    /// 视频内容
    var videoImageButton:UIButton?
    /// 放9图 备用
    var contentImgView:UIView?
    
    ///分享
    var shareButton:UIButton?
    ///评论
    var commentButton:UIButton?
    ///点赞
    var likeButton:UIButton?
    ///line
    let lineA = UILabel()
    let lineB = UILabel()
    
    /// 代理
    weak var delegate: NYHotTopicCellDelegate?
    
//    func isEnabledHeaderButton(isEnabled: Bool) {
//        headerImageButton?.buttonForAvatar.isUserInteractionEnabled = isEnabled
//    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        bgView.backgroundColor = TSColor.main.themeTBCellBg
        self.contentView.addSubview(bgView)
        /// 头像
        self.headerImageButton = UIButton(type: .custom)
        self.headerImageButton?.setImage(UIImage(named: "IMG_pic_default_woman"), for: .normal)
        bgView.addSubview(self.headerImageButton!)
        /// 昵称
        self.nickNameLabel = TSLabel()
        self.nickNameLabel?.textColor = TSColor.main.themeZsColor
        self.nickNameLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView.addSubview(self.nickNameLabel!)
        /// 时间
        self.timeLabel = TSLabel()
        self.timeLabel?.textColor = UIColor.white
        self.timeLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView.addSubview(self.timeLabel!)
        /// 来自
        self.fromLabel = TSLabel()
        self.fromLabel?.textColor = UIColor.white
        self.fromLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView.addSubview(self.fromLabel!)
        /// 内容
        self.contentLabel = TSLabel()
        self.contentLabel?.numberOfLines = 0
        self.contentLabel?.textColor = UIColor.white
        self.contentLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView.addSubview(self.contentLabel!)
        /// 视频内容
        self.videoImageButton = UIButton(type: .custom)
        self.videoImageButton?.layer.cornerRadius = 10
        self.videoImageButton?.layer.masksToBounds = true
        videoImageButton?.setImage(UIImage(named: "tmp2"), for: .normal)
        bgView.addSubview(self.videoImageButton!)
        /// 查看全文
        self.alltxtButton = UIButton(type: .custom)
        alltxtButton?.setImage(UIImage(named: "com_allow"), for: .normal)
        alltxtButton?.setTitle("查看全文", for: .normal)
        alltxtButton?.setTitleColor(TSColor.main.themeZsColor, for: .normal)
        alltxtButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bgView.addSubview(self.alltxtButton!)
        ///分享
        self.shareButton = UIButton(type: .custom)
        self.shareButton?.setImage(UIImage(named: "cell_share"), for: .normal)
        self.shareButton?.setTitle("9999", for: .normal)
        self.shareButton?.setTitleColor(UIColor.white, for: .normal)
        self.shareButton?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView.addSubview(self.shareButton!)
        ///评论
        self.commentButton = UIButton(type: .custom)
        self.commentButton?.setImage(UIImage(named: "cell_comment"), for: .normal)
        self.commentButton?.setTitle("9999", for: .normal)
        self.commentButton?.setTitleColor(UIColor.white, for: .normal)
        self.commentButton?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView.addSubview(self.commentButton!)
        ///点赞
        self.likeButton = UIButton(type: .custom)
        self.likeButton?.setImage(UIImage(named: "cell_like"), for: .normal)
        self.likeButton?.setTitle("9999", for: .normal)
        self.likeButton?.setTitleColor(UIColor.white, for: .normal)
        self.likeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView.addSubview(self.likeButton!)
        ///line
        lineA.backgroundColor = UIColor.lightGray
        bgView.addSubview(lineA)
        lineB.backgroundColor = UIColor.lightGray
        bgView.addSubview(lineB)
        ///9图
        self.contentImgView = UIView()
        bgView.addSubview(self.contentImgView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    ///分配 frame
    func setHotTopicFrameModel(hotTopicFrame:HotTopicFrameModel)
    {
        self.hotTopicFrameModel=hotTopicFrame
        let model = hotTopicFrame.hotTopicModel
        bgView.frame = hotTopicFrame.bgViewF!
        self.headerImageButton?.frame = hotTopicFrame.headViewF!
        self.headerImageButton?.layer.cornerRadius = (hotTopicFrame.headViewF?.size.width)!*0.5
        self.headerImageButton?.layer.masksToBounds = true
        //头像
        if let url = model?.userInfo.avatar?.url {
            self.headerImageButton?.setImageWith(URL(string: url), for: .normal)
        }
        /// 昵称
        self.nickNameLabel?.frame = hotTopicFrame.nickViewF!
        self.nickNameLabel?.text = model?.userInfo.name
        /// 时间
        self.timeLabel?.frame = hotTopicFrame.timeViewF!
        self.timeLabel?.text = model?.comment_updated_at.string()
        /// 来自
        self.fromLabel?.frame = hotTopicFrame.fromTxtViewF!
        self.fromLabel?.text = model?.groupInfo.name
        /// 内容
        self.contentLabel?.frame = hotTopicFrame.contentViewF!
        self.contentLabel?.text = model?.summary
        /// 视频内容
        self.videoImageButton?.frame = hotTopicFrame.videoViewF!
        if let url = model?.groupInfo.avatar?.url {
            self.videoImageButton?.setImageWith(URL(string: url), for: .normal)
        }
        self.alltxtButton?.frame = hotTopicFrame.allTxtViewF!
        /// 放9图 备用
//    self.contentImgView?.removeAllSubViews()
        
        ///分享
        self.shareButton?.frame = hotTopicFrame.shareViewF!
        self.shareButton?.setTitle(String(format:"%d",(model?.views_count)!), for: .normal)
        ///评论
        self.commentButton?.frame = hotTopicFrame.commentViewF!
        self.commentButton?.setTitle(String(format:"%d",(model?.comments_count)!), for: .normal)
        ///点赞
        self.likeButton?.frame = hotTopicFrame.likeViewF!
        self.likeButton?.setTitle(String(format:"%d",(model?.likes_count)!), for: .normal)
        ///line
        lineA.frame = hotTopicFrame.lineListF[0] as! CGRect
        lineB.frame = hotTopicFrame.lineListF[1] as! CGRect
        
    }
    
}
