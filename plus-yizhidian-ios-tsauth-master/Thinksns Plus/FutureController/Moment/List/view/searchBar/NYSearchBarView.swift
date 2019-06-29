//
//  NYSearchBarView.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/12.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYSearchBarView: UIView
{
    public let searchTextFiled = UITextField()
    let searchBgImageView = UIImageView()
    let rightButton: UIButton = UIButton(type: .custom)
    
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
    
    func setUI() {
        
        searchBgImageView.image = UIImage(named: "search_bg")
            //?.resizableImage(withCapInsets: UIEdgeInsetsMake(15, 15, 15, 15), resizingMode:.stretch)
        self.addSubview(searchBgImageView)
        
        searchTextFiled.font = UIFont.systemFont(ofSize: TSFont.SubInfo.footnote.rawValue)
        searchTextFiled.textColor = UIColor.white
        searchTextFiled.placeholder = "Keyword"
        searchTextFiled.backgroundColor = UIColor.clear
        searchTextFiled.layer.cornerRadius = 5
        searchTextFiled.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")        
        
        rightButton.setImage(UIImage(named: "nav_close"), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        rightButton.setTitleColor(TSColor.main.theme, for: .normal)
        let sa_ImageL = UIImageView()
        
        self.addSubview(searchTextFiled)
        self.addSubview(rightButton)
        self.addSubview(sa_ImageL)
        
        
//        sa_ImageL.frame = CGRect(x: sa_searchBtn.x - 4, y:8, width:2, height:searchH-16)
        sa_ImageL.image = UIImage(named: "nav_search_l")
        
        searchBgImageView.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(self)
        }
        sa_ImageL.snp.makeConstraints { (make) in
            make.top.equalTo(searchBgImageView).offset(6)
            make.bottom.equalTo(searchBgImageView).offset(-6)
            make.width.equalTo(2)
            make.right.equalTo(rightButton.snp.left).offset(-2)
        }
        searchTextFiled.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(1)
            make.right.equalTo(rightButton.snp.left).offset(-10)
            make.left.equalTo(self).offset(15)
            make.bottom.equalTo(self).offset(1)
        }
        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(searchBgImageView)
            make.right.equalTo(searchBgImageView)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
  
    }
    
}
