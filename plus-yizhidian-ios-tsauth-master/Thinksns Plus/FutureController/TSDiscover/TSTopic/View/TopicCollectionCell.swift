//
//  TopicCollectionCell.swift
//  ThinkSNSPlus
//
//  Created by IMAC on 2018/7/23.
//  Copyright © 2018年 ZhiYiCX. All rights reserved.
//

import UIKit

class TopicCollectionCell: UICollectionViewCell {

    let itemHeit: CGFloat = 55
    static let identifier = "topicCell"
    var titleLabel: UILabel!
    var imageBg: UIImageView!
    var imageShadow: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initUI() {
        backgroundColor = UIColor.clear
        let itemX:CGFloat = (self.width - itemHeit)*0.5
        imageBg = UIImageView(frame: CGRect(x: itemX, y: 15, width:itemHeit, height: itemHeit))
        imageBg.image = UIImage(named: "item_Imgbg")
        imageBg.layer.cornerRadius = itemHeit*0.5
        imageBg.contentMode = UIViewContentMode.scaleAspectFill
        imageBg.clipsToBounds = true
        
        let shaW = itemHeit-5
        imageShadow = UIImageView(frame: CGRect(x: 0, y: 0, width:shaW, height: shaW))
        imageShadow.layer.cornerRadius = shaW*0.5
        imageShadow.layer.masksToBounds = true
        imageShadow.backgroundColor = UIColor.clear
        imageShadow.center = imageBg.center
        
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: imageShadow.frame.maxY+5, width:self.width, height: 18))
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        
        self.addSubview(imageBg)
        self.addSubview(imageShadow)
        self.addSubview(titleLabel)
        
    }
    func setInfo(model: GroupModel, index: IndexPath) {
        titleLabel.text = model.name
        let url = URL(string:TSUtil.praseTSNetFileUrl(netFile: model.avatar)!)
        imageShadow.kf.setImage(with:url, placeholder: #imageLiteral(resourceName: "pic_cover"), options: nil, progressBlock: nil, completionHandler: nil)
    }
//    func setInfo(model: GroupModel, index: IndexPath) {
//        titleLabel.text = model.name
//        let url = URL(string:TSUtil.praseTSNetFileUrl(netFile: model.avatar)!)
//        imageShadow.kf.setImage(with:url, placeholder: #imageLiteral(resourceName: "pic_cover"), options: nil, progressBlock: nil, completionHandler: nil)
//    }
}
