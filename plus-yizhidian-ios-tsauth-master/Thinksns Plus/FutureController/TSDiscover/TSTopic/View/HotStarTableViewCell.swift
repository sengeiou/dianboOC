//
//  HotStarTableViewCell.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/19.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit
class HotStarTableViewCell: UITableViewCell
{
    var userImage: UIButton!
    var userName: UILabel!
    var userTime: UILabel!
    var txtfrom: UILabel!
    var contentLabel: UILabel!
    var alldoButton: UIButton!
    
    //通过模式 动态创建
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initUI() {
    
    }
    
    func setInfo(model: TopicListModel, keyword: String?) {
    
    }
}
