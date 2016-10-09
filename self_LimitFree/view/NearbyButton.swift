//
//  NearbyButton.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/28.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

class NearbyButton: UIControl {

    private var imageView: UIImageView?
    private var textLabel: UILabel?
    
    var model: LimitModel? {
        didSet{
            let url = NSURL(string: (model?.iconUrl)!)
            imageView?.kf_setImageWithURL(url!)
            
            textLabel?.text = model?.name
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleH: CGFloat = 20
        let w = bounds.size.width
        let h = bounds.size.height
        
        imageView = UIImageView(frame: CGRectMake(0, 0, w, h-titleH))
        addSubview(imageView!)
        
        textLabel = UILabel.createLabelFrame(CGRectMake(0, h-titleH, w, titleH), title: nil, textAlignment: .Center)
        textLabel?.font = UIFont.systemFontOfSize(12)
        addSubview(textLabel!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
