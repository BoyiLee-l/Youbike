//
//  String+Extension.swift
//  YoubikeDemo
//
//  Created by Jack on 7/3/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation

extension String {
    var convertDetailToDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.date(from: self)!
    }
}
