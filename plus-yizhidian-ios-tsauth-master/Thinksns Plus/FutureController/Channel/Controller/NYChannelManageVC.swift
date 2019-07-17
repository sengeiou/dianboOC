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
        NYPopularNetworkManager.getChannelsListData { (default_list, user_list, other_list, error, Boolisobl) in
            self._myTags = NSMutableArray()
            self._recommandTags = NSMutableArray()
            if let u_arr = user_list {
                for obj in u_arr
                {
                    let dict = ["id":obj.id, "name":obj.name, "blog":"sunfusheng.com"] as [String : Any]
                    self._myTags?.add(dict)
                }
            }
            if let o_arr = other_list {
                for obj in o_arr
                {
                    let dict = ["id":obj.id, "name":obj.name, "blog":"sunfusheng.com"] as [String : Any]
                    self._recommandTags?.add(dict)
                }
            }
            self.channelTagsVC = ChannelTags.init(myTags: self._myTags as! [Any], andRecommandTags: self._recommandTags as! [Any])
            self.channelTagsVC!.bgColor = TSColor.main.themeTB
            self.channelTagsVC!.view.backgroundColor = TSColor.main.themeTB
            self.channelTagsVC!.addTag = {(obj:Any) -> () in
                let tObj = obj as! Channel
                NYPopularNetworkManager.upDelChannel(channel_id: tObj.id, act: "add", complete: { (msg, isobl) in
                    NSLog("\(msg)")
                })
            }
            self.channelTagsVC!.delTag = {(obj:Any) -> () in
                let tObj = obj as! Channel
                NYPopularNetworkManager.upDelChannel(channel_id: tObj.id, act: "del", complete: { (msg, isobl) in
                    NSLog("\(msg)")
                })
            }
            
            self.view.addSubview((self.channelTagsVC?.view)!)
        }
        
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
