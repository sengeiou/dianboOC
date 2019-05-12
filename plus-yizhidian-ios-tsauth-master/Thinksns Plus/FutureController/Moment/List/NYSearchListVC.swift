//
//  NYSearchListVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/12.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYSearchListVC: UIViewController {

    //search bar
    let searchBar = NYSearchBarView()
    //search button
    let searchBtton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }

    func setUI() {
        //设置 nav
        searchBar.searchTextFiled.placeholder = "搜索_关键字".localized
//        searchBar.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        self.navigationItem.titleView = searchBar
        searchBar.snp.makeConstraints { (make) in
            make.width.equalTo(245.0)
            make.height.equalTo(30.0)
        }
        
        searchBtton.setTitle("显示_搜索".localized, for: .normal)
        searchBtton.addTarget(self, action: #selector(searchClickdo(_:)), for: .touchUpInside)
        searchBtton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: searchBtton)
    }
    
    func searchClickdo(_ button:UIButton) {
        
    }
}
