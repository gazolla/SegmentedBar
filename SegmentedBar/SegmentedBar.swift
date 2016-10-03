//
//  SegmentedControl.swift
//  Segmented
//
//  Created by Gazolla on 25/06/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit

class SegmentedBar:UIView {
    
    lazy var segment:UISegmentedControl = {
        let items = ["Gazolla", "Apple"]
        let s = UISegmentedControl(items: items)
        s.selectedSegmentIndex = 0
        s.layer.cornerRadius = 5.0  
        return s
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        self.addSubview(self.segment)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let height = self.bounds.size.height * 0.65
        let width = self.bounds.size.width * 0.65
        let x = (self.bounds.size.width - width) / 2
        let y = (self.bounds.size.height - height)/2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        print(frame)
        segment.frame = frame
    }
    
    
}
