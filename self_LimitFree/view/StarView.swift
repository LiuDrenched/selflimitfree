//
//  StarView.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/26.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

class StarView: UIView {

    //前景图
    private var fgImageView: UIImageView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //初始化
        createImageView()
    }
    
    func createImageView() {
        let bgImageView = UIImageView(frame: CGRectMake(0, 0, 65, 23))
        bgImageView.image = UIImage(named: "StarsBackground")
        addSubview(bgImageView)
        
        fgImageView = UIImageView(frame: CGRectMake(0, 0, 65, 23))
        fgImageView?.image = UIImage(named: "StarsForeground")
        //停靠模式
        fgImageView?.contentMode = .Left
        fgImageView?.clipsToBounds = true
        
        addSubview(fgImageView!)
    }
    //设置星级
    func setRating(rating: String){
        let rateValue = CGFloat(NSString(string: rating).floatValue)
        fgImageView?.frame.size.width = 65 * (rateValue / 5.0)
    }

}
