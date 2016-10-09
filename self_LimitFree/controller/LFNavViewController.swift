//
//  LFNavViewController.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/26.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

class LFNavViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
    }
    
    func addNavTitle(title: String){
        let label = UILabel.createLabelFrame(CGRectMake(0, 0, 215, 44), title: title, textAlignment: .Center)
        label.font = UIFont.boldSystemFontOfSize(24)
        label.textColor = UIColor(red: 58.0/255.0, green: 95.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        navigationItem.titleView = label
    }
    
    func addNavButton(title: String, target: AnyObject?, action: Selector, isLeft: Bool) {
        
        addNavButton(title, target: target, action: action, isLeft: isLeft, imageName: "buttonbar_action")
    }
    
    private func addNavButton(title: String, target: AnyObject?, action: Selector, isLeft: Bool, imageName: String) {
        
        let btn = UIButton.createBtn(CGRectMake(0, 0, 60, 36), title: title, bgImageName: imageName, target: target, action: action)
        let barButton = UIBarButtonItem(customView: btn)
        if isLeft {
            //左边
            navigationItem.leftBarButtonItem = barButton
        }else{
            navigationItem.rightBarButtonItem = barButton
        }
    }
    
    //添加返回按钮
    func addBackButton() {
        //addNavButton("返回", target: self, action: "backAction", isLeft: true, imageName: "buttonbar_back")
        addNavButton("返回", target: self, action: #selector(backAction), isLeft: true, imageName: "buttonbar_back")
    }
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
