//
//  Data+Extension.swift
//  YoubikeDemo
//
//  Created by Jack on 7/3/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation

extension Date {
    var convertDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.string(from: self)
    }
}
