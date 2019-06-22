//
//  HotListHeadView.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/18.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

protocol HotListHeadViewDelegate:NSObjectProtocol
{
    /// select
     func headSelectItemAt(_ view: HotListHeadView,HotModel obj: GroupModel)
}

class HotListHeadView: UIView,UICollectionViewDataSource, UICollectionViewDelegate
{
    var starCollectionView: UICollectionView!
    /// 数据源
    var dataSource: [GroupModel] = []
    
    /// 交互代理
    weak var hotListHeadDelegate: HotListHeadViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    deinit {
        
    }
    
    // MARK: - Custom user interface
    func setUI()
    {
        backgroundColor = TSColor.main.themeTBCellBg
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 2
        let itemW:CGFloat = (ScreenWidth/5)-10
        let itemH:CGFloat = (self.height/2)-10
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.scrollDirection = .vertical
        // 3.设置滚动方向
        starCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        starCollectionView.backgroundColor = UIColor.clear
        starCollectionView.delegate = self
        starCollectionView.dataSource = self
        starCollectionView.register(TopicCollectionCell.self, forCellWithReuseIdentifier: TopicCollectionCell.identifier)
        self.addSubview(starCollectionView)
        starCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
//        topicCollectionView.mj_header = TSRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
//        topicCollectionView.mj_footer = TSRefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
//        topicCollectionView.mj_header.beginRefreshing()
        
        refresh()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TopicCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionCell.identifier, for: indexPath) as! TopicCollectionCell
        cell.setInfo(model: dataSource[indexPath.row], index: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 游客触发登录
        if !TSCurrentUserInfo.share.isLogin {
            TSRootViewController.share.guestJoinLoginVC()
            return
        }
        hotListHeadDelegate?.headSelectItemAt(self, HotModel: dataSource[indexPath.row])
    }
    
    func refresh() {
        GroupNetworkManager.getRecommendGroups(offset: 0) { (models, message, status) in
            if let models = models {
                self.dataSource = models
                self.starCollectionView.reloadData()
            }
        }

//        return
//        NYPopularNetworkManager.getPopularData(complete: { (list: [StarsHotModel]?, error,isobl) in
//            if let models = list {
//                self.dataSource = models
//                self.starCollectionView.reloadData()
//            }
//        })
    }

}
