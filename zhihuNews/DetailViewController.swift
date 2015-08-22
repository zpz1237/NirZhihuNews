//
//  DetailViewController.swift
//  zhihuNews
//
//  Created by Nirvana on 8/21/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol DetailViewControllerDataSource {
    func newsId() -> String!
}

class DetailViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var dataSource: DetailViewControllerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        Alamofire.request(.GET, URLString: "http://news-at.zhihu.com/api/4/news/"+self.dataSource!.newsId()).responseJSON(completionHandler: { (_, _, data, error) -> Void in
            let url = JSON(data!)["share_url"].string
            
            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: (url)!)!))
            
        })
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
