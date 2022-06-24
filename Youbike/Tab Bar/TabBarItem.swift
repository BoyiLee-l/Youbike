//
//  TabBarItem.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation

import UIKit

class TabBarItem: UITabBarItem {
    
    var itemType: TabBarItemType?
    
    init(itemType: TabBarItemType) {
        
        super.init()
        
        self.itemType = itemType
        
        self.title = ""
        
        self.image = itemType.image
        
        //self.selectedImage = itemType.selectedImage
        
        // 調整tabBar icon位置
        self.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
}
