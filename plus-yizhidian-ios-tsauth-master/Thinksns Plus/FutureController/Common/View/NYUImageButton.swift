//
//  NYUImageButton.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/26.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYUImageButton: UIButton {

    let centerImageView = UIImageView()
    
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
        self.centerImageView.frame = CGRect(x:1,y:1,width:self.width-2,height:self.width-2)
        self.addSubview(centerImageView)
        self.imageView?.image = UIImage(named: "item_Imgbg")
        self.centerImageView.layer.cornerRadius = (self.width-2)*0.5
        self.centerImageView.layer.masksToBounds = true
        
        self.titleLabel?.textColor = UIColor.white
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x:0,y:0,width:contentRect.width,height:contentRect.width)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x:0,y:contentRect.width,width:contentRect.width,height:contentRect.height-contentRect.width)
    }
    
}
