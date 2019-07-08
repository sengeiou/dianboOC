//
//  NYPsentModalView.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/9.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

protocol NYPsentModalViewDelegate: class {
    /// 选中
    func muneView(view:NYPsentModalView,to:Int)
}


class NYPsentModalView: UIView,NibLoadable
{
    
    @IBOutlet weak var bgButton: UIButton!
    
    @IBOutlet weak var muneView: UIView!
    
    @IBOutlet weak var mune_contentView: UIView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var delButton: UIButton!
    
    var indexPath: IndexPath?
    
    weak var delegate:NYPsentModalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    @IBAction func editClickdo(_ sender: UIButton) {
        self.delegate?.muneView(view: self, to: 0)
    }
    
    @IBAction func delClickdo(_ sender: UIButton) {
        self.delegate?.muneView(view: self, to: 1)
    }
    
    ///展示  add to view   mune的位置
    func showInView(_ view:UIView,cnterView:UIView)
    {
        view.insertSubview(self, at: 999)
        let point = view.convert(cnterView.center, to: self)
        muneView.mj_y = point.y+10
        muneView.mj_x = point.x - muneView.width+2
    }
    
    ///隐藏
    func hide()
    {
        self.removeFromSuperview()
    }
    
    ///点击背景
    @IBAction func bjViewClickdo(_ sender: UIButton)
    {
        hide()
    }
    
}
