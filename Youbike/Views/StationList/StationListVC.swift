//
//  StationListVC.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class StationListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var stationListViewModel = StationListViewModel()
    private let stationService = StationService()
    
    private var itemsToken: NotificationToken?
    
    var spinner: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .medium
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setup()
        setupTableView()
        setupActivityView()
        requestStationData()
    }
    
    private func requestStationData() {
        guard let url = URL(string: baseURL) else { return }
        
        let resource = Resource<StationInfo>(url: url)
        
        startLoading()
        
        stationService.load(resource: resource) { [weak self] (stationInfo) in
            guard let stationInfo = stationInfo else {
                self?.popupAlert(title: "提示", message: "資料庫異常, 請稍後再試", actionTitles: ["確定"], actionStyle: [.default], action: [nil])
                return
            }
            print("stationInfo:\(stationInfo.retVal.count)")
            self?.saveToLocal(with: stationInfo)
           
            
            self?.stationListViewModel.allStations = Array(stationInfo.retVal.values)
            
            DispatchQueue.main.async {
                self?.stopLoading()
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    private func setup() {
        navigationItem.title = "Youbike 站點列表"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon-reload"), style: .done, target: self, action: #selector(reloadStation))
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.register(UINib(nibName: "StationCell", bundle: nil), forCellReuseIdentifier: "StationCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    private func setupActivityView() {
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    private func startLoading() {
        spinner.startAnimating()
        spinner.isHidden = false
    }
    
    private func stopLoading() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    @objc private func reloadStation() {
        requestStationData()
    }
    
    private func navigateToMap(stationVM: StationViewModel) {
        guard let latitude = stationVM.latitude, let logitude = stationVM.longitude else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = stationVM.name
        mapItem.openInMaps(launchOptions: nil)
    }
    
    private func saveToLocal(with stationInfo: StationInfo) {
        let allStations = List<Station>()
        
        for station in stationInfo.retVal.values {
            allStations.append(Station(station: station))
        }
        let allStation = AllStation(stations: allStations)
        
        allStation.save()
    }
}

extension StationListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationListViewModel.numberOfRowsInSection(with: .allList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell
        cell.stationVM = stationListViewModel.stationAtIndex(indexPath.row, with: .allList)
        return cell
    }
}

extension StationListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToMap(stationVM: stationListViewModel.stationAtIndex(indexPath.row, with: .allList))
    }
}
