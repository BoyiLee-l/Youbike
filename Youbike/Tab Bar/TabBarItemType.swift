//
//  TabBarItemType.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit

enum TabBarItemType {
    case stationList
    case stationMap
    case favoriteStation
}

extension TabBarItemType {
    
    var image: UIImage {
        switch self {
        case .stationList:
            
            return #imageLiteral(resourceName: "tabIcon_bikeParking")
            
        case .stationMap:
            
            return #imageLiteral(resourceName: "tabIcon_bikeLocate")
            
        case .favoriteStation:
            
            return #imageLiteral(resourceName: "tabIcon_selectedFavorite")
            
        }
    }
    
//    var selectedImage: UIImage? {
//        switch self {
//
//        case .stationList:
//
//            return #imageLiteral(resourceName: "Icon_bikeParking-Small")
//
//        case .stationLocation:
//
//            return #imageLiteral(resourceName: "tabIcon_bikeParking")
//
//        case .favoriteStation:
//
//            return #imageLiteral(resourceName: "tabIcon_selectedFavorite")
//
//        }
//    }
}

