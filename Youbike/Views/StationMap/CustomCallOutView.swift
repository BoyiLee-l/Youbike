//
//  CustomCallOutView.swift
//  YoubikeDemo
//
//  Created by Jack on 7/3/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit

class CustomCallOutView: UIView {

    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationAddressLabel: UILabel!
    @IBOutlet weak var availableBikeCountLabel: UILabel!
    @IBOutlet weak var availableParkingCountLabel: UILabel!
    
    var station: Station!

    var stationVM: StationViewModel! {
        didSet {
            let name = stationVM.name
            let predicate = NSPredicate(format: "name = %@", name)
            station = Station.allStation().filter(predicate)[0]
            
            likeImageView.image = station.isLike  ? #imageLiteral(resourceName: "Icon_favorite") : #imageLiteral(resourceName: "Icon_unselectedFavorite")
            stationNameLabel.text = stationVM.name
            stationAddressLabel.text = stationVM.addressDescription
            availableBikeCountLabel.text = stationVM.availableBikeCount
            availableBikeCountLabel.textColor = .systemGreen
            availableParkingCountLabel.text = stationVM.availableParkingCount
            availableParkingCountLabel.textColor = .lightRed
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleLike)))
        likeImageView.isUserInteractionEnabled = true
    }
    
    @objc func toggleLike() {
        station.toggleLike()
        likeImageView.image = station.isLike ? #imageLiteral(resourceName: "Icon_favorite") : #imageLiteral(resourceName: "Icon_unselectedFavorite")
    }

}
