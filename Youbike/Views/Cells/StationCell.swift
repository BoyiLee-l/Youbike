//
//  StationCell.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import RealmSwift

class StationCell: UITableViewCell {
    
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationAddressLabel: UILabel!
    @IBOutlet weak var availableBikeCountLabel: UILabel!
    @IBOutlet weak var availableParkingCountLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    var station: Station!
    var stationStatus: StationStatus = .allList
    
    var stationVM: StationViewModel! {
        didSet {
            if stationStatus == .allList {
                let name = stationVM.name
                let predicate = NSPredicate(format: "name = %@", name)
                station = Station.allStation().filter(predicate).first
                likeImageView.image = station.isLike  ? #imageLiteral(resourceName: "Icon_favorite") : #imageLiteral(resourceName: "Icon_unselectedFavorite")
            } else {
                likeImageView.image = stationVM.isLike ? #imageLiteral(resourceName: "Icon_favorite") : #imageLiteral(resourceName: "Icon_unselectedFavorite")
            }
            stationNameLabel.text = stationVM.name
            stationAddressLabel.text = stationVM.addressDescription
            
            availableBikeCountLabel.text = stationVM.availableBikeCount
            availableBikeCountLabel.textColor = .systemGreen
            
            availableParkingCountLabel.text = stationVM.totalParkingCount
            availableParkingCountLabel.textColor = .lightRed
            
            updateTimeLabel.text = stationVM.updateTimeDescription
            updateTimeLabel.textColor = .magenta
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleLike)))
        likeImageView.isUserInteractionEnabled = true
    }
    
    @objc func toggleLike() {
        if stationStatus == .allList {
            station.toggleLike()
            likeImageView.image = station.isLike ? #imageLiteral(resourceName: "Icon_favorite") : #imageLiteral(resourceName: "Icon_unselectedFavorite")
        } else {
            stationVM.toggleLike()
            likeImageView.image = stationVM.isLike ? #imageLiteral(resourceName: "Icon_favorite") : #imageLiteral(resourceName: "Icon_unselectedFavorite")
       }
    }
}
