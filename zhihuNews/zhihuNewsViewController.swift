//
//  zhihuNewsViewController.swift
//  zhihuNews
//
//  Created by Nirvana on 8/16/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class zhihuNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    let items: [(image: String, label: String)] = [
        ("1", "NASA黎明号团队唯一会讲中文的人说"),
        ("2", "这里展示的是获得的文章标题是两行文字的情况"),
        ("3", "The third image from space"),
        ("4", "The fourth image from space"),
        ("5", "The fifth image from space")]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
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
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PageCollectionViewCell
        let item = items[indexPath.item]
        cell.imageView.image = UIImage(named: item.image)
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


