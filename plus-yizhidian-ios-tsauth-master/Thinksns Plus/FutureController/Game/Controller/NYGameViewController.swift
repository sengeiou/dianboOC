//
//  NYGameViewController.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/6.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYGameViewController: UIViewController ,UIWebViewDelegate{


    var gameUrl:String?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = TSColor.main.themeTB
        self.webView.backgroundColor = TSColor.main.themeTB
        self.webView.alpha = 0
        NYPopularNetworkManager.getVideoGameUrl { (url, msg, isBol) in
            self.gameUrl = url
            self.webView.loadRequest(URLRequest(url: URL(string: self.gameUrl!)!))
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("web加载成功")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute:{
            ///延迟执行的代码
             self.webView.alpha = 1
        })
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\(error)")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("web加载失败")
    }
}
