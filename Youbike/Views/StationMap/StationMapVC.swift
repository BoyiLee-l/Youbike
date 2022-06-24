//
//  StationMapVC.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StationMapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private let stationService = StationService()
    private var stationListViewModel  = StationListViewModel()
    private var locationManager = CLLocationManager()
    
    var lastLocation = CLLocation() {
        didSet {
            let latitude = lastLocation.coordinate.latitude
            let longitude = lastLocation.coordinate.longitude
            
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        }
    }
    
    private let customView = Bundle.main.loadNibNamed("CustomCallOutView", owner: self, options: nil)?.first as! CustomCallOutView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        setupMap()
        startUpdateLocation()
        requestStationData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAnnotations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        customView.removeFromSuperview()
    }
    
    private func setup() {
        navigationItem.title = "附近站點位置"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon-reload"), style: .done, target: self, action: #selector(reloadStation))
    }
    
    private func setupMap() {
        mapView.isRotateEnabled = false  // 地圖選轉是否開啟
        mapView.isPitchEnabled = false   // 是否能斜視地圖，不過要先 check 是否支援3D
        mapView.showsUserLocation = true // 顯示目前位置
        mapView.delegate = self
    }
    
    private func startUpdateLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 100.0
            locationManager.startUpdatingLocation()
        }
    }
    
    private func addAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        let stationList = stationListViewModel.allStations
        
        for station in stationList {
            let stationVM = StationViewModel(station)
            let annotation = MyCustomPointAnnotation()
            
            guard let lat = stationVM.latitude else {continue}
            guard let lng = stationVM.longitude else {continue}
            
            annotation.stationVM = stationVM
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            //print("\(lat),\(lng)")
            mapView.addAnnotation(annotation)
        }
    }
    
    private func requestStationData() {
        guard let url = URL(string: baseURL) else { return }
        
        let resource = Resource<StationInfo>(url: url)
        
        stationService.load(resource: resource) { [weak self] (stationInfo) in
            guard let stationInfo = stationInfo else {
                self?.popupAlert(title: "提示", message: "資料庫異常, 請稍後再試", actionTitles: ["確定"], actionStyle: [.default], action: [nil])
                return
            }
            
            self?.stationListViewModel.allStations = Array(stationInfo.retVal.values)
            
            DispatchQueue.main.async {
                self?.addAnnotations()
            }
        }
    }
    
    @objc private func reloadStation() {
        requestStationData()
    }

}

extension StationMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {return}
        
        self.lastLocation = lastLocation
        print("lsat: \(lastLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopUpdatingLocation()
            print(error.localizedDescription)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            manager.stopUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdateLocation()
        default:
            return
        }
    }
}

extension StationMapVC: MKMapViewDelegate {
    
    // MARK: - 顯示 Annotation
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MyCustomPointAnnotation.self) {
            let customeAnnotation = CustomPinAnnotation(annotation: annotation, reuseIdentifier: "Custom") 
            return customeAnnotation
        }

        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Marker") as? MKMarkerAnnotationView
        
        annotationView?.annotation = annotation
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didselect")
        let region = mapView.region
        
        self.view.addSubview(customView)
        
        
        customView.anchor(top: nil, leading: self.view.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.view.trailingAnchor, size: CGSize(width: 0, height: 0))
        
        if let annotView = view as? CustomPinAnnotation{
            customView.stationVM = annotView.stationVM
        }
        let coordinate = view.annotation!.coordinate
        
        let newRegion = MKCoordinateRegion(center: coordinate, span: region.span)
        mapView.setRegion(newRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        customView.removeFromSuperview()
    }
}
