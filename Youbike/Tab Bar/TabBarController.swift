//
//  TabBarController.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    init(itemTypes: [TabBarItemType]) {
        
        super.init(nibName: nil, bundle: nil)
        
        let viewControllers: [UIViewController] = itemTypes.map(
            TabBarController.prepare
        )
        
        setViewControllers(viewControllers, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func prepare(for itemType: TabBarItemType) -> UIViewController {
        switch itemType {
            
        case .stationList:
            let mainPageVC = StationListVC()
            let nav = UINavigationController(rootViewController: mainPageVC)
            nav.tabBarItem = TabBarItem(itemType: itemType)
            
            return nav
            
        case .stationMap:
            
            let analysisVC = StationMapVC()
            let nav = UINavigationController(rootViewController: analysisVC)
            nav.tabBarItem = TabBarItem(itemType: itemType)
            return nav
        case .favoriteStation:
            let yellowPages = FavoriteVC()
            let nav = UINavigationController(rootViewController: yellowPages)
            nav.tabBarItem = TabBarItem(itemType: itemType)
            
            return nav
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
}
