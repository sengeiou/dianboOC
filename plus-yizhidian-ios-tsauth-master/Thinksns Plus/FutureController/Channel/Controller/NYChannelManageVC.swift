//
//  NYChannelManageVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/23.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYChannelManageVC: UIViewController {
    var rightItem:UIButton?
    var channelTagsVC :ChannelTags?
    var _myTags:NSMutableArray?
    var _recommandTags:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "显示_频道管理".localized
        setUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UI
    func setUI() {
        self.view.backgroundColor = TSColor.main.themeTB
        setChatButton()
        
        _myTags = ["关注","推荐","热点","北京","视频","社会","图片","娱乐","问答","科技","汽车"];
        _recommandTags = ["小说","时尚","历史","育儿","直播","搞笑","数码","养生","电影","手机","旅游","宠物","情感","家居","教育","三农"];
        channelTagsVC = ChannelTags.init(myTags: _myTags as! [Any], andRecommandTags: _recommandTags as! [Any])
        channelTagsVC!.bgColor = TSColor.main.themeTB
        channelTagsVC!.view.backgroundColor = TSColor.main.themeTB
        self.view.addSubview((channelTagsVC?.view)!)
    }

    
    // MARK: - 设置编辑（设置右上角按钮）
    func setChatButton() {
        let rightItem = UIButton(type: .custom)
        rightItem.frame = CGRect(x: 0, y: 0, width: 65, height: 40)
        rightItem.contentHorizontalAlignment = .right
        rightItem.set(title: "选择_编辑".localized, titleColor: UIColor.white, for: .normal)
        rightItem.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItem)
        self.rightItem = rightItem
//     self.rightItem?.titleEdgeInsets = UIEdgeInsets(top: 0, left:40, bottom: 0, right: 0)
    }
    
    func rightButtonClick()
    {
        if (channelTagsVC?.onEdit)! {
            self.rightItem?.set(title: "选择_编辑".localized, titleColor: UIColor.white, for: .normal)
        }
        else
        {
            self.rightItem?.set(title: "选择_保存".localized, titleColor: UIColor.white, for: .normal)
        }
        channelTagsVC?.edit(nil)
    }

}
