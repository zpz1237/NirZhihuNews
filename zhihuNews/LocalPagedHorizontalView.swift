//
//  LocalPagedHorizontalView.swift
//  zhihuNews
//
//  Created by Nirvana on 8/22/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class LocalPagedHorizontalView: UIView {
    
    var timer: NSTimer?
    var direction = 1
    var selectedItem: Int?
    
    /// Represents the page control property.
    @IBOutlet weak var pageControl: UIPageControl? {
        didSet {
            pageControl?.addTarget(self, action: "pageChanged:", forControlEvents: .ValueChanged)
        }
    }
    
    /// Represents the next button property.
    @IBOutlet weak var nextButton: UIButton? {
        didSet {
            nextButton?.addTarget(self, action: "goToNextPage:", forControlEvents: .TouchUpInside)
        }
    }
    
    /// Represents the previous button property.
    @IBOutlet weak var previousButton: UIButton? {
        didSet {
            previousButton?.addTarget(self, action: "goToPreviousPage:", forControlEvents: .TouchUpInside)
        }
    }
    
    /// Represents the collection view property.
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            assert(collectionView.collectionViewLayout is UICollectionViewFlowLayout,
                "collectionViewLayout should be of type 'UICollectionViewFlowLayout'")
            let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.scrollDirection = .Horizontal
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: "nextPage", userInfo: nil, repeats: true)
            
            collectionView.pagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.delegate = self
        }
    }
    
    /// whether or not dragging has ended
    private var endDragging = false
    
    /// the current page
    dynamic var currentIndex: Int = 0 {
        didSet {
            updateAccessoryViews()
        }
    }
    
    /**
    Currnet page changed.
    
    :param: sender the page control of the action.
    */
    @IBAction func pageChanged(sender: UIPageControl) {
        moveToPage(sender.currentPage, animated: true)
    }
    
    /**
    Go to next page.
    
    :param: sender The sender of the action parameter.
    */
    @IBAction func goToNextPage(sender: AnyObject) {
        moveToPage(currentIndex + 1, animated: true)
    }
    
    /**
    Go to previous page.
    
    :param: sender The sender of the action parameter.
    */
    @IBAction func goToPreviousPage(sender: AnyObject) {
        moveToPage(currentIndex - 1, animated: true)
    }
    
    /**
    Move to a specific page.
    
    :param: page     The page parameter.
    :param: animated The animated parameter to control whether the transition should be animated or not.
    */
    func moveToPage(page: Int, animated: Bool) {
        // outside the range
        if page < 0 || page >= collectionView.numberOfItemsInSection(0) {
            return
        }
        
        currentIndex = page
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: currentIndex, inSection: 0),
            atScrollPosition: .Left, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.performBatchUpdates(nil, completion: nil)
        moveToPage(currentIndex, animated: false)
    }
    
    /**
    Update accessory views (i.e. UIPageControl, UIButtons).
    */
    func updateAccessoryViews() {
        pageControl?.numberOfPages = collectionView.numberOfItemsInSection(0)
        pageControl?.currentPage = currentIndex
        nextButton?.enabled = currentIndex < collectionView.numberOfItemsInSection(0) - 1
        previousButton?.enabled = currentIndex > 0
    }
}


extension LocalPagedHorizontalView : UICollectionViewDelegateFlowLayout {
    
    /**
    size of the collection view
    
    :param: collectionView the collection view
    :param: collectionViewLayout the collection view flow layout
    :param: indexPath the index path
    */
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return collectionView.bounds.size
    }
    
    /**
    scroll view did end dragging
    
    :param: scrollView the scroll view
    :param: decelerate wether the view is decelerating or not.
    */
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            endScrolling(scrollView)
        } else {
            endDragging = true
        }
    }
    
    func nextPage() {
        if currentIndex == (collectionView.numberOfItemsInSection(0) - 1) {
            direction = -1
        } else if currentIndex == 0 {
            direction = 1
        }
        moveToPage(currentIndex + direction, animated: true)
    }
    
    /**
    Scroll view did end decelerating
    */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if endDragging {
            endDragging = false
            endScrolling(scrollView)
        }
    }
    
    /**
    end scrolling
    */
    private func endScrolling(scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let page = (scrollView.contentOffset.x + (0.5 * width)) / width
        currentIndex = Int(page)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyBoard.instantiateViewControllerWithIdentifier("webViewController") as!DetailViewController
        selectedItem = indexPath.item
        detailViewController.dataSource = self
        (self.window?.rootViewController as! UINavigationController).pushViewController(detailViewController, animated: true)
        
        print(indexPath.item)
    }
}

extension LocalPagedHorizontalView: DetailViewControllerDataSource {
    
    func zdl() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func newsId() -> String! {
        return zdl().topItems[selectedItem!].id
    }
}

