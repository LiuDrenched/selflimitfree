//
//  DetailViewController.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/27.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

import CoreLocation

class DetailViewController: LFNavViewController {
    
    //应用的id
    var appId: String?
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nearByScrollView: UIScrollView!
    
    //详情的数据
    private var detailModel: DetailModel?
    //定位对象
    private var manager: CLLocationManager?
    //下载详情是否成功
    private var detailSuccess: Bool?
    //下载附近是否成功
    private var nearBySuccess: Bool?
    //是否已经下载附近数据
    private var isNearbyDownload: Bool?
    
    //分享
    @IBAction func shareAction() {}
    //收藏
    @IBAction func favoriteAction() {}
    //下载
    @IBAction func downloadAction() {}
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ProgressHUD.showOnView(view)
        //下载详情数据
        downloadDetailData()
        //定位
        locate()
        
        //导航
        createMyNav()
    }
    
    //定位
    func locate() {
        manager = CLLocationManager()
        manager?.distanceFilter = 10
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        //请求定位
        if manager?.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)) == true {
            manager?.requestWhenInUseAuthorization()
        }
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    
    //导航
    func createMyNav() {
        addNavTitle("应用详情")
        
        //返回按钮
        addBackButton()
    }
    
    //下载详情数据
    func downloadDetailData() {
        let urlString = String(format: kDetailUrl, appId!)
        let d = LFDownloader()
        d.delegate = self
        d.type = .Detail
        d.downloaderWithURLString(urlString)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //显示详情数据
    func showDetail() {
        let url = NSURL(string: (detailModel?.iconUrl)!)
        appImageView.kf_setImageWithURL(url!)
        
        nameLabel.text = detailModel?.name
        
        lastPriceLabel.text = "原价:"+(detailModel?.lastPrice)!
        
        if detailModel?.priceTrend == "limited"{
            statusLabel.text = "限免中"
        }
        
        sizeLabel.text = (detailModel?.fileSize)! + "MB"
        
        categoryLabel.text = MyUtil.transferCateName((detailModel?.categoryName)!)
        
        rateLabel.text = "评分:"+(detailModel?.starCurrent)!
        
        let cnt = detailModel?.photos?.count
        let imageH: CGFloat = 80
        let imageW: CGFloat = 80
        let marginX: CGFloat = 10
        for i in 0..<cnt!{
            let frame = CGRectMake((imageW+marginX)*CGFloat(i), 0, imageW, imageH)
            let tmpImageView = UIImageView(frame: frame)
            
            let pModel = detailModel?.photos![i]
            let url = NSURL(string: (pModel?.smallUrl)!)
            tmpImageView.kf_setImageWithURL(url!)
            
            let g = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
            tmpImageView.userInteractionEnabled = true
            tmpImageView.addGestureRecognizer(g)
            tmpImageView.tag = 100+i
            
            imageScrollView.addSubview(tmpImageView)
        }
        
        imageScrollView.contentSize = CGSizeMake((imageW+marginX)*CGFloat(cnt!), 0)
        descLabel.text = detailModel?.desc
    }
    
    func tapImage(g: UIGestureRecognizer){
        let index = (g.view?.tag)! - 100
        
        let photoCtrl = PhotoViewController()
        photoCtrl.modalTransitionStyle = .FlipHorizontal
        photoCtrl.photoIndex = index
        photoCtrl.photoArray = detailModel?.photos
        
        presentViewController(photoCtrl, animated: true, completion: nil)
    }
    //详情的解析
    func parseDetailData(data: NSData) {
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary) {
            let dict = result as! Dictionary<String,AnyObject>
            detailModel = DetailModel()
            detailModel?.setValuesForKeysWithDictionary(dict)
            var pArray = Array<PhotoModel>()
            
            for pDict in (dict["photos"] as! NSArray) {
                let model = PhotoModel()
                model.setValuesForKeysWithDictionary(pDict as! [String : AnyObject])
                pArray.append(model)
            }
            detailModel?.photos = pArray
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.showDetail()
            })
        }
    }
    
    func parseNearByData(data: NSData) {
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        
        if result.isKindOfClass(NSDictionary){
            let dict = result as! Dictionary<String,AnyObject>
            let array = dict["applications"] as! Array<Dictionary<String,AnyObject>>
            
            var modelArray = Array<LimitModel>()
            for appDict in array {
                let model = LimitModel()
                model.setValuesForKeysWithDictionary(appDict)
                modelArray.append(model)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.showNearData(modelArray)
            })
        }
    }

    
    func showNearData(array: Array<LimitModel>) {
        let btnW: CGFloat = 60
        let btnH: CGFloat = 80
        let marginX: CGFloat = 10
        for i in 0..<array.count {
            let model = array[i]
            let btn = NearbyButton(frame: CGRectMake((btnW+marginX)*CGFloat(i),0,btnW,btnH))
            btn.addTarget(self, action: #selector(clickBtn(_:)), forControlEvents: .TouchUpInside)
            btn.model = model
            nearByScrollView.addSubview(btn)
        }
        nearByScrollView.contentSize = CGSizeMake((btnW+marginX)*CGFloat(array.count), 0)
    }
    
    func clickBtn(btn: NearbyButton){
        let detailCtrl = DetailViewController()
        detailCtrl.appId = btn.model?.applicationId
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailCtrl, animated: true)
    }
    
}

//MARK: LFDownloader代理
extension DetailViewController: LFDownloaderDelegete{
    func downloader(downloader: LFDownloader, didFailWithError error: NSError) {
        if downloader.type == .Detail {
            detailSuccess = false
        }else if downloader.type == .NearBy {
            nearBySuccess = false
        }
        
        //两个都失败
        if detailSuccess == false && nearBySuccess == false {
            dispatch_async(dispatch_get_main_queue(), {
              ProgressHUD.hideAfterFailOnView(self.view)
            })
        }
    }
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        if downloader.type == .Detail {
            
            self.parseDetailData(data)
            detailSuccess = true
        }else if downloader.type == .NearBy {
            self.parseNearByData(data)
            nearBySuccess = true
        }
        //如果两个都是失败，就是失败
        if detailSuccess == false && nearBySuccess == false {
            
        }else{
            dispatch_async(dispatch_get_main_queue(), {
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })
        }
    }
}

//MARK: CLLocationManager代理
extension DetailViewController:CLLocationManagerDelegate{
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last
        
        if loc?.coordinate.latitude != nil && loc?.coordinate.longitude != nil || (isNearbyDownload != true) {
            let urlString = String(format: kNearByUrl, (loc?.coordinate.longitude)!,(loc?.coordinate.latitude)!)
            let d = LFDownloader()
            d.delegate = self
            d.type = .NearBy
            
            d.downloaderWithURLString(urlString)
            
            manager.stopUpdatingLocation()
            isNearbyDownload = true
        }
    }
}
