//
//  NYVideoDetailVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/19.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
import RealmSwift
import ZFPlayer
import Kingfisher

class NYVideoDetailVC: UIViewController ,TSMomentDetailToolbarDelegate,TSKeyboardToolbarDelegate,NYCommentsCellDelegate,videoHeadViewDelegate{
    /// 记录当前Y轴坐标
    private var yAxis: CGFloat = 0
    
    var video_id:Int?
    /// 播放进度
    var progress = 0.0
    /// 顶部 view
    let topPlayerView = UIView()
    /// 返回 button
    let backButton = UIButton(type: .custom)
    /// 第一站图
    var firstImage = UIButton(type: .custom)
    /// 播放标识
    var playBtn = UIButton(type: .custom)
    /// 底部视图
    var toolbarView: TSMomentDetailToolbar?

    // 播放器
    var playerView: ZFPlayerView?
    // 离开页面时是否正在播放视频
    var isPlaying: Bool = false
    var playerModel: ZFPlayerModel?
    //播放对象
    var _videosModel:NYVideosModel?
    /// 评论 + 推荐 + 广告
    var headView:videoHeadView!
    var table:TSTableView!
        //TSTableView(frame: CGRect(x: 0, y: TSNavigationBarHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - TSNavigationBarHeight - 48), style: .plain)
    /// 数据
    var commentDatas: [FeedListCommentFrameModel]!
    /// 当前回复的评论模型
    private var commentModel: FeedListCommentModel?
    /// 是否是键盘导致的上拉加载
    private var isScroll = true
    private var myContext = 0 //KVO 用
    /// 发送的评论内容
    var sendText: String?
    /// 发送类型
    private var sendCommentType: SendCommentType = .send
        
//        [TSSimpleCommentModel]() {
//        didSet {
//            cellHeight = TSDetailCommentTableViewCell().setCommentHeight(comments: commentDatas, width: super.table.bounds.size.width)
//            super.table.reloadData()
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setUI()
        addNotification()
        //视频详细
        NYPopularNetworkManager.getVideosListData(video_id: self.video_id! ,complete: { (model, msg, isbol) in
            
            if let data = model {
                self.setVideoModel(model: data)
            }
        })
        refresh()
    }
    
    // MARK: - refresh
    func refresh() {
        //评论数据
        NYPopularNetworkManager.getCommentsVideosData(_id: self.video_id!, complete: { (models, msg, isbol) in
            self.table.mj_header.endRefreshing()
            if let datas = models {
                self.commentDatas = NSMutableArray() as![FeedListCommentFrameModel]
                for item in datas
                {
                    let obj = FeedListCommentFrameModel()
                    obj.setListCommentModel(commentModel: item)
                    self.commentDatas.append(obj)
                }
                self.table.reloadData()
            }
        })
    }
    
    // MARK: - loadMore
    func loadMore()
    {
        
    }
    
    func setVideoModel(model:NYVideosModel) {
        _videosModel = model
        self.headView.delegate = self
        self.headView.setVideosModel(video: model)
        if toolbarView==nil
        {
            let momentObj = TSMomentListObject()
            momentObj.feedIdentity = model.channel_id
            momentObj.group_id = model.channel_id
            momentObj.title = model.name
            momentObj.content = model.summary
            toolbarView = TSMomentDetailToolbar(momentObj)
            toolbarView?.commentDelegate = self
            self.view.addSubview(toolbarView!)
            if model.has_collect
            {
                toolbarView?.setImage("me_collect", At: 0)
                toolbarView?.setTitleColor(TSColor.main.themeZsColor, At: 0)
            }
        }
        //设置图片
        let url = URL(string:model.cover.imageUrl())
        firstImage.setBackgroundImageWith(url, for: .normal, placeholder: #imageLiteral(resourceName: "tmp1"))

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TSKeyboardToolbar.share.keyboarddisappear()
        TSKeyboardToolbar.share.keyboardStopNotice()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        self.playerView?.removeObserver(self, forKeyPath: "state", context: &myContext)
        //移除监听
//        self.removeObserver(self, forKeyPath: "state", context: &myContext);
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TSKeyboardToolbar.share.keyboardstartNotice()
        TSKeyboardToolbar.share.keyboardToolbarDelegate = self
       
        // 注册网络变化监听
        NotificationCenter.default.addObserver(self, selector: #selector(notiNetstatesChange(noti:)), name: Notification.Name.Reachability.Changed, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if self.navigationController?.viewControllers.count == 2 && self.playerView != nil && self.isPlaying {
            self.isPlaying = false
            self.playerView?.playerPushedOrPresented = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didClickShortVideoShareBtn(_:)), name: NSNotification.Name(rawValue: "didClickShortVideoShareBtn"), object: nil)
    }
    deinit {
        if let notificationTokenForMoment = notificationTokenForMoment {
            notificationTokenForMoment.invalidate()
        }
        // 清除编号记录
        TSMomentTaskQueue.usingMomentIdentity = nil
    }
    func setUI()
    {
        self.view.backgroundColor = TSColor.main.themeTB
        topPlayerView.backgroundColor = UIColor.clear
        topPlayerView.frame = CGRect(x:0,y:0,width:ScreenWidth,height:230)
        self.view.addSubview(topPlayerView)
        

        firstImage.addTarget(self, action: #selector(playerButtonTaped(_:)), for: .touchUpInside)
//        firstImage.imageView?.contentMode = .scaleToFill
        firstImage.frame = topPlayerView.bounds
        topPlayerView.addSubview(firstImage)
        
        playBtn.frame = CGRect(x: 20, y: firstImage.height - 20 - 40, width: 40, height: 40)
        playBtn.center = firstImage.center
        playBtn.setImage(UIImage(named: "ico_video_play_list"), for: .normal)
        playBtn.isUserInteractionEnabled = false
        playBtn.addTarget(self, action: #selector(playerButtonTaped(_:)), for: .touchUpInside)
        firstImage.addSubview(playBtn)
        
        //返回
        backButton.frame = CGRect(x:0,y:10,width:50,height:50)
        backButton.setImage(UIImage(named: "nav_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTaped(_:)), for: .touchUpInside)
        topPlayerView.addSubview(backButton)
        
        //table
        table = TSTableView(frame: CGRect(x: 0, y: topPlayerView.height, width: ScreenWidth, height: ScreenHeight - topPlayerView.height - 55), style: .grouped)
        table.backgroundColor = TSColor.main.themeTB
        table.backgroundView?.backgroundColor = TSColor.main.themeTB
        table.mj_header = TSRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        table.mj_footer = TSRefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        table.mj_footer.isHidden = true
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.register(NYCommentsCell.self, forCellReuseIdentifier: NYCommentsCell.identifier)
        self.view.addSubview(table)
        
        //headview
        headView = videoHeadView.loadFromNib()
        table.tableHeaderView = headView
        
        //chat tools view
        
        
    }
    
    func updateUI(view: videoHeadView) {
        table.tableHeaderView = headView
    }
    
    
    /// 网络变化回调处理视频自动暂停
    func notiNetstatesChange(noti: NSNotification) {
        if self.playerView != nil && TSCurrentUserInfo.share.isAgreeUserCelluarWatchShortVideo == false && TSAppConfig.share.reachabilityStatus == .Cellular {
            // 弹窗 然后继续播放
            self.playerView?.pause()
            let alert = TSAlertController(title: "提示", message: "您当前正在使用移动网络，继续播放将消耗流量", style: .actionsheet, sheetCancelTitle: "放弃")
            let action = TSAlertAction(title:"继续", style: .default, handler: { [weak self] (_) in
                self?.playerView?.play()
                TSCurrentUserInfo.share.isAgreeUserCelluarWatchShortVideo = true
            })
            alert.addAction(action)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: false, completion: nil)
        }
    }
    
    ///返回
    func backButtonTaped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //点击视频
    func playerButtonTaped(_ sender: TSButton) {
        var url: URL?
        let videoUrl = _videosModel?.play_url.imageUrl()
        if  (videoUrl != nil) {
            url = URL(string: videoUrl!)
        }
//        if let fileURL = model.data?.shortVideoOutputUrl {
//            let filePath = TSUtil.getWholeFilePath(name: fileURL)
//            url = URL(fileURLWithPath: filePath)
//        }
        guard url != nil else {
            return
        }
        playerView = ZFPlayerView()
        playerModel = ZFPlayerModel()
        if let image = firstImage.imageView?.image {
            playerModel?.placeholderImage = image
            self.playerView?.placeholderBlurImageView.image = image
        } else {
            self.playerView?.placeholderBlurImageView.image = nil
        }
        
        playerModel?.title = "一个标题"
        playerModel?.seekTime = Int(progress)
        playerModel?.videoURL = url
        playerModel?.fatherView = firstImage
        playerView?.playerControlView(CustomPlayerControlView(), playerModel: playerModel!)
        playerView?.playerLayerGravity = ZFPlayerLayerGravity.resizeAspectFill
        playerView?.hasPreviewView = true
        playerView?.disablePanGesture = true
        playerView?.hasDownload = true
        playerView?.delegate = self
        
        //添加监听  KVO
        playerView?.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.new, context: &myContext)
        
        playerView?.autoPlayTheVideo()
    }
    
//    //视频 方向问题
//    override var shouldAutorotate: Bool
//    {
//        get {
//            return true
//        }
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
//        {
//        if  self.playerView!.isFullScreen
//        {
//            return UIInterfaceOrientationMask.landscape // UIInterfaceOrientationIsLandscape
//        }else
//        {
//            return UIInterfaceOrientationMask.portrait
//        }
//    }

    func didClickShortVideoShareBtn(_ sender: Notification) {
//        shareMoments()
    }
    //KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (self.playerView?.state == ZFPlayerState.playing ||
            self.playerView?.state == ZFPlayerState.stopped ||
            self.playerView?.state == ZFPlayerState.pause)
        {
            let progress = "0.3"
            
            NYPopularNetworkManager.upVideoRecordprogress(video_id:self.video_id!, progress: progress) { (msg, osbol) in
                print("\(keyPath) - -- -\(msg)")
            }
        }
        
    }

    
    // MARK: - Notification
    
    /// 添加通知
    func addNotification() {
        setMomentNotification()
    }
    
    /// 动态通知口令
    var notificationTokenForMoment: NotificationToken?
    /// 增加通知检测动态的改变
    func setMomentNotification() {
        if let momentData = _videosModel {
//            notificationTokenForMoment = momentData.observe({ [weak self] (changes) in
//                if let weakSelf = self {
//                    switch changes {
//                    case .deleted:
//                        // [长期注释] 动态详情页收到数据库删除通知执行不同的操作. 2017/04/25
//                        if  weakSelf.isCurrentPageDelete {
//                            _ = weakSelf.navigationController?.popViewController(animated: true)
//                        } else {
//                            weakSelf.showDeleteOccupiedView()
//                        }
//                    case .change:
//                        weakSelf.toolbarView!.updateToolBar()
//                        weakSelf.headerView!.updateDiggIcon()
//                    case .error(let error):
//                        assert(false, error.localizedDescription)
//                    }
//                }
//            })
        }
    }
    
    /// 分享动态
    private func shareMoments() {
        if let model = _videosModel {
            var image = UIImage(named: "IMG_icon")
            image =  self.firstImage.imageView?.image
            
            let title = model.name == "" ? TSAppSettingInfoModel().appDisplayName + " " + "视频" : model.name
            var defaultContent = "默认分享内容".localized
            defaultContent.replaceAll(matching: "kAppName", with: TSAppSettingInfoModel().appDisplayName)
            let description = model.summary == "" ? defaultContent:model.summary
            
            let messageModel = TSmessagePopModel(videoModel: model)
            let shareView = ShareListView(isMineSend: true, isCollection: false, shareType: ShareListType.momenDetail)
            shareView.delegate = self
            shareView.messageModel = messageModel
            shareView.show(URLString: ShareURL.feed.rawValue + "\(model.id)", image: image, description: description, title: title)
        }
    }
    
    
    // MARK: TSMomentDetailToolbarDelegate
    func inputToolbar(toolbar: TSMomentDetailToolbar) {
        //评论
        TSKeyboardToolbar.share.keyboarddisappear()
        toolbarDidSelectedCommentButton(toolbar)
    }
    func toolbar(_ toolbar: TSMomentDetailToolbar, DidSelectedItemAt index: Int) {
        if index == 0 { // 收藏
            if  self._videosModel!.has_collect
            {
                NYVideosNetworkManager.postVideoUncollect(video_id: video_id!) { (msg, isBol) in
                    if isBol
                    {
                        self._videosModel!.has_collect = false
                        toolbar.setImage("com_collection", At: 0)
                        toolbar.setTitleColor(UIColor.white, At: 0)
                    }
                }

            }else
            {
                NYVideosNetworkManager.postVideoCollections(video_id: video_id!) { (msg, isBol) in
                    if isBol
                    {
                        self._videosModel!.has_collect = true
                        toolbar.setImage("me_collect", At: 0)
                        toolbar.setTitleColor(TSColor.main.themeZsColor, At: 0)
                    }
                }
            }
            
        }
        if index == 1 { // 下载
            
//            zf_playerDownload()
        }
        if index == 2 { // 分享
            shareMoments()
        }
        
    }
    
    /// 键盘弹出
    func toolbarDidSelectedCommentButton(_ toolbar: TSMomentDetailToolbar) {
        self.commentModel = nil
        self.sendCommentType = .send
        setTSKeyboard(placeholderText: "随便说说~", cell: nil)
    }
    // MARK: - Other
    /// 设置键盘
    ///
    /// - Parameters:
    ///   - placeholderText: 占位字符串
    ///   - cell: cell
    private func setTSKeyboard(placeholderText: String, cell: NYCommentsCell?) {
        if let cell = cell {
            let origin = cell.convert(cell.contentView.frame.origin, to: UIApplication.shared.keyWindow)
            yAxis = origin.y + cell.contentView.frame.size.height
        }
        
        TSKeyboardToolbar.share.keyboardBecomeFirstResponder()
        TSKeyboardToolbar.share.keyboardSetPlaceholderText(placeholderText: placeholderText)
    }
    // MARK: TSKeyboardToolbarDelegate
    func keyboardToolbarSendTextMessage(message: String, inputBox: AnyObject?) {
        // 评论完成后合成模型，存入数据库，后台请求发送接口，然后存入当前的TableView 刷新列表
        if message == "" {
            return
        }
        sendText = message
        isScroll = false
        //发布视频评论
        var reply_user = ""
        var reply_comment_id = ""
        if self.commentModel != nil
        {
            reply_user = "\(self.commentModel?.userInfo.userIdentity ?? 0)"
            reply_comment_id = "\(self.commentModel?.id ?? 0)"
        }
        NYVideosNetworkManager.postVideoCommentsdo(video_id: video_id!, body: sendText!, reply_user: reply_user, reply_comment_id: reply_comment_id) { (msg, isbol) in
            if isbol
            {
                // 获得执行该方法的当前线程
                let currentThread = Thread.current
                // 当前线程为:(Function)
                print("当前线程为:\(currentThread)")
                self.refresh()
            }
        }
    }
    
    func keyboardToolbarFrame(frame: CGRect, type: keyboardRectChangeType) {
        if yAxis == 0 {
            return
        }
        let toScrollValue = frame.origin.y - yAxis
        if  frame.origin.y > yAxis && self.table.contentOffset.y < toScrollValue {
            return
        }
        
        if Int(frame.origin.y) == Int(yAxis) {
            return
        }
        
        switch type {
        case .popUp, .typing:
            self.table.setContentOffset(CGPoint(x: 0, y: self.table.contentOffset.y - toScrollValue), animated: false)
            yAxis = frame.origin.y
        default:
            break
        }
    }
    /// 键盘准备收起
    internal func keyboardWillHide() {
        if sendText != nil {
            sendText = nil
            self.table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            isScroll = true
            return
        } else {
            isScroll = true
        }
        
        if self.table.contentOffset.y > self.table.contentSize.height - self.table.bounds.height {
            if self.table.contentSize.height < self.table.bounds.size.height {
                self.table.setContentOffset(CGPoint.zero, animated: true)
                return
            }
            self.table.setContentOffset(CGPoint(x: 0, y: self.table.contentSize.height - self.table.bounds.height), animated: true)
        }
    }
    
    /// Mark ----NYCommentsCellDelegate
    func commentsCell(cell: NYCommentsCell) {
        self.commentModel = cell._listCommentFrameModel?._commentModel
        self.sendCommentType = .send
        setTSKeyboard(placeholderText: "随便说说~", cell: cell)
    }
    
    func commentsLikeCell(cell: NYCommentsCell) {
        
    }
    
}


extension NYVideoDetailVC: ZFPlayerDelegate {

    func zf_playerDownload(_ url: String!) {
        TSUtil.share().showDownloadVC(videoUrl: url)
    }
}


extension NYVideoDetailVC: UITableViewDelegate,UITableViewDataSource
{
    // MARK: - delegateDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.table.mj_footer != nil {
//            self.table.mj_footer.isHidden = self.commentDatas.count < self.showFootDataCount
//        }
        
        if self.commentDatas==nil {
            return 0
        }
        
        return self.commentDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NYCommentsCell.identifier) as? NYCommentsCell
        cell?.delegate = self
        cell?.setListCommentFrameModel(commentFModel: self.commentDatas[indexPath.row])
        
        cell?.line2.isHidden = (self.commentDatas.count-1)==indexPath.row
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.frame = CGRect(x:0,y:0,width:ScreenWidth,height:40)
        headView.backgroundColor = UIColor(red: 59, green: 59, blue: 61)
        let title = UILabel(frame: CGRect(x:10,y:0,width:ScreenWidth-10,height:40))
        var num = Float(0).combatValues
        if _videosModel != nil
        {
            num = Float((_videosModel?.comment_count)!).combatValues
        }
        title.text = "评论（\(num)）"
        title.textColor = TSColor.main.themeZsColor
        title.font = UIFont.systemFont(ofSize: 12.0)
        headView.addSubview(title)
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    // MARK: - tableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? NYCommentsCell
        
//        let userId = self.commentDatas[indexPath.row].userInfo?.userIdentity
//        self.index = indexPath.row
//        TSKeyboardToolbar.share.keyboarddisappear()
//        if userId == (TSCurrentUserInfo.share.userInfo?.userIdentity)! {
//            let customAction = TSCustomActionsheetView(titles: ["申请评论置顶", "选择_删除".localized])
//            customAction.delegate = self
//            customAction.tag = 250
//            customAction.show()
//            return
//        }
//
//        self.sendCommentType = .replySend
//        self.commentModel = self.commentDatas[indexPath.row]
//        isScroll = false
//        setTSKeyboard(placeholderText: "回复: \((self.commentModel?.userInfo?.name)!)", cell: cell)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight:CGFloat = self.commentDatas[indexPath.row].cellHeight
        return cellHeight
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        currentScrollOffSet = scrollView.contentOffset.y
//        if isScroll {
//            super.scrollViewDidScroll(scrollView)
//        }
//    }
    
}

extension NYVideoDetailVC: ShareListViewDelegate {
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
        let repostModel = TSRepostModel.coverPostVideoModel(videoModel: _videosModel!)
        let releaseVC = TSReleasePulseViewController(isHiddenshowImageCollectionView: true)
        releaseVC.repostModel = repostModel
        let navigation = TSNavigationController(rootViewController: releaseVC)
        self.present(navigation, animated: true, completion: nil)
    }
    
    func didClickApplyTopButon(_ shareView: ShareListView, fatherViewTag: Int, feedIndex: IndexPath) {
        
    }
}
