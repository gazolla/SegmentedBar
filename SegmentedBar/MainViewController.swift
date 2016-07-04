//
//  MainViewController.swift
//  TableTest2
//
//  Created by Gazolla on 25/06/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let items = ["Gazolla", "Apple"]
    let urls = ["https://api.github.com/users/gazolla/repos", "https://api.github.com/users/apple/repos"]
    
    lazy var layout:UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .Horizontal
        l.minimumLineSpacing = 0
        return l
    }()
    
    lazy var collectionView:UICollectionView = {
        let cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        cv.autoresizingMask = [.FlexibleWidth, . FlexibleHeight]
        cv.backgroundColor = .whiteColor()
        cv.delegate = self
        cv.dataSource = self
        cv.registerClass(TableCollectionViewCell.self, forCellWithReuseIdentifier:"cell")
        cv.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        cv.scrollIndicatorInsets = UIEdgeInsetsMake(50,0,0,0)
        cv.pagingEnabled = true
        return cv
    }()
   
    
    func loadData(url:String, completion:(error:NSError?, items:[String]?)->Void){
        HTTP.GET(url) { (error, data) in
            var its:[String]=[]
            if error != nil {
                completion(error: error, items: nil)
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                for item in json as! [AnyObject]{
                    its.append(item["full_name"] as! String)
                }
            } catch let er as NSError {
                completion(error: er, items: nil)
            }
            dispatch_async(dispatch_get_main_queue(), {
                completion(error: nil, items: its)
            })
        }
    }

    
    lazy var segmentBar:SegmentedBar = {
        let y = self.navigationController!.navigationBar.bounds.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
        let frame = CGRect(x: 0, y: y, width: self.view.bounds.size.width, height: 50)
        print(frame)
        let segBar = SegmentedBar(frame: frame)
        return segBar
    
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List"
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.segmentBar)
        segmentBar.segment.addTarget(self, action: #selector(MainViewController.change(_:)), forControlEvents: .ValueChanged)
    }
    
    func change(sender:UISegmentedControl){
        let indexPath = NSIndexPath(forItem: segmentBar.segment.selectedSegmentIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let url = self.urls[indexPath.item]
        self.loadData(url) { (error, items) in
            (cell as! TableCollectionViewCell).items = items!
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.segmentBar.segment.selectedSegmentIndex = indexPath.item
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
    
        if (scrollView.contentOffset.x/self.view.bounds.width) == 0 {
            self.segmentBar.segment.selectedSegmentIndex = 0
        } else if (scrollView.contentOffset.x/self.view.bounds.width) == 1 {
            self.segmentBar.segment.selectedSegmentIndex = 1
        }
    }
    
    
}
