//
//  LimitCell.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/26.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

class FreeCell: UITableViewCell {
    
    @IBOutlet weak var BgImageView: UIImageView!
    @IBOutlet weak var AppImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var RateLabel: UILabel!
    @IBOutlet weak var LastPriceLabel: UILabel!
    @IBOutlet weak var MyStarView: StarView!

    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var ShareLabel: UILabel!
    @IBOutlet weak var FavoriteLabel: UILabel!
    
    @IBOutlet weak var DownloadLabel: UILabel!
    
    private var lineView: UIView?
    
    //显示数据
    func config(model: LimitModel, atIndex index: Int) {
        //背景
        if index % 2 == 0{
            BgImageView.image = UIImage(named: "cate_list_bg1")
        }else{
            BgImageView.image = UIImage(named: "cate_list_bg2")
        }
        
        //应用图片
        let url = NSURL(string: model.iconUrl!)
        AppImageView.kf_setImageWithURL(url!)
        
        //名字
        NameLabel.text = "\(index)."+model.name!
        //评分
        RateLabel.text = "评分:"+model.starCurrent!
        
        //原价
        let priceStr = "￥:"+model.lastPrice!
        LastPriceLabel.text = priceStr
        
        let attrStr = NSMutableAttributedString(string: priceStr)
        attrStr.addAttributes([NSStrikethroughStyleAttributeName:NSNumber(int:1)], range: NSMakeRange(0, attrStr.length))
        LastPriceLabel.attributedText = attrStr
        
        //星级
        MyStarView.setRating(model.starCurrent!)
        //类型
        CategoryLabel.text = MyUtil.transferCateName(model.categoryName!)
        //分享收藏下载
        ShareLabel.text = "分享:"+model.shares!+"次"
        FavoriteLabel.text = "收藏:"+model.favorites!+"次"
        DownloadLabel.text = "下载:"+model.downloads!+"次"
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
