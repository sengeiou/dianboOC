//
//  NYVideoColl.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/22.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYVideoColl: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "NYVideoColl_Item"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }

    func setUI()
    {
        self.backgroundColor = TSColor.main.themeTBCellBg
        self.backgroundView?.backgroundColor = TSColor.main.themeTBCellBg
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func setVideosModel(video:NYVideosModel)
    {
        let url = URL(string:video.cover.imageUrl())
        self.imageView.setImageWith(url, placeholder: #imageLiteral(resourceName: "tmp1"))
        self.titleLabel.text = video.name
    }
}
