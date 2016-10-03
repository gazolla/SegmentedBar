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
        l.scrollDirection = .horizontal
        l.minimumLineSpacing = 0
     //   l.itemSize = self.collectionView.bounds.size
        return l
    }()
    
    lazy var collectionView:UICollectionView = {
        let cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        cv.autoresizingMask = [.flexibleWidth, . flexibleHeight]
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(TableCollectionViewCell.self, forCellWithReuseIdentifier:"cell")
        cv.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        cv.scrollIndicatorInsets = UIEdgeInsetsMake(50,0,0,0)
        cv.isPagingEnabled = true
        
        return cv
    }()
   
    
    func loadData(_ url:String, completion:@escaping (_ error:Error?, _ items:[String]?)->Void){
        HTTP.GET(url) { (error, data) in
            var its:[String]=[]
            if error != nil {
                completion(error, nil)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                for item in json as! [AnyObject]{
                    its.append(item["full_name"] as! String)
                }
            } catch let er as NSError {
                completion(er, nil)
            }
            DispatchQueue.main.async(execute: {
                completion(nil, its)
            })
        }
    }

    
    lazy var segmentBar:SegmentedBar = {
        let y = self.navigationController!.navigationBar.bounds.size.height + UIApplication.shared.statusBarFrame.size.height
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
        segmentBar.segment.addTarget(self, action: #selector(MainViewController.change(_:)), for: .valueChanged)
    }
    
    func change(_ sender:UISegmentedControl){
        let indexPath = IndexPath(item: segmentBar.segment.selectedSegmentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let url = self.urls[(indexPath as NSIndexPath).item]
        self.loadData(url) { (error, items) in
            if let items = items {
                (cell as! TableCollectionViewCell).items = items
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let adjust =    self.navigationController!.navigationBar.bounds.height +
                        self.segmentBar.bounds.height +
                        UIApplication.shared.statusBarFrame.height
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height - adjust)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.segmentBar.segment.selectedSegmentIndex = (indexPath as NSIndexPath).item
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = (scrollView.contentOffset.x/self.view.bounds.width).truncatingRemainder(dividingBy: 1) == 0
        if position {
            self.segmentBar.segment.selectedSegmentIndex = Int(scrollView.contentOffset.x/self.view.bounds.width)
        }
    
    }
    
    
}
