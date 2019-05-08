//
//  TSHomeTabBar.swift
//  Thinksns Plus
//
//  Created by GorCat on 17/1/13.
//  Copyright © 2017年 ZhiYiCX. All rights reserved.
//
//  首页 tabBar

import UIKit
/// 主页子页面标识
///
/// - feed: 动态
/// - discover: 发现
/// - centerBtn: 中心按钮
/// - message: 消息
/// - myCenter: 个人中心
enum HomeChildPage: Int {
    case feed = 0
    case discover
    case centerBtn
    case message
    case myCenter
}

protocol HomeTabBarCenterButtonDelegate: class {
    func tabbarCenterButtonTap(_ tabbar: TSHomeTabBar)
    //选中，代理
    func tabBarSelectItemClick(_ tabbar: TSHomeTabBar,item:NYTabBarItem,index:Int)
}

class TSHomeTabBar: UITabBar {
    let tabBgImageView = UIImageView()
    /// 所有的小红点
    lazy var badgeViews = [UIView]()
    /// 小红点的尺寸
    let badgeSize = CGSize(width: 6, height: 6)
    //数组
    lazy var barItems = [NYTabBarItem]()
    //滑块
    let moveView = UIView()
    //选中的button
    private var selectedItemBtn:UIButton?
    
    /// 代理
    weak var centerButtonDelegate: HomeTabBarCenterButtonDelegate?
    //下标
    var selectedIndex = 0
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews
        {
            if !subview.isKind(of: NYTabBarItem.self) &&
                !subview.isEqual(tabBgImageView) &&
                !subview.isEqual(moveView)
            {
                subview.removeFromSuperview()
            }
        }
 
        self.tabBgImageView.frame =  CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.size.width, height: self.height+20)
        itemWidth = UIScreen.main.bounds.size.width / CGFloat(5)
        
        let barItemWidth = UIScreen.main.bounds.size.width / CGFloat(self.barItems.count)
        let barItemHeight = CGFloat(49.0)
        
        for index in 0..<barItems.count {
            let barItem = barItems[index]
            barItem.frame = CGRect(x: CGFloat(index) * barItemWidth, y: 0, width: barItemWidth, height: barItemHeight)
            NSLog("%@", barItem)
        }

        let badgeLeftDistance = itemWidth / 2 + 4 // UI尺寸
        for index in 0..<badgeViews.count {
            let badge = badgeViews[index]
            badge.frame = CGRect(x: badgeLeftDistance + itemWidth * CGFloat(index), y: 9, width: badgeSize.width, height: badgeSize.height)
            insertSubview(badge, at: self.subviews.count)
        }
        let moveY = barItemHeight - 5
        let moveW = self.barItems[selectedIndex].barItemTitleLabelWidth()
        let moveX = barItemWidth*CGFloat(selectedIndex) + (barItemWidth-moveW)*0.5
        self.moveView.frame = CGRect(x: moveX, y: moveY, width: moveW, height:2)
    }

    // MARK: - Custom user interface
    func initialize() {
        centerButtonDelegate = nil
        setBar()
        setupBadge()
    }

   
    func setBar() {
         // 首页底部导航栏背景颜色
        self.barTintColor = UIColor.clear //InconspicuousColor().tabBar
        self.backgroundColor = UIColor.clear
        self.tabBgImageView.image = UIImage(named: "tab_bg")
        self.tabBgImageView.backgroundColor = UIColor.clear
        self.tabBgImageView.contentMode = .scaleToFill
        self.addSubview(tabBgImageView)
        
        self.moveView.backgroundColor = UIColor.white
        self.insertSubview(self.moveView, at: 10)
    }
    
    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        if barItems.count==0 {
            for (index, value) in items!.enumerated() {
                let item = NYTabBarItem.init(tabBarItem: value as UITabBarItem)
                item.tag = index
                item.addTarget(self, action: #selector(tabBarItemOnClick(_:)), for: .touchUpInside)
                item.frame =  CGRect(x: 10 , y: 0, width: 50, height: 40)
                self.addSubview(item)
                barItems.append(item)
            }
        }
    }

    //点击tabbar
    func tabBarItemOnClick(_ barItem :NYTabBarItem)
    {
        selectedIndex = barItem.tag
        selectedItemBtn?.isSelected = false
        selectedItemBtn = barItem
        selectedItemBtn?.isSelected = true
        let barItemWidth = UIScreen.main.bounds.size.width / CGFloat(self.barItems.count)
        //滑动动画
        let barItem = self.barItems[selectedIndex]
        let moveW = barItem.barItemTitleLabelWidth()
        let moveX = barItemWidth*CGFloat(selectedIndex) + (barItemWidth-moveW)*0.5
        UIView.animate(withDuration: 0.3) {
            self.moveView.mj_x = moveX
            self.moveView.mj_w = moveW
        }
        if self.centerButtonDelegate == nil {
            return
        }
        self.centerButtonDelegate?.tabBarSelectItemClick(self, item: barItem, index: selectedIndex)
    }
    
    func setupBadge() {
        for _ in 0...4 {
            let badge = UIView(frame: CGRect.zero)
            badge.backgroundColor = TSColor.main.warn
            badge.clipsToBounds = true
            badge.layer.cornerRadius = badgeSize.height * 0.5
            badge.isHidden = true
            badgeViews.append(badge)
        }
    }

    // MARK: - Button click
    func centerButtonTaped(_ sender: UIGestureRecognizer) {
        if self.centerButtonDelegate == nil {
            return
        }
        self.centerButtonDelegate?.tabbarCenterButtonTap(self)
    }

    // MARK: - badge show/hidden
    /// 显示小红点
    func showBadge(_ page: HomeChildPage) {
        let index = page.rawValue
        badgeViews[index].isHidden = false
    }

    /// 隐藏小红点
    func hiddenBadge(_ page: HomeChildPage) {
        let index = page.rawValue
        badgeViews[index].isHidden = true
    }
    

}
