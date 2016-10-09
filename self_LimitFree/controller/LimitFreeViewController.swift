//
//  LimitFreeViewController.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/26.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

class LimitFreeViewController: LFBaseViewController {
    
    //分页的类型
    private var cateId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view.backgroundColor = UIColor.brownColor()
        
        //导航
        createMyNav()
        
        //分页
        addRefresh()
    }
    
    //下载
    override func downloadData() {
        //进入加载状态
        ProgressHUD.showOnView(view)
        
        var urlString = String(format: kLimitUrl, curPage)
        if cateId != nil{
            //有分类
            urlString = urlString.stringByAppendingString("&category_id=\(cateId!)")
        }
        let d = LFDownloader()
        d.delegate = self
        d.downloaderWithURLString(urlString)
    }
    
    //创建导航
    func createMyNav() {
        //分类
        //addNavButton("分类", target: self, action: "gotoCategory", isLeft: true)
        addNavButton("分类", target: self, action: #selector(gotoCategory), isLeft: true)
        //标题
        addNavTitle("限免")
        //设置
        //addNavButton("设置", target: self, action: "gotoSetPage", isLeft: false)
        addNavButton("设置", target: self, action: #selector(gotoSetPage), isLeft: false)
        
    }
    //分类
    func gotoCategory() {
        
        let cateCtrl = CategoryViewController()
        cateCtrl.type = .LimitFree
        //代理
        cateCtrl.delegate = self
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cateCtrl, animated: true)
        hidesBottomBarWhenPushed = false
        
    }
    func gotoSetPage() {
        
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

//MARK: LFDownloader代理
extension LimitFreeViewController: LFDownloaderDelegete{
    
    //下载失败
    func downloader(downloader: LFDownloader, didFailWithError error: NSError) {
        ProgressHUD.hideAfterFailOnView(view)
    }
    //下载成功
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        if curPage == 1{
            dataArray.removeAllObjects()
        }
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary) {
            
            let dict = result as! Dictionary<String,AnyObject>
            let array = dict["applications"] as! Array<Dictionary<String,AnyObject>>
            for appDict in array {
                //闯将模型对象
                let model = LimitModel()
                //KVC
                model.setValuesForKeysWithDictionary(appDict)
                dataArray.addObject(model)
            }
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), { 
                self.tbView?.reloadData()
                
                self.tbView?.headerView?.endRefreshing()
                self.tbView?.footerView?.endRefreshing()
                
                ProgressHUD.hideAfterSuccessOnView(self.view)
                
            })
        }
    }
}


//MARK: UITableView代理
extension LimitFreeViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "limitCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? LimitCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("LimitCell", owner: nil, options: nil).last as? LimitCell
        }
        cell?.selectionStyle = .None
        
        let model = dataArray[indexPath.row] as! LimitModel
        cell?.config(model, atIndex: indexPath.row+1)
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailCtrl = DetailViewController()
        let model = dataArray[indexPath.row] as! LimitModel
        detailCtrl.appId = model.applicationId
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailCtrl, animated: true)
        hidesBottomBarWhenPushed = false
    }
}

//MARK: CategoryViewController代理
extension LimitFreeViewController: CategoryViewControllerDelegate {
    
    func didClickCate(cateId: String, cateName: String) {
        //1.标题文字
        var titleStr = "限免-"+cateName
        if cateName == "全部"{
            titleStr = "限免"
        }
        addNavTitle(titleStr)
        //2.重新下载数据
        self.cateId = cateId
        
        curPage = 1
        downloadData()
    }
}


