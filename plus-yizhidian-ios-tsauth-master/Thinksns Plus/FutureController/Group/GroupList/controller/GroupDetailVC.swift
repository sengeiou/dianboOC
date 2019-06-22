//
//  GroupDetailVC.swift
//  ThinkSNSPlus
//
//  Created by IMAC on 2018/9/11.
//  Copyright © 2018年 ZhiYiCX. All rights reserved.
//

import UIKit

class GroupDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum PostsType: String {
        /// 最新帖子
        case latest = "group"
        /// 最新回复
        case reply = "group_reply"
        /// 精华帖，请求列表的时候需要设置excellent:1，分享H5不能用
        case recommend = "group_fine"
    }

    /// 圈子 id
    var groupId = 0
    fileprivate var groupModel = GroupModel()
    /// 数据 model
    fileprivate var model = PostListControllerModel()
    /// header view
    fileprivate let headerView = PostListHeaderView()
//    /// 导航视图
//    fileprivate let navView = PostListNavView()
    /// 列表视图
    fileprivate let table = GroupDetailRootTableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
    /// 分栏高度
    fileprivate let styleSelectedBarHeight: CGFloat = 55
    /// 背景滚动视图
    fileprivate let bgScrollView = UIScrollView(frame: .zero)
    /// 左边视图
    fileprivate let leftView = UIView()
    /// 右边视图
    fileprivate let rightView = MoreTableView(frame: CGRect(x: UIScreen.main.bounds.width, y: 0, width: 200, height: UIScreen.main.bounds.height))
    /// 蒙板视图（当右边视图显示时，用来遮挡左边视图的蒙板）
    fileprivate let maskView = UIControl()
    /// 发布按钮
    fileprivate var buttonForRelease = TSButton(type: .custom)
    /// 发布视频
    fileprivate var videoForButton = TSButton(type: .custom)
    /// 发布照片
    fileprivate var photoForButton = TSButton(type: .custom)
    /// 最新发布
    fileprivate var lastPostTable: NYPostListActionView!
    /// 最新回复
    fileprivate var lastCommentTable: NYPostListActionView!
    /// 精华帖子
    fileprivate var recommendTable: NYPostListActionView!
    /// 分类按钮数组
    fileprivate var seletedTypeBtns: [UIButton] = []
    fileprivate var seletedTypeBtn = UIButton()
    /// 是否可以滚动
    fileprivate var bgTableViewCanScroll: Bool = true
    /// 列表是否可以滚动
    fileprivate var childrenTableCouldScroll: Bool = false {
        didSet {
            lastPostTable.curentTabCanScroll = childrenTableCouldScroll
            lastCommentTable.curentTabCanScroll = childrenTableCouldScroll
            recommendTable.curentTabCanScroll = childrenTableCouldScroll
            if childrenTableCouldScroll == false {
                lastPostTable.contentOffset = .zero
                lastCommentTable.contentOffset = .zero
                recommendTable.contentOffset = .zero
            }
        }
    }
    /// 通过圈子id初始化
    init(groupId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.groupId = groupId
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setRightUI()
        NotificationCenter.default.addObserver(self, selector: #selector(notiResLeaveTop), name: NSNotification.Name(rawValue: "leaveTop"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
        // 更新导航栏右方按钮的位置
//        navView.updateRightButtonFrame()
    }
    
    func setRightUI()
    {
        let shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage(named: "com_share"), for: .normal)
        shareButton.frame = CGRect(x:0,y:0,width:30,height:30)
        shareButton.addTarget(self, action: #selector(shareClickdo(_:)), for: .touchUpInside)
        let moreButton = UIButton(type: .custom)
        moreButton.setImage(UIImage(named: "com_more"), for: .normal)
        moreButton.frame = CGRect(x:0,y:0,width:30,height:30)
        moreButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10)
        moreButton.addTarget(self, action: #selector(moreClickdo(_:)), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem.init(customView: moreButton),UIBarButtonItem.init(customView: shareButton)],animated: false)
    }
    //分享
    func shareClickdo(_ btn:UIButton) {
        guard let image = headerView.contentView.coverImageView.image else {
            return
        }
        var currenType = PostsType.latest
        let seletedIndex = seletedTypeBtn.tag - 100
        if seletedIndex == 0 {
            currenType = .latest
        } else if seletedIndex == 1 {
            currenType = .reply
        } else if seletedIndex == 2 {
            currenType = .recommend
        }
        var defaultContent = "默认分享内容".localized
        defaultContent.replaceAll(matching: "kAppName", with: TSAppSettingInfoModel().appDisplayName)
        var url = ShareURL.groupsList.rawValue
        url.replaceAll(matching: "replacegroup", with: "\(model.id)")
        url.replaceAll(matching: "replacefetch", with: currenType.rawValue)
        let shareContent = model.intro.count > 0 ? model.intro : defaultContent
        let shareTitle = model.name.count > 0 ? model.name : TSAppSettingInfoModel().appDisplayName + " " + "帖子"
        
        let messageModel = TSmessagePopModel(groupDetail: model)
        let shareView = ShareListView(isMineSend: true, isCollection: false, shareType: ShareListType.momenDetail)
        shareView.delegate = self
        shareView.messageModel = messageModel
        shareView.show(URLString: url, image: image, description: shareContent, title: shareTitle)
    }
    func moreClickdo(_ btn:UIButton) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TSKeyboardToolbar.share.keyboardstartNotice()
        let info = UserDefaults.standard.object(forKey: "TSPostWebEditorControllerPostInfo") as? [String:Any]
        if let groupid = info?["groupid"] as? Int, let id = info?["id"] as? Int {
            self.navigationController?.navigationBar.isHidden = false
            refresh(table: lastPostTable)
            let postDetailVC = PostDetailController(groupId: groupid, postId: id, fromGroup: true)
            self.navigationController?.pushViewController(postDetailVC, animated: true)
            UserDefaults.standard.removeObject(forKey: "TSPostWebEditorControllerPostInfo")
            UserDefaults.standard.synchronize()
        }
    }
    func setUI() {
        view.backgroundColor = .white
        // 1.加载左边视图
        leftView.frame = UIScreen.main.bounds
        leftView.addSubview(table)
//        leftView.addSubview(navView)
        leftView.addSubview(buttonForRelease)
        leftView.addSubview(videoForButton)
        leftView.addSubview(photoForButton)

        view.addSubview(leftView)
        view.addSubview(rightView)

        table.delegate = self
        table.dataSource = self
        table.rowHeight = ScreenHeight - TSUserInterfacePrinciples.share.getTSNavigationBarHeight()
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = TSColor.inconspicuous.background
        // 1.3 header 视图
        headerView.set(taleView: table)
        headerView.delegate = self
//        navView.delegate = self

        bgScrollView.frame = CGRect(x: 0, y: styleSelectedBarHeight, width: ScreenWidth, height: ScreenHeight - TSUserInterfacePrinciples.share.getTSNavigationBarHeight() - styleSelectedBarHeight)
        bgScrollView.contentSize = CGSize(width: ScreenWidth * 3, height: 0)
        bgScrollView.showsVerticalScrollIndicator = false
        bgScrollView.showsHorizontalScrollIndicator = false
        bgScrollView.delegate = self
        bgScrollView.isPagingEnabled = true
        bgScrollView.bounces = false
        /// 初始化三个显示帖子的子tableview
        lastPostTable = NYPostListActionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: bgScrollView.height), tableIdentifier: "lastPostTable")
        lastCommentTable = NYPostListActionView(frame: CGRect(x: ScreenWidth, y: 0, width: ScreenWidth, height: bgScrollView.height), tableIdentifier: "lastCommentTable")
        recommendTable = NYPostListActionView(frame: CGRect(x: ScreenWidth * 2, y: 0, width: ScreenWidth, height: bgScrollView.height), tableIdentifier: "recommendTable")
        /// 禁止table的下拉刷新
        lastPostTable.mj_header = nil
        lastCommentTable.mj_header = nil
        recommendTable.mj_header = nil

        lastPostTable.refreshDelegate = self
        lastCommentTable.refreshDelegate = self
        recommendTable.refreshDelegate = self
        lastPostTable.scrollDelegate = self
        lastCommentTable.scrollDelegate = self
        recommendTable.scrollDelegate = self
        lastPostTable.interactDelegate = self
        lastCommentTable.interactDelegate = self
        recommendTable.interactDelegate = self

        lastPostTable.groupId = groupId
        lastCommentTable.groupId = groupId
        recommendTable.groupId = groupId

        lastPostTable.isUnionChildTable = true
        lastCommentTable.isUnionChildTable = true
        recommendTable.isUnionChildTable = true

        lastPostTable.fromGroupFlag = true
        lastCommentTable.fromGroupFlag = true
        recommendTable.fromGroupFlag = true

        bgScrollView.addSubview(lastPostTable)
        bgScrollView.addSubview(lastCommentTable)
        bgScrollView.addSubview(recommendTable)

        // 2.加载右边视图
        rightView.delegate = self

        // 3.发布按钮
        buttonForRelease.setImage(UIImage(named: "com_add_post"), for: .normal)
        buttonForRelease.contentMode = .center
        buttonForRelease.sizeToFit()
        buttonForRelease.frame = CGRect(x: (UIScreen.main.bounds.width - buttonForRelease.frame.width) - 25, y: view.frame.height*0.6, width: buttonForRelease.frame.width, height: buttonForRelease.frame.height)
        buttonForRelease.addTarget(self, action: #selector(releaseButtonTaped), for: .touchUpInside)
        //照片
        photoForButton.setImage(UIImage(named: "com_album"), for: .normal)
        photoForButton.alpha = 0
        photoForButton.isHidden = true
        photoForButton.contentMode = .center
        photoForButton.sizeToFit()
        photoForButton.frame = CGRect(x:(buttonForRelease.frame.minX - photoForButton.frame.width) - 10, y: buttonForRelease.frame.minY - photoForButton.frame.height*0.5 , width: photoForButton.frame.width, height: photoForButton.frame.height)
        photoForButton.addTarget(self, action: #selector(postPhotoClickdo(btn:)), for: .touchUpInside)
        //视频
        videoForButton.setImage(UIImage(named: "com_video"), for: .normal)
        videoForButton.alpha = 0
        videoForButton.isHidden = true
        videoForButton.contentMode = .center
        videoForButton.sizeToFit()
        videoForButton.frame = CGRect(x:photoForButton.frame.minX, y: photoForButton.frame.maxY + 10 , width: videoForButton.frame.width, height: videoForButton.frame.height)
        videoForButton.addTarget(self, action: #selector(postVideoClickdo(btn:)), for: .touchUpInside)
        loading()
        loadData()
        refresh(table: lastPostTable)
    }
    /// 收起右边的抽屉视图
    func dissmissRightView() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let weakself = self else {
                return
            }
            weakself.leftView.frame = CGRect(origin: .zero, size: weakself.leftView.size)
            weakself.rightView.frame = CGRect(origin: CGPoint(x: UIScreen.main.bounds.width, y: 0), size: weakself.rightView.size)
            }, completion: { [weak self] (_) in
                self?.maskView.removeFromSuperview()
        })
    }

    /// 加载抽屉视图
    func loadRightView() {
        // 1.根据不同类型，设置不同的 cell 显示内容，以及 exitButton 标题
        var images: [String] = []
        var titles: [String] = []
        var detailTexts: [String] = []
        switch model.role {
        case .master:
            images = ["IMG_ico_circle_member", "IMG_ico_circle_details", "IMG_ico_circle_earnings", "IMG_ico_circle_limits", "IMG_ico_circle_report", "IMG_ico_circle_blacklist"]
            titles = ["成员", "详细信息", "圈子收益", "发帖权限", "举报管理", "黑名单"]
            detailTexts = [String].init(repeating: "", count: 6)
            detailTexts[0] = "\(model.userCount - model.blackCount)"
            detailTexts[5] = "\(model.blackCount)"
            rightView.exitButton.isHidden = false
            rightView.exitButton.setTitle("转让圈子", for: .normal)
        case .manager:
            images = ["IMG_ico_circle_member", "IMG_ico_circle_details", "IMG_ico_circle_report", "IMG_ico_circle_blacklist"]
            titles = ["成员", "详细信息", "举报管理", "黑名单"]
            detailTexts = [String].init(repeating: "", count: 4)
            detailTexts[0] = "\(model.userCount - model.blackCount)"
            detailTexts[3] = "\(model.blackCount)"
            rightView.exitButton.isHidden = false
            rightView.exitButton.setTitle("退出圈子", for: .normal)
        case .member, .black:
            images = ["IMG_ico_circle_member", "IMG_ico_circle_details", "IMG_ico_circle_report"]
            titles = ["成员", "详细信息", "举报圈子"]
            detailTexts = [String].init(repeating: "", count: 3)
            detailTexts[0] = "\(model.userCount - model.blackCount)"
            rightView.exitButton.isHidden = false
            rightView.exitButton.setTitle("退出圈子", for: .normal)
        case .unjoined:
            images = ["IMG_ico_circle_member", "IMG_ico_circle_details", "IMG_ico_circle_report"]
            titles = ["成员", "详细信息", "举报圈子"]
            detailTexts = [String].init(repeating: "", count: 3)
            detailTexts[0] = "\(model.userCount - model.blackCount)"
            rightView.exitButton.isHidden = true
        }
        // 2.创建 cell models
        var viewModels: [MoreTableViewCellModel] = []
        for (index, image) in images.enumerated() {
            let detailText = detailTexts[index]
            let title = titles[index]
            let viewModel = MoreTableViewCellModel()
            viewModel.title = title
            viewModel.detailText = detailText
            viewModel.iconImage = image
            viewModels.append(viewModel)
        }
        rightView.datas = viewModels
        // 3.设置 exitButton 点击事件
        rightView.exitButton.addTarget(self, action: #selector(exitButtonTaped(_:)), for: .touchUpInside)
        // 刷新界面
        rightView.table.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        TSKeyboardToolbar.share.keyboarddisappear()
        TSKeyboardToolbar.share.keyboardStopNotice()
        // 更新状态栏的颜色
        UIApplication.shared.statusBarStyle = .default
    }
    func notiResLeaveTop() {
        bgTableViewCanScroll = true
        childrenTableCouldScroll = false
    }
    // MARK: - Data
    func loadData() {
        // 1.获取圈子信息
        GroupNetworkManager.getGroupInfo(groupId: groupId) { [weak self] (model, message, status) in
            guard let model = model else {
                self?.loadFaild(type: .network)
                return
            }
            self?.endLoading()
            self?.groupModel = model
            self?.load(model: PostListControllerModel(groupModel: model))
//            self?.navView.setTitle(model.name)
        }
    }

    func load(model: PostListControllerModel) {
        self.model = model
        // 1.加载 header 视图
//        table.contentOffset.y = -100
        headerView.load(contentModel: model)

        // 2.加载抽屉视图
        loadRightView()

        // 3.table
        lastPostTable.role = model.role
        lastCommentTable.role = model.role
        recommendTable.role = model.role
        table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.id > 0 ? 1 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            /// 把视图添加在cell内
            cell?.contentView.addSubview(bgScrollView)
            let selectedBtnBgView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: styleSelectedBarHeight))
            cell?.contentView.addSubview(selectedBtnBgView)
            let titles = ["最新发布", "最新回复", "精华帖子"]
            seletedTypeBtns.removeAll()
            let btnW: CGFloat = selectedBtnBgView.width / CGFloat(titles.count)
            let btnH: CGFloat = selectedBtnBgView.height
            for (index, title) in titles.enumerated() {
                let btn = UIButton(frame: CGRect(x: CGFloat(index) * btnW, y: 0, width: btnW, height: btnH))
                selectedBtnBgView.addSubview(btn)
                btn.tag = index + 100
                btn.setTitle(title, for: .normal)
                btn.setBackgroundImage(UIImage(named: "com_item_nol"), for: .normal)
                btn.setBackgroundImage(UIImage(named: "com_item_sel"), for: .selected)
                btn.setTitleColor(TSColor.button.disabled, for: .selected)
                btn.setTitleColor(UIColor.white, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: TSFont.ContentText.text.rawValue)
                if index == 0 {
                    btn.isSelected = true
                    seletedTypeBtn = btn
                }
                btn.addTarget(self, action: #selector(didSelectedTypeBtn(selectedBtn:)), for: .touchUpInside)
                seletedTypeBtns.append(btn)
            }
            let spView = UIView(frame: CGRect(x: 0, y: selectedBtnBgView.height - 1, width: selectedBtnBgView.width, height: 1))
            spView.backgroundColor = UIColor(red: 59, green: 59, blue: 61)
            selectedBtnBgView.addSubview(spView)
            /// 添加对应的动态列表
        }
        return cell!
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// 需要确保已经加载了header的内容监听才有意义
        if scrollView == self.table && headerView.contentModel.id > 0 {
            // 1.更新 header view 的动画效果
            headerView.updateChildviews(tableOffset: scrollView.contentOffset.y)
            let offset = -(scrollView.contentOffset.y + headerView.stretchModel.headerHeightMin)
//            navView.updateChildView(offset: offset)
            if scrollView.contentOffset.y > -TSUserInterfacePrinciples.share.getTSNavigationBarHeight() {
                scrollView.contentOffset.y = -TSUserInterfacePrinciples.share.getTSNavigationBarHeight()
                if self.bgTableViewCanScroll == true {
                    self.bgTableViewCanScroll = false
                    self.childrenTableCouldScroll = true
                }
            } else {
                if self.bgTableViewCanScroll == false {
                    scrollView.contentOffset.y = -TSUserInterfacePrinciples.share.getTSNavigationBarHeight()
                }
            }
        } else if scrollView == bgScrollView {
            if scrollView.contentOffset.x < ScreenWidth {
                if lastPostTable.datas.count == 0 && lastPostTable.isRequestList == false {
                    refresh(table: lastPostTable)
                }
                for (index, btn) in seletedTypeBtns.enumerated() {
                    if index == 0 {
                        btn.setTitleColor(TSColor.normal.content, for: .normal)
                        seletedTypeBtn = btn
                    } else {
                        btn.setTitleColor(TSColor.button.disabled, for: .normal)
                    }
                }
            } else if ScreenWidth <= scrollView.contentOffset.x && scrollView.contentOffset.x < ScreenWidth * 2 {
                if lastCommentTable.datas.count == 0 && lastCommentTable.isRequestList == false {
                    refresh(table: lastCommentTable)
                }
                for (index, btn) in seletedTypeBtns.enumerated() {
                    if index == 1 {
                        btn.setTitleColor(TSColor.normal.content, for: .normal)
                        seletedTypeBtn = btn
                    } else {
                        btn.setTitleColor(TSColor.button.disabled, for: .normal)
                    }
                }
            } else  if ScreenWidth * 2 <= scrollView.contentOffset.x {
                if recommendTable.datas.count == 0 && recommendTable.isRequestList == false {
                    refresh(table: recommendTable)
                }
                for (index, btn) in seletedTypeBtns.enumerated() {
                    if index == 2 {
                        btn.setTitleColor(TSColor.normal.content, for: .normal)
                        seletedTypeBtn = btn
                    } else {
                        btn.setTitleColor(TSColor.button.disabled, for: .normal)
                    }
                }
            }
        }
    }
    func didSelectedTypeBtn(selectedBtn: UIButton) {
        seletedTypeBtn.isSelected = false
        selectedBtn.isSelected = true;
        seletedTypeBtn = selectedBtn
//        for btn in seletedTypeBtns {
//            btn.setTitleColor(TSColor.button.disabled, for: .normal)
//        }
//        selectedBtn.setTitleColor(TSColor.normal.content, for: .normal)
        bgScrollView.setContentOffset(CGPoint(x: CGFloat(selectedBtn.tag - 100 ) * ScreenWidth, y: 0), animated: true)
    }

    // MARK: - Action
    /// 点击了发布按钮
    func releaseButtonTaped() {
        //动画
        if photoForButton.isHidden
        {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.buttonForRelease.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
                self.photoForButton.alpha = 1
                self.videoForButton.alpha = 1
                self.photoForButton.isHidden = false
                self.videoForButton.isHidden = false
            }, completion: nil)
        }
        else
        {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.photoForButton.alpha = 0
                self.videoForButton.alpha = 0
                self.photoForButton.isHidden = true
                self.videoForButton.isHidden = true
                self.buttonForRelease.transform = CGAffineTransform.identity
            }, completion:nil)
        }
        return
    }
    
    ///普通发帖
    func postPhotoClickdo(btn:TSButton)
    {
        checkPhotoAuthorizeStatus()
    }
    ///视频发帖
    func postVideoClickdo(btn:TSButton)
    {
        guard let imagePickerVC = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: self, pushPhotoPickerVc: true) else {
            return
        }
        /// 不设置则直接用TZImagePicker的pod中的图片素材
        /// #视频选择列表页面
        /// item右上角蓝色的选中图片、视频拍摄按钮
        //            imagePickerVC.selectImage = UIImage(named: "msg_box_choose_now")
        //        imagePickerVC.takeVideo = UIImage(named: "pic_shootvideo")
        /// #视频裁剪页面
        /// 返回按钮、视频长度截取左侧选择滑块、视频长度截取右侧选择滑块
        //        imagePickerVC.backImage = UIImage(named: "ico_title_back_black")
        //        imagePickerVC.editFaceLeft = UIImage(named: "pic_eft")
        //        imagePickerVC.editFaceRight = UIImage(named: "pic_right")
        /// #封面选择页面
        /// 封面选择滑块
        //        imagePickerVC.picCoverImage = UIImage(named: "pic_cover_frame")

        // 最大loading超时时间设置为3min，防止快速编辑的时候导出视频等待时间过长而loading消失
        imagePickerVC.timeout = 60 * 3
        imagePickerVC.isSelectOriginalPhoto = false
        imagePickerVC.allowTakePicture = true
        imagePickerVC.allowPickingVideo = true
        imagePickerVC.allowPickingImage = false
        imagePickerVC.allowPickingGif = false
        imagePickerVC.allowPickingMultipleVideo = false
        imagePickerVC.sortAscendingByModificationDate = false
        imagePickerVC.backImage = UIImage(named:"nav_back")
        imagePickerVC.barItemTextColor = UIColor.white
        imagePickerVC.navigationBar.barTintColor = UIColor.white
        imagePickerVC.navigationBar.tintColor = UIColor.white
        var dic = [String: Any]()
        dic[NSForegroundColorAttributeName] = UIColor.white
        imagePickerVC.navigationBar.titleTextAttributes = dic
        present(imagePickerVC, animated: true)
        
//        let vc = PostShortVideoViewController(nibName: "PostShortVideoViewController", bundle: nil)
//        vc.shortVideoAsset = ShortVideoAsset(coverImage: coverImage, asset: nil, recorderSession: nil, videoFileURL: videoURL as! URL)
//        let nav = TSNavigationController(rootViewController: vc)
//        present(nav, animated: true)
//        return
//        postContentdo(tag: 1)
    }
    
    /// 查看相册授权，显示相册查看器
    func checkPhotoAuthorizeStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .denied, .restricted:
            let appName = TSAppConfig.share.localInfo.appDisplayName
            TSErrorTipActionsheetView().setWith(title: "相册权限设置", TitleContent: "请为\(appName)开放相册权限：手机设置-隐私-相册-\(appName)(打开)", doneButtonTitle: ["去设置", "取消"], complete: { (_) in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
            })
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self] (newState) in
                if newState == .authorized {
                    self?.showImagePickerVC()
                }
            })
        case .authorized:
            showImagePickerVC()
        }
    }
    func showImagePickerVC() {
        guard let imagePickerVC = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: self, mainColor: UIColor.white)
            else {
                return
        }
        /// 不设置则直接用TZImagePicker的pod中的图片素材
        /// #图片选择列表页面
        /// item右上角蓝色的选中图片
        //            imagePickerVC.selectImage = UIImage(named: "msg_box_choose_now")
        
        //设置默认为中文，不跟随系统
        imagePickerVC.preferredLanguage = "zh-Hans"
        imagePickerVC.maxImagesCount = 9
        imagePickerVC.isSelectOriginalPhoto = true
        imagePickerVC.allowTakePicture = true
        imagePickerVC.allowPickingVideo = false
        imagePickerVC.allowPickingImage = true
        imagePickerVC.allowPickingGif = true
        imagePickerVC.allowPickingMultipleVideo = true
        imagePickerVC.sortAscendingByModificationDate = false
        imagePickerVC.backImage = UIImage(named:"nav_back")
        imagePickerVC.barItemTextColor = UIColor.white
        imagePickerVC.oKButtonTitleColorNormal = UIColor.black
        imagePickerVC.oKButtonTitleColorDisabled = UIColor.black
        imagePickerVC.navigationBar.barTintColor = UIColor.white
        imagePickerVC.navigationBar.tintColor = UIColor.white
        var dic = [String: Any]()
        dic[NSForegroundColorAttributeName] = UIColor.white
        imagePickerVC.navigationBar.titleTextAttributes = dic
        present(imagePickerVC, animated: true)
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        let releasePulseVC = TSReleasePulseViewController(isHiddenshowImageCollectionView: photos.isEmpty)
        releasePulseVC.group_id = self.groupId
        
        let navigation = TSNavigationController(rootViewController: releasePulseVC)
        releasePulseVC.selectedPHAssets = assets as! [PHAsset]
        self.present(navigation, animated: true, completion: nil)
    }
    /// 点击了 退出or转让按钮
    func exitButtonTaped(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        if buttonTitle == "退出圈子" {
            exitGroup(groupId: groupId)
        }
        if buttonTitle == "转让圈子" {
            transferGroup(groupId: groupId)
        }
    }

    /// 转让圈子
    func transferGroup(groupId: Int) {
        let transferVC = TransferGroupController(groupId: groupId, groupTitle: groupModel.name)
        transferVC.finishTransferBlock = { [weak self] in
            self?.loadData()
        }
        navigationController?.pushViewController(transferVC, animated: true)
    }

    /// 退出圈子
    func exitGroup(groupId: Int) {
        let alert = TSIndicatorWindowTop(state: .loading, title: "正在退出圈子...")
        alert.show()
        GroupNetworkManager.exitGroup(groupId: groupId, complete: { [weak self] (status, message) in
            guard let weakself = self else {
                return
            }
            alert.dismiss()

            let showMessage = message != nil && (message?.count)! > 0 ? message : (status ? "退出成功" : "退出失败")
            let resultAlert = TSIndicatorWindowTop(state: status ? .success : .faild, title: showMessage)
            resultAlert.show(timeInterval: TSIndicatorWindowTop.defaultShowTimeInterval)
            if status {
                // 退出成功，发出通知
                let cellModel = GroupListCellModel(model: weakself.groupModel)
                NotificationCenter.default.post(name: NSNotification.Name.Group.joined, object: nil, userInfo: ["isJoin": false, "groupInfo": cellModel])
                self?.navigationController?.popViewController(animated: true)
            }
        })
        return
    }

    // MARK: - Notification

    func setNotification() {
        // 监听“圈内搜索点击了’去发帖‘按钮”
        NotificationCenter.default.addObserver(self, selector: #selector(inGroupSearchReleaseButtonTaped(_:)), name: NSNotification.Name.Post.SearchReleasePost, object: nil)
        // 圈子信息更新
        NotificationCenter.default.addObserver(self, selector: #selector(notiResReloadGroupInfo(noti:)), name: NSNotification.Name.Group.uploadGroupInfo, object: nil)
    }

    /// 圈内搜索点击了“去发帖“按钮
    func inGroupSearchReleaseButtonTaped(_ noti: Notification) {
        guard let notiGroupId = noti.userInfo?["groupId"] as? Int, notiGroupId == groupId else {
            return
        }
        releaseButtonTaped()
    }
    func notiResReloadGroupInfo(noti: Notification) {
        let notiInfo = noti.object as! Dictionary<String, Any>
        if let notiGroupId: Int = notiInfo["groupId"] as? Int, let type: String = notiInfo["type"] as? String, let count: Int = notiInfo["count"] as? Int {
            if self.groupId == notiGroupId {
                if type == "removeMember" {
                    self.model.memberCount = self.model.memberCount - count
                } else if type == "removeBlack" {
                    self.model.blackCount = self.model.blackCount - count
                } else if type == "addBlack" {
                    self.model.blackCount = self.model.blackCount + count
                }
                self.loadRightView()
            }
        }
        /// 更新圈子信息
        // editGroupInfo
        if let notiGroupId: Int = notiInfo["groupId"] as? Int, let type: String = notiInfo["type"] as? String, let groupModel: GroupModel = notiInfo["groupModel"] as? GroupModel {
            if self.groupId == notiGroupId && type == "editGroupInfo" {
                self.model = PostListControllerModel(groupModel: groupModel)
                // 2.加载 header 视图
                headerView.load(contentModel: model)
                // 3.加载抽屉视图
                loadRightView()
                // 4.table
                lastPostTable.role = model.role
                lastCommentTable.role = model.role
                recommendTable.role = model.role
                table.reloadData()
            }
        }
    }
}
extension GroupDetailVC: LoadingViewDelegate {
    func reloadingButtonTaped() {
        loadData()
    }

    func loadingBackButtonTaped() {
        navigationController?.popViewController(animated: true)
    }
}

extension GroupDetailVC:NYFeedListViewDelegate{
    func feedList(_ view: NYPostListActionView, didSelected cell: NYHotTopicCell, onSeeAllButton: Bool) {
        let feedId = cell.hotTopicFrameModel?.hotMomentListModel?.moment.feedIdentity
        // 3.以上情况都不是，跳转动态详情页
        let detailVC = TSCommetDetailTableView(feedId: feedId!, isTapMore: true)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func feedList(_ view: NYPostListActionView, didSelected cell: NYHotTopicCell, on pictureView: PicturesTrellisView, withPictureIndex index: Int) {
        
    }
    
    func feedList(_ view: NYPostListActionView, didSelected cell: NYHotTopicCell, on toolbar: TSToolbarView, withToolbarButtonIndex index: Int) {
        
    }
    
    func feedList(_ view: NYPostListActionView, didSelected cell: NYHotTopicCell, on commentView: FeedCommentListView, withCommentIndexPath commentIndexPath: IndexPath) {
        
    }
    
    func feedList(_ view: NYPostListActionView, didLongPress cell: NYHotTopicCell, on commentView: FeedCommentListView, withCommentIndexPath commentIndexPath: IndexPath) {
        
    }
    
    func feedList(_ view: NYPostListActionView, didSelected cell: NYHotTopicCell, didSelectedComment commentCell: FeedCommentListCell, onUser userId: Int) {
        
    }
    
    func feedList(_ view: NYPostListActionView, didSelectedResendButton cell: NYHotTopicCell) {
        
    }
}


// MARK: - header 代理事件
extension GroupDetailVC: PostListHeaderViewDelegate {
    /// 点击了加入按钮
    func postListHeaderDidSelectedJoinButton(_ view: PostListHeaderView) {
        // 1.如果是加入圈子，先判断是否是付费圈子，如果是，显示付费弹窗
        let mode = model.mode
        if mode == "paid" {
            PaidManager.showPaidGroupAlert(price: Double(model.joinMoney), groupId: groupId, groupMode: mode) {
                // 付费的圈子有审核时间，所以不需要立刻通知列表刷新界面
            }
            return
        }
        // 2.如果不是付费圈子，直接发起加入申请
        let alert = TSIndicatorWindowTop(state: .loading, title: "正在加入圈子")
        alert.show()
        view.contentView.joinButton.isEnabled = false
        GroupNetworkManager.joinGroup(groupId: groupId, complete: { [weak self] (isSuccess, message) in
            alert.dismiss()
            view.contentView.joinButton.isEnabled = true
            guard let weakself = self else {
                return
            }
            // 成功加入
            if isSuccess {
                let successAlert = TSIndicatorWindowTop(state: .success, title: message)
                successAlert.show(timeInterval: TSIndicatorWindowTop.defaultShowTimeInterval)
                // 非公开的圈子，需要审核时间，所以不能马上改变加入状态
                if mode == "public" {
                    weakself.model.isJoin = true
                    weakself.model.role = .member
                    weakself.load(model: weakself.model)
                    // 发送通知
                    NotificationCenter.default.post(name: NSNotification.Name.Group.joined, object: nil, userInfo: ["isJoin": true, "groupInfo": GroupListCellModel(postsHeaderModel: weakself.model)])
                }
            } else {
                // 加入失败
                let faildAlert = TSIndicatorWindowTop(state: .faild, title: message ?? "加入失败")
                faildAlert.show(timeInterval: TSIndicatorWindowTop.defaultShowTimeInterval)
            }
        })
    }

    /// 点击了私聊按钮
    func postListHeaderDidSelectedChatButtonWith(_ view: PostListHeaderView) {
        guard let userIdentity = groupModel.founder?.userIdentity else {
            return
        }
        if !EMClient.shared().isLoggedIn {
            let appDeleguate = UIApplication.shared.delegate as! AppDeleguate
            appDeleguate.getHyPassword()
            return
        }
        let idSt: String = String(userIdentity)
        let vc = ChatDetailViewController(conversationChatter: idSt, conversationType:EMConversationTypeChat)
        vc?.chatTitle = groupModel.founder?.name
        navigationController?.pushViewController(vc!, animated: true)
    }
}
// MARK: - 导航栏视图代理事件
extension GroupDetailVC: PostListNavViewDelegate {
    /// 返回按钮点击事件
    func navView(_ navView: PostListNavView, didSelectedLeftButton: TSButton) {
        TSUtil.popViewController(currentVC: self, animated: true)
    }
    /// 更多按钮点击事件
    func navView(_ navView: PostListNavView, didSelectedRightButton: TSButton) {
        /// 显示右边的抽屉视图，并用蒙板视图将左边视图遮住
        maskView.frame = leftView.bounds
        maskView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        maskView.addTarget(self, action: #selector(dissmissRightView), for: .touchUpInside)

        leftView.addSubview(maskView)
        rightView.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: 200, height: UIScreen.main.bounds.height)
        rightView.backgroundColor = UIColor(hex: 0x363845)

        // 过渡动画
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let weakself = self else {
                return
            }
            weakself.leftView.frame = CGRect(origin: CGPoint(x: -weakself.rightView.frame.width, y: 0), size: weakself.leftView.size)
            weakself.rightView.frame = CGRect(origin: CGPoint(x: UIScreen.main.bounds.width - weakself.rightView.frame.width, y: 0), size: weakself.rightView.size)
        }
    }

    /// 分享按钮点击事件
    func navView(_ navView: PostListNavView, didSelectedShareButton: UIButton) {
        
    }

    /// 搜索按钮点击事件
    func navView(_ navView: PostListNavView, didSelectedSearchButton: UIButton) {
        let searchVC = InGroupSearchVC(groupId: groupId)
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: - 帖子列表刷新代理事件
extension GroupDetailVC: NYFeedListViewRefreshDelegate {
    /// 上拉加载
    func feedListTable(_ table: NYPostListActionView, loadMoreDataOf tableIdentifier: String) {
        var type: PostsType = PostsType.latest
        if table == self.lastPostTable {
            type = PostsType.latest
        } else if table == self.lastCommentTable {
            type = PostsType.reply
        } else if table == self.recommendTable {
            type = PostsType.recommend
        }
        table.curentPage += 1
        
        //动态数据
        TSMomentNetworkManager().getfeedList(hot: "", search: "",group_id:groupId,type: type.rawValue,after:table.after! ,complete:{(data: [TSMomentListModel]?, error) in
            table.isRequestList = false
            var datas: [TSMomentListModel]?
            if let models = data {
                datas = models
            }
            else {
                table.curentPage = table.curentPage - 1
            }
            table.processloadMore(data: datas, message: nil, status: true)
        })
        
//        GroupNetworkManager.getPosts(groupId: groupId, type: type.rawValue, offset: table.after) { [weak self] (model, message, status) in
//            table.isRequestList = false
////            self?.navView.indicator.dismiss()
//            var datas: [FeedListCellModel]?
//            if let model = model {
//                datas = []
//                datas?.append(contentsOf: model.posts.map { FeedListCellModel(postModel: $0) })
//            } else {
//                table.curentPage = table.curentPage - 1
//            }
//            table.processloadMore(data: datas, message: nil, status: true)
//        }
    }
    // 下拉刷新
    func refresh(table: NYPostListActionView) {
        table.isRequestList = true
//        navView.indicator.starAnimationForFlowerGrey() // 显示小菊花
        table.curentPage = 0
        var type: PostsType = PostsType.latest
        if table == self.lastPostTable {
           type = PostsType.latest
        } else if table == self.lastCommentTable {
            type = PostsType.reply
        } else if table == self.recommendTable {
            type = PostsType.recommend
        }
        //动态数据
        TSMomentNetworkManager().getfeedList(hot: "", search: "",group_id:groupId,type: type.rawValue,after:0 ,complete:{(data: [TSMomentListModel]?, error) in
            if let models = data {
                table.processRefresh(data: models, message: nil, status: true)
            }
        })
        
//        GroupNetworkManager.getPosts(groupId: groupId, type: type.rawValue, offset: nil) { [weak self] (model, message, status) in
////            self?.navView.indicator.dismiss()
//            table.isRequestList = false
//            var datas: [FeedListCellModel]?
//            if let model = model {
//                datas = []
//                if  type == PostsType.latest {
//                    for pinned in model.pinneds {
//                        let cellModel = FeedListCellModel(postModel: pinned)
//                        cellModel.showPostTopIcon = true
//                        datas?.append(cellModel)
//                    }
//                }
//                // 去除置顶的内容
//                if  type == PostsType.latest {
//                    var fmodels: [PostListModel] = model.posts
//                    for (postsIndex, modelPost) in model.pinneds.enumerated() {
//                     let tempModels = fmodels.filter({ (fmodel) -> Bool in
//                        if fmodel.id != modelPost.id {
//                            return true
//                        } else {
//                            return false
//                        }
//                        })
//                        fmodels = tempModels
//                    }
//                    model.posts = fmodels
//                }
//                datas?.append(contentsOf: model.posts.map { FeedListCellModel(postModel: $0) })
//            }
//            table.processRefresh(data: datas, message: nil, status: true)
//        }

        ///目前就这样处理刷新到时候没有刷新后台修改圈子信息的问题
        GroupNetworkManager.getGroupInfo(groupId: groupId) { [weak self] (model, message, status) in
            guard let model = model else {
                self?.loadFaild(type: .network)
                return
            }
            // 1.设置 model
            self?.groupModel = model
            self?.load(model: PostListControllerModel(groupModel: model))
        }
    }
}

// MARK: - 帖子列表滚动代理事件
extension GroupDetailVC: NYFeedListViewScrollowDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2.更新导航视图的动画效果
        // 这里需要把 offset 处理一下，移除 headerView 引起的 table inset 偏移的影响
        let offset = -(scrollView.contentOffset.y + headerView.stretchModel.headerHeightMin)
        // 3.当下拉到一定程度的时候，发起下拉刷新操作
        if offset > (TSStatusBarHeight + 25) {
//            // 如果下拉刷新正在进行，就什么都不做
//            if navView.indicator.isAnimating {
//                return
//            }
            let seletedIndex = seletedTypeBtn.tag - 100
            if seletedIndex == 0 {
                // 发起下拉刷新操作
                refresh(table: lastPostTable)
            } else if seletedIndex == 1 {
                // 发起下拉刷新操作
                refresh(table: lastCommentTable)
            } else if seletedIndex == 2 {
                // 发起下拉刷新操作
                refresh(table: recommendTable)
            }
        }
    }
}
// MARK: - MoreTableViewDelegate
extension GroupDetailVC: MoreTableViewDelegate {
    /// 点击了抽屉视图上的 cell
    func moreTableView(_ view: MoreTableView, didSelectedCell indexPath: IndexPath, with title: String) {
        switch title {
        case "成员":
            guard let roleType = GroupMemberModel.memberRoleTypeWithMemberType(self.groupModel.getRoleInfo()) else {
                if  groupModel.mode == "public"{
                    let memberVC = GroupMemberManageController(groupId: self.groupId, isBlack: false, currentUserRole: GroupMemberRoleType.member)
                    // 普通成员数量 = 总数量 - 黑名单 - 管理员 - 圈主 (管理角色数量在列表页扣除)
                    memberVC.memberCount = model.memberCount - model.blackCount
                    self.navigationController?.pushViewController(memberVC, animated: true)
                }
                return
            }
            let memberVC = GroupMemberManageController(groupId: self.groupId, isBlack: false, currentUserRole: roleType)
            // 普通成员数量 = 总数量 - 黑名单 - 管理员 - 圈主 (管理角色数量在列表页扣除)
            memberVC.memberCount = model.memberCount - model.blackCount
            self.navigationController?.pushViewController(memberVC, animated: true)
        case "详细信息":
            let groupInfoVC = GroupInfoController.vc(managerType: model.role, groupId: groupId)
            groupInfoVC.finishChangeBlock = { [weak self](buildGroupModel) in
                self?.groupModel.updateWithBuildGroup(buildGroupModel)
            }
            navigationController?.pushViewController(groupInfoVC, animated: true)
        case "圈子收益":
            let incomeVC = GroupIncomeDetailController(groupId: self.groupId, groupModel: self.groupModel)
            self.navigationController?.pushViewController(incomeVC, animated: true)
        case "发帖权限":
            let postCapabilityVC = PostCapabilityController(groupId: groupId)
            navigationController?.pushViewController(postCapabilityVC, animated: true)
        case "举报管理":
            let reportManageVC = GroupReportManageController(groupId: self.groupId)
            self.navigationController?.pushViewController(reportManageVC, animated: true)
        case "举报圈子":
            let informModel = ReportTargetModel(groupModel: groupModel)
            let informVC = ReportViewController(reportTarget: informModel)
            navigationController?.pushViewController(informVC, animated: true)
        case "黑名单":
            guard let roleType = GroupMemberModel.memberRoleTypeWithMemberType(self.groupModel.getRoleInfo()) else {
                return
            }
            let memberVC = GroupMemberManageController(groupId: self.groupId, isBlack: true, currentUserRole: roleType)
            memberVC.memberCount = model.blackCount
            self.navigationController?.pushViewController(memberVC, animated: true)
        default:
            break
        }
    }
}
// MARK: 分享视图代理相关操作
extension GroupDetailVC: ShareListViewDelegate {
    func didClickSetTopButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath) {
    }

    func didClickCancelTopButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath) {
    }

    func didClickSetExcellentButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath) {
    }

    func didClickCancelExcellentButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath) {
    }

    func didClickMessageButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath?, model: TSmessagePopModel) {
        let chooseFriendVC = TSPopMessageFriendList(model: model)
        self.navigationController?.pushViewController(chooseFriendVC, animated: true)
    }

    func didClickReportButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath) {

    }

    func didClickCollectionButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath) {

    }

    func didClickDeleteButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath) {

    }

    func didClickRepostButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath?) {
        let repostModel = TSRepostModel.coverGroupModel(groupModel: self.groupModel)
        let releaseVC = TSReleasePulseViewController(isHiddenshowImageCollectionView: true)
        releaseVC.repostModel = repostModel
        let navigation = TSNavigationController(rootViewController: releaseVC)
        self.present(navigation, animated: true, completion: nil)
    }

    func didClickApplyTopButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath) {
    }
}

extension GroupDetailVC: TZImagePickerControllerDelegate {
    func imagePickerControllerDidClickTakePhotoBtn(_ picker: TZImagePickerController!) {
        // 进入视频录制
        // 视频录制完毕后 进入发布页面
        let vc = RecorderViewController(minDuration: TSAppConfig.share.localInfo.postMomentsRecorderVideoMinDuration, maxDuration: TSAppConfig.share.localInfo.postMomentsRecorderVideoMaxDuration)
        vc.delegate = self
        let nav = TSNavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishEditVideoCover coverImage: UIImage!, videoURL: Any!) {
        TSLogCenter.log.debug(coverImage)
        TSLogCenter.log.debug(videoURL)
        let vc = PostShortVideoViewController(nibName: "PostShortVideoViewController", bundle: nil)
        vc.group_id = self.groupId
        vc.shortVideoAsset = ShortVideoAsset(coverImage: coverImage, asset: nil, recorderSession: nil, videoFileURL: videoURL as! URL)
        let nav = TSNavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    // 视频长度超过5分钟少于4秒钟的都不显示
    func isAssetCanSelect(_ asset: Any!) -> Bool {
        guard let asset = asset as? PHAsset else {
            return false
        }
        if asset.mediaType == .video {
            return asset.duration < 5 * 60 && asset.duration > 3
        } else {
            return true
        }
    }
}
extension GroupDetailVC: RecorderVCDelegate {
    func finishRecorder(recordSession: SCRecordSession, coverImage: UIImage) {
        let vc = PostShortVideoViewController(nibName: "PostShortVideoViewController", bundle: nil)
        vc.group_id = self.groupId
        vc.shortVideoAsset = ShortVideoAsset(coverImage: coverImage, asset: nil, recorderSession: recordSession, videoFileURL: nil)
        let nav = TSNavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}
