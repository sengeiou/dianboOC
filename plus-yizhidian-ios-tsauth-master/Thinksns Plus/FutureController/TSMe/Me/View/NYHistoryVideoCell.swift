//
//  NYHistoryVideoCell.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/4.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYHistoryVideoCell: UITableViewCell {
    
    static let identifier = "NYHistoryVideoCell_Item"
    
    static let cellHeight:CGFloat = 85
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var playImageView: UIImageView!
    
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var playLabel: UILabel!
    
    @IBOutlet weak var playTimeLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var layoutSelW: NSLayoutConstraint!
    
    @IBOutlet weak var layoutPayW: NSLayoutConstraint!
    
    @IBOutlet weak var layoutPayImgW: NSLayoutConstraint!
    
    /// 是否编辑
    var isEdit:Bool = false
    
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
        self.iconImageView.layer.cornerRadius = 8
        self.iconImageView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMeHistoryVModel(meHistoryVModel:NYMeHistoryVModel)
    {
        _MeHistoryVModel = meHistoryVModel
        let url = URL(string:meHistoryVModel.video!.cover.imageUrl())
        self.iconImageView.setImageWith(url, placeholder: #imageLiteral(resourceName: "tmp1"))
        self.contentLabel.text = meHistoryVModel.video?.summary
        let time = NYUtils.durationStringWithTime(time: Int(meHistoryVModel.progress))
        self.playTimeLabel.text = "观看至\(time)"
        self.selectBtn.isSelected = meHistoryVModel.select
        if isEdit
        {
            self.selectBtn.isHidden = false
            self.playLabel.isHidden = true
            self.playImageView.isHidden = true
            layoutSelW.constant = 45.0
            layoutPayW.constant = 0
            layoutPayImgW.constant = 0
        }
        else
        {
            self.selectBtn.isHidden = true
            self.playLabel.isHidden = false
            self.playImageView.isHidden = false
            layoutSelW.constant = 15.0
            layoutPayW.constant = 42
            layoutPayImgW.constant = 26
        }
    }
    
    @IBAction func selectCellClickdo(_ sender: UIButton)
    {
        self.selectBtn.isSelected = !self.selectBtn.isSelected
        _MeHistoryVModel?.select = self.selectBtn.isSelected
    }

}
