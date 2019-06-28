//
//  NYStarsListCell.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/26.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

protocol NYStarsListCellDelegate: class {
    /// 选中
    func selectCellModel(cell:NYStarsListCell,starsHotModel:StarsHotModel)
}

class NYStarsListCell: UITableViewCell {

//    @IBOutlet weak var tagsView: UIView!
    
    var _starsKeyValue:StarsKeyValue?
    /// 刷新代理
    weak var delegate: NYStarsListCellDelegate?
    static let cellHeight:CGFloat = 95

    static let identifier = "NYStarsListCell_Item"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    
    func setUI()
    {
        self.backgroundColor = TSColor.main.themeTBCellBg
        self.backgroundView?.backgroundColor = TSColor.main.themeTBCellBg
        self.contentView.backgroundColor = TSColor.main.themeTBCellBg
        
    }
    
    func setStarsKeyValue(starsKeyValue:StarsKeyValue)
    {
        self.backgroundColor = TSColor.main.themeTBCellBg
        self.backgroundView?.backgroundColor = TSColor.main.themeTBCellBg
        self.contentView.backgroundColor = TSColor.main.themeTBCellBg
        _starsKeyValue = starsKeyValue
        self.contentView.subviews.forEach({ $0.removeFromSuperview()});
        
        if ((starsKeyValue.valueList) != nil)
        {
            var index:Int = 0
            let btnW:CGFloat = 60
            let btnH:CGFloat = 80
            let btnY:CGFloat = (NYStarsListCell.cellHeight-btnH)*0.5
            let marg:CGFloat = (ScreenWidth-20-btnW*4)/5
            for obj in starsKeyValue.valueList!
            {
                let btnX:CGFloat = marg + (btnW+marg)*CGFloat(index)
                let button = NYUImageButton(frame: CGRect(x:btnX,y:btnY,width:btnW,height:btnH))
                button.tag = index
                button.setImage(UIImage(named:"item_Imgbg"), for: .normal)
                let url = URL(string:TSUtil.praseTSNetFileUrl(netFile: obj.avatar)!)
                button.centerImageView.setImageWith(url, placeholder: #imageLiteral(resourceName: "IMG_pic_default_secret"))
                button.setTitle(obj.name, for: .normal)
                button.addTarget(self, action: #selector(tagClickdo(button:)), for: .touchUpInside)
                self.contentView.addSubview(button)
                index += 1
            }
        }
    }
    
    func tagClickdo(button:NYUImageButton)
    {
        let model = _starsKeyValue!.valueList![button.tag]
        self.delegate?.selectCellModel(cell: self, starsHotModel: model)
    }
}
