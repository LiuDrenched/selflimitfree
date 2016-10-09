//
//  MainTabBarController.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/26.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //修改选中文字的颜色
        tabBar.tintColor = UIColor(red: 83.0/255.0, green: 156.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        //创建tabbar
        createViewControllers()
        
    }
    
    func createViewControllers() {
        
        //标题
        let titleArray = ["限免","降价","免费","专题","热榜"]
        //图片
        let imageArray = ["tabbar_limitfree","tabbar_reduceprice","tabbar_appfree","tabbar_subject","tabbar_rank"]
        //视图控制器
        let ctrlArray = ["self_LimitFree.LimitFreeViewController","self_LimitFree.ReduceViewController","self_LimitFree.FreeViewController","self_LimitFree.SubjectViewController","self_LimitFree.RankViewController"]
        
        var array = Array<UINavigationController>()
        for i in 0..<titleArray.count{
            //1)创建视图控制器
            let ctrlName = ctrlArray[i]
            let cls = NSClassFromString(ctrlName) as! UIViewController.Type
            let ctrl = cls.init()
            //2)图片和文字
            ctrl.tabBarItem.title = titleArray[i]
            let imageName = imageArray[i]
            ctrl.tabBarItem.image = UIImage(named: imageName)
            //选中图片
            ctrl.tabBarItem.selectedImage = UIImage(named: (imageName + "_press"))?.imageWithRenderingMode(.AlwaysOriginal)
            
            //3.导航
            let navCtrl = UINavigationController(rootViewController: ctrl)
            //navCtrl.navigationBar.setBackgroundImage(UIImage(named: "navigationbar"), forBarMetrics: .Default)
            //navCtrl.navigationBar.setBackgroundImage(UIImage(named: "navigationbar")?.stretchableImageWithLeftCapWidth(10, topCapHeight: 0), forBarMetrics: .Default)
            array.append(navCtrl)
        }
        viewControllers = array
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
