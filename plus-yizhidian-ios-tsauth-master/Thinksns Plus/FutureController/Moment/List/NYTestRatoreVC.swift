//
//  NYTestRatoreVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/21.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYTestRatoreVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override var shouldAutorotate: Bool
        {
        get {
            return true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
  
            return UIInterfaceOrientationMask.landscape
        
    }

}
