//
//  TSMeTableViewHeader.swift
//  ThinkSNS +
//
//  Created by Fiction on 2017/7/21.
//  Copyright © 2017年 ZhiYiCX. All rights reserved.
//
// MeTableView头视图分离的view

import UIKit
import Kingfisher

protocol didHeaderViewDelegate: NSObjectProtocol {
    /// 点击了头视图中的那一个view
    func didHeaderIndex(index: MeHeaderView)
    /// 推广
    func didExtension()
    /// 消息
    func didMessagedo()
    /// 设置
    func didSettingdo()
}

enum MeHeaderView: Int {
    /// userinfoview
    case user = 0
    /// fans view
    case fans
    /// follow view
    case follow
    /// friend view
    case friend
}

class TSMeTableViewHeader: UIView {
    
    let topView = UIView()
    let logoView = UIButton(type: .custom)
    let msgView = UIButton(type: .custom)
    let settingView = UIButton(type: .custom)
    /// 用户信息展示view
    let userInfoView: UIView = UIView()
    let headbgimgView = UIImageView(image: UIImage(named: "me_bg"))
    /// 头像图片
    var avatar: AvatarView!
    /// 名字
    var name: UILabel = UILabel()
    /// 简介
//    var intro: TYAttributedLabel = TYAttributedLabel()
    /// >
//    var accessory: UIImageView = UIImageView()
    ///  用户id
    let id = TSCurrentUserInfo.share.userInfo?.userIdentity
    weak var didHeaderViewDelegate: didHeaderViewDelegate? = nil
    /// 粉丝和关注的背景view
    let userFansAndFollowBackGround: UIView = UIView()
//    /// 粉丝view
//    let fansView: UIView = UIView()
//    /// 关注view
//    let followView: UIView = UIView()
//    /// 好友view
//    let friendView: UIView = UIView()
    /// 数字 - 粉丝
    let fanslabel: UILabel = UILabel()
    /// 数字 - 关注
    let followlabel: UILabel = UILabel()
    /// 数字 - 好友
    let friendlabel: UILabel = UILabel()
    /// 粉丝小红点
    let fansBage = TSBageNumberView()
    /// 关注小红点
    let followBage = TSBageNumberView()
    /// 好友小红点
    let friendBage = TSBageNumberView()
    
    /// 已看次数
    let seeCountLabel = UILabel()
    let seeTextLabel = UILabel()
    let seeButton = UIButton(type: .custom)
    /// 已下载次数
    let dowCountLabel = UILabel()
    let dowTextLabel = UILabel()
    let dowButton = UIButton(type: .custom)
    /// 推广升级
    let upgradeImgButton = UIButton(type: .custom)
    let upgradeTextLabel = UILabel()
    let upgradeButton = UIButton(type: .custom)
    /// line x 2
    let line1 = UIView()
    let line2 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUI() {
        setUserInfo()
        setUserFansAndFollow()
    }

    /// load用户信息展示
    func  setUserInfo() {
        self.backgroundColor = UIColor.clear
        userInfoView.backgroundColor = UIColor.clear // TSColor.main.white
        /// 给用户信息展示view添加点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapUser))
        userInfoView.addGestureRecognizer(tap)

        // 头像
        avatar = AvatarView(type: AvatarType.widt90(showBorderLine: false))
        avatar.avatarPlaceholderType = AvatarView.PlaceholderType(sexNumber: (TSCurrentUserInfo.share.userInfo?.sex ?? 0))
        let avatarInfo = AvatarInfo()
        avatarInfo.avatarURL = TSUtil.praseTSNetFileUrl(netFile: TSCurrentUserInfo.share.userInfo?.avatar)
        avatarInfo.verifiedIcon = TSCurrentUserInfo.share.userInfo?.verified?.icon ?? ""
        avatarInfo.verifiedType = TSCurrentUserInfo.share.userInfo?.verified?.type ?? ""
        avatarInfo.type = .normal(userId: id)
        avatar.avatarInfo = avatarInfo

        // 名字
        name.font = UIFont.systemFont(ofSize: TSFont.Title.pulse.rawValue)
        name.textAlignment = .center
        name.textColor = UIColor.white

//        // 简介
//        intro.numberOfLines = 2
//        intro.linesSpacing = 10
//        intro.verticalAlignment = .top
//        intro.font = UIFont.systemFont(ofSize: TSFont.SubInfo.footnote.rawValue)
//        intro.textColor = TSColor.normal.minor
//        intro.lineBreakMode = .byTruncatingTail

//        accessory.image = #imageLiteral(resourceName: "IMG_ic_arrow_smallgrey")
//        accessory.contentMode = .scaleAspectFill
//        userInfoView.addSubview(accessory)
        topView.backgroundColor = UIColor.clear
        logoView.setImage(UIImage(named: "me_logo"), for: .normal)
//        logoView.contentEdgeInsets = UIEdgeInsetsMake(20, 15, 20, 15)
        msgView.setImage(UIImage(named: "me_msg"), for: .normal)
        msgView.addTarget(self, action: #selector(tapMessage(_:)), for: .touchUpInside)
        settingView.setImage(UIImage(named: "me_setting"), for: .normal)
        settingView.addTarget(self, action: #selector(tapSetings(_:)), for: .touchUpInside)
        
        self.addSubview(headbgimgView)
        self.addSubview(topView)
        self.addSubview(userInfoView)
        userInfoView.addSubview(avatar)
        userInfoView.addSubview(name)
        topView.addSubview(logoView)
        topView.addSubview(msgView)
        topView.addSubview(settingView)
//        userInfoView.addSubview(intro)

        headbgimgView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(60)
        }
        
        logoView.snp.makeConstraints { (make) in
            make.top.left.equalTo(topView)
            make.width.height.equalTo(60)
        }
        
        msgView.snp.makeConstraints { (make) in
            make.top.equalTo(topView)
            make.right.equalTo(settingView.snp.left)
            make.width.height.equalTo(60)
        }
        
        settingView.snp.makeConstraints { (make) in
            make.top.right.equalTo(topView)
            make.width.height.equalTo(60)
        }
        
        userInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(150)
        }
        avatar.snp.makeConstraints { (make) in
            make.top.equalTo(userInfoView).offset(10)
            make.centerX.equalTo(userInfoView.snp.centerX)
            make.width.height.equalTo(100)
        }
        name.snp.makeConstraints { (make) in
            make.top.equalTo(avatar.snp.bottom).offset(0)
            make.left.equalTo(userInfoView)
            make.right.equalTo(userInfoView)
            make.height.equalTo(17.5)
        }
//        intro.snp.makeConstraints { (make) in
//            make.top.equalTo(name.snp.bottom).offset(9)
//            make.left.equalTo(avatar.snp.right).offset(10)
//            make.right.equalTo(accessory.snp.left).offset(-14)
//            make.height.equalTo(40.5)
//        }
//        accessory.snp.makeConstraints { (make) in
//            make.top.equalTo(userInfoView).offset(39.5)
//            make.right.equalTo(userInfoView.snp.right).offset(-16)
//            make.width.equalTo(10)
//            make.height.equalTo(20)
//        }
    }

    /// 创建粉丝和关注BG
    func setUserFansAndFollow() {
        userFansAndFollowBackGround.backgroundColor = UIColor.clear

        self.addSubview(userFansAndFollowBackGround)

        userFansAndFollowBackGround.snp.makeConstraints { (make) in
            make.top.equalTo(userInfoView.snp.bottom)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        
        /// 已看次数
        let seeCountW:CGFloat = ScreenWidth / 3
        let seeCountH:CGFloat = 18
        let seeCountX:CGFloat = 0
        let seeCountY:CGFloat = 30
        seeCountLabel.textColor = UIColor.white
        seeCountLabel.text = "0/55"
        seeCountLabel.textAlignment = .center
        seeCountLabel.frame = CGRect(x:seeCountX,y:seeCountY,width:seeCountW,height:seeCountH)
        seeCountLabel.font = UIFont.systemFont(ofSize: 12)
        userFansAndFollowBackGround.addSubview(seeCountLabel)
        
        seeTextLabel.textColor = UIColor.white
        seeTextLabel.text = "已看 / 可看次数"
        seeTextLabel.textAlignment = .center
        seeTextLabel.frame = CGRect(x:seeCountX,y:seeCountLabel.frame.maxY,width:seeCountW,height:seeCountH)
        seeTextLabel.font = UIFont.systemFont(ofSize: 12)
        userFansAndFollowBackGround.addSubview(seeTextLabel)
        
        seeButton.frame = CGRect(x:seeCountX,y:10,width:seeCountW,height:70)
        seeButton.tag = 0
        seeButton.backgroundColor = UIColor.clear
        seeButton.addTarget(self, action: #selector(tagButtonClickdo(_:)), for: .touchUpInside)
        userFansAndFollowBackGround.addSubview(seeButton)
        /// 已下载次数
        let dowCountW:CGFloat = seeCountW
        let dowCountH:CGFloat = seeCountH
        let dowCountX:CGFloat = seeCountW*1
        let dowCountY:CGFloat = seeCountY
        dowCountLabel.textColor = UIColor.white
        dowCountLabel.text = "0/55"
        dowCountLabel.textAlignment = .center
        dowCountLabel.frame = CGRect(x:dowCountX,y:dowCountY,width:dowCountW,height:dowCountH)
        dowCountLabel.font = UIFont.systemFont(ofSize: 12)
        userFansAndFollowBackGround.addSubview(dowCountLabel)
        
        dowTextLabel.textColor = UIColor.white
        dowTextLabel.text = "已下 / 下载次数"
        dowTextLabel.textAlignment = .center
        dowTextLabel.frame = CGRect(x:dowCountX,y:seeCountLabel.frame.maxY,width:seeCountW,height:seeCountH)
        dowTextLabel.font = UIFont.systemFont(ofSize: 12)
        userFansAndFollowBackGround.addSubview(dowTextLabel)
        
        dowButton.frame = CGRect(x:dowCountX,y:10,width:seeCountW,height:70)
        dowButton.tag = 1
        dowButton.backgroundColor = UIColor.clear
        dowButton.addTarget(self, action: #selector(tagButtonClickdo(_:)), for: .touchUpInside)
        userFansAndFollowBackGround.addSubview(dowButton)
        /// 推广升级
        let upImgW:CGFloat = seeCountW
        let upImgH:CGFloat = seeCountH
        let upImgX:CGFloat = seeCountW*2
        let upImgY:CGFloat = seeCountY
        upgradeImgButton.setImage(UIImage(named: "me_head_up"), for: .normal)
        upgradeImgButton.frame = CGRect(x:upImgX,y:upImgY,width:upImgW,height:upImgH)
        userFansAndFollowBackGround.addSubview(upgradeImgButton)
        
        upgradeTextLabel.textColor = UIColor.white
        upgradeTextLabel.text = "推广可升级"
        upgradeTextLabel.textAlignment = .center
        upgradeTextLabel.frame = CGRect(x:upImgX,y:seeCountLabel.frame.maxY,width:seeCountW,height:seeCountH)
        upgradeTextLabel.font = UIFont.systemFont(ofSize: 12)
        userFansAndFollowBackGround.addSubview(upgradeTextLabel)
        
        upgradeButton.frame = CGRect(x:upImgX,y:10,width:seeCountW,height:70)
        upgradeButton.tag = 2
        upgradeButton.backgroundColor = UIColor.clear
        upgradeButton.addTarget(self, action: #selector(tagButtonClickdo(_:)), for: .touchUpInside)
        userFansAndFollowBackGround.addSubview(upgradeButton)
        /// line x 2
        let lineW:CGFloat = 0.5
        let lineH:CGFloat = 30
        let lineX:CGFloat = dowCountX
        let lineY:CGFloat = seeCountY+3
        line1.backgroundColor = UIColor.lightGray
        line2.backgroundColor = UIColor.lightGray
        line1.frame = CGRect(x:lineX,y:lineY,width:lineW,height:lineH)
        line2.frame = CGRect(x:lineX*2,y:lineY,width:lineW,height:lineH)
        userFansAndFollowBackGround.addSubview(line1)
        userFansAndFollowBackGround.addSubview(line2)
        
        setFansView()
        setFollowView()
        setFriendView()
    }
    
    /// header 按钮 tag
    func tagButtonClickdo(_ btn:UIButton)
    {
        didHeaderViewDelegate?.didExtension()
    }

    /// 单独加载粉丝
    func setFansView() {
        /// 给粉丝view添加点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFans))
        fanslabel.textColor = TSColor.main.content
        fanslabel.font = UIFont.boldSystemFont(ofSize: 20)
        let label = UILabel()
        label.text = "粉丝"
        label.font = UIFont.systemFont(ofSize: TSFont.SubInfo.mini.rawValue)
        label.textColor = TSColor.normal.minor

//        fansView.addGestureRecognizer(tap)
//        fansView.addSubview(fanslabel)
//        fansView.addSubview(label)
//        fansView.addSubview(fansBage)

//        fanslabel.snp.makeConstraints { (make) in
//            make.top.equalTo(fansView).offset(12)
//            make.centerX.equalTo(fansView)
//            make.height.equalTo(20)
//        }
//        fansBage.snp.makeConstraints { (make) in
//            make.top.equalTo(fansView).offset(8)
//            make.left.equalTo(fanslabel.snp.right).offset(8)
//            make.width.equalTo(bageViewBouds.Width.rawValue)
//            make.height.equalTo(bageViewBouds.Height.rawValue)
//        }
//        label.snp.makeConstraints { (make) in
//            make.top.equalTo(fanslabel.snp.bottom).offset(5)
//            make.centerX.equalTo(fansView)
//            make.height.equalTo(13)
//        }
    }

    /// 单独加载关注
    func setFollowView() {
        /// 给关注view添加点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFollow))
        followlabel.textColor = TSColor.main.content
        followlabel.font = UIFont.boldSystemFont(ofSize: 20)

        let label = UILabel()
        label.text = "关注"
        label.font = UIFont.systemFont(ofSize: TSFont.SubInfo.mini.rawValue)
        label.textColor = TSColor.normal.minor

//        followView.addGestureRecognizer(tap)
//        followView.addSubview(followlabel)
//        followView.addSubview(label)
//        followView.addSubview(followBage)
//
//        followlabel.snp.makeConstraints { (make) in
//            make.top.equalTo(followView).offset(12)
//            make.centerX.equalTo(followView)
//            make.height.equalTo(20)
//        }
//        followBage.snp.makeConstraints { (make) in
//            make.top.equalTo(followView).offset(8)
//            make.left.equalTo(followlabel.snp.right).offset(8)
//            make.width.equalTo(bageViewBouds.Width.rawValue)
//            make.height.equalTo(bageViewBouds.Height.rawValue)
//        }
//        label.snp.makeConstraints { (make) in
//            make.top.equalTo(followlabel.snp.bottom).offset(5)
//            make.centerX.equalTo(followView)
//            make.height.equalTo(13)
//        }

    }

    /// 单独加载好友
    func setFriendView() {
        /// 给关注view添加点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFriend))
        friendlabel.textColor = TSColor.main.content
        friendlabel.font = UIFont.boldSystemFont(ofSize: 20)

        let label = UILabel()
        label.text = "好友"
        label.font = UIFont.systemFont(ofSize: TSFont.SubInfo.mini.rawValue)
        label.textColor = TSColor.normal.minor

//        friendView.addGestureRecognizer(tap)
//        friendView.addSubview(friendlabel)
//        friendView.addSubview(label)
//        friendView.addSubview(friendBage)
//
//        friendlabel.snp.makeConstraints { (make) in
//            make.top.equalTo(friendView).offset(11.5)
//            make.centerX.equalTo(friendView)
//            make.height.equalTo(20)
//        }
//        friendBage.snp.makeConstraints { (make) in
//            make.top.equalTo(friendView).offset(8)
//            make.left.equalTo(friendlabel.snp.right).offset(8)
//            make.width.equalTo(bageViewBouds.Width.rawValue)
//            make.height.equalTo(bageViewBouds.Height.rawValue)
//        }
//        label.snp.makeConstraints { (make) in
//            make.top.equalTo(friendlabel.snp.bottom).offset(5)
//            make.centerX.equalTo(friendView)
//            make.height.equalTo(13)
//        }

    }

    // MARK: - 外部调用改变view展示的方法
    /// 更改用户展示view数据
    public func changeUserInfoData() {
        guard let userInfo = TSCurrentUserInfo.share.userInfo else {
            return
        }
        // 更新用户名
        name.text = userInfo.name
        // 更新用户简介
//        intro.text = userInfo.shortDesc()
//        var introHeight: CGFloat = intro.text?.heightWithConstrainedWidth(width: intro.width, font: intro.font) ?? 0
//        if introHeight > 20 {
//            introHeight = 34.5
//        }
//        intro.frame = CGRect.init(x: avatar.right + 10, y: name.bottom + 7.5, width: accessory.left - 14 - avatar.right - 10, height: introHeight)
        // 关注 - following
        let follower = userInfo.extra?.followingsCount ?? 0
        followlabel.text = "\(follower)"
        // 粉丝 - follower
        let following = userInfo.extra?.followersCount ?? 0
        fanslabel.text = "\(following)"
        // 好友 - friend
        let friend = userInfo.friendsCount
        friendlabel.text = "\(friend)"
        /// 已看次数
        let watchCount = userInfo.eExtension?.watch_has_use_count ?? 0
        let watchTotalCount = userInfo.eExtension?.watch_total_count ?? 0
        seeCountLabel.text = "\(watchCount)/\(watchTotalCount)"
        /// 已下载次数
        let downCount = userInfo.eExtension?.watch_has_use_count ?? 0
        let downTotalCount = userInfo.eExtension?.watch_total_count ?? 0
        dowCountLabel.text = "\(downCount)/\(downTotalCount)"
        

        let avatarInfo = AvatarInfo()
        avatarInfo.avatarURL = TSUtil.praseTSNetFileUrl(netFile: userInfo.avatar)
        avatarInfo.verifiedType = userInfo.verified?.type ?? ""
        avatarInfo.verifiedIcon = userInfo.verified?.icon ?? ""
        avatarInfo.type = .normal(userId: userInfo.userIdentity)
        avatar.avatarPlaceholderType = AvatarView.PlaceholderType(sexNumber: (TSCurrentUserInfo.share.userInfo?.sex ?? 0))
        avatar.avatarInfo = avatarInfo
    }

    // MARK: - Gesture的sector
    func tapUser() {
        self.didHeaderViewDelegate?.didHeaderIndex(index: .user)
    }

    func tapFans() {
        self.didHeaderViewDelegate?.didHeaderIndex(index: .fans)
    }

    func tapFollow() {
        self.didHeaderViewDelegate?.didHeaderIndex(index: .follow)
    }

    func tapFriend() {
        self.didHeaderViewDelegate?.didHeaderIndex(index: .friend)
    }
    
    func tapMessage(_ btn:UIButton){
        self.didHeaderViewDelegate?.didMessagedo()
    }
    
    func tapSetings(_ btn:UIButton){
        self.didHeaderViewDelegate?.didSettingdo()
    }
}
