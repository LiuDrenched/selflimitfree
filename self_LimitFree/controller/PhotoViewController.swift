//
//  PhotoViewController.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/27.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var photoIndex: Int?
    var photoArray: Array<PhotoModel>?
    
    private var titleLabel: UILabel?
    private var scrollView: UIScrollView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createMyNav()
        createScrollView()
        
    }
    
    func createScrollView() {
        scrollView = UIScrollView(frame: CGRectMake(0,200,kScreenWidth,300))
        view.addSubview(scrollView!)
        
        ProgressHUD.showOnView(view)
        
        let cnt = photoArray?.count
        let w = scrollView!.bounds.size.width
        let h = scrollView!.bounds.size.height
        for i in 0..<cnt! {
            let pModel = photoArray![i]
            let tmpImageView = UIImageView(frame: CGRectMake(kScreenWidth*CGFloat(i), 0, w, h))
            let url = NSURL(string: pModel.originalUrl!)
            
            if i != photoIndex!{
                tmpImageView.kf_setImageWithURL(url!)
            }else{
                tmpImageView.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) -> () in
                    
                    }, completionHandler: { (image, error, cacheType, imageURL) -> () in
                        ProgressHUD.hideOnView(self.view)
                })
            }
            scrollView?.addSubview(tmpImageView)
        }
        scrollView?.contentSize = CGSizeMake(w*CGFloat(cnt!), 0)
        scrollView?.pagingEnabled = true
        scrollView?.delegate = self
        scrollView?.contentOffset = CGPointMake(w*CGFloat(photoIndex!), 0)
    }
    
    func createMyNav() {
        let bgImageView = UIImageView(frame: CGRectMake(0, 20, kScreenWidth, 44))
        bgImageView.image = UIImage(named: "navigationbar")
        view.addSubview(bgImageView)
        
        let title = "第\(photoIndex!+1)页,共\((photoArray?.count)!)页"
        titleLabel = UILabel.createLabelFrame(CGRectMake(80, 0, 215, 44), title: title, textAlignment: .Center)
        bgImageView.addSubview(titleLabel!)
        
        let btn = UIButton.createBtn(CGRectMake(290, 4, 60, 36), title: "Done", bgImageName: "buttonbar_action", target: self, action: #selector(doneAction))
        bgImageView.addSubview(btn)
        bgImageView.userInteractionEnabled = true
        
    }
    func doneAction(){
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

//MARK: UIScrollView代理
extension PhotoViewController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let title = "第\(index+1)页,共\((photoArray?.count)!)页"
        titleLabel?.text = title
    }
}
