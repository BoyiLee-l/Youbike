//
//  Station.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import RealmSwift

class StationInfo: Codable {
    let retVal: [String: Station]
}

class Station: Object, Codable {
    
    @objc dynamic var name = ""                      // 站點名稱
    @objc dynamic var region = ""                    // 站點所在區域
    @objc dynamic var area = ""                      // 站點位置
    @objc dynamic var latitude = ""                  // 站點緯度
    @objc dynamic var longitude = ""                 // 站點經度
    @objc dynamic var totalParkingQuantity = ""      // 總停車格
    @objc dynamic var availableParkingCount = ""     // 站點空位數量
    @objc dynamic var availableBikeCount = ""        // 站點目前車輛數量
    @objc dynamic var updateTime = ""                // 站點資料更新時間
    
    @objc dynamic var isLike: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case name = "sna"
        case region = "sarea"
        case area = "ar"
        case latitude = "lat"
        case longitude = "lng"
        case totalParkingQuantity = "tot"
        case availableParkingCount = "bemp"
        case availableBikeCount = "sbi"
        case updateTime = "mday"
    }
}

extension Station {
    convenience init(station: Station) {
        self.init()
        
        self.name = station.name
        self.region = station.region
        self.area = station.area
        self.latitude = station.latitude
        self.longitude = station.longitude
        self.totalParkingQuantity = station.totalParkingQuantity
        self.availableParkingCount = station.availableParkingCount
        self.availableBikeCount = station.availableBikeCount
        self.updateTime = station.updateTime
    }
}

extension Station {
    static func allStation(in realm: Realm = try! Realm()) -> Results<Station> {
        return realm.objects(Station.self)
    }
    
    static func favoriteStation(in realm: Realm = try! Realm()) -> Results<Station> {
        return realm.objects(Station.self).filter("isLike = true")
    }
    
    func toggleLike(in realm: Realm = try! Realm()) {
        do {
            try realm.write {
                isLike = !isLike
            }
        } catch {
            print("Realm update error: \(error)")
        }
    }
    
    func save(in realm: Realm = try! Realm()) {
        do {
            try realm.write {
                realm.add(self)
            }
        } catch {
            print("Realm save error: \(error)")
        }
    }
}

class AllStation: Object {
    dynamic var stations = List<Station>()
    
    convenience init(stations: List<Station>) {
        self.init()
        
        self.stations = stations
    }
}

extension AllStation {
    func save(in realm: Realm = try! Realm()) {
        do {
            try realm.write {
                realm.add(self)
            }
        } catch {
            print("Realm save error: \(error)")
        }
    }
    
    func delete() {
        guard let realm = realm else {return}
        
        do {
            try realm.write {
                realm.delete(self)
            }
        } catch {
            print("Realm delete error: \(error)")
        }
    }
}

