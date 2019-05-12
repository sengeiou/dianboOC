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
    let rightButton: UIButton = UIButton(type: .system)
    
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
        
//        let searchIcon = UIImageView()
//        searchIcon.image = #imageLiteral(resourceName: "IMG_search_icon_search")
//        searchIcon.contentMode = .center
//        searchIcon.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
//        searchTextFiled.leftView = searchIcon
//        searchTextFiled.leftViewMode = .always
        
        rightButton.setImage(UIImage(named: "nav_close"), for: .normal)
        rightButton.setTitleColor(TSColor.main.theme, for: .normal)
        let separator = TSSeparatorView()
        
        self.addSubview(searchTextFiled)
        self.addSubview(rightButton)
        self.addSubview(separator)
        
        
        searchBgImageView.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(self)
        }
        searchTextFiled.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(1)
            make.right.equalTo(rightButton.snp.left).offset(-10)
            make.left.equalTo(self).offset(15)
            make.bottom.equalTo(self).offset(1)
        }
        rightButton.snp.makeConstraints { (make) in
//            make.top.bottom.equalTo(self)
//            make.right.equalTo(self).offset(-10)
            make.width.equalTo(self.height)
            make.height.equalTo(self.height)
        }
        separator.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self).offset(TSNavigationBarHeight - 0.5)
        }
    }
    
}
