//
//  NYMePostListVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/7.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYMePostListVC: NYBaseViewController,NYPsentModalViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    ///模态
    let psentModalView = NYPsentModalView.loadFromNib()
    
    var tableIdentifier = "NYMePostListCell_item"
    /// 数据
    var post_datas: [HotTopicFrameModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    func  setUI() {
        self.view.backgroundColor = TSColor.main.themeTB
        table.backgroundColor = TSColor.main.themeTB
        table.backgroundView?.backgroundColor = TSColor.main.themeTB
        table.tableFooterView = UIView()
        table.register(NYHotTopicCell.self, forCellReuseIdentifier: tableIdentifier)
        table.mj_header = TSRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        table.mj_footer = TSRefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        table.mj_footer.isHidden = true
        table.mj_header.beginRefreshing()
        
        psentModalView.delegate = self
    }
    
    func refresh() {
        //帖子
        let userID = "\(TSCurrentUserInfo.share.userInfo?.userIdentity ?? 0)"
        TSMomentNetworkManager().getfeedList(user:userID,hot: "", search: "", type: "users",after:0 ,complete:{(data: [TSMomentListModel]?, error) in
            var dataSource: [HotTopicFrameModel]?
            if let models = data {
                dataSource = []
                for obj in models {
                    let hotF = HotTopicFrameModel()
                    hotF.setHotMomentListModel(hotMomentModel: obj)
                    dataSource?.append(hotF)
                }
                self.post_datas = dataSource!
            }
            self.table.reloadData()
            self.table.mj_header.endRefreshing()
        })
    }
    
    // MARK: - loadMore
    func loadMore()
    {
        
    }
    
    // Mark --NYPsentModalViewDelegate
    func muneView(view: NYPsentModalView, to: Int) {
        view.index
        if to==0
        {//编辑
            view.hide()
        }else if to==1
        {//删除
            let feedId = self.post_datas[view.indexPath!.row].hotMomentListModel!.moment.feedIdentity
            deleteFeed(feedId: feedId, feedIndexPath: view.indexPath!)
        }
        view.hide()
    }
    /// 删除动态
    fileprivate func deleteFeed(feedId: Int, feedIndexPath: IndexPath) -> Void {
        let sendStatus = post_datas[feedIndexPath.row].hotMomentListModel?.status
        if sendStatus != 1 {
            // 1.如果是发送失败的动态
            TSDatabaseManager().moment.delete(moment: feedId)
        } else {
            // 2.如果是发送成功的动态
            TSDataQueueManager.share.moment.start(delete: feedId)
        }
        /// 刷新列表
        /// 刷新列表
        post_datas.remove(at: feedIndexPath.row)
        table.reloadData()
    }
}



extension NYMePostListVC: UITableViewDelegate,UITableViewDataSource
{
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        count = post_datas.count
        
        if table.mj_footer != nil {
            table.mj_footer.isHidden = true //datas.count < listLimit
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.post_datas[indexPath.row] as! HotTopicFrameModel
        let cellHeight = model.cellHeight!
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.post_datas[indexPath.row] as! HotTopicFrameModel
        let cellHeight = model.cellHeight!
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! NYHotTopicCell
        cell.delegate = self
        cell.moreButton?.isHidden=false
        cell.setHotTopicFrameModel(hotTopicFrame: self.post_datas[indexPath.row] as! HotTopicFrameModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? NYHotTopicCell else {
            return
        }
        let feedId = cell.hotTopicFrameModel?.hotMomentListModel?.moment.feedIdentity
        let detailVC = TSCommetDetailTableView(feedId: feedId!, isTapMore: true)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension NYMePostListVC: NYHotTopicCellDelegate
{
    func cell(_ cell: TSTableViewCell, operateBtn: TSButton, indexPathRow: NSInteger) {
        
    }
    
    func feedCell(_ cell: NYHotTopicCell, didSelectedPictures pictureView: PicturesTrellisView, at index: Int) {
        
    }
    
    func feedCell(_ cell: NYHotTopicCell, didSelectedPicturesCountMaskButton pictureView: PicturesTrellisView) {
        
    }
    
    func feedCellMore(_ cell: NYHotTopicCell) {
        psentModalView.showInView(self.view, cnterView: cell.moreButton!)
        psentModalView.indexPath = table.indexPath(for: cell)
    }
    func detailsFeedCelldo(_ cell: NYHotTopicCell) {
        let feedId = cell.hotTopicFrameModel?.hotMomentListModel?.moment.feedIdentity
        // 3.以上情况都不是，跳转动态详情页
        let detailVC = TSCommetDetailTableView(feedId: feedId!, isTapMore: true)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
