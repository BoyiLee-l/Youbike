//
//  Station.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import RealmSwift

//class StationInfo: Codable {
//    let retVal: [String: Station]
//}

class Station: Object, Codable {
    
    @objc dynamic var area : String = "" // 站點位置
    @objc dynamic var availableParkingCount : Int = 0 // 總停車格
    @objc dynamic var latitude : Double = 0.0 // 站點緯度
    @objc dynamic var longitude : Double = 0.0 // 站點經度
    @objc dynamic var mday : String = "" // 站點資料更新時間
    @objc dynamic var region : String = "" // 站點所在區域
    @objc dynamic var availableBikeCount : Int = 0 // 站點目前車輛數量
    @objc dynamic var name : String = "" // 站點名稱
    @objc dynamic var totalParkingQuantity : Int = 0 // 總停車格
    @objc dynamic var updateTime : String = ""

    @objc dynamic var isLike: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case area = "ar"
        case availableParkingCount = "bemp"
        case latitude = "lat"
        case longitude = "lng"
        case mday = "mday"
        case region = "sarea"
        case availableBikeCount = "sbi"
        case name = "sna"
        case totalParkingQuantity = "tot"
        case updateTime = "updateTime"
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

