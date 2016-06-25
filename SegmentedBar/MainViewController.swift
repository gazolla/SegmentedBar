//
//  MainViewController.swift
//  TableTest2
//
//  Created by Gazolla on 25/06/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var items:[String] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    func loadData(url:String){
        HTTP.GET(url) { (error, data) in
            var its:[String]=[]
            if error != nil {
                print(error)
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                for item in json as! [AnyObject]{
                    its.append(item["full_name"] as! String)
                }
            } catch  {
                print(error)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.items = its
            })
        }
    }

    
    lazy var segmentBar:SegmentedBar = {
        let y = self.navigationController!.navigationBar.bounds.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
        let frame = CGRect(x: 0, y: y, width: self.view.bounds.size.width, height: 50)
        let segBar = SegmentedBar(frame: frame)
        return segBar
    
    }()
    
    
    lazy var tableView:UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .Plain)
        tv.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tv.delegate = self
        tv.dataSource = self
        tv.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
        tv.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List"
        self.view.addSubview(self.tableView)
        self.view.addSubview(segmentBar)
        segmentBar.segment.addTarget(self, action: #selector(MainViewController.change(_:)), forControlEvents: .ValueChanged)
        loadData("https://api.github.com/users/gazolla/repos")
    }
    
    func change(sender:UISegmentedControl){
        if segmentBar.segment.selectedSegmentIndex == 0 {
            loadData("https://api.github.com/users/gazolla/repos")
        } else if segmentBar.segment.selectedSegmentIndex == 1 {
            loadData("https://api.github.com/users/apple/repos")
        }
    }
}

extension MainViewController:UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
}
