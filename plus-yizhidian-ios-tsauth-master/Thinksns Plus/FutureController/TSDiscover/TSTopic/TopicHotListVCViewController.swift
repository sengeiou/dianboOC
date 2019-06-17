//
//  TopicHotListVCViewController.swift
//  ThinkSNSPlus
//
//  Created by IMAC on 2018/7/23.
//  Copyright © 2018年 ZhiYiCX. All rights reserved.
//

import UIKit

class TopicHotListVCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //明星
    let starHead = HotListHeadView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 2))
    var me_tablview :TSTableView!
    /// 数据源
    var dataStars: [StarsHotModel] = []
    var dataSource = NSMutableArray()
    /// 占位图
    let occupiedView = UIImageView()
    /// table 区分标识符，当多个 TSQuoraTableView 同时存在同一个界面时区分彼此
    var tableIdentifier = "NYHotTopicCell_hot"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        refresh()

    }

    // MARK: - UI
    func setUI() {
//        NYSelFocusView.init(frame: .zero, tableIdentifier: "dssssPP")
//        init(frame: frame, style: .plain)
        me_tablview = TSTableView(frame: CGRect.zero, style: .plain)
        self.view.backgroundColor = TSColor.main.themeTB
        self.view.addSubview(me_tablview)
        me_tablview.delegate = self
        me_tablview.dataSource = self
        me_tablview.separatorStyle = UITableViewCell.SeparatorStyle.none
//        me_tablview.register(UINib.init(nibName: "NYSelCell", bundle: Bundle.main), forCellReuseIdentifier: tableIdentifier)
        me_tablview.register(NYHotTopicCell.self, forCellReuseIdentifier: tableIdentifier)
        me_tablview.backgroundColor = TSColor.main.themeTB
        me_tablview.backgroundView?.backgroundColor = TSColor.main.themeTB
        me_tablview.tableHeaderView = starHead
        me_tablview.mj_header = TSRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        me_tablview.mj_footer = TSRefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        me_tablview.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0))
        }
    }
   
    func loadMore() {
        
    }
    func refresh() {
        
        TSMomentNetworkManager().getfeedList(hot: "", search: "", type: "hot",after:0 ,complete:{(data: [TSMomentListModel]?, error) in
            if let models = data {
                for obj in models {
                    let hotF = HotTopicFrameModel()
                    hotF.setHotMomentListModel(hotMomentModel: obj)
                    self.dataSource.add(hotF)
                }
                self.me_tablview.reloadData()
            }
            self.me_tablview.mj_header.endRefreshing()
        })
//        NYPopularNetworkManager.getHotPostListData( offset: 0,complete:{(list: [HotTopicModel]?, error,isobl) in
//            if let models = list {
//                for obj in models {
//                    let hotF = HotTopicFrameModel()
//                    hotF.setHotTopicModel(hotTModel: obj)
//                    self.dataSource.add(hotF)
//                }
//                self.me_tablview.reloadData()
//            }
//            self.me_tablview.mj_header.endRefreshing()
//        })
        
//        TSUserNetworkingManager().getTopicList(index: nil, keyWordString: nil, limit: 15, direction: "desc", only: "hot") { (topicModel, networkError) in
//            self.processRefresh(datas: topicModel, message: networkError)
//        }
//
    }

    func processRefresh(datas: [TopicListModel]?, message: NetworkError?) {
//        // 获取数据成功
//        if let datas = datas {
//            dataSource = datas
//            if dataSource.isEmpty {
//                showOccupiedView(type: .empty)
//            }
//        }
//        // 获取数据失败
//        if message != nil {
//            dataSource = []
//            showOccupiedView(type: .network)
//        }
//        topicCollectionView.reloadData()
    }

    /// 显示占位图
    func showOccupiedView(type: TSTableViewController.OccupiedType) {
        var image = ""
        switch type {
        case .empty:
            image = "IMG_img_default_search"
        case .network:
            image = "IMG_img_default_internet"
        }
        occupiedView.image = UIImage(named: image)
        occupiedView.contentMode = .center
        if occupiedView.superview == nil {
            occupiedView.frame = me_tablview.bounds
            me_tablview.addSubview(occupiedView)
        }
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count>0 {
            me_tablview.removePlaceholderViews()
        }
        if me_tablview.mj_footer != nil {
            me_tablview.mj_footer.isHidden = true //datas.count < listLimit
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataSource[indexPath.row] as! HotTopicFrameModel
        let cellHeight = model.cellHeight!
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataSource[indexPath.row] as! HotTopicFrameModel
        let cellHeight = model.cellHeight!
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! NYHotTopicCell
        cell.setHotTopicFrameModel(hotTopicFrame: self.dataSource[indexPath.row] as! HotTopicFrameModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? NYHotTopicCell else {
            return
        }
        let feedId = cell.hotTopicFrameModel?.hotMomentListModel?.moment.feedIdentity
        // 3.以上情况都不是，跳转动态详情页
        let detailVC = TSCommetDetailTableView(feedId: feedId!, isTapMore: true)
        self.navigationController?.pushViewController(detailVC, animated: true)
        //        interactDelegate?.feedList(self, didSelected: cell, onSeeAllButton: false)
    }
    
}
