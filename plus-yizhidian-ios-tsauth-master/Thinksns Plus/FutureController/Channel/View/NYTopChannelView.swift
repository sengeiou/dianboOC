//
//  NYTopChannelView.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/2.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

protocol NYTopChannelViewDelegate: class {
    /// 选中
    func selectViewModelList(view:NYTopChannelView,tsgList:[NYtagModel])
    /// 首次
    func firstViewModelList(view:NYTopChannelView,tsgList:[NYtagModel])
}

class NYTopChannelView: UIView,UICollectionViewDataSource, UICollectionViewDelegate,NYChannelCollectionViewCellDelegate
{
    var dataSource: [[NYtagModel]]?
    //选择
    let channelSelectButton = UIButton(type: .custom)
    
    //内容
    let contentView = UIView()
    /// 选择标题标签
    var selectTitle = ""
    /// tags view
    var collectionViewList: [UICollectionView] = []
    /// 选中的 model
    var selectTagModel:[NYtagModel]=[]
    
    weak var delegate: NYTopChannelViewDelegate?
//    //全部地区
//    let allAreaBtn = UIButton(type: .custom)
//    var areaCollectionView: UICollectionView!
//    //全部类型
//    let allTypeBtn = UIButton(type: .custom)
//    var typeCollectionView: UICollectionView!
//    //全部年份
//    let allYearBtn = UIButton(type: .custom)
//    var yearCollectionView: UICollectionView!
//    //标签分类
//    let aCategreBtn = UIButton(type: .custom)
//    var aCollectionView: UICollectionView!
//    //标签分类
//    let bCategreBtn = UIButton(type: .custom)
//    var bCollectionView: UICollectionView!
    //线
    let lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TSColor.main.themeTBCellBg
        
        //选择
        channelSelectButton.frame =  CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:40)
        channelSelectButton.setImage(UIImage(named: "com_allow"), for: .normal)
        channelSelectButton.setTitle("内地·古装·全部年份", for: .normal)
        channelSelectButton.setTitleColor(TSColor.main.themeZsColor, for: .normal)
        channelSelectButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        channelSelectButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        channelSelectButton.addTarget(self, action: #selector(channelSelectClickdo(btn:)), for: .touchUpInside)
        self.addSubview(channelSelectButton)
        
        //内容
        contentView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:0)
        contentView.backgroundColor = UIColor.clear
        contentView.isHidden = true
        self.addSubview(contentView)
        
//        //全部地区
//        let areaBtnW:CGFloat = 80
//        let areaBtnH:CGFloat = 35
//        let areaBtnY:CGFloat = 10
//        let areaBtnX:CGFloat = 10
//        let CollectionW:CGFloat = UIScreen.main.bounds.width - allAreaBtn.frame.maxX-CGFloat(5)
//        allAreaBtn.frame = CGRect(x:areaBtnX,y:areaBtnY,width:areaBtnW,height:areaBtnH)
//        allAreaBtn.setTitle("显示_全部地区".localized, for:.normal)
//        allAreaBtn.setTitleColor(UIColor.white, for: .normal)
//        allAreaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        contentView.addSubview(allAreaBtn)
//        areaCollectionView = createCollectionView(cF: CGRect(x:allAreaBtn.frame.maxX+5,y:areaBtnY,width:CollectionW,height:areaBtnH), tag: 10)
//        //全部类型
//        let typeBtnY:CGFloat = allAreaBtn.frame.maxY+8
//        allTypeBtn.frame = CGRect(x:areaBtnX,y:typeBtnY,width:areaBtnW,height:areaBtnH)
//        allTypeBtn.setTitle("显示_全部类型".localized, for:.normal)
//        allTypeBtn.setTitleColor(UIColor.white, for: .normal)
//        allTypeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        contentView.addSubview(allTypeBtn)
//        typeCollectionView = createCollectionView(cF: CGRect(x:allTypeBtn.frame.maxX+5,y:typeBtnY,width:CollectionW,height:areaBtnH), tag: 20)
//        //全部年份
//        let yearBtnY:CGFloat = allTypeBtn.frame.maxY+8
//        allYearBtn.frame = CGRect(x:areaBtnX,y:yearBtnY,width:areaBtnW,height:areaBtnH)
//        allYearBtn.setTitle("显示_全部年份".localized, for:.normal)
//        allYearBtn.setTitleColor(TSColor.main.themeZsColor, for: .normal)
//        allYearBtn.setBackgroundImage(UIImage(named: "com_bg"), for: .normal)
//        allYearBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        contentView.addSubview(allYearBtn)
//        yearCollectionView = createCollectionView(cF: CGRect(x:allYearBtn.frame.maxX+5,y:yearBtnY,width:CollectionW,height:areaBtnH), tag: 30)
//        //标签分类
//        let aCategreBtnY:CGFloat = allYearBtn.frame.maxY+8
//        aCategreBtn.frame = CGRect(x:areaBtnX,y:aCategreBtnY,width:areaBtnW,height:areaBtnH)
//        aCategreBtn.setTitle("显示_标签分类".localized, for:.normal)
//        aCategreBtn.setTitleColor(TSColor.main.themeZsColor, for: .normal)
//        aCategreBtn.setBackgroundImage(UIImage(named: "com_bg"), for: .normal)
//        aCategreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        contentView.addSubview(aCategreBtn)
//        aCollectionView = createCollectionView(cF: CGRect(x:aCategreBtn.frame.maxX+5,y:aCategreBtnY,width:CollectionW,height:areaBtnH), tag: 40)
//        //标签分类
//        let bCategreBtnY:CGFloat = aCategreBtn.frame.maxY+8
//        bCategreBtn.frame = CGRect(x:areaBtnX,y:bCategreBtnY,width:areaBtnW,height:areaBtnH)
//        bCategreBtn.setTitle("显示_标签分类".localized, for:.normal)
//        bCategreBtn.setTitleColor(TSColor.main.themeZsColor, for: .normal)
//        bCategreBtn.setBackgroundImage(UIImage(named: "com_bg"), for: .normal)
//        bCategreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        contentView.addSubview(bCategreBtn)
//        bCollectionView = createCollectionView(cF: CGRect(x:bCategreBtn.frame.maxX+5,y:bCategreBtnY,width:CollectionW,height:areaBtnH), tag: 40)
        //线
        lineView.frame = CGRect(x:10,y:0,width:UIScreen.main.bounds.width-20,height:0.5)
        lineView.backgroundColor = UIColor.lightGray
        lineView.isHidden = true
        self.addSubview(lineView)
        
    }
    
    ///数据
    func refresh() {
        //头部筛选条件
        //动态数据
        NYPopularNetworkManager.getTagsListData(complete:{(list: [NYTagsMModel]?, error,isobl) in
            if let models = list {
                print("\(models)")
                let tagList = NSMutableArray()
                let collectionH:CGFloat = 35
                for (index,data) in models.enumerated()
                {
                    let array = NSMutableArray()
                    let oneTag = NYtagModel()
                    oneTag.id = data.id
                    oneTag.name = data.name
                    array.add(oneTag)
                    array.addObjects(from: data.tags!)
                    tagList.add(array)
                    let collectionY:CGFloat = 8 + (collectionH+8)*CGFloat(index)
                    let collectionView = self.createCollectionView(cF: CGRect(x:0,y:collectionY,width:ScreenWidth,height:collectionH), tag: index)
                    self.collectionViewList.append(collectionView)
                    
                    //判断 tages 是否存在 selecttitle
                    var selModel:NYtagModel?
                    for item in data.tags!
                    {
                        if self.selectTitle.isEqual(item.name)
                        {
                            selModel = item
                            break
                        }
                    }
                    if selModel != nil
                    {
                        self.selectTagModel.append(selModel!)
                    }
                    else
                    {
                        self.selectTagModel.append(oneTag)
                    }

                }
                self.dataSource = tagList as! [[NYtagModel]]
                //刷新
                for collectionView in self.collectionViewList
                {
                    collectionView.reloadData()
                }
                self.delegate?.firstViewModelList(view: self, tsgList: self.selectTagModel)
                self.updateSelctTitle()
            }
        })
    }
    
    func updateSelctTitle()
    {
        var str = String()
        for obj in self.selectTagModel
        {
            str.append("\(obj.name)·")
        }
        str.remove(at: str.index(before: str.endIndex))
        channelSelectButton.setTitle(str, for: .normal)
    }
    
    func createCollectionView(cF:CGRect,tag:Int) -> UICollectionView
    {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 2
        let itemW:CGFloat = 65
        let itemH:CGFloat = 30
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.scrollDirection = .horizontal
        // 3.设置滚动方向
        let collectionView = UICollectionView(frame: cF, collectionViewLayout: layout)
        collectionView.tag = tag
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NYChannelCollectionViewCell.self, forCellWithReuseIdentifier: NYChannelCollectionViewCell.identifier)
        self.contentView.addSubview(collectionView)
        return collectionView
    }
    
    //点击事件
    func channelSelectClickdo(btn:UIButton)
    {
        let collectionView  = self.collectionViewList.last
        let height:CGFloat = (collectionView?.frame.maxY)! + 50
        if contentView.isHidden   //展开
        {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.lineView.isHidden = false
                self.contentView.isHidden = false
                self.mj_h = height
                self.channelSelectButton.mj_y = height-CGFloat(40)
                self.contentView.mj_h = height-CGFloat(40)
                self.lineView.mj_y = height-CGFloat(40)
            }, completion: nil)
        }
        else    //收起
        {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.lineView.isHidden = true
                self.contentView.isHidden = true
                self.mj_h = 40
                self.channelSelectButton.mj_y = 0
                self.contentView.mj_h = 0
                self.lineView.mj_y = 0
            }, completion: nil)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.dataSource![collectionView.tag].count
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NYChannelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NYChannelCollectionViewCell.identifier, for: indexPath) as! NYChannelCollectionViewCell
        cell.tag = collectionView.tag
        cell.delegate = self
        let model = self.dataSource![collectionView.tag][indexPath.row]
        let from = self.selectTagModel[collectionView.tag]
        cell.setTagModel(tag: model, from: from)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        // 游客触发登录
        //        if !TSCurrentUserInfo.share.isLogin {
        //            TSRootViewController.share.guestJoinLoginVC()
        //            return
        //        }
        //        let postListVC = TopicPostListVC(groupId: dataSource[indexPath.row].topicId)
        //        navigationController?.pushViewController(postListVC, animated: true)
    }
    
    /// mark -----NYChannelCollectionViewCellDelegate
    func selectCellModel(cell: NYChannelCollectionViewCell, tagModel: NYtagModel) {
        let collectionView  = self.collectionViewList[cell.tag]
        selectTagModel[cell.tag]=tagModel
        collectionView.reloadData()
        updateSelctTitle()
        self.delegate?.selectViewModelList(view: self, tsgList: selectTagModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
