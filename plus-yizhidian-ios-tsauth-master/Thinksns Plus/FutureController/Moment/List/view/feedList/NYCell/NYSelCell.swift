//
//  NYSelCell.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/10.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYSelCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static let cellHeight:CGFloat = 280.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    

    /// 设置视图
    internal func setUI() {
        self.contentView.backgroundColor = TSColor.main.themeTB
        self.cellContentView.backgroundColor = TSColor.main.themeTBCellBg
        self.cellContentView.layer.cornerRadius = 10
        self.cellContentView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
