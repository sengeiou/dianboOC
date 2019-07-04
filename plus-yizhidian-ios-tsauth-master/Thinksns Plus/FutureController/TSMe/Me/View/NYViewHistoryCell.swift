//
//  NYViewHistoryCell.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/7/2.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

protocol NYViewHistoryCellDelegate: class {
    
    /// topcell
    func topViewHistoryCell(view:NYViewHistoryCell)
    /// 首次
    func selectItemAtHistoryCell(view:NYViewHistoryCell,model:NYMeHistoryVModel)
    
}

class NYViewHistoryCell: UITableViewCell,UICollectionViewDataSource, UICollectionViewDelegate {
    
    static let identifier = "NYViewHistoryCell_Item"
    
    static let cellHeight:CGFloat = 140
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var topCellView: UIView!
    
    weak var delegate: NYViewHistoryCellDelegate?
    
    /// 数据源
    var dataSource: [NYMeHistoryVModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = TSColor.main.themeTBCellBg
        self.backgroundView?.backgroundColor = TSColor.main.themeTBCellBg
        self.contentView.backgroundColor = TSColor.main.themeTBCellBg
        self.topCellView.backgroundColor = TSColor.main.themeTBCellBg
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        // Initialization code
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        let itemW:CGFloat = 110
        let itemH:CGFloat = 85
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.scrollDirection = .horizontal
        // 3.设置滚动方向
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = TSColor.main.themeTBCellBg
        collectionView.backgroundView?.backgroundColor = TSColor.main.themeTBCellBg
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "NYViewHisCollectionCell", bundle: nil), forCellWithReuseIdentifier: NYViewHisCollectionCell.identifier)
    }
    
    func refresh() {
//        //推荐视频
//        NYPopularNetworkManager.getRecommendVideosData(_id: 1, complete: { (models, msg, isbol) in
//            
//            if let datas = models {
//                self.dataSource = datas
//            }
//            self.collectionView.reloadData()
//        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NYViewHisCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NYViewHisCollectionCell.identifier, for: indexPath) as! NYViewHisCollectionCell
//        cell.setVideosModel(video: dataSource[indexPath.row])
        cell.setMeHistoryVModel(meHistoryVModel: dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 游客触发登录
        if !TSCurrentUserInfo.share.isLogin {
            TSRootViewController.share.guestJoinLoginVC()
            return
        }
        delegate?.selectItemAtHistoryCell(view: self, model: dataSource[indexPath.row])
    }
    
    @IBAction func cellClickdo(_ sender: UIButton) {
        delegate?.topViewHistoryCell(view: self)
    }

}
