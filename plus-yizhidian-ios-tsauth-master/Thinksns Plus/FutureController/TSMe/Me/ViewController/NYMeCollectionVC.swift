//
//  NYMeCollectionVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/4.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYMeCollectionVC: NYBaseViewController ,UIScrollViewDelegate{

    /// 视频
    let videoPage = NYSelFocusView.init(frame: .zero, tableIdentifier: "videoCell",channel_id:0)
    /// 帖子
    let postPage = NYPostTableView.init(frame: .zero, tableIdentifier: "postPageCell")
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    
    /// 滚动视图
    var scrollView = UIScrollView(frame: CGRect(x:0,y:0,width:ScreenWidth,height:ScreenHeight-60))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        setUI()
        settingViewController()
        loadRefresh()
    }
    
    func setUI() {
        self.videoButton.isSelected = true
        
        scrollView.contentSize = CGSize(width: ScreenWidth*2, height: scrollView.height)
        scrollView.backgroundColor = UIColor.clear
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        self.contentView.addSubview(scrollView)
//        scrollView.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        }
    }
    
    func settingViewController()
    {
        // 2.设置刷新代理
        videoPage.refreshDelegate = self
        postPage.refreshDelegate = self
        
        add(childView: postPage, at: 1)
        add(childView: videoPage, at: 0)
        
        videoPage.interactDelegate = self
        postPage.interactDelegate = self
    }
    
    // MARK: - refresh
    func loadRefresh() {
        //视频
        NYPopularNetworkManager.getVideosCollectionsData(after:0) { (list: [NYVideosModel]?,error,isobl) in
            if let models = list {
                self.videoPage.datas = models
            }
            self.videoPage.reloadData()
        }
        //帖子
        TSMomentNetworkManager().getfeedcollectionList(after:0 ,complete:{(data: [TSMomentListModel]?, error) in
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
    
    var oldIndex = 0
    /// 刷新按钮
    private func updateButton(_ index: Int) {
        if oldIndex == index {
            return
        }
        if index==0
        {
            self.videoButton.isSelected = true
            self.postButton.isSelected = false
        }
        else
        {
            self.videoButton.isSelected = false
            self.postButton.isSelected = true
        }
        oldIndex = index
    }
    // MARK: - Public
    
    /// 添加子视图
    public func add(childView: UIView, at index: Int) {
        let width = self.scrollView.frame.width
        let height = self.scrollView.frame.height
        childView.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
        self.scrollView.addSubview(childView)
    }
    
    // MARK: - Button click
    @IBAction func buttonTaped(sender: UIButton) {
        let index = sender.tag
        updateButton(Int(index))
        scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.size.width * CGFloat(index), y: 0), animated: true)
    }
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index = scrollView.contentOffset.x / scrollView.frame.width
        if index < 0 {
            index = CGFloat(0)
        }
        if Int(index) > 2 {
            index = CGFloat(1)
        }
        let i = round(index)
        updateButton(Int(i))
    }

}

extension NYMeCollectionVC: FeedListViewDelegate {
    
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
extension NYMeCollectionVC: FeedListViewRefreshDelegate {
    
    // MARK: 代理方法
    /// 下拉刷新
    func feedListTable(_ table: FeedListActionView, refreshingDataOf tableIdentifier: String) {
        
    }
    /// 上拉加载
    func feedListTable(_ table: FeedListView, loadMoreDataOf tableIdentifier: String) {
        
    }
}
