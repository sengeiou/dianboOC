//
//  videoHeadView.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/21.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

protocol videoHeadViewDelegate: class {
    /// 选中
    func updateUI(view:videoHeadView)
}

class videoHeadView: UIView,NibLoadable,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var tagsView: UIView!
    
    @IBOutlet weak var wntjLabel: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet weak var mcollectionView: UICollectionView!
    
    @IBOutlet weak var allowButton: UIButton!
    
    @IBOutlet weak var layout_TopView_H: NSLayoutConstraint!
    
    @IBOutlet weak var layout_ContentView_H: NSLayoutConstraint!
    
    weak var delegate : videoHeadViewDelegate?
    
    var isShow:Bool = false
    /// 数据源
    var dataSource: [NYVideosModel] = []
    var _videoModel:NYVideosModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = TSColor.main.themeTB
        // Initialization code
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(15, 25, 0, 25)
        let itemW:CGFloat = 160
        let itemH:CGFloat = 120
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.scrollDirection = .vertical
        // 3.设置滚动方向
        mcollectionView.collectionViewLayout = layout
        mcollectionView.delegate = self
        mcollectionView.dataSource = self
        mcollectionView.showsVerticalScrollIndicator = false
        mcollectionView.showsHorizontalScrollIndicator = false
        mcollectionView.register(UINib(nibName: "NYVideoColl", bundle: nil), forCellWithReuseIdentifier: NYVideoColl.identifier)
    }
    
    func setVideosModel(video:NYVideosModel) {
        _videoModel = video
        self.titleLabel.text = video.name
        self.contentLabel.text = video.summary
        self.tagsView.subviews.forEach({ $0.removeFromSuperview()});
        if (video.tags?.count)!>0
        {
            let itemW:CGFloat = 65
            let itemH:CGFloat = 26
            let itemY:CGFloat = (self.tagsView.height-itemH)*0.5
            let margin:CGFloat = (ScreenWidth-16-itemW*5)/6
            
            for (index,item) in (video.tags?.enumerated())!
            {
                let itemX:CGFloat = margin*CGFloat(index+1)+itemW*CGFloat(index)
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: itemX,y:itemY, width: itemW, height: itemH)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                button.setTitle(item.name, for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.setBackgroundImage(UIImage(named: "com_bg"), for: .normal)
                self.tagsView.addSubview(button)
            }
        }
        
        
        refresh()
    }
    
    func refresh() {
        //推荐视频
        NYPopularNetworkManager.getRecommendVideosData(_id: _videoModel.id, complete: { (models, msg, isbol) in
            
            if let datas = models {
                self.dataSource = datas
                
                if(datas.count>2)
                {
                    self.mj_h = 320+130
                }else
                {
                    self.mj_h = 320
                }
                self.delegate?.updateUI(view: self)
            }
            self.mcollectionView.reloadData()
        })
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NYVideoColl = collectionView.dequeueReusableCell(withReuseIdentifier: NYVideoColl.identifier, for: indexPath) as! NYVideoColl
        cell.setVideosModel(video: dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 游客触发登录
        if !TSCurrentUserInfo.share.isLogin {
            TSRootViewController.share.guestJoinLoginVC()
            return
        }
        
    }
    ///换一换
    @IBAction func changeClickdo(_ sender: UIButton) {
        refresh()
    }
    
    @IBAction func showDesClickdo(_ sender: UIButton) {
        
        let com_size = contentLabel.text?.size(maxSize: CGSize(width:contentLabel.width,height:CGFloat(MAXFLOAT)), font: contentLabel.font)
        if(dataSource.count>2)
        {
            self.mj_h = 320+130
        }else
        {
            self.mj_h = 320
        }
//            commentModel.body.size(maxSize: CGSize(width:L1_W,height:CGFloat(MAXFLOAT)), font: UIFont.systemFont(ofSize: 12))
        if !isShow
        {
            if  (com_size?.height)! > contentLabel.height
            {
                self.layout_ContentView_H.constant = (com_size?.height)!+15
                self.layout_TopView_H.constant = 120 + self.layout_ContentView_H.constant - 38.0
                self.mj_h = self.mj_h + self.layout_ContentView_H.constant - 38.0
            }
            //展开
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.allowButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            }, completion: nil)
            isShow = true
        }
        else
        {
            self.layout_ContentView_H.constant = 38.0
            self.layout_TopView_H.constant = 120
            //收缩
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.allowButton.transform = CGAffineTransform.identity
            }, completion:nil)
            isShow = false
        }

        self.delegate?.updateUI(view: self)        
    }
    
}
