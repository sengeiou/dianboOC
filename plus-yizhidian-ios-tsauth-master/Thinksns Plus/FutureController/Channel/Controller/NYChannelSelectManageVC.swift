//
//  NYChannelSelectManageVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/2.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYChannelSelectManageVC: UIViewController , UITableViewDelegate, UITableViewDataSource
{
    let topChannelView = NYTopChannelView()
    
    var me_tablview :TSTableView!
    /// 数据源
    var dataStars: [StarsHotModel] = []
    var dataSource = NSMutableArray()
    /// 占位图
    let occupiedView = UIImageView()
    /// table 区分标识符，当多个 TSQuoraTableView 同时存在同一个界面时区分彼此
    var tableIdentifier = "NYChannelSelCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        refresh()
    }
    
    // MARK: - UI
    func setUI() {
        dataSource = [0,2,3,4,3,5,53,5]
        //        NYSelFocusView.init(frame: .zero, tableIdentifier: "dssssPP")
        //        init(frame: frame, style: .plain)
        me_tablview = TSTableView(frame: CGRect.zero, style: .plain)
        self.view.backgroundColor = TSColor.main.themeTB
        self.view.addSubview(me_tablview)
        me_tablview.delegate = self
        me_tablview.dataSource = self
        me_tablview.separatorStyle = UITableViewCell.SeparatorStyle.none
        me_tablview.register(UINib.init(nibName: "NYSelCell", bundle: Bundle.main), forCellReuseIdentifier: tableIdentifier)
        me_tablview.backgroundColor = TSColor.main.themeTB
        me_tablview.backgroundView?.backgroundColor = TSColor.main.themeTB
//        me_tablview.tableHeaderView = starHead
        me_tablview.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        }
        
        //topview
        topChannelView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:40)
        self.view.addSubview(topChannelView)
        
    }
    
    func refresh() {
//        NYPopularNetworkManager.getHotPostListData( offset: 0,complete:{(list: [HotTopicModel]?, error,isobl) in
//            if let models = list {
//                for obj in models {
//                    let hotF = HotTopicFrameModel()
//                    hotF.setHotTopicModel(hotTModel: obj)
//                    self.dataSource.add(hotF)
//                }
//                self.me_tablview.reloadData()
//            }
//        })
//        me_tablview.mj_header.endRefreshing()
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
        let cellHeight = NYSelCell.cellHeight // datas[indexPath.row].cellHeight
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = CGFloat(20) // datas[indexPath.row].cellHeight
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! NYSelCell
//        cell.setHotTopicFrameModel(hotTopicFrame: self.dataSource[indexPath.row] as! HotTopicFrameModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        guard let cell = tableView.cellForRow(at: indexPath) as? NYSelCell else {
//            return
//        }
//        let feedId = 0;
//        // 3.以上情况都不是，跳转动态详情页
//        let detailVC = TSCommetDetailTableView(feedId: feedId, isTapMore: true)
//        self.navigationController?.pushViewController(detailVC, animated: true)
        //        interactDelegate?.feedList(self, didSelected: cell, onSeeAllButton: false)
    }
    
}
