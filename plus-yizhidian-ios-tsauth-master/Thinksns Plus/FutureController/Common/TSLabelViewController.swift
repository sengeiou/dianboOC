//
//  TSLabelViewController.swift
//  Thinksns Plus
//
//  Created by GorCat on 17/2/14.
//  Copyright © 2017年 LeonFa. All rights reserved.
//
//  分页视图控制器
//  超类
//  点击导航栏标签可切换下方 view 的视图控制器
//  例如：粉丝关注列表

import UIKit

let topContentHeight = 115

fileprivate struct SizeDesign {
    let badgeSize: CGSize = CGSize(width: 6, height: 6)
}

class TSLabelViewController: TSViewController, UIScrollViewDelegate {

    ///整个 top view
    let topContentView = UIView()
    ///背景
    let topContentBgImageView = UIImageView()
    /// 滚动视图
    var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height)))
    /// 标签视图
    let labelView = UIView()
    /// 标签滚动视图
    let label_scrollView = UIScrollView()
    /// 标签下方的蓝线
    let blueLine = UIView()
    /// 提示用的小红点
    var badges: [UIView] = []
    /// 蓝线的 leading
    var blueLineLeading: CGFloat = 0
    ///logo 标按钮
    let logoButton = UIButton(type: .custom)
    ///右边菜单
    let right_munButton = UIButton(type: .custom)
    /// 标签标题数组
    var titleArray: [String]? = nil

    /// 按钮基础 tag 值
    let tagBasicForButton = 200
    
    //------ search
    let searchALLView = UIView()
    let searchA = UIView()
    let searchA_bg = UIImageView()
    //搜索框
    let sa_Field = UIButton()
    let sa_ImageL = UIImageView()
    //搜索按钮
    let sa_searchBtn = UIButton()
    
    let searchB = UIView()
    let searchB_bg = UIImageView()
    //喜剧
    let tag_ABtn = UIButton()
    //标签二
    let tag_BBtn = UIButton()
    //明星
    let tag_mxBtn = UIButton()
    //全部
    let tag_ALLBtn = UIButton()
    //------- search end

    // MARK: - Lifecycle

    /// 自定义初始化方法
    ///
    /// - Parameter labelTitleArray: 导航栏上标签的 title 的数组
    init(labelTitleArray: [String], scrollViewFrame: CGRect?, isChat: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        if isChat {
            let frame = scrollViewFrame ?? CGRect(x: 0, y: topContentHeight, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height) - topContentHeight)
            self.scrollView = ChatScrollView(frame: frame)
        }

        if let scrollViewFrame = scrollViewFrame {
            scrollView.frame = scrollViewFrame
        }
        
        titleArray = labelTitleArray
        for _ in labelTitleArray {
            let badge = UIView()
            badge.backgroundColor = TSColor.main.warn
            badge.clipsToBounds = true
            badge.layer.cornerRadius = SizeDesign().badgeSize.height * 0.5
            badge.isHidden = true
            badges.append(badge)
        }

        setSuperUX()
        setSearchUX()
    }
    
    /// 更新 title label
    func updateTitleArray(labelTitleArray: [String])
    {
        titleArray = labelTitleArray
        badges.removeAll()
        for _ in labelTitleArray {
            let badge = UIView()
            badge.backgroundColor = TSColor.main.warn
            badge.clipsToBounds = true
            badge.layer.cornerRadius = SizeDesign().badgeSize.height * 0.5
            badge.isHidden = true
            badges.append(badge)
        }
        let labelButtonWidth:CGFloat = 65.0
        
        //30 + (titleArray[0].sizeOfString(usingFont: UIFont.systemFont(ofSize: TSFont.Title.headline.rawValue))).width // 单边间距，参见 TS 设计文档第二版第 7 页
        let buttonTitleSize = titleArray![0].sizeOfString(usingFont: UIFont.systemFont(ofSize: TSFont.Title.headline.rawValue))
        let labelHeight: CGFloat = 44
        
        //重新 计算labelView
        self.labelView.subviews.forEach({ $0.removeFromSuperview()});
        // labelView button
        var buttonCX:CGFloat = 0.0
        for (index, title) in titleArray!.enumerated() {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: CGFloat(index) * labelButtonWidth, y: CGFloat(0), width: labelButtonWidth, height: labelHeight)
            button.titleLabel?.font = UIFont.systemFont(ofSize: TSFont.Title.pulse.rawValue)
            button.setTitle(title, for: .normal)
            button.setTitleColor( index == 0 ? UIColor.white : UIColor(hex:0xffffff,alpha:0.5), for: .normal)
            button.addTarget(self, action: #selector(buttonTaped(sender:)), for: .touchUpInside)
            button.tag = tagBasicForButton + index
            
            let badge = badges[index]
            let badgeX = CGFloat(index) * labelView.frame.width / CGFloat(titleArray!.count) + labelButtonWidth - 13
            badge.frame = CGRect(x: badgeX, y: 10, width: SizeDesign().badgeSize.width, height: SizeDesign().badgeSize.height)
            button.addSubview(badge)
            if index==0 {
                buttonCX = button.centerX;
            }
            labelView.addSubview(button)
        }
        // blue line
        let blueLineHeight: CGFloat = 2.0
        blueLineLeading = (labelButtonWidth - buttonTitleSize.width) / 2 - 7
        blueLine.frame = CGRect(x: blueLineLeading, y: labelHeight - blueLineHeight-6, width: buttonTitleSize.width-8, height: blueLineHeight)
        blueLine.centerX = buttonCX
        blueLine.backgroundColor = UIColor.white
        labelView.addSubview(blueLine)
        // labelView
        labelView.mj_w = labelButtonWidth * CGFloat(titleArray!.count)
        label_scrollView.contentSize = labelView.size
        
        // scrollView contentSize
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(titleArray!.count), height: scrollView.frame.size.height)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStatuBar), name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: nil)
    }

    func changeStatuBar() {
        if UIApplication.shared.statusBarFrame.size.height == 20 {
            scrollView.frame = CGRect(x: 0, y: topContentHeight, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height) - topContentHeight)
        }
    }

    // MARK: - Custom user interface

    /// 视图设置
    func setSuperUX() {
        self.automaticallyAdjustsScrollViewInsets = false
        if let titleArray = titleArray {
            if titleArray.isEmpty {
                return
            }
            //设置 top content view
            topContentView.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width) , height: topContentHeight)
            self.view.addSubview(topContentView)
            
            //topContentBgImageView
            let topY:CGFloat = 20.0
            topContentBgImageView.image = UIImage(named: "nav_home")
            topContentBgImageView.frame = topContentView.frame
            topContentView.addSubview(topContentBgImageView)
            
            //左边
            logoButton.setImage(UIImage(named: "nav_logo"), for: .normal)
            logoButton.contentEdgeInsets = UIEdgeInsetsMake(12, 10, 12, 10)
            logoButton.frame =  CGRect(x: 0, y: topY, width: 44, height: 44)
            topContentView.addSubview(logoButton)
            
            //右边菜单
            right_munButton.setImage(UIImage(named: "nav_mun"), for: .normal)
            right_munButton.contentEdgeInsets = UIEdgeInsetsMake(14, 14, 14, 14)
            right_munButton.frame =  CGRect(x: topContentView.width - CGFloat(44), y: topY, width: CGFloat(44), height: CGFloat(44))
            right_munButton.addTarget(self, action: #selector(rightMunClickdo(_:)), for: .touchUpInside)
            right_munButton.isHidden = true
            topContentView.addSubview(right_munButton)
        
            // label 滚动视图
            let labelHeight: CGFloat = 44
            let label_scrollW = right_munButton.frame.minX - logoButton.frame.maxX
            label_scrollView.frame = CGRect(x: logoButton.width, y:topY, width:label_scrollW, height: labelHeight)
            label_scrollView.backgroundColor = UIColor.clear
            label_scrollView.isPagingEnabled = true
            label_scrollView.showsVerticalScrollIndicator = false
            label_scrollView.showsHorizontalScrollIndicator = false
            label_scrollView.bounces = false
            topContentView.addSubview(label_scrollView)
            
            let labelButtonWidth:CGFloat = 65.0 //(topContentView.width - 88)/CGFloat(titleArray.count);
                
                //30 + (titleArray[0].sizeOfString(usingFont: UIFont.systemFont(ofSize: TSFont.Title.headline.rawValue))).width // 单边间距，参见 TS 设计文档第二版第 7 页
            let buttonTitleSize = titleArray[0].sizeOfString(usingFont: UIFont.systemFont(ofSize: TSFont.Title.headline.rawValue))
        
            // labelView button
            var buttonCX:CGFloat = 0.0
            for (index, title) in titleArray.enumerated() {
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: CGFloat(index) * labelButtonWidth, y: CGFloat(0), width: labelButtonWidth, height: labelHeight)
                button.titleLabel?.font = UIFont.systemFont(ofSize: TSFont.Title.pulse.rawValue)
                button.setTitle(title, for: .normal)
                button.setTitleColor( index == 0 ? UIColor.white : UIColor(hex:0xffffff,alpha:0.5), for: .normal)
                button.addTarget(self, action: #selector(buttonTaped(sender:)), for: .touchUpInside)
                button.tag = tagBasicForButton + index

                let badge = badges[index]
                let badgeX = CGFloat(index) * labelView.frame.width / CGFloat(titleArray.count) + labelButtonWidth - 13
                badge.frame = CGRect(x: badgeX, y: 10, width: SizeDesign().badgeSize.width, height: SizeDesign().badgeSize.height)
                button.addSubview(badge)
                if index==0 {
                    buttonCX = button.centerX;
                }
                labelView.addSubview(button)
            }
            
            // blue line
            let blueLineHeight: CGFloat = 2.0
            blueLineLeading = (labelButtonWidth - buttonTitleSize.width) / 2 - 7
            blueLine.frame = CGRect(x: blueLineLeading, y: labelHeight - blueLineHeight-6, width: buttonTitleSize.width-8, height: blueLineHeight)
            blueLine.centerX = buttonCX
                blueLine.backgroundColor = UIColor.white
            labelView.addSubview(blueLine)
            
            // labelView
            labelView.frame = CGRect(x: 0, y:0, width: labelButtonWidth * CGFloat(titleArray.count), height: labelHeight)
            label_scrollView.contentSize = labelView.size
            label_scrollView.addSubview(labelView)

            // scrollView
            
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(titleArray.count), height: scrollView.frame.size.height)
            scrollView.backgroundColor = UIColor.white
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.bounces = false
            scrollView.delegate = self
            view.addSubview(scrollView)
        }
    }
    //第二行 search
    func setSearchUX() {
        let spacing:CGFloat = 10.0
        let sallY:CGFloat = labelView.frame.maxY
        searchALLView.frame = CGRect(x: 0, y:sallY, width: topContentView.width, height: topContentView.height - sallY)
        searchALLView.backgroundColor = UIColor.clear
        topContentView.addSubview(searchALLView)
        
        let searchH:CGFloat = 30.0
        let searchW:CGFloat = (topContentView.width - CGFloat(spacing*3))*0.5
        let searchY:CGFloat = (searchALLView.height - searchH)*0.5
        searchA.frame = CGRect(x: spacing, y:searchY, width:searchW, height:searchH)
        searchALLView.addSubview(searchA)
        
        searchA_bg.frame = searchA.bounds
        searchA_bg.image = UIImage(named: "nav_search_bg")
        searchA.addSubview(searchA_bg)
      
        //搜索按钮
        sa_searchBtn.frame = CGRect(x:searchA.width-searchH, y:0, width:searchH, height:searchH)
        sa_searchBtn.setImage(UIImage(named: "nav_search"), for: .normal)
        sa_searchBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
        sa_searchBtn.addTarget(self, action: #selector(searchClickdo(_:)), for: .touchUpInside)
        searchA.addSubview(sa_searchBtn)
        
        sa_ImageL.frame = CGRect(x: sa_searchBtn.x - 4, y:8, width:2, height:searchH-16)
        sa_ImageL.image = UIImage(named: "nav_search_l")
        searchA.addSubview(sa_ImageL)

        //搜索框
        sa_Field.frame = CGRect(x: 0, y:0, width:sa_ImageL.x, height:searchH)
        sa_Field.setTitle("精选_推荐搜索".localized, for: .normal)
        sa_Field.setTitleColor(UIColor.white, for: .normal)
        sa_Field.titleLabel?.font = UIFont.systemFont(ofSize: TSFont.SubInfo.footnote.rawValue)
        sa_Field.addTarget(self, action: #selector(searchClickdo(_:)), for: .touchUpInside)
        searchA.addSubview(sa_Field)
        
        ////BBBB
        searchB.frame = CGRect(x: searchA.frame.maxX+spacing , y:searchY, width:searchW, height:searchH)
        searchALLView.addSubview(searchB)
        
        searchB_bg.frame = searchA.bounds
        searchB_bg.image = UIImage(named: "nav_search_bg")
        searchB.addSubview(searchB_bg)
        
        let tagW:CGFloat = searchB.width / CGFloat(3)
        //喜剧
        tag_ABtn.frame = CGRect(x: 0, y:0, width:tagW, height:searchH)
        tag_ABtn.tag = 1
        tag_ABtn.setTitle("精选", for: .normal)
        tag_ABtn.setTitleColor(UIColor.white, for: .normal)
        tag_ABtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        tag_ABtn.addTarget(self, action: #selector(sortClickdo(_:)), for: .touchUpInside)
        searchB.addSubview(tag_ABtn)
        //标签二
        tag_BBtn.frame = CGRect(x: tagW, y:0, width:tagW, height:searchH)
        tag_BBtn.tag = 2
        tag_BBtn.setTitle("短视频".localized, for: .normal)
        tag_BBtn.setTitleColor(UIColor.white, for: .normal)
        tag_BBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        tag_BBtn.addTarget(self, action: #selector(sortClickdo(_:)), for: .touchUpInside)
        searchB.addSubview(tag_BBtn)
        
        //明星
        tag_mxBtn.frame = CGRect(x: 20, y:0, width:tag_BBtn.frame.maxX-20, height:searchH)
        tag_mxBtn.isHidden = true
        tag_mxBtn.tag = 30
        tag_mxBtn.contentHorizontalAlignment = .left
        tag_mxBtn.setTitle("赵丽颖", for: .normal)
        tag_mxBtn.setTitleColor(UIColor.white, for: .normal)
        tag_mxBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        tag_mxBtn.addTarget(self, action: #selector(sortClickdo(_:)), for: .touchUpInside)
        searchB.addSubview(tag_mxBtn)
        
        //全部
        tag_ALLBtn.frame = CGRect(x: tagW*2, y:0, width:tagW, height:searchH)
        tag_ALLBtn.tag = 0
        tag_ALLBtn.setImage(UIImage(named: "nav_loc"), for: .normal)
//        tag_ALLBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        tag_ALLBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
//        tag_ALLBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        tag_ALLBtn.contentHorizontalAlignment = .left
        tag_ALLBtn.setTitle("精选_全部".localized, for: .normal)
        tag_ALLBtn.setTitleColor(UIColor.white, for: .normal)
        tag_ALLBtn.titleLabel?.font = UIFont.systemFont(ofSize:12)
        tag_ALLBtn.addTarget(self, action: #selector(sortClickdo(_:)), for: .touchUpInside)
        searchB.addSubview(tag_ALLBtn)
    }
    // MARK: - Button click
    func buttonTaped(sender: UIButton) {
        let index = sender.tag - tagBasicForButton
//        updateLabelScrollView(sender:sender)
        scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.size.width * CGFloat(index), y: 0), animated: true)
    }
    
    func updateLabelScrollView(sender: UIButton) {
        let shouldX = sender.frame.origin.x - self.label_scrollView.frame.size.width / 2.0 + sender.frame.size.width / 2.0;
        // 右侧的补偿x，offsetRight意味着 scrollview右侧被隐藏部分的宽度。
        let offsetRight = (+self.label_scrollView.contentSize.width) - self.label_scrollView.frame.size.width - shouldX;
        var shouldPoint = CGPoint(x: 0, y: 0)
        
        if (shouldX > 0) && (offsetRight>0) {
            shouldPoint = CGPoint(x:shouldX,y:CGFloat(0))
        }else {
            if shouldX <= 0 {
                shouldPoint = CGPoint(x:0, y:0)
            }else {
                if offsetRight <= 0 {
                    shouldPoint = CGPoint(x:self.label_scrollView.contentSize.width - self.label_scrollView.frame.size.width, y:0)
                }
            }
        }
        label_scrollView.setContentOffset(shouldPoint, animated:true)
    }

    // MARK: - Public

    /// 添加子视图
    public func add(childView: UIView, at index: Int) {
        let width = self.scrollView.frame.width
        let height = self.scrollView.frame.height
        childView.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
        self.scrollView.addSubview(childView)
    }

    /// 添加子视图控制器的方法
    ///
    /// - Parameters:
    ///   - childViewController: 子视图控制器
    ///   - index: 索引下标，从 0 开始，请与 labelTitleArray 中的下标一一对应
    public func add(childViewController: Any, At index: Int) {
        let width = self.scrollView.frame.width
        let height = self.scrollView.frame.height
        if let childVC = childViewController as? UIViewController {
            self.addChildViewController(childVC)
            childVC.view.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
            self.scrollView.addSubview(childVC.view)
        }
    }


    /// 切换选中的分页
    ///
    /// - Parameter index: 分页下标
    public func setSelectedAt(_ index: Int) {
        update(childViewsAt: index)
    }
    
    /// 搜索
    ///
    ///
    func searchClickdo(_ btn: UIButton) {
        
    }
    
    /// 分类
    ///
    ///
    func sortClickdo(_ btn: UIButton) {
        
    }
    
    ///  右边菜单
    ///
    /// - Parameter btn:
    func rightMunClickdo(_ btn: UIButton) {
        
    }
    /// 切换了选中的页面
    func selectedPageChangedTo(index: Int) {
        /// [长期注释] 这个方法有子类实现，来获取页面切换的回调
    }

    // MARK: - Private

    /// 更新 scrollow 的偏移位置
    private func update(childViewsAt index: Int) {
        let width = self.scrollView.frame.width
        // scroll view
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * width, y: 0), animated: true)
        updateButton(index)
    }

    var oldIndex = 0
    /// 刷新按钮
    private func updateButton(_ index: Int) {
        if oldIndex == index {
            return
        }
        selectedPageChangedTo(index: index)
        let oldButton = (labelView.viewWithTag(tagBasicForButton + oldIndex) as? UIButton)!
        oldButton.setTitleColor(UIColor(hex:0xffffff,alpha:0.5), for: .normal)
        oldIndex = index
        let button = (labelView.viewWithTag(tagBasicForButton + index) as? UIButton)!
        button.setTitleColor(UIColor.white, for: .normal)
    }

    // MARK: - Delegate

    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index = scrollView.contentOffset.x / scrollView.frame.width
        if index < 0 {
            index = CGFloat(0)
        }
        if Int(index) > titleArray!.count {
            index = CGFloat(titleArray!.count)
        }
        let i = round(index)
        updateButton(Int(i))
        let btn:UIButton = labelView.viewWithTag(tagBasicForButton + Int(i)) as! UIButton
        
        blueLine.centerX = btn.centerX
       
//        frame = CGRect(x: CGFloat(index) * labelView.frame.width / CGFloat(titleArray!.count) + blueLineLeading, y: blueLine.frame.origin.y, width: blueLine.frame.width, height: blueLine.frame.height)
        
         TSKeyboardToolbar.share.keyboarddisappear()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var index = scrollView.contentOffset.x / scrollView.frame.width
        if index < 0 {
            index = CGFloat(0)
        }
        if Int(index) > titleArray!.count {
            index = CGFloat(titleArray!.count)
        }
        let btn:UIButton = labelView.viewWithTag(tagBasicForButton + Int(index)) as! UIButton
        updateLabelScrollView(sender: btn)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDragging(scrollView,willDecelerate: true)
    }
    
}
