//
//  NYSearchListVC.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/12.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

class NYSearchListVC: NYBaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var del_button: UIButton!
    
    @IBOutlet weak var top_contentView: UIView!
    
    @IBOutlet weak var hot_contentView: UIView!
    
    @IBOutlet weak var top_titleLabel: UILabel!
    
    @IBOutlet weak var hot_titleLabel: UILabel!
    
    @IBOutlet weak var topViewH: NSLayoutConstraint!
    
    @IBOutlet weak var bannerView: UIView!
    
    
    /// 广告 Banner
    let banner = TSAdvertBanners(frame: CGRect(x: 20, y:20, width: UIScreen.main.bounds.width-40, height: (UIScreen.main.bounds.width-40) / 2))
    //数组
    lazy var keywordViews = [NYWordItem]()
    
    //search bar
    let searchBar = NYSearchBarView()
    //search button
    let searchBtton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        refresh()
    }

    func setUI() {
        self.view.backgroundColor = TSColor.main.themeTB
        //设置 nav
        searchBar.searchTextFiled.placeholder = "搜索_关键字".localized
        searchBar.searchTextFiled.delegate = self
        searchBar.searchTextFiled.text = TSAppConfig.share.channel_default_search
        
//        searchBar.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        self.navigationItem.titleView = searchBar
        searchBar.snp.makeConstraints { (make) in
            make.width.equalTo(245.0)
            make.height.equalTo(30.0)
        }
        
        searchBtton.setTitle("显示_搜索".localized, for: .normal)
        searchBtton.frame = CGRect(x:0,y:0,width:60,height:30)
        searchBtton.addTarget(self, action: #selector(searchClickdo(_:)), for: .touchUpInside)
        searchBtton.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        searchBtton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: searchBtton)
        
        self.top_titleLabel.text = "显示_搜索历史".localized
        self.hot_titleLabel.text = "显示_热门搜索".localized
        loadAdvertBanner()

    }
    
    /// 增加一个广告的 Banner
    func loadAdvertBanner() {
        // 2.获取 banner 的广告
        let bannerAdverts = TSDatabaseManager().advert.getObjects(spaceId:17)
        if bannerAdverts.isEmpty {
            return
        }
        banner.setModels(models: bannerAdverts.map { TSAdvertBannerModel(object: $0) })
        banner.layer.cornerRadius = 10
        banner.layer.masksToBounds = true
        banner.scrollView.contentSize = CGSize.zero
        banner.pageControl.isHidden = true
        self.bannerView.addSubview(banner)
//        banner.center = self.bannerView.center
    }
    
    ///搜索
    func searchClickdo(_ button:UIButton) {
        let keyword = searchBar.searchTextFiled.text
        let srlVC = NYSearchResultListVC()
        srlVC.keyword = keyword
        self.navigationController?.pushViewController(srlVC, animated: true)
    }
    
    // MARK: - refresh
    func refresh() {
        //搜索历史
        NYPopularNetworkManager.getKeywordsListData(complete: { (list, msg, isBol) in
            if let models = list
            {
                var row = 0
                for (index, obj) in models.enumerated() {
                    let item = NYWordItem(frame: CGRect(x:0,y:0,width:30,height:30))
                    item.tag = index + 99
                    let size = item.setWordTxt(word: obj.keyword)
                    var lastX:CGFloat = 20.0
                    if(self.keywordViews.count>0){
                        lastX = self.keywordViews.last?.frame.maxX ?? 0
                        lastX = lastX + 10
                    }
                    var itemX:CGFloat = lastX
                    if(itemX + size.width > UIScreen.main.bounds.size.width)
                    {
                        itemX = 20
                        row = row+1;
                    }
                    let itemY:CGFloat = (CGFloat(10)+size.height)*CGFloat(row)
                    item.frame = CGRect(x:itemX,y:itemY,width:size.width,height:size.height)
                    let btn = self.createBtn(title:obj.keyword, frame: item.frame )
                    self.top_contentView.addSubview(item)
                    self.top_contentView.addSubview(btn)
                    self.keywordViews.append(item)
                }
                if self.keywordViews.count>0
                {
                    let lstBtn = self.keywordViews.last
                    self.topViewH.constant = (lstBtn?.frame.maxY)! + 60
                }
            }
        })
        //热门搜索
        NYPopularNetworkManager.getKeywordsListData(type:"hot",complete: { (list, msg, isBol) in
            if let models = list
            {
                let labW:CGFloat = (UIScreen.main.bounds.size.width-40)*0.5
                let labH:CGFloat = 22
                let column:CGFloat=2
                let margin:CGFloat=22
                for (index, obj) in models.enumerated() {
                    let row=index/Int(column)
                    let col=index%Int(column)
                    let labX:CGFloat  = margin+(labW+margin)*CGFloat(col)
                    let labY:CGFloat  = 12+(labH+12)*CGFloat(row)
                    let label = UILabel(frame: CGRect(x:labX,y:labY,width:labW,height:labH))
                    let highlightedStr = "\(index+1)"
                    let superString = "\(highlightedStr)  \(obj.keyword)"
                    label.textColor = UIColor.white
                    if(index<3){
                        label.attributedText = NYUtils.superStringAttributedString(superString: superString, highlightedStr: highlightedStr, color: UIColor(hex: 0xF2125A))
                    }
                    else{
                        label.text = superString
                    }
                    label.font = UIFont.systemFont(ofSize: 12)
                    let btn = self.createBtn(title: obj.keyword, frame: label.frame)
                    btn.tag = obj.id
                    self.hot_contentView.addSubview(label)
                    self.hot_contentView.addSubview(btn)
                }
            }
        })
    }
    
    func createBtn(title:String,frame:CGRect) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(self.hotClickdo(_:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.clear, for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.frame = frame
        return btn
    }
    ///热门搜索
    func hotClickdo(_ btn:UIButton)
    {
        self.searchBar.searchTextFiled.text = btn.currentTitle
        searchClickdo(self.searchBtton)
    }
    
    ///清空历史数据
    @IBAction func delKeywordClickdo(_ sender: UIButton)
    {
        NYPopularNetworkManager.delSearchKeywords(complete: { (msg, isbol) in
            if isbol
            {
                self.top_contentView.subviews.forEach({ $0.removeFromSuperview()});
                //刷新UI
                self.topViewH.constant = 100
            }
        })
    }
    
    
    /// mark ---UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchClickdo(self.searchBtton)
        return true
    }
}
