//
//  AppDelegate.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        initSetup()
        
        
//        let navigationBarColor =  UINavigationBar.appearance()
//        navigationBarColor.barTintColor = .lightBlue
//        navigationBarColor.tintColor = .black
//        navigationBarColor.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        return true
    }
    
    private func initSetup() {
        UINavigationBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().tintColor = UIColor.black
        
        let mainTabBar = TabBarController(itemTypes: [.stationList, .stationMap, .favoriteStation])
        
        window =  UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = mainTabBar
        window?.makeKeyAndVisible()
    }
    
}

