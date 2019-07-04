//
//  NYViewHisCollectionCell.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/3.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYViewHisCollectionCell: UICollectionViewCell {
    
    static let identifier = "NYViewHisCollectionCell_Item"
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var _MeHistoryVModel:NYMeHistoryVModel?
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    
    func setUI()
    {
        
        self.backgroundColor = TSColor.main.themeTBCellBg
        self.backgroundView?.backgroundColor = TSColor.main.themeTBCellBg
        self.iconImageView.layer.cornerRadius = 10
        self.iconImageView.layer.masksToBounds = true
    }
    
    func setMeHistoryVModel(meHistoryVModel:NYMeHistoryVModel)
    {
        _MeHistoryVModel = meHistoryVModel
        let url = URL(string:meHistoryVModel.video!.cover.imageUrl())
        self.iconImageView.setImageWith(url, placeholder: #imageLiteral(resourceName: "tmp1"))
        self.titleLabel.text = meHistoryVModel.video!.name
        self.timeLabel.text = NYUtils.durationStringWithTime(time: meHistoryVModel.video!.duration)
    }
    
}
