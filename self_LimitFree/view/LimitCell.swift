//
//  LimitCell.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/26.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

class LimitCell: UITableViewCell {
    
    @IBOutlet weak var BgImageView: UIImageView!
    @IBOutlet weak var AppImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var TimeLabel: UILabel!
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
        //日期
        let index = model.expireDatetime?.endIndex.advancedBy(-2)
        let expireDateStr = model.expireDatetime?.substringToIndex(index!)
        
        //字符串转对象
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let expireDate = df.dateFromString(expireDateStr!)
        
        //日历
        let cal = NSCalendar.currentCalendar()
        let unit = NSCalendarUnit(rawValue: NSCalendarUnit.Hour.rawValue | NSCalendarUnit.Minute.rawValue | NSCalendarUnit.Second.rawValue)
        let dateComps = cal.components(unit, fromDate: NSDate(), toDate: expireDate!, options: NSCalendarOptions.MatchStrictly)
        
        TimeLabel.text = String(format: "剩余:%02ld:%02ld:%02ld", dateComps.hour, dateComps.minute, dateComps.second)
        
        //原价
        let priceStr = "￥:"+model.lastPrice!
        LastPriceLabel.text = priceStr
        
        //横线
        if lineView == nil{
            lineView = UIView(frame: CGRectMake(0,10,60,1))
            lineView?.backgroundColor = UIColor.blackColor()
            LastPriceLabel.addSubview(lineView!)
        }
        
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
