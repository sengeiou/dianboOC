//
//  NYChannelCollectionViewCell.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/3.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

protocol NYChannelCollectionViewCellDelegate: class {
    /// 选中
    func selectCellModel(cell:NYChannelCollectionViewCell,tagModel:NYtagModel)
}

class NYChannelCollectionViewCell: UICollectionViewCell {
    let itemHeit: CGFloat = 30
    static let identifier = "channelColl"
    var itemButton:UIButton!
    
    var tagModel:NYtagModel?
    
    weak var delegate: NYChannelCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        backgroundColor = UIColor.clear
        let itemWidth:CGFloat = self.width - CGFloat(10)
        let itemX:CGFloat = (self.width - itemWidth)*0.5
        let itemY:CGFloat = (self.height - itemHeit)*0.5
        itemButton = UIButton(type: .custom)
        itemButton.frame = CGRect(x: itemX, y: itemY, width:itemWidth, height: itemHeit)
        itemButton.setTitle("年份", for: .normal)
        itemButton.setTitleColor(UIColor.white, for: .normal)
        itemButton.setTitleColor(TSColor.main.themeZsColor, for: .selected)
        itemButton.setBackgroundImage(UIImage(named: "com_bg"), for: .selected)
        itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        itemButton.addTarget(self, action: #selector(selItemClickdo(_:)), for: .touchUpInside)
        self.addSubview(itemButton)
    }
    
    func selItemClickdo(_ btn:UIButton)
    {
        self.delegate?.selectCellModel(cell: self, tagModel: tagModel!)
    }
    
    /// tag
    func setTagModel(tag:NYtagModel,from:NYtagModel)
    {
        tagModel = tag
        self.itemButton.isSelected = ((tag.id==from.id)&&tag.name.isEqual(from.name))
        
        itemButton.setTitle(tag.name, for: .normal)
    }
    
}
