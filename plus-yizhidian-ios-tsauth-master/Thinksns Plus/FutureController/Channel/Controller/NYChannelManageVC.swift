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
        
        let  _myTags = ["关注","推荐","热点","北京","视频","社会","图片","娱乐","问答","科技","汽车","财经","军事","体育","段子","国际","趣图","健康","特卖","房产","美食"];
        let  _recommandTags = ["小说","时尚","历史","育儿","直播","搞笑","数码","养生","电影","手机","旅游","宠物","情感","家居","教育","三农"];
        channelTagsVC = ChannelTags.init(myTags: _myTags, andRecommandTags: _recommandTags)
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
    
    func rightButtonClick() {
        
    }

}
