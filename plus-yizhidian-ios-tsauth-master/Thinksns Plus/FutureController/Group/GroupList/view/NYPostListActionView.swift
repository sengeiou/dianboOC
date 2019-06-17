//
//  NYGroupListView.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/9.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
@objc protocol NYFeedListViewRefreshDelegate: class {
    
    /// 下拉刷新
    @objc optional func feedListTable(_ table: NYPostListActionView, refreshingDataOf tableIdentifier: String)
    
    /// 上拉加载
    @objc optional func feedListTable(_ table: NYPostListActionView, loadMoreDataOf tableIdentifier: String)
}

/// 交互代理事件
@objc protocol NYFeedListViewDelegate: class {
    
    /// 点击了动态 cell
    ///
    /// - Parameters:
    ///   - onSeeAllButton: 点击的范围是否属于“查看全部评论”按钮上
    func feedList(_ view: NYPostListActionView, didSelected cell: NYHotTopicCell, onSeeAllButton: Bool)
    
    /// 点击了图片
    func feedList(_ view: NYPostListActionView, didSelected  cell: NYHotTopicCell, on pictureView: PicturesTrellisView, withPictureIndex index: Int)
    
    /// 点击了工具栏
    func feedList(_ view: NYPostListActionView, didSelected cell: NYHotTopicCell, on toolbar: TSToolbarView, withToolbarButtonIndex index: Int)
    
    /// 点击了评论行
    func feedList(_ view: NYPostListActionView, didSelected cell: NYHotTopicCell, on commentView: FeedCommentListView, withCommentIndexPath commentIndexPath: IndexPath)
    
    /// 长按了评论行
    func feedList(_ view: NYPostListActionView, didLongPress cell: NYHotTopicCell, on commentView: FeedCommentListView, withCommentIndexPath commentIndexPath: IndexPath)
    
    /// 点击了评论内容中的用户名
    func feedList(_ view: NYPostListActionView, didSelected cell: NYHotTopicCell, didSelectedComment commentCell: FeedCommentListCell, onUser userId: Int)
    
    /// 点击了重发按钮
    func feedList(_ view: NYPostListActionView, didSelectedResendButton cell: NYHotTopicCell)
    /// 点击了话题板块儿的某个话题
    @objc optional func feedListDidClickTopic(_ view: NYPostListActionView, topicId: Int)
}

@objc protocol NYFeedListViewScrollowDelegate: class {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
}

class NYPostListActionView: TSTableView
{
    enum SectionViewType {
        case none
//        case topic(FilterSectionViewModel, FilterSectionViewDelegate)
//        /// 有过滤弹窗按钮的 section view
//        case filter(FilterSectionViewModel, FilterSectionViewDelegate?)
//        /// 没有过滤弹窗,只有数量的section View
//        case count(FilterSectionViewModel)
    }
    /// 圈子 id
    var groupId: Int?
    /// 当前用户在圈子中的角色
    var role: GroupManagerType?
    /// 是否来自圈子标记，用于进入帖子详情时使用(本视图被多处使用，而进入帖子详情页需要该参数)
    var fromGroupFlag: Bool = false
    
    /// 创建新评论需要用到的信息
    ///
    /// - (feedIndexPath, feedId, replyId, replyName)
    var newCommentInfo: (IndexPath, Int, Int?, String?)?
    
    /// 评论编辑弹框需要用的属性（大概是这样）
    var yAxis: CGFloat = 0
    /// 是否是联合滚动的子视图
    var isUnionChildTable: Bool = false
    /// 主视图是否可以滚动
    var curentTabCanScroll: Bool = false {
        didSet {
            if curentTabCanScroll == false {
                self.contentOffset = .zero
            }
        }
    }
    /// 是否正在请求数据
    var isRequestList: Bool = false
    
    /// 数据源
    var datas: [TSMomentListModel] = []
    /// 我们自己的数据
    var dataSourceList = NSMutableArray()
    /// 刷新代理
    weak var refreshDelegate: NYFeedListViewRefreshDelegate?
    /// 交互代理
    weak var interactDelegate: NYFeedListViewDelegate?
    /// 滚动代理
    weak var scrollDelegate: NYFeedListViewScrollowDelegate?
    
    /// table 区分标识符，当多个 TSQuoraTableView 同时存在同一个界面时区分彼此
    var tableIdentifier = ""
    /// 是否需要显示话题板块儿
    var showTopics = true
    /// 动态所属话题的话题id
    var cellTopicId: Int = 0
    /// section view 类型
    var sectionViewType = SectionViewType.none
    /// 单页条数
    var listLimit = TSAppConfig.share.localInfo.limit
    /// 热门的分页是需要根据分页数量*listLimit
    var curentPage: Int = 0
    /// 分页标识
    var after: Int? {
        return datas.last?.moment.feedIdentity
//        guard let id = datas.last?.moment.feedIdentity else {
//            return nil
//        }
//        switch id {
//        case .advert(let pageId, _):
//            return pageId
//        case .feed(let feedId):
//            return feedId
//        case .post(_, _):
//            return self.curentPage * self.listLimit
//        case .topic(_, _):
//            return self.curentPage * self.listLimit
//        }
    }
    
    /// 是否需要显示加精的标识
    func isNeedShowPostExcellent() -> Bool {
        return true
    }
    
    // MARK: - 生命周期
    init(frame: CGRect, tableIdentifier identifier: String) {
        super.init(frame: frame, style: .plain)
        tableIdentifier = identifier
        setUI()
//        NotificationCenter.default.addObserver(self, selector: #selector(notiResReloadPaiedFeed(noti:)), name: NSNotification.Name.Moment.paidReloadFeedList, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(momentDetailVCDelete(noti:)), name: NSNotification.Name.Moment.momentDetailVCDelete, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var headerViewInsets = UIEdgeInsets.zero {
        didSet {
            shouldManuallyLayoutHeaderViews = headerViewInsets != .zero
            setNeedsLayout()
        }
    }
    
    var shouldManuallyLayoutHeaderViews = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shouldManuallyLayoutHeaderViews {
            layoutHeaderViews()
        }
    }
    
    func layoutHeaderViews() {
        let numberOfSections = self.numberOfSections
        let contentInset = self.contentInset
        let contentOffset = self.contentOffset
        let sectionViewMinimumOriginY = contentOffset.y + contentInset.top + headerViewInsets.top + TSStatusBarHeight - 20
        
        //    Layout each header view
        for section in 0 ..< numberOfSections {
            guard let sectionView = self.headerView(forSection: section) else {
                continue
            }
            let sectionFrame = rect(forSection: section)
            var sectionViewFrame = sectionView.frame
            
            sectionViewFrame.origin.y = sectionFrame.origin.y < sectionViewMinimumOriginY ? sectionViewMinimumOriginY : sectionFrame.origin.y
            
            if section < numberOfSections - 1 {
                let nextSectionFrame = self.rect(forSection: section + 1)
                if sectionViewFrame.maxY > nextSectionFrame.minY {
                    sectionViewFrame.origin.y = nextSectionFrame.origin.y - sectionViewFrame.size.height
                }
            }
            
            sectionView.frame = sectionViewFrame
        }
    }
    
    // MARK: - UI
    func setUI() {
        backgroundColor = TSColor.main.themeTB
        separatorStyle = .none
        delegate = self
        dataSource = self
        estimatedRowHeight = 100
        register(NYHotTopicCell.self, forCellReuseIdentifier: tableIdentifier)
        register(FilterSectionView.self, forHeaderFooterViewReuseIdentifier: FilterSectionView.identifier)
    }
    
    // MAKR: - Data
    override func refresh() {
        refreshDelegate?.feedListTable?(self, refreshingDataOf: tableIdentifier)
    }
    
    override func loadMore() {
        refreshDelegate?.feedListTable?(self, loadMoreDataOf: tableIdentifier)
    }
    
    /// 处理下拉刷新的数据，并更新界面 UI
    func processRefresh(data: [TSMomentListModel]?, message: String?, status: Bool) {
        // 1.隐藏指示器
        dismissIndicatorA()
        if mj_header != nil {
            if mj_header.isRefreshing() {
                mj_header.endRefreshing()
            }
        }
        mj_footer.resetNoMoreData()
        // 2.获取数据失败，显示占位图或者 A 指示器
        if let message = message {
            datas.isEmpty ? show(placeholderView: .network) : show(indicatorA: message)
            return
        }
        // 3.获取数据成功，更新数据
        guard let newDatas = data else {
            return
        }
        datas = newDatas
        // 如果数据为空，显示占位图
        if datas.isEmpty {
            show(placeholderView: .empty)
        }
        else
        {
            for obj in datas {
                let hotF = HotTopicFrameModel()
                hotF.setHotMomentListModel(hotMomentModel: obj)
                self.dataSourceList.add(hotF)
            }
        }
        // 刷新界面
        reloadData()
    }
    
    /// 处理上拉刷新的数据，并更新界面 UI
    func processloadMore(data: [TSMomentListModel]?, message: String?, status: Bool) {
        // 1.获取数据失败，显示"网络失败"的 footer
        if message != nil {
            mj_footer.endRefreshingWithWeakNetwork()
            return
        }
        // 隐藏 A 指示器
        dismissIndicatorA()
        // 2.请求成功
        // 更新 dataSource，并刷新界面
        guard let newDatas = data else {
            mj_footer.endRefreshing()
            return
        }
        datas = datas + newDatas
        reloadData()
        // 3.判断新数据数量是否够一页。不够一页显示"没有更多"的 footer；够一页仅结束 footer 动画
        if newDatas.count < listLimit {
            mj_footer.endRefreshingWithNoMoreData()
        } else {
            mj_footer.endRefreshing()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NYPostListActionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !datas.isEmpty {
            removePlaceholderViews()
        }
        if mj_footer != nil {
            mj_footer.isHidden = dataSourceList.count < listLimit
        }
        return dataSourceList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sectionViewType {
        case .none:
            return 0
//        case .filter(_), .count(_):
//            return 35
//        case .topic:
//            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataSourceList[indexPath.row] as! HotTopicFrameModel
        let cellHeight = model.cellHeight!
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataSourceList[indexPath.row] as! HotTopicFrameModel
        let cellHeight = model.cellHeight!
//        let cellHeight = datas[indexPath.row].cellHeight
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sectionViewType {
        case .none:
            return nil
//        case .filter(let model, let delegate):
//            let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterSectionView.identifier) as! FilterSectionView
//            sectionView.model = model
//            sectionView.delegate = delegate
//            sectionView.filterButton.isHidden = false
//            return sectionView
//        case .count(let model):
//            let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterSectionView.identifier) as! FilterSectionView
//            sectionView.model = model
//            sectionView.filterButton.isHidden = true
//            return sectionView
//        case .topic(let model, let delegate):
//            let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterSectionView.identifier) as! FilterSectionView
//            sectionView.headerSectionHeight = 40.0
//            sectionView.model = model
//            sectionView.delegate = delegate
//            sectionView.filterButton.isHidden = true
//            return sectionView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! NYHotTopicCell
        cell.setHotTopicFrameModel(hotTopicFrame: self.dataSourceList[indexPath.row] as! HotTopicFrameModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? NYHotTopicCell else {
            return
        }
        interactDelegate?.feedList(self, didSelected: cell, onSeeAllButton: false)
    }
    // MARK: - 更新付费内容显示
    func notiResReloadPaiedFeed(noti: Notification) {
        /// 付费当前页的列表刷新也是同一刷新的
        if let info = noti.userInfo, let feedId = info["feedId"] as? Int, let content = info["content"] as? String {
            /// 找到需要更新的id，可能会有重复的id，比如置顶id和第一页之后的数据
//            var reloadIndexs: [IndexPath] = []
//            for (index, data) in datas.enumerated() {
//
//                if let fid = data.moment.feedIdentity!, fid == feedId {
//                    datas[index]. = content
//                    datas[index].paidInfo = nil
//                    datas[index].shouldAddFuzzyString = false
//                    reloadIndexs.append(IndexPath(row: index, section: 0))
//                }
//            }
//            if reloadIndexs.isEmpty == false {
//                reloadRows(at: reloadIndexs, with: .none)
//            }
        }
    }
    // MARK: - 动态详情页执行了删除动态之后的通知刷新列表
    func momentDetailVCDelete(noti: Notification) {
        if let info = noti.userInfo, let feedId = info["feedId"] as? Int {
//            /// 找到需要更新的id，可能会有重复的id，比如置顶id和第一页之后的数据
//            var reloadIndexs: [IndexPath] = []
//            for (index, data) in datas.enumerated() {
//                if let fid = data.moment.feedIdentity, Int(fid) == feedId {
//                    reloadIndexs.append(IndexPath(row: index, section: 0))
//                }
//            }
//            if reloadIndexs.isEmpty == false {
//                for (_, datad) in reloadIndexs.enumerated().reversed() {
//                    datas.remove(at: datad.row)
//                }
//                reloadData()
//            }
        }
    }
    
}

// MARK: - UIScrollViewDelegate
extension NYPostListActionView {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideReleaseButton"), object: nil)
        self.perform(#selector(scrollViewDidEndScrollingAnimation), with: nil, afterDelay: 0.000_01)
        scrollDelegate?.scrollViewDidScroll(scrollView)
        TSAnimationTool.animationManager.stopGifAnimation()
        TSAnimationTool.animationManager.resetGifSuperView()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showReleaseButton"), object: nil)
//        getCurrentGifPicture()
    }
    
    /// 这里检索当前可见有动图且动图至少有一张是满足可见百分之八十
    func getCurrentGifPicture() {
        var hasGifAndCanPlay = false
        var curentCellIndex: Int = -1
        for index in 0..<self.visibleCells.count {
            if hasGifAndCanPlay {
                break
            }
            if self.visibleCells[index] as! FeedListCell != nil {
                for indexGif in 0..<(self.visibleCells[index] as! FeedListCell).picturesView.models.count {
                    if (self.visibleCells[index] as! FeedListCell).picturesView.models[indexGif].mimeType == "image/gif" {
                        if (self.visibleCells[index] as! FeedListCell).picturesView.models[indexGif].paidInfo?.type == .pictureSee {
                            /// 需要付费的不处理（没有付费的）
                        } else {
                            /// 这里需要计算这个gif图片是不是满足可见面积达到百分之八十
                            if (self.visibleCells[index] as! FeedListCell).picturesView.pictureViews[indexGif] != nil {
                                let coverViewPoint = (self.visibleCells[index] as! FeedListCell).picturesView.pictureViews[indexGif].convert(CGPoint(x: 0, y: 0), to: self.superview)
                                if coverViewPoint.y < 0 {
                                    if (coverViewPoint.y + (self.visibleCells[index] as! FeedListCell).picturesView.pictureViews[indexGif].frame.size.height * 0.2) >= 0 {
                                        hasGifAndCanPlay = true
                                        curentCellIndex = index
                                        break
                                    }
                                } else {
                                    if (coverViewPoint.y + (self.visibleCells[index] as! FeedListCell).picturesView.pictureViews[indexGif].frame.size.height * 0.8) <= (self.superview?.frame.height)! {
                                        hasGifAndCanPlay = true
                                        curentCellIndex = index
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if hasGifAndCanPlay {
            TSAnimationTool.animationManager.currentTable = (self.visibleCells[curentCellIndex] as! FeedListCell).picturesView
            TSAnimationTool.animationManager.allSuperView = self.superview
            TSAnimationTool.animationManager.getGifPictures()
        }
    }
}
