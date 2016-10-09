//
//  LFDownloader.swift
//  self_LimitFree
//
//  Created by 千锋 on 16/9/26.
//  Copyright © 2016年 Alex. All rights reserved.
//

import UIKit

//下载的类型
public enum DownloadType: Int{
    case Default    //默认值
    case Detail     //详情数据
    case NearBy     //详情页的附近
}

protocol LFDownloaderDelegete: NSObjectProtocol {
    //下载失败
    func downloader(downloader: LFDownloader,didFailWithError error:NSError)
    //下载成功
    func downloader(downloader: LFDownloader,didFinishWithData data:NSData)
}


class LFDownloader: NSObject {
    //下载类型
    var type: DownloadType = .Default
    
    weak var delegate: LFDownloaderDelegete?
    
    func downloaderWithURLString(urlString: String) {
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let tmpError = error {
                
                self.delegate?.downloader(self, didFailWithError: tmpError)
                
            }else{
                let httpResponse = response as! NSHTTPURLResponse
                if httpResponse.statusCode == 200 {
                    //下载成功
                    self.delegate?.downloader(self, didFinishWithData: data!)
                }else{
                    //下载失败
                    let err = NSError(domain: urlString, code: httpResponse.statusCode, userInfo: ["msg":"下载失败"])
                    self.delegate?.downloader(self, didFailWithError: err)
                }
            }
        }
        //开启下载
        task.resume()
    }
}
