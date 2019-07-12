//
//  NYCommentsCell.swift
//  ThinkSNSPlus
//
//  Created by ningye on 2019/6/22.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

import UIKit

protocol NYCommentsCellDelegate: class {
    
    /// 评论
    func commentsCell(cell:NYCommentsCell)
    /// 点赞
    func commentsLikeCell(cell:NYCommentsCell)

}

class NYCommentsCell: UITableViewCell {

    static let identifier = "NYCommentsCell_Item"
    
    //用户头像
    let user_imageButton = UIButton(type: .custom)
    //用户名称
    let user_nameButton = UIButton(type: .custom)
    //评论时间
    let com_dateLabel = UILabel()
    //评论按钮
    let comment_Button = UIButton(type: .custom)
    //点赞数
    let like_CountButton = UIButton(type: .custom)
    let line_L = UIView()
    //line 1
    let line1 = UIView()
    //内容
    let comment_Label = UILabel()
    //跟评论view
    let reply_listView = UIView()
    //跟评背景
    let reply_imagebgView = UIImageView()
    //跟评论
    /// 查看全文
    var alltxtButton:UIButton?
    //line 2
    let line2 = UIView()
    
    //评论model
    var _listCommentFrameModel:FeedListCommentFrameModel?
//    /// 空视图
//    var nothingImageView: UIImageView!
//    /// 空视图的高度
//    var nothingImageViewHeight: NSLayoutConstraint!
    
    weak var delegate:NYCommentsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TSColor.main.themeTBCellBg
        self.contentView.backgroundColor = TSColor.main.themeTBCellBg
        //用户头像
        let userImgWH:CGFloat = 45
        let userImgX:CGFloat = 10
        let userImgY:CGFloat = 15
        user_imageButton.layer.cornerRadius = userImgWH*0.5
        user_imageButton.layer.masksToBounds = true
        user_imageButton.setBackgroundImage(UIImage(named: "IMG_pic_default_secret"), for: .normal)
        user_imageButton.frame = CGRect(x:userImgX,y:userImgY,width:userImgWH,height:userImgWH)
        self.contentView.addSubview(user_imageButton)
        //用户名称
        let userNameW:CGFloat = 180
        let userNameH:CGFloat = 22
        let userNameX:CGFloat = user_imageButton.frame.maxX+10
        let userNameY:CGFloat = userImgY+8
        user_nameButton.setTitle("小明", for: .normal)
        user_nameButton.setTitleColor(TSColor.main.themeZsColor, for: .normal)
        user_nameButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        user_nameButton.contentHorizontalAlignment = .left
        user_nameButton.frame = CGRect(x:userNameX,y:userNameY,width:userNameW,height:userNameH)
        self.contentView.addSubview(user_nameButton)
        //评论时间
        let dateW:CGFloat = 180
        let dateH:CGFloat = 20
        let dateX:CGFloat = userNameX
        let dateY:CGFloat = user_nameButton.frame.maxY
        com_dateLabel.font = UIFont.systemFont(ofSize: 12)
        com_dateLabel.textColor = UIColor.white
        com_dateLabel.frame = CGRect(x:dateX,y:dateY,width:dateW,height:dateH)
        self.contentView.addSubview(com_dateLabel)
        //点赞数
        let likeW:CGFloat = 65
        let likeH:CGFloat = 30
        let likeX:CGFloat = 100
        let likeY:CGFloat = 20
        like_CountButton.setImage(UIImage(named: "com_likec"), for: .normal)
        like_CountButton.setTitleColor(UIColor.lightGray, for: .normal)
        like_CountButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        like_CountButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        like_CountButton.frame = CGRect(x:likeX,y:likeY,width:likeW,height:likeH)
        like_CountButton.addTarget(self, action: #selector(commentLikeClickdo(_:)), for: .touchUpInside)
        self.contentView.addSubview(like_CountButton)
        
        // zline
        let L_W:CGFloat = 0.5
        let L_H:CGFloat = 20
        let L_X:CGFloat = 100
        let L_Y:CGFloat = 20
        
        line_L.frame = CGRect(x:L_X,y:L_Y,width:L_W,height:L_H)
        line_L.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(line_L)
        //评论按钮
        let combWH:CGFloat = 30
        let combX:CGFloat = 100
        let combY:CGFloat = 20
        comment_Button.setImage(UIImage(named: "cell_comment"), for: .normal)
        comment_Button.addTarget(self, action: #selector(commentClickdo(_:)), for: .touchUpInside)
        comment_Button.frame = CGRect(x:combX,y:combY,width:combWH,height:combWH)
        self.contentView.addSubview(comment_Button)

        //line 1
        let L1_W:CGFloat = 0.5
        let L1_H:CGFloat = 20
        let L1_X:CGFloat = 100
        let L1_Y:CGFloat = 20
        line1.backgroundColor = UIColor.lightGray
        line1.frame = CGRect(x:L1_X,y:L1_Y,width:L1_W,height:L1_H)
        self.contentView.addSubview(line1)
        //内容
        let commentW:CGFloat = L1_W
        let commentH:CGFloat = 20
        let commentX:CGFloat = L1_X
        let commentY:CGFloat = L1_Y+10
        comment_Label.font = UIFont.systemFont(ofSize: 12)
        comment_Label.textColor = UIColor.white
        comment_Label.textAlignment = .left
        comment_Label.numberOfLines = 0
        comment_Label.frame = CGRect(x:commentX,y:commentY,width:commentW,height:commentH)
        self.contentView.addSubview(comment_Label)
        //跟评论view
        let reply_listW:CGFloat = commentW
        let reply_listH:CGFloat = 0
        let reply_listX:CGFloat = commentX
        let reply_listY:CGFloat = comment_Label.frame.maxY+4
        reply_listView.backgroundColor = UIColor.clear
        reply_listView.frame = CGRect(x:reply_listX,y:reply_listY,width:reply_listW,height:reply_listH)
        self.contentView.addSubview(reply_listView)
    
        //跟评论
        
        //line 2
        let L2_W:CGFloat = ScreenWidth - userImgX*2
        let L2_H:CGFloat = 0.5
        let L2_X:CGFloat = userImgX
        let L2_Y:CGFloat = 20
        line2.backgroundColor = UIColor.lightGray
        line2.frame = CGRect(x:L2_X,y:L2_Y,width:L2_W,height:L2_H)
        self.contentView.addSubview(line2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setListCommentFrameModel(commentFModel:FeedListCommentFrameModel) {
        _listCommentFrameModel = commentFModel
        let model = commentFModel._commentModel
        //用户头像
        self.user_imageButton.frame = commentFModel.user_imageViewF!
        if let url = model?.userInfo.avatar?.url {
            self.user_imageButton.setBackgroundImageWith(URL(string: url), for: .normal, placeholder: #imageLiteral(resourceName: "IMG_pic_default_secret"))
        }
        //用户名称
        self.user_nameButton.frame = commentFModel.user_nameViewF
        self.user_nameButton.setTitle(model?.userInfo.name, for: .normal)
        //评论时间
        self.com_dateLabel.frame = commentFModel.com_dateViewF
        let timeString = TSDate().dateString(.detail, nsDate: model!.create as NSDate)
        
        self.com_dateLabel.text =  timeString
        self.line_L.frame = commentFModel.lineLF
        
        //评论按钮
        self.comment_Button.frame = commentFModel.commentButtonF
        //点赞数
        self.like_CountButton.frame = commentFModel.like_CountF
        
        let num_txt = Float((model?.comment_like_count)!).combatValues
        self.like_CountButton.setTitle(num_txt, for: .normal)
        //line 1
        self.line1.frame = commentFModel.line1F
        //内容
        self.comment_Label.frame = commentFModel.commentF
        self.comment_Label.text = model?.body
        
        self.reply_listView.isHidden = true
        //跟评背景
        self.reply_listView.subviews.forEach({ $0.removeFromSuperview()});
        
        if ((model?.comment_children) != nil) && (model?.comment_children!.count)!>0
        {
            //跟评论view
            self.reply_listView.frame = commentFModel.reply_listF
            self.reply_listView.isHidden = false
            self.reply_imagebgView.frame = commentFModel.reply_imagebgF
            reply_imagebgView.image = UIImage(named: "com_com_bg")?
                .resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
                                resizingMode: .stretch) //左右15像素的部分不变，中间部分来拉伸
            self.reply_listView.addSubview(reply_imagebgView)
            
            //跟评论
            if commentFModel.replyLabListF.count>0
            {
                for (index,item) in (commentFModel.replyLabListF?.enumerated())!
                {
                    let data = model?.comment_children![index] as! FeedListCommentModel
                    let label = UILabel()
                    label.frame = item as! CGRect
                    label.font = UIFont.systemFont(ofSize: 12)
                    label.textColor = UIColor.white
                    label.attributedText = NYUtils.superStringAttributedStringList(superString: data.nameBody, highlightedStrList: ["回复",data.body], colorList: [TSColor.main.themeZsColor,UIColor.lightGray])
                    self.reply_listView.addSubview(label)
                }
                /// 查看全文
                let allStr = "查看全文\(model?.comment_children_count ?? 0)条回复"
                self.alltxtButton = UIButton(type: .custom)
                alltxtButton?.setImage(UIImage(named: "com_allow"), for: .normal)
                alltxtButton?.setTitle(allStr, for: .normal)
                alltxtButton?.setTitleColor(TSColor.main.themeZsColor, for: .normal)
                alltxtButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                alltxtButton?.frame = commentFModel.allTxtViewF
                alltxtButton?.contentHorizontalAlignment = .left
                self.reply_listView.addSubview(self.alltxtButton!)
            }
        }
        
        //line 2
        self.line2.frame = commentFModel.line2F
    }

    func commentClickdo(_ btn:UIButton)
    {
        self.delegate?.commentsCell(cell: self)
    }
    
    func commentLikeClickdo(_ btn:UIButton)
    {
        self.delegate?.commentsLikeCell(cell: self)
    }
}
