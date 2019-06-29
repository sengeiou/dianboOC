//
//  NYStarsListVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/26.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYStarsListVC: UITableViewController,NYStarsListCellDelegate {
    
    var dataDict:Dictionary<String, Any>?
    var keys:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "明星"
        self.view.backgroundColor = TSColor.main.themeTB
        tableView.backgroundColor = TSColor.main.themeTB
        tableView.backgroundView?.backgroundColor = TSColor.main.themeTB
        tableView.rowHeight = NYStarsListCell.cellHeight
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.register(NYStarsListCell.self, forCellReuseIdentifier: NYStarsListCell.identifier)

        refresh()
    }

    // MARK: - refresh
    func refresh() {
        
        NYPopularNetworkManager.getStarsListData(complete: { (dict: Dictionary<String, Any>?, error,isobl) in
            if let data = dict
            {
                self.dataDict = data
                self.keys = data.keys.sorted()
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.dataDict == nil
        {
            return 0
        }
        return (self.dataDict?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataDict == nil
        {
            return 0
        }
        // #warning Incomplete implementation, return the number of rows
        let key = self.keys![section]
        let list = self.dataDict![key] as? NSArray
        return list!.count
    }

//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let key = self.keys![section]
//        return key
//    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let key = self.keys![section]
        let headView = UIView()
        headView.frame = CGRect(x:0,y:0,width:ScreenWidth,height:20)
        headView.backgroundColor = TSColor.main.themeTBCellBg
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x:10,y:0,width:150,height:20)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = TSColor.main.themeZsColor
        titleLabel.text = key
        headView.addSubview(titleLabel)
        return headView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.frame = CGRect(x:0,y:0,width:ScreenWidth,height:25)
        footerView.backgroundColor = TSColor.main.themeTB
        return footerView
    }
    
    //右侧的索引
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = TSColor.main.themeZsColor
        if self.dataDict == nil
        {
            return [""]
        }
        return self.keys
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NYStarsListCell.identifier, for: indexPath) as! NYStarsListCell
        cell.delegate = self
        let key = self.keys![indexPath.section]
        let list = self.dataDict![key] as? [StarsKeyValue]
        let obj = list![indexPath.row]
        cell.setStarsKeyValue(starsKeyValue: obj)
        return cell
    }
    
    // MARK: - NYStarsListCellDelegate
    func selectCellModel(cell: NYStarsListCell, starsHotModel: StarsHotModel) {
        print("name=\(starsHotModel.name)")
        let channelSelManageVC = NYChannelSelectManageVC()
        channelSelManageVC.title = starsHotModel.name
        self.navigationController?.pushViewController(channelSelManageVC, animated: true)
    }
    
}
