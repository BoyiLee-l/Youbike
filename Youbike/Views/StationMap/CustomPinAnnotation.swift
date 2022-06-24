//
//  CustomCallOutView.swift
//  YoubikeDemo
//
//  Created by Jack on 7/3/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import MapKit

class CustomPinAnnotation: MKAnnotationView {
    
    var stationVM: StationViewModel!
    
    var bikeAvailableCountLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: -30, width: 30, height: 30))
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        return label
    } ()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        setup(with: annotation)
    }
    
    private func setup(with annotation: MKAnnotation?) {
        image = #imageLiteral(resourceName: "Icon_bikeParking-Small")
        canShowCallout = true
        displayPriority = .defaultHigh
        
        addSubview(bikeAvailableCountLabel)
        
        let annotation = annotation as! MyCustomPointAnnotation
        stationVM = annotation.stationVM
        bikeAvailableCountLabel.text = annotation.stationVM.availableBikeCount
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
