//
//  NYMomentDetailHeaderView.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/23.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

protocol NYMomentDetailHeaderViewDelegate: class {
    /// 点击了图片
    func headerView(_ headerView: NYMomentDetailHeaderView, didSelectedImagesAt index: Int)
    func headerView(_ headerView: NYMomentDetailHeaderView, didSelectedDiggView: UIButton)

}

class NYMomentDetailHeaderView: UIView,NibLoadable
{
    
    @IBOutlet weak var content_Label: UILabel!
    
    @IBOutlet weak var firstImage: TSPreviewButton!
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var playTime_Label: UILabel!
    
    @IBOutlet weak var postTime_Label: UILabel!
    
    @IBOutlet weak var browse_Btn: UIButton!
    
    @IBOutlet weak var like_Btn: UIButton!
    
    @IBOutlet weak var more_Btn: UIButton!
    
    /// 数据模型
    var _object: TSMomentListObject!

    var topicModes: [TopicListModel]?
    /// 代理
    weak var delegate: NYMomentDetailHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = TSColor.main.themeTBCellBg
        
    }
    
    func setTSMomentListObject(model:TSMomentListObject)
    {
        _object = model
        let images = model.pictures.filter { (object) -> Bool in
            return object.width > 0 && object.height > 0
        }
        content_Label.attributedText = model.content.attributonString().setTextFont(15).setlineSpacing(6)

        let timeString = TSDate().dateString(.detail, nsDate: model.create)
        postTime_Label.text = "发布于\(timeString)"
        browse_Btn.setTitle(TSAppConfig.share.pageViewsString(number: model.view), for: .normal)
        like_Btn.setTitle("\(model.digg)", for: .normal)
        if model.videoURL != nil { //视频内容
            self.firstImage.imageObject = images[0]
            self.playBtn.isHidden = false
            self.playTime_Label.isHidden = false
            self.more_Btn.isHidden = true
        }
        else
        {   //图片集内容
            self.firstImage.imageObject = images[0]
            self.firstImage.imageObject = images[0]
            self.playBtn.isHidden = true
            self.playTime_Label.isHidden = true
            self.more_Btn.isHidden = false
        }

    }
    
    @IBAction func firstClickdo(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.headerView(self, didSelectedImagesAt: 0)
        }
    }
    
    @IBAction func browseClickdo(_ sender: UIButton) {
    
    }
    
    @IBAction func likeClickdo(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.headerView(self, didSelectedDiggView: sender)
        }
    }
    
    func isPlaydo(isBol:Bool) {
        if isBol
        {
            self.playBtn.isHidden = true
            self.playTime_Label.isHidden = true
            self.more_Btn.isHidden = true
        }
        else
        {
            self.playBtn.isHidden = false
            self.playTime_Label.isHidden = false
            self.more_Btn.isHidden = true
        }
    }
    
}
