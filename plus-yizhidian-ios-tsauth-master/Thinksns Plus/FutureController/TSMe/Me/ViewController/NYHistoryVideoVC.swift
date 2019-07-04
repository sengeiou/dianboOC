//
//  NYHistoryVideoVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/4.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYHistoryVideoVC: NYBaseViewController {

    var rightItem:UIButton?
    
    var table:TSTableView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var allSelectBtn: UIButton!
    
    @IBOutlet weak var delButton: UIButton!
    
    /// 数据源
    var dataSource: [[NYMeHistoryVModel]] = [[]]
    var dataHeadTitles:[String] = ["七天内","更早"]
    /// 是否编辑
    var isEdit:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "观看历史"
        setUI()
    }

    func setUI()
    {
        self.view.backgroundColor = TSColor.main.themeTB
        setChatButton()
        //table
        table = TSTableView(frame: CGRect.zero, style: .grouped)
        table.backgroundColor = TSColor.main.themeTB
        table.backgroundView?.backgroundColor = TSColor.main.themeTB
        table.mj_header = TSRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        table.mj_footer = TSRefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        table.mj_footer.isHidden = true
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        table.register(UINib.init(nibName: "NYHistoryVideoCell", bundle: Bundle.main), forCellReuseIdentifier: NYHistoryVideoCell.identifier)
        self.view.insertSubview(table, at: 0)
//        self.view.addSubview(table)
        table.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0)
        table.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        table.mj_header.beginRefreshing()
    }
    // MARK: - 设置编辑（设置右上角按钮）
    func setChatButton() {
        let rightItem = UIButton(type: .custom)
        rightItem.frame = CGRect(x: 0, y: 0, width: 65, height: 40)
        rightItem.contentHorizontalAlignment = .right
        rightItem.set(title: "选择_编辑".localized, titleColor: UIColor.white, for: .normal)
        rightItem.set(title: "取消", titleColor: UIColor.white, for: .selected)
        rightItem.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItem)
        self.rightItem = rightItem
        //     self.rightItem?.titleEdgeInsets = UIEdgeInsets(top: 0, left:40, bottom: 0, right: 0)
    }
    
    func rightButtonClick()
    {
        if isEdit
        {
            self.bottomView.isHidden = false
            self.rightItem?.isSelected = true
            isEdit = false
        }
        else
        {
            self.bottomView.isHidden = true
            self.rightItem?.isSelected = false
            isEdit = true
        }
        self.table.reloadData()
    }

    func refresh() {
        //历史观看
        NYPopularNetworkManager.getVideoRecordListData { (list, msg, isBol) in
            if let models = list
            {
                var reslutList = NSMutableArray()
                var data7:[NYMeHistoryVModel] = [] //7天
                var data:[NYMeHistoryVModel] = [] //更早
                let date2 = Date()
                for obj in models
                {
                    let hour = NYUtils.getCountDateHour(date1: obj.created_at, date2: date2)
                    if  hour < 168
                    {
                        data7.append(obj)
                    }
                    else
                    {
                        data.append(obj)
                    }
                }
                if data7.count>0
                {
                    reslutList.add(data7)
                }
                if data.count>0
                {
                    reslutList.add(data)
                }
                self.dataSource = reslutList as! [[NYMeHistoryVModel]]
                self.table.reloadData()
            }
            self.table.mj_header.endRefreshing()
        }
    }
    
    // MARK: - loadMore
    func loadMore()
    {
        
    }
    
    /// 全选
    @IBAction func allSelectClickdo(_ sender: UIButton)
    {
        self.allSelectBtn.isSelected = !self.allSelectBtn.isSelected
        if  self.dataSource.count>0
        {
            for data in self.dataSource
            {
                for obj in data
                {
                    obj.select = self.allSelectBtn.isSelected
                }
            }
            self.table.reloadData()
        }
    }
    
    /// 删除
    @IBAction func delButtonClickdo(_ sender: UIButton)
    {
        var video_ids = String()
        if self.allSelectBtn.isSelected
        {
            video_ids = "all"
        }else
        {
            if self.dataSource.count>0
            {
                for (index,data) in self.dataSource.enumerated()
                {
                    for obj in data
                    {
                        if obj.select
                        {
                            video_ids.append("\(obj.video_id),")
                        }
                    }
                }
                video_ids.remove(at: video_ids.index(before: video_ids.endIndex))
                video_ids = "[\(video_ids)]"
            }
        }
        
        NYPopularNetworkManager.delVideoRecordprogress(video_ids:video_ids) { (msg, isBol) in
            if isBol
            {
                self.refresh()
            }
        }
    }
    
}

extension NYHistoryVideoVC: UITableViewDelegate,UITableViewDataSource
{
    // MARK: - delegateDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if self.table.mj_footer != nil {
        //            self.table.mj_footer.isHidden = self.commentDatas.count < self.showFootDataCount
        //        }
        
        return self.dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NYHistoryVideoCell.identifier) as? NYHistoryVideoCell
        let rowData = self.dataSource[indexPath.section]
        cell?.isEdit = (rightItem?.isSelected)!
        cell?.setMeHistoryVModel(meHistoryVModel:rowData[indexPath.row])
        
        if indexPath.row == (rowData.count - 1) {
            cell?.lineView.isHidden = true
        } else {
            cell?.lineView.isHidden = false
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.frame = CGRect(x:0,y:0,width:ScreenWidth,height:40)
        headView.backgroundColor = TSColor.main.themeTBCellBg
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x:10,y:0,width:150,height:40)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = TSColor.main.themeZsColor
        titleLabel.text = dataHeadTitles[section]
        headView.addSubview(titleLabel)
        let line = UIView()
        line.frame = CGRect(x:0,y:39.5,width:ScreenWidth,height:0.5)
        line.backgroundColor = UIColor.lightGray
        headView.addSubview(line)
        return headView
    }
    
    
    // MARK: - tableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if rightItem?.isSelected==false
        {
            let cell = tableView.cellForRow(at: indexPath) as? NYHistoryVideoCell
            let model = cell?._MeHistoryVModel
            let videoDetailVC = NYVideoDetailVC()
            videoDetailVC.video_id = model!.video_id
            videoDetailVC.progress = model!.progress
            self.navigationController?.pushViewController(videoDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight:CGFloat = NYHistoryVideoCell.cellHeight
        return cellHeight
    }
    
    //    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        currentScrollOffSet = scrollView.contentOffset.y
    //        if isScroll {
    //            super.scrollViewDidScroll(scrollView)
    //        }
    //    }
    
    
}
