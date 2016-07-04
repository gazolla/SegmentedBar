//
//  TableCollectionViewCell.swift
//  SegmentedBar
//
//  Created by Gazolla on 04/07/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit

class TableCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource  {
 
    var items:[String] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    lazy var tableView:UITableView = {
        let tv = UITableView(frame: self.bounds, style: .Plain)
        tv.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tv.delegate = self
        tv.dataSource = self
        tv.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
       // tv.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.items = []
    }

    override func layoutSubviews() {
        self.tableView.frame = self.bounds
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }

}
