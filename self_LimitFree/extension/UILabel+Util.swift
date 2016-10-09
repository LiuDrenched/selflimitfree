//
//  UILabel+Util.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/26.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

extension UILabel{
    class func createLabelFrame(frame: CGRect, title: String?, textAlignment: NSTextAlignment?) -> UILabel{
        let label = UILabel(frame: frame)
        label.text = title
        
        if let tmpAlignment = textAlignment{
            label.textAlignment = tmpAlignment
        }
        return label
    }
}
