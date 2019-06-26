//
//  NYImageButton.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/12.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYImageButton: UIView
{
    let imagebgView = UIImageView()
    let currentButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        setUI()
    }
    
    deinit {
    }
    
    func setUI()
    {
        imagebgView.frame = self.bounds
        imagebgView.image = UIImage(named: "item_Imgbg")
        self.addSubview(imagebgView)
        currentButton.layer.cornerRadius = (self.width-2)*0.5
        currentButton.frame = CGRect(x:1,y:1,width:self.width-2,height:self.height-2)
        currentButton.layer.masksToBounds = true
        self.addSubview(currentButton)
    }
}
