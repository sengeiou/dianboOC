//
//  NYPostTableView.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/30.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYPostTableView: NYSelFocusView {

    /// 数据
    var post_datas: [HotTopicFrameModel] = []
    
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
        register(NYHotTopicCell.self, forCellReuseIdentifier: tableIdentifier)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if !post_datas.isEmpty {
            removePlaceholderViews()
        }
        count = post_datas.count
        
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
        let model = self.post_datas[indexPath.row] as! HotTopicFrameModel
        let cellHeight = model.cellHeight!
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.post_datas[indexPath.row] as! HotTopicFrameModel
        let cellHeight = model.cellHeight!
        if cellHeight == 0 {
            return UITableViewAutomaticDimension
        }
        return cellHeight
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! NYHotTopicCell
        cell.setHotTopicFrameModel(hotTopicFrame: self.post_datas[indexPath.row] as! HotTopicFrameModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? NYHotTopicCell else {
            return
        }
        interactDelegate?.postList!(self, didSelected: cell)

    }
    
}

