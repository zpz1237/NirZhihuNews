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
    
    var selectedItem: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshData()

        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
    }
    
    func refreshData() {
        
        Alamofire.request(.GET, URLString: "http://news-at.zhihu.com/api/4/news/latest").responseJSON(completionHandler: { (_, _, data, error) -> Void in
            guard error == nil else {
                print("获取数据失败")
                return
            }
            let json = JSON(data!)
            let jsonTopStories = json["top_stories"]
            let jsonDetailStories = json["stories"]
            
            self.zdl().topItems.removeAll()
            self.zdl().detailItems.removeAll()
            
            for i in 0 ..< jsonTopStories.count {
                self.zdl().topItems.append((jsonTopStories[i]["image"].string!, String(jsonTopStories[i]["id"]), jsonTopStories[i]["title"].string!))
            }
            
            for i in 0 ..< jsonDetailStories.count {
                self.zdl().detailItems.append((jsonDetailStories[i]["images"][0].string!, String(jsonDetailStories[i]["id"]), jsonDetailStories[i]["title"].string!))
            }
            
            print(self.zdl().detailItems.count)
            print("refreshDataDetailItems")
            
            print(self.tableView.visibleCells.count)
            print("self.tableView.visibleCells.count")
            (self.tableView.visibleCells[0] as! HeadTableViewCell).pageView.collectionView.reloadData()
            self.tableView.reloadData()
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
        
        let item = zdl().detailItems[indexPath.item-1]
        
        cell.newsImage.sd_setImageWithURL(NSURL(string: item.images))
        cell.label.text = item.label
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
        print(zdl().detailItems.count)
        print("numberOfItemInTableView")
        //return 20
        return zdl().detailItems.count + 1
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let color = UIColor(red: 0/255.0, green: 139/255.0, blue: 255/255.0, alpha: 1)
        let offsetY = scrollView.contentOffset.y
        if offsetY > 30 {
            let alpha = min(1, 1 - ((30 + 64 - offsetY) / 64))
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
        } else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.delegate = self
        self.scrollViewDidScroll(self.tableView)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            return
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = storyBoard.instantiateViewControllerWithIdentifier("webViewController") as!DetailViewController
            selectedItem = indexPath.row - 1
            detailViewController.dataSource = self
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

}

extension zhihuNewsViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(zdl().topItems.count)
        //print("numberOfItem")
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
    public override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.topViewController
    }
}

extension zhihuNewsViewController : DetailViewControllerDataSource {
    func newsId() -> String! {
        print(selectedItem)
        print("selectedItem")
        return zdl().detailItems[selectedItem!].id
    }
}


