//
//  NYWordItem.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/12.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYWordItem: UIView {
    
    let word_button = UIButton(type: .system)
    let close_button = UIButton(type: .system)
    let sizeFont = UIFont.systemFont(ofSize: 12)
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
        word_button.backgroundColor = UIColor(red: 59, green: 59, blue: 61)
        word_button.setTitleColor(UIColor.white, for: .normal)
        word_button.titleLabel?.font = sizeFont
        word_button.layer.cornerRadius = 15
        word_button.layer.masksToBounds = true
        
        close_button.setImage(UIImage(named: "item_close"), for: .normal)
        close_button.frame = CGRect(x:0,y:0,width:20,height:20)
        self.addSubview(word_button)
        self.addSubview(close_button)
    }
    
    func setWordTxt(word:String) ->CGSize
    {
        word_button.setTitle(word, for: .normal)
        let size = word.sizeOfString(usingFont: sizeFont)
        word_button.frame = CGRect(x:0,y:0,width:size.width+20,height:self.height)
        let width = word_button.width + close_button.width*0.5
        close_button.mj_x = width - close_button.width
        return CGSize(width:width,height:self.height)
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
}
