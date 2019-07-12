//
//  NYGroupTableView.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/29.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYGroupTableView: NYSelFocusView {

    /// 数据
    var group_datas: [GroupListCellModel] = []
    override var after: Int? {
            guard let id = group_datas.last?.id else {
                return nil
            }
            return id
    }
    init(frame: CGRect, tableIdentifier identifier: String) {
        super.init(frame: frame, tableIdentifier: identifier, channel_id: 0)
        tableIdentifier = identifier
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI()
    {
        backgroundColor = TSColor.main.themeTB
        separatorStyle = .none
        delegate = self
        dataSource = self
        estimatedRowHeight = 100
        register(GroupListCell.self, forCellReuseIdentifier: GroupListCell.identifier)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0

        if !group_datas.isEmpty {
            removePlaceholderViews()
        }
        count = group_datas.count
        
        if mj_footer != nil {
            mj_footer.isHidden = true //datas.count < listLimit
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sectionViewType {
        case .none:
            return 0
        case .filter(_), .count(_):
            return 35
        case .topic:
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight:CGFloat = 120
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = CGFloat(20) // datas[indexPath.row].cellHeight
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupListCell.identifier, for: indexPath) as! GroupListCell
        cell.delegate = self
        let model = group_datas[indexPath.row]
        cell.model = model
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? GroupListCell else {
            return
        }
        interactDelegate?.groupList!(self, didSelected: cell)
        
        //        interactDelegate?.feedList(self, didSelected: cell, onSeeAllButton: false)
    }
    
}

// MARK: - cell 代理事件
extension NYGroupTableView: GroupListCellDelegate {
    
    /// 点击了加入按钮
    func groupListCellDidSelectedJoinButton(_ cell: GroupListCell) {
        // 如果是游客模式，触发登录注册操作
        if TSCurrentUserInfo.share.isLogin == false {
            TSRootViewController.share.guestJoinLoginVC()
            return
        }
        
        let groupIndexPath = indexPath(for: cell)!
        let cellModel = group_datas[groupIndexPath.row]
        let groupId = cellModel.id
        
        // 1.如果是加入圈子，先判断是否是付费圈子，如果是，显示付费弹窗
        let mode = cellModel.mode
        if mode == "paid" {
            PaidManager.showPaidGroupAlert(price: Double(cellModel.joinMoney), groupId: groupId, groupMode: mode) {
                // 付费的圈子有审核时间，所以不需要立刻通知列表刷新界面
            }
            return
        }
        
        // 2.如果不是付费圈子，直接发起加入申请
        let alert = TSIndicatorWindowTop(state: .loading, title: "正在加入圈子")
        alert.show()
        cell.joinButton.isEnabled = false
        GroupNetworkManager.joinGroup(groupId: groupId, complete: { [weak self] (isSuccess, message) in
            alert.dismiss()
            cell.joinButton.isEnabled = true
            guard let weakself = self else {
                return
            }
            // 成功加入
            if isSuccess {
                let successAlert = TSIndicatorWindowTop(state: .success, title: message)
                successAlert.show(timeInterval: TSIndicatorWindowTop.defaultShowTimeInterval)
                // 非公开的圈子，需要审核时间，所以不能马上改变加入状态
                if cellModel.mode == "public" {
                    weakself.group_datas[groupIndexPath.row].role = .member
                    weakself.group_datas[groupIndexPath.row].joined = GroupJoinModel(JSONString: "{\"audit\":1}")
                    weakself.reloadData()
                    NotificationCenter.default.post(name: NSNotification.Name.Group.joined, object: nil, userInfo: ["isJoin": true, "groupInfo": weakself.group_datas[groupIndexPath.row]])
                }
            } else {
                // 加入失败
                let faildAlert = TSIndicatorWindowTop(state: .faild, title: message ?? "加入失败")
                faildAlert.show(timeInterval: TSIndicatorWindowTop.defaultShowTimeInterval)
            }
        })
    }
}
