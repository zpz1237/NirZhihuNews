//
//  zhihuNewsViewController.swift
//  zhihuNews
//
//  Created by Nirvana on 8/16/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class zhihuNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
        
        print(zdl().topItems.count)
        print("viewDidLoad")
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
    }
    
    func refreshData() {
        
        Alamofire.request(.GET, URLString: "http://news-at.zhihu.com/api/4/news/latest").responseJSON(completionHandler: { (_, _, data, error) -> Void in
            guard error == nil else {
                print("获取数据失败")
                return
            }
            let jsonTopStories = JSON(data!)["top_stories"]
            self.zdl().topItems.removeAll()
            
            for i in 0 ..< jsonTopStories.count {
                self.zdl().topItems.append((jsonTopStories[i]["image"].string!, String(jsonTopStories[i]["id"]), jsonTopStories[i]["title"].string!))
            }
            
            print(self.zdl().topItems.count)
            print("refreshData")
            
        })
        
    }
    
    func zdl() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cellHead = tableView.dequeueReusableCellWithIdentifier("headViewCell") as! HeadTableViewCell
            return cellHead
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("news") as! NewsTableViewCell
        cell.label.verticalAlignment = VerticalAlignmentTop
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height / 3
        }
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let color = UIColor(red: 0/255.0, green: 139/255.0, blue: 255/255.0, alpha: 1)
        let offsetY = scrollView.contentOffset.y
        if offsetY > 20 {
            let alpha = min(1, 1 - ((20 + 64 - offsetY) / 64))
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
        } else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.delegate = self
        self.scrollViewDidScroll(self.tableView)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

}

extension zhihuNewsViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(zdl().topItems.count)
        print("numberOfItem")
        return zdl().topItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PageCollectionViewCell
        
        let item = zdl().topItems[indexPath.item]
        cell.imageView.sd_setImageWithURL(NSURL(string: item.image))
        cell.label.text = item.label
        cell.label.verticalAlignment = VerticalAlignmentBottom
        
        return cell
    }
}

extension UINavigationController {
    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.topViewController
    }
}


