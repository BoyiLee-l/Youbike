//
//  StationViewModel.swift
//  YoubikeDemo
//
//  Created by Jack on 7/3/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation

enum StationStatus{
    case allList
    case favorite
}

class StationListViewModel {
    var allStations: [Station] = []
    let favoriteStations = Station.favoriteStation()
}

extension StationListViewModel {
    var numberOfSection: Int {
        return 1
    }
    
    func numberOfRowsInSection(with status: StationStatus) -> Int {
        return (status == .allList) ? allStations.count : favoriteStations.count
    }
    
    func stationAtIndex(_ index: Int, with status: StationStatus) -> StationViewModel {
        let station = (status == .allList) ? allStations[index] : favoriteStations[index]
        return StationViewModel(station)
    }
}

class StationViewModel {
    private let station: Station
    
    init(_ station: Station) {
        self.station = station
    }
}

extension StationViewModel {
    var isLike: Bool {
        return station.isLike
    }
    
    var name: String {
        return station.name
    }
    
    var region: String {
        return station.region
    }
    
    var addressDescription: String {
        return "地址 : \(station.area)"
    }
    
    var latitude: Double? {
        return Double(station.latitude)
    }
    
    var longitude: Double? {
        return Double(station.longitude)
    }
    
    var totalParkingCount: String {
        return station.totalParkingQuantity
    }
    
    var availableParkingCount: String {
        return station.availableParkingCount
    }
    
    var availableBikeCount: String {
        return station.availableBikeCount
    }
    
    var updateTimeDescription: String {
        return "資料更新時間: \(station.updateTime.convertDetailToDate.convertDateString)"
    }
}

extension StationViewModel {
    func toggleLike() {
        station.toggleLike()
    }
}
