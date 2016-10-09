//
//  UIButton+Util.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/26.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit


extension UIButton {
    
    class func createBtn(frame: CGRect, title: String?, bgImageName:String?, target: AnyObject?, action: Selector) -> UIButton {
        let btn = UIButton(type: .Custom)
        btn.frame = frame
        if let tmpTitle = title {
            btn.setTitle(tmpTitle, forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        if let imageName = bgImageName{
            btn.setBackgroundImage(UIImage(named: imageName), forState: .Normal)
        }
        if target != nil && action != nil{
            btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        }
        return btn
    }
}
