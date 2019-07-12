//
//  NYChannelSelectManageVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/2.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYChannelSelectManageVC: NYBaseViewController , UITableViewDelegate, UITableViewDataSource,NYTopChannelViewDelegate
{
    //分类 频道 id
    var channel_id = 0
    //明星 id
    var star_id = 0
    
    let topChannelView = NYTopChannelView()
    
    var me_tablview :TSTableView!

    /// 数据源
    var datas: [NYVideosModel] = []
    /// 占位图
    let occupiedView = UIImageView()
    /// table 区分标识符，当多个 TSQuoraTableView 同时存在同一个界面时区分彼此
    var tableIdentifier = "NYChannelSelCell_Item"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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
        
        me_tablview.register(UINib.init(nibName: "NYSelCell", bundle: Bundle.main), forCellReuseIdentifier: tableIdentifier)
        me_tablview.backgroundColor = TSColor.main.themeTB
        me_tablview.backgroundView?.backgroundColor = TSColor.main.themeTB
//        me_tablview.tableHeaderView = starHead
        me_tablview.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        }
        
        //topview
        topChannelView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:40)
        topChannelView.delegate = self
        self.view.addSubview(topChannelView)
        topChannelView.refresh()
        
    }
    
    func refresh(tags:String,tag_cates:String) {
        
        NYPopularNetworkManager.getVideosListData(channel_id: channel_id, keyword: "", tags: tags,tag_cates:tag_cates) { (list: [NYVideosModel]?,error,isobl) in
            if let models = list {
                self.datas = models
                self.me_tablview.reloadData()
            }
            self.me_tablview.mj_header.endRefreshing()
        }

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
        if datas.count>0 {
            me_tablview.removePlaceholderViews()
        }
        if me_tablview.mj_footer != nil {
            me_tablview.mj_footer.isHidden = true //datas.count < listLimit
        }
        return datas.count
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
        cell.setVideosModel(video: self.datas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? NYSelCell else {
            return
        }
        let videoDetailVC = NYVideoDetailVC()
        videoDetailVC.video_id = cell.videoModel!.id
        self.navigationController?.pushViewController(videoDetailVC, animated: true)
    }
    
    /// Mark ----NYTopChannelViewDelegate
    
    func selectViewModelList(view: NYTopChannelView, tsgList: [NYtagModel]) {
        var tags = String()
        var tag_cates = String()
        for obj in tsgList
        {
            if obj.tag_category_id>0
            {
                tags.append("\(obj.id),")
            }else
            {
                tag_cates.append("\(obj.id),")
            }
        }
        if tags.count>0
        {
            tags.remove(at: tags.index(before: tags.endIndex))
            tags = "[\(tags)]"
        }
        if tag_cates.count>0
        {
            tag_cates.remove(at: tag_cates.index(before: tag_cates.endIndex))
            tag_cates = "[\(tag_cates)]"
        }
        refresh(tags: tags, tag_cates:tag_cates)
    }
    
    func firstViewModelList(view: NYTopChannelView, tsgList: [NYtagModel]) {
        var tag_cates = String()
        for obj in tsgList
        {
            tag_cates.append("\(obj.id),")
        }
        if tag_cates.count>0
        {
            tag_cates.remove(at: tag_cates.index(before: tag_cates.endIndex))
            tag_cates = "[\(tag_cates)]"
        }
        refresh(tags: "", tag_cates: tag_cates)
    }
    
}
