//
//  NYBaseViewController.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/28.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}
