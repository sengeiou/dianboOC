//
//  TSMomentDetailToolbar.swift
//  Thinksns Plus
//
//  Created by GorCat on 17/3/15.
//  Copyright © 2017年 ZhiYiCX. All rights reserved.
//
//  动态详情 工具栏

import UIKit

@objc protocol TSMomentDetailToolbarDelegate: class {
    func toolbar(_ toolbar: TSMomentDetailToolbar, DidSelectedItemAt index: Int)
    
    @objc optional func inputToolbar(toolbar: TSMomentDetailToolbar)
}
class TSMomentDetailToolbar: TSToolbarView, TSToolbarViewDelegate {

    /// 动态数据
    let object: TSMomentListObject

    let bg_imageView = UIImageView()
    /// 代理
    weak var commentDelegate: TSMomentDetailToolbarDelegate?

    // MARK: - Lifecycle
    init(_ object: TSMomentListObject) {
        self.object = object

        var yPoint = UIScreen.main.bounds.height - 55 - TSBottomSafeAreaHeight
        if UIApplication.shared.statusBarFrame.size.height != TSStatusBarHeight {
            yPoint -= TSStatusBarHeight
        }
        
    super.init(frame: CGRect(x: 0, y: yPoint, width: UIScreen.main.bounds.width, height: 55 + TSBottomSafeAreaHeight), type: .top, items: [TSToolbarItemModel(image: "com_collection", title: "收藏", index: 0), TSToolbarItemModel(image: "com_download", title: "下载", index: 1), TSToolbarItemModel(image: "com_share", title: "分享", index: 2)])
       
        if object.isCollect==1
        {
            setImage("me_collect", At: 0)
            setTitleColor(TSColor.main.themeZsColor, At: 0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        object = TSMomentListObject()
        super.init(coder: aDecoder)
    }

    // MAKR: - Custom user interface
    override func setUI() {
        super.setUI()
        self.backgroundColor = UIColor.clear
        bg_imageView.frame = self.bounds
        bg_imageView.image = UIImage(named: "com_tools_bg")
        self.insertSubview(bg_imageView, at: 0)
        
        delegate = self
        // tool
        updateToolBar()
    }

    // MARK: - Public

    /// 更新工具栏的内容
    func updateToolBar() {
        
    }

    /// 滑动效果动画
    func scrollowAnimation(_ offset: CGFloat) {
        let topY = UIScreen.main.bounds.height - 55 - TSBottomSafeAreaHeight
        let bottomY = UIScreen.main.bounds.height + 1
        let isAtTop = frame.minY == topY
        let isAtBottom = frame.minY == bottomY
        let isScrollowUp = offset > 0
        let isScrollowDown = offset < 0

        if (isAtTop && isScrollowDown) || (isAtBottom && isScrollowUp) {
            return
        }

        var frameY = frame.minY + offset
        if isScrollowDown && frameY < topY { // 上滑
            frameY = topY
            if UIApplication.shared.statusBarFrame.size.height != TSStatusBarHeight {
                frameY -= TSStatusBarHeight
            }
        }
        if isScrollowUp && frameY > bottomY {
            frameY = bottomY
        }

        frame = CGRect(x: 0, y: frameY, width: frame.width, height: frame.height)
    }

    // MARK: - Delegate

//    /// [长期注释] 由于后台的原因，要求按钮的点击间隔长达 1s
//    var canDigg = true

    // MARK: TSMomentDetailNavViewDelegate
    /// 点击了工具栏
    func toolbar(_ toolbar: TSToolbarView, DidSelectedItemAt index: Int) {
        
        
        if let commentDelegate = commentDelegate {
            commentDelegate.toolbar(self, DidSelectedItemAt: index)
        }
    }
    func inputToolbar(_ toolbar: TSToolbarView) {
        if let commentDelegate = commentDelegate {
            commentDelegate.inputToolbar!(toolbar: self)
        }
    }
}
