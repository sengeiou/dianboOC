//
//  NYSelFocusView.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/10.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYSelFocusView: TSTableView {

    enum SectionViewType {
        case none
        case topic(FilterSectionViewModel, FilterSectionViewDelegate)
        /// 有过滤弹窗按钮的 section view
        case filter(FilterSectionViewModel, FilterSectionViewDelegate?)
        /// 没有过滤弹窗,只有数量的section View
        case count(FilterSectionViewModel)
    }
    
    /// 数据源
    var datas: [NYVideosModel] = []
    /// 刷新代理
    weak var refreshDelegate: FeedListViewRefreshDelegate?
    /// 交互代理
    weak var interactDelegate: FeedListViewDelegate?
    /// 滚动代理
    weak var scrollDelegate: FeedListViewScrollowDelegate?
    /// table 区分标识符，当多个 TSQuoraTableView 同时存在同一个界面时区分彼此
    var tableIdentifier = ""
    /// section view 类型
    var sectionViewType = SectionViewType.none
    
    var channel_id:Int = 0
    
    // MARK: - 生命周期
    init(frame: CGRect, tableIdentifier identifier: String,channel_id channel_ID:Int) {
        super.init(frame: frame, style: .plain)
        tableIdentifier = identifier
        channel_id = channel_ID
        setUI()
//        NotificationCenter.default.addObserver(self, selector: #selector(notiResReloadPaiedFeed(noti:)), name: NSNotification.Name.Moment.paidReloadFeedList, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(momentDetailVCDelete(noti:)), name: NSNotification.Name.Moment.momentDetailVCDelete, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var headerViewInsets = UIEdgeInsets.zero {
        didSet {
            shouldManuallyLayoutHeaderViews = headerViewInsets != .zero
            setNeedsLayout()
        }
    }
    var shouldManuallyLayoutHeaderViews = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shouldManuallyLayoutHeaderViews {
            layoutHeaderViews()
        }
    }
    
    func layoutHeaderViews() {
        let numberOfSections = self.numberOfSections
        let contentInset = self.contentInset
        let contentOffset = self.contentOffset
        let sectionViewMinimumOriginY = contentOffset.y + contentInset.top + headerViewInsets.top + TSStatusBarHeight - 20
        
        //    Layout each header view
        for section in 0 ..< numberOfSections {
            guard let sectionView = self.headerView(forSection: section) else {
                continue
            }
            let sectionFrame = rect(forSection: section)
            var sectionViewFrame = sectionView.frame
            
            sectionViewFrame.origin.y = sectionFrame.origin.y < sectionViewMinimumOriginY ? sectionViewMinimumOriginY : sectionFrame.origin.y
            
            if section < numberOfSections - 1 {
                let nextSectionFrame = self.rect(forSection: section + 1)
                if sectionViewFrame.maxY > nextSectionFrame.minY {
                    sectionViewFrame.origin.y = nextSectionFrame.origin.y - sectionViewFrame.size.height
                }
            }
            
            sectionView.frame = sectionViewFrame
        }
    }
    // MARK: - UI
    func setUI() {
        backgroundColor = TSColor.main.themeTB
        separatorStyle = .none
        delegate = self
        dataSource = self
        estimatedRowHeight = 100
        
        if channel_id==3
        {
            register(UINib.init(nibName: "NYSelMXCell", bundle: Bundle.main), forCellReuseIdentifier: tableIdentifier)
        }else
        {
            register(UINib.init(nibName: "NYSelCell", bundle: Bundle.main), forCellReuseIdentifier: tableIdentifier)
        }
        
//        register(NYSelCell.self, forCellReuseIdentifier: tableIdentifier)
//        register(FilterSectionView.self, forHeaderFooterViewReuseIdentifier: FilterSectionView.identifier)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NYSelFocusView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !datas.isEmpty {
            removePlaceholderViews()
        }
        if mj_footer != nil {
            mj_footer.isHidden = true //datas.count < listLimit
        }
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sectionViewType {
        case .none:
            return 0
        case .filter(_), .count(_):
            return 35
        case .topic:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight = NYSelCell.cellHeight // datas[indexPath.row].cellHeight
        if channel_id==3
        {
            cellHeight = NYSelMXCell.cellHeight
        }
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
        if channel_id==3
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! NYSelMXCell
            cell.setVideosModel(video: self.datas[indexPath.row])
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! NYSelCell
            cell.setVideosModel(video: self.datas[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? NYSelCell else {
            return
        }
        interactDelegate?.feedList!(self, didSelected: cell)
        
//        interactDelegate?.feedList(self, didSelected: cell, onSeeAllButton: false)
    }
    
    
}
