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
        let tv = UITableView(frame: self.bounds, style: .plain)
        tv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.items[(indexPath as NSIndexPath).row]
        return cell
    }

}
