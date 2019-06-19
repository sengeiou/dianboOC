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
    
    @IBOutlet weak var tagsView: UIView!
    
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
    
    func setVideosModel(video:NYVideosModel) -> Void {
        titleLabel.text = video.name
        let url = URL(string:video.cover.imageUrl())
        contentImageView.kf.setImage(with:url, placeholder: #imageLiteral(resourceName: "tmp1"), options: nil, progressBlock: nil, completionHandler: nil)
        self.tagsView.subviews.forEach({ $0.removeFromSuperview()});
        if (video.tags?.count)!>0
        {
            
            let itemW:CGFloat = 65
            let itemH:CGFloat = 26
            let itemY:CGFloat = (self.tagsView.height-itemH)*0.5
            let margin:CGFloat = (ScreenWidth-16-itemW*5)/6
            
            for (index,item) in (video.tags?.enumerated())!
            {
                let itemX:CGFloat = margin*CGFloat(index+1)+itemW*CGFloat(index)
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: itemX,y:itemY, width: itemW, height: itemH)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                button.setTitle(item.name, for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.setBackgroundImage(UIImage(named: "com_bg"), for: .normal)
                self.tagsView.addSubview(button)
            }
        }
    }
    
}
