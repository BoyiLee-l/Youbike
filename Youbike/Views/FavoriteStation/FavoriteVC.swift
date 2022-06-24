//
//  FavoriteVC.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class FavoriteVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let stationListViewModel = StationListViewModel()
    
    private var itemsToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeFavoriteStation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        itemsToken?.invalidate()
    }
    
    private func setup() {
        navigationItem.title = "我的收藏站點"
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "StationCell", bundle: nil), forCellReuseIdentifier: "StationCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.bounces = false
    }
    
    private func observeFavoriteStation() {
        itemsToken = stationListViewModel.favoriteStations.observe({ [weak tableView] changes in
            guard let tableView = tableView else { return }
            
            switch changes {
            case .initial:
                print("initial")
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                print("update")
                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
            case .error: break
            }
        })
    }
    
    private func navigateToMap(stationVM: StationViewModel) {
        guard let latitude = stationVM.latitude, let logitude = stationVM.longitude else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = stationVM.name
        mapItem.openInMaps(launchOptions: nil)
    }
}

extension FavoriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationListViewModel.numberOfRowsInSection(with: .favorite)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell
        cell.stationVM = stationListViewModel.stationAtIndex(indexPath.row, with: .favorite)
        cell.stationStatus = .favorite
        return cell
    }
}

extension FavoriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToMap(stationVM: stationListViewModel.stationAtIndex(indexPath.row, with: .favorite))
    }
}
