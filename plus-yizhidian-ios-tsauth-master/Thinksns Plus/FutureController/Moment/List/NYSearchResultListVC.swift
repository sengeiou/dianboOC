//
//  NYSearchResultListVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/29.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYSearchResultListVC: NYBaseViewController,UIScrollViewDelegate,UITextFieldDelegate {

    /// 视频
    let videoPage = NYSelFocusView.init(frame: .zero, tableIdentifier: "videoCell",channel_id:0) //FeedListActionView(frame: .zero, tableIdentifier: FeedListType.hot.rawValue)
    /// 短视频
    let videoShortPage = NYSelFocusView.init(frame: .zero, tableIdentifier: "ShortCell",channel_id:2)
    //FeedListActionView(frame: .zero, tableIdentifier: FeedListType.new.rawValue)
    /// 明星
    let starPage = NYSelFocusView.init(frame: .zero, tableIdentifier: "StarCell",channel_id:3)
    /// 圈子
    let groupPage = NYGroupTableView.init(frame: .zero, tableIdentifier: "groupPageCell")
    /// 帖子
    let postPage = NYPostTableView.init(frame: .zero, tableIdentifier: "postPageCell")
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var navgtionView: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var tabsView: UIView!
    /// 标签下方的蓝线
    let blueLine = UIView()
    /// 蓝线的 leading
    var blueLineLeading: CGFloat = 0
    /// 按钮基础 tag 值
    let tagBasicForButton = 200
    //search bar
    let searchBar = NYSearchBarView()
    /// 滚动视图
    var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height)))
    ///关键字
    var keyword:String?
    /// 标签标题数组
    var titleArray: [String]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        settingViewController()
        loadRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUI()
    {
        self.view.backgroundColor = TSColor.main.themeTB
        //设置 nav
        searchBar.searchTextFiled.placeholder = "搜索_关键字".localized
        searchBar.searchTextFiled.text = keyword
        searchBar.searchTextFiled.delegate = self
        self.navgtionView.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.width.equalTo(245.0)
            make.height.equalTo(30.0)
            make.top.equalTo(26.0)
            make.centerX.equalTo(self.navgtionView.centerX)
        }
        
        titleArray = ["视频".localized,
         "推荐_短视频".localized,
         "推荐_明星".localized,
         "圈子",
         "帖子"]
        //tab title
        let labelButtonWidth = (ScreenWidth - 88)/CGFloat(titleArray!.count);
        
        //30 + (titleArray[0].sizeOfString(usingFont: UIFont.systemFont(ofSize: TSFont.Title.headline.rawValue))).width // 单边间距，参见 TS 设计文档第二版第 7 页
        let buttonTitleSize = titleArray![0].sizeOfString(usingFont: UIFont.systemFont(ofSize: TSFont.Title.headline.rawValue))
        let labelHeight: CGFloat = 44
        
        // labelView button
        var buttonCX:CGFloat = 0.0
        for (index, title) in titleArray!.enumerated() {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: CGFloat(index) * labelButtonWidth, y: CGFloat(0), width: labelButtonWidth, height: labelHeight)
            button.titleLabel?.font = UIFont.systemFont(ofSize: TSFont.Title.pulse.rawValue)
            button.setTitle(title, for: .normal)
            button.setTitleColor( index == 0 ? UIColor.white : UIColor(hex:0xffffff,alpha:0.5), for: .normal)
            button.addTarget(self, action: #selector(buttonTaped(sender:)), for: .touchUpInside)
            button.tag = tagBasicForButton + index
            if index==0 {
                buttonCX = button.centerX;
            }
            tabsView.addSubview(button)
        }
        // blue line
        let blueLineHeight: CGFloat = 2.0
        blueLineLeading = (labelButtonWidth - buttonTitleSize.width) / 2 - 7
        blueLine.frame = CGRect(x: blueLineLeading, y: labelHeight - blueLineHeight, width: buttonTitleSize.width-8, height: blueLineHeight)
        blueLine.centerX = buttonCX
        blueLine.backgroundColor = UIColor.white
        tabsView.addSubview(blueLine)
       
        // scrollView
        scrollView.mj_y = topView.height
        scrollView.mj_h = ScreenHeight - topView.height
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(titleArray!.count), height: scrollView.frame.size.height)
        scrollView.backgroundColor = UIColor.clear
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
    }
    
    func settingViewController()
    {
        groupPage.tag = 10
        postPage.tag = 20
        // 2.设置刷新代理
        videoPage.refreshDelegate = self
        videoShortPage.refreshDelegate = self
        starPage.refreshDelegate = self
        groupPage.refreshDelegate = self
        postPage.refreshDelegate = self
        
        add(childView: postPage, at: 4)
        add(childView: groupPage, at: 3)
        add(childView: starPage, at: 2)
        add(childView: videoShortPage, at: 1)
        add(childView: videoPage, at: 0)
        
        videoPage.interactDelegate = self
        videoShortPage.interactDelegate = self
        videoShortPage.interactDelegate = self
        groupPage.interactDelegate = self
        postPage.interactDelegate = self
    }
    // MARK: - refresh
    func loadRefresh() {
        //历史搜索
        NYPopularNetworkManager.addSearchKeywords(keyword: keyword!, complete: { (msg, isbol) in
            print("\(msg)")
        })
        
        //视频
        NYPopularNetworkManager.getVideosListData(channel_id: 0, keyword: keyword!, tags: "") { (list: [NYVideosModel]?,error,isobl) in
            if let models = list {
                self.videoPage.datas = models
            }
            self.videoPage.reloadData()
        }
        
        //短视频
        NYPopularNetworkManager.getVideosListData(channel_id: 2, keyword: keyword!, tags: "") { (list: [NYVideosModel]?,error,isobl) in
            if let models = list {
                self.videoShortPage.datas = models
            }
            self.videoShortPage.reloadData()
        }
        //明星
        NYPopularNetworkManager.getMXVideosListData(channel_id: 3, keyword: keyword!, tags: "") { (list: [NYMXVideosModel]?,error,isobl) in
            if let models = list {
                self.starPage.mx_datas = models
            }
            self.starPage.reloadData()
        }
        //圈子
        GroupNetworkManager.getALLGroupsList(keyword: keyword!, category_id: "", id: "", offset: 0) { (models, message, status) in
            var cellModels: [GroupListCellModel]?
            if let models = models {
                cellModels = []
                cellModels = models.map { GroupListCellModel(model: $0) }
                self.groupPage.group_datas = cellModels!
            }
            self.groupPage.reloadData()
        }
        //帖子
        TSMomentNetworkManager().getfeedList(hot: "", search: keyword!, type: "new",after:0 ,complete:{(data: [TSMomentListModel]?, error) in
            var dataSource: [HotTopicFrameModel]?
            if let models = data {
                dataSource = []
                for obj in models {
                    let hotF = HotTopicFrameModel()
                    hotF.setHotMomentListModel(hotMomentModel: obj)
                    dataSource?.append(hotF)
                }
                self.postPage.post_datas = dataSource!
            }
            self.postPage.reloadData()
        })
    }
    
    //MARK: - 事件
    //返回
    @IBAction func backClickdo(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //搜索
    @IBAction func searchClickdo(_ sender: UIButton) {
        self.view.endEditing(true)
        keyword = searchBar.searchTextFiled.text
        loadRefresh()
        print("搜索=%@",keyword)
    }
    
    // MARK: - Public
    
    /// 添加子视图
    public func add(childView: UIView, at index: Int) {
        let width = self.scrollView.frame.width
        let height = self.scrollView.frame.height
        childView.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
        self.scrollView.addSubview(childView)
    }
    /// 添加子视图控制器的方法
    ///
    /// - Parameters:
    ///   - childViewController: 子视图控制器
    ///   - index: 索引下标，从 0 开始，请与 labelTitleArray 中的下标一一对应
    public func add(childViewController: Any, At index: Int) {
        let width = self.scrollView.frame.width
        let height = self.scrollView.frame.height
        if let childVC = childViewController as? UIViewController {
            self.addChildViewController(childVC)
            childVC.view.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
            self.scrollView.addSubview(childVC.view)
        }
    }
    // MARK: - Button click
    func buttonTaped(sender: UIButton) {
        let index = sender.tag - tagBasicForButton
        scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.size.width * CGFloat(index), y: 0), animated: true)
    }
    /// 切换了选中的页面
    func selectedPageChangedTo(index: Int) {
        /// [长期注释] 这个方法有子类实现，来获取页面切换的回调
    }
    /// 切换选中的分页
    ///
    /// - Parameter index: 分页下标
    public func setSelectedAt(_ index: Int) {
        update(childViewsAt: index)
    }
    // MARK: - Private
    
    /// 更新 scrollow 的偏移位置
    private func update(childViewsAt index: Int) {
        let width = self.scrollView.frame.width
        // scroll view
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * width, y: 0), animated: true)
        updateButton(index)
    }
    
    var oldIndex = 0
    /// 刷新按钮
    private func updateButton(_ index: Int) {
        if oldIndex == index {
            return
        }
        selectedPageChangedTo(index: index)
        let oldButton = (tabsView.viewWithTag(tagBasicForButton + oldIndex) as? UIButton)!
        oldButton.setTitleColor(UIColor(hex:0xffffff,alpha:0.5), for: .normal)
        oldIndex = index
        let button = (tabsView.viewWithTag(tagBasicForButton + index) as? UIButton)!
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    // MARK: - Delegate
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index = scrollView.contentOffset.x / scrollView.frame.width
        if index < 0 {
            index = CGFloat(0)
        }
        if Int(index) > titleArray!.count {
            index = CGFloat(titleArray!.count)
        }
        let i = round(index)
        updateButton(Int(i))
        let btn:UIButton = tabsView.viewWithTag(tagBasicForButton + Int(i)) as! UIButton
        blueLine.centerX = btn.centerX
    }
    
    /// mark ---UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchClickdo(self.searchButton)
        return true
    }

    
}

extension NYSearchResultListVC: FeedListViewDelegate {
    
    func postList(_ view: NYSelFocusView, didSelected cell:NYHotTopicCell) {
        let feedId = cell.hotTopicFrameModel?.hotMomentListModel?.moment.feedIdentity
        // 3.以上情况都不是，跳转动态详情页
        let detailVC = TSCommetDetailTableView(feedId: feedId!, isTapMore: true)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func groupList(_ view: NYSelFocusView, didSelected cell: GroupListCell) {
        let postListVC = GroupDetailVC(groupId: cell.model.id)
        navigationController?.pushViewController(postListVC, animated: true)
    }
    func feedList(_ view: FeedListView, didSelected cell: FeedListCell, onSeeAllButton: Bool) {
        
    }
    
    func feedList(_ view: NYSelFocusView, didSelected cell: NYSelCell) {
        let videoDetailVC = NYVideoDetailVC()
        videoDetailVC.video_id = cell.videoModel!.id
        self.navigationController?.pushViewController(videoDetailVC, animated: true)
    }
    
    func feedList(_ view: FeedListView, didSelected cell: FeedListCell, on pictureView: PicturesTrellisView, withPictureIndex index: Int) {
        
    }
    
    func feedList(_ view: FeedListView, didSelected cell: FeedListCell, on toolbar: TSToolbarView, withToolbarButtonIndex index: Int) {
        
    }
    
    func feedList(_ view: FeedListView, didSelected cell: FeedListCell, on commentView: FeedCommentListView, withCommentIndexPath commentIndexPath: IndexPath) {
        
    }
    
    func feedList(_ view: FeedListView, didLongPress cell: FeedListCell, on commentView: FeedCommentListView, withCommentIndexPath commentIndexPath: IndexPath) {
        
    }
    
    func feedList(_ view: FeedListView, didSelected cell: FeedListCell, didSelectedComment commentCell: FeedCommentListCell, onUser userId: Int) {
        
    }
    
    func feedList(_ view: FeedListView, didSelectedResendButton cell: FeedListCell) {
        
    }
    
}

// MARK: - FeedListViewRefreshDelegate: 列表刷新代理
extension NYSearchResultListVC: NYSelFocusListViewRefreshDelegate {

    // MARK: 代理方法
    /// 下拉刷新
    func feedListTable(_ table: NYSelFocusView, refreshingDataOf tableIdentifier: String) {
        // 1.如果在游客模式下，不用请求关注列表的数据
        if !TSCurrentUserInfo.share.isLogin {
            table.mj_header.endRefreshing()
            return
        }
        // 游客模式下不能刷新
        if !TSCurrentUserInfo.share.isLogin {
            TSRootViewController.share.guestJoinLoginVC()
            table.mj_header.endRefreshing()
            return
        }
        if table.tag == 10 //圈子
        {
            GroupNetworkManager.getALLGroupsList(keyword: keyword!, category_id: "", id: "", offset: 0) { (models, message, status) in
                var cellModels: [GroupListCellModel]?
                if let models = models {
                    cellModels = []
                    cellModels = models.map { GroupListCellModel(model: $0) }
                    self.groupPage.group_datas = cellModels!
                }
                table.reloadData()
                table.mj_header.endRefreshing()
            }
        }
        else if table.tag == 20 //帖子
        {
            TSMomentNetworkManager().getfeedList(hot: "", search: keyword!, type: "new",after:0 ,complete:{(data: [TSMomentListModel]?, error) in
                var dataSource: [HotTopicFrameModel]?
                if let models = data {
                    dataSource = []
                    for obj in models {
                        let hotF = HotTopicFrameModel()
                        hotF.setHotMomentListModel(hotMomentModel: obj)
                        dataSource?.append(hotF)
                    }
                    self.postPage.post_datas = dataSource!
                }
                table.reloadData()
                table.mj_header.endRefreshing()
            })
        }else
        {
            if  table.channel_id == 3
            {
                //明星
                NYPopularNetworkManager.getMXVideosListData(channel_id: table.channel_id, keyword: keyword!, tags: "") { (list: [NYMXVideosModel]?,error,isobl) in
                    if let models = list {
                        table.mx_datas = models
                    }
                    table.reloadData()
                    table.mj_header.endRefreshing()
                }
            }else
            {
                //短视频
                NYPopularNetworkManager.getVideosListData(channel_id: table.channel_id, keyword: keyword!, tags: "") { (list: [NYVideosModel]?,error,isobl) in
                    if let models = list {
                        table.datas = models
                    }
                    table.reloadData()
                    table.mj_header.endRefreshing()
                }
            }
        }
        
    }
    /// 上拉加载
    func feedListTable(_ table: NYSelFocusView, loadMoreDataOf tableIdentifier: String) {
        // 游客模式下不能加载
        if !TSCurrentUserInfo.share.isLogin {
            TSRootViewController.share.guestJoinLoginVC()
            table.mj_footer.endRefreshing()
            table.mj_footer.isHidden = true
            return
        }
        if table.tag == 10 //圈子
        {
            GroupNetworkManager.getALLGroupsList(keyword: keyword!, category_id: "", id: "", offset: self.groupPage.group_datas.count) { (models, message, status) in
                var cellModels: [GroupListCellModel]?
                if let models = models {
                    cellModels = []
                    cellModels = models.map { GroupListCellModel(model: $0) }
                    for obj in cellModels!
                    {
                        self.groupPage.group_datas.append(obj)
                    }
                }
                table.reloadData()
                table.mj_header.endRefreshing()
            }
        }
        else if table.tag == 20 //帖子
        {
            TSMomentNetworkManager().getfeedList(hot: "", search: keyword!, type: "new",after:0 ,complete:{(data: [TSMomentListModel]?, error) in
                if let models = data {
                    for obj in models {
                        let hotF = HotTopicFrameModel()
                        hotF.setHotMomentListModel(hotMomentModel: obj)
                        self.postPage.post_datas.append(hotF)
                    }
                }
                table.reloadData()
                table.mj_header.endRefreshing()
            })
        }else
        {
            if  table.channel_id == 3
            {
                //明星
                NYPopularNetworkManager.getMXVideosListData(channel_id: table.channel_id, keyword: keyword!, tags: "",after:table.after!) { (list: [NYMXVideosModel]?,error,isobl) in
                    if let models = list {
                        for obj in models
                        {
                            table.mx_datas.append(obj)
                        }
                    }
                    table.reloadData()
                    table.mj_header.endRefreshing()
                }
            }else
            {
                //短视频
                NYPopularNetworkManager.getVideosListData(channel_id: table.channel_id, keyword: keyword!, tags: "",after:table.after!) { (list: [NYVideosModel]?,error,isobl) in
                    if let models = list {
                        for obj in models
                        {
                            table.datas.append(obj)
                        }
                    }
                    table.reloadData()
                    table.mj_header.endRefreshing()
                }
            }
        }
       
    }
}
