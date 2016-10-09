//
//  CategoryViewController.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/28.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

protocol CategoryViewControllerDelegate: NSObjectProtocol {
    
    func didClickCate(cateId: String, cateName: String)
}

public enum CategoryType: Int{
    case LimitFree  //限免
    case Reduce     //降价
    case Free       //免费
}

class CategoryViewController: LFBaseViewController {
    
    //类型
    var type: CategoryType?
    //代理
    weak var delegate: CategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //修改表格的高度
        tbView?.frame.size.height = kScreenHeight-64
        
        //导航
        createMyNav()
        
    }
    
    //导航
    func createMyNav() {
        //返回按钮
        addBackButton()
        
        //标题文字
        var titleStr = ""
        if type == .LimitFree {
            titleStr = "限免-分类"
        }else if type == .Reduce {
            titleStr = "降价-分类"
        }else if type == .Free {
            titleStr = "免费-分类"
        }
        addNavTitle(titleStr)
    }
    
    override func downloadData() {
        ProgressHUD.showOnView(view)
        
        var urlString: String? = nil
        if type == .LimitFree{
            //限免
            urlString = kCategoryLimitUrl
        }else if type == .Reduce{
            //降价
            urlString = kCategoryReduceUrl
        }else if type == .Free{
            //免费
            urlString = kCategoryFreeUrl
        }
        if urlString != nil{
            let d = LFDownloader()
            d.delegate = self
            d.downloaderWithURLString(urlString!)
        }
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
extension CategoryViewController:LFDownloaderDelegete{
    func downloader(downloader: LFDownloader, didFailWithError error: NSError) {
        ProgressHUD.hideAfterFailOnView(view)
    }
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
//        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
//        print(str)
        //JSON解析
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary) {
            
            let dict = result as! Dictionary<String,AnyObject>
            let array = dict["category"] as! Array<Dictionary<String,AnyObject>>
            for cateDict in array {
                let cateId = cateDict["categoryId"]
                let cateIdStr = "\(cateId!)"
                if cateIdStr == "0" {
                    continue
                }
                let model = CategoryModel()
                model.setValuesForKeysWithDictionary(cateDict)
                dataArray.addObject(model)
            }
            //刷新表格
            dispatch_async(dispatch_get_main_queue(), {
                self.tbView?.reloadData()
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })
        }
    }
}

//MARK: UITableView代理
extension CategoryViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "categoryCellId"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CategoryCell
        
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("CategoryCell", owner: nil, options: nil).last as? CategoryCell
        }
        //显示数据
        let model = dataArray[indexPath.row] as! CategoryModel
        cell?.configModel(model, type: type!)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row] as! CategoryModel
        let cateId = "\(model.categoryId!)"
        let cateName = MyUtil.transferCateName(model.categoryName!)
        
        delegate?.didClickCate(cateId, cateName: cateName)
        
        navigationController?.popViewControllerAnimated(true)
    }
}
