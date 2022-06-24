//
//  UITableView+Extension.swift
//  YoubikeDemo
//
//  Created by Jack on 7/2/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit

extension IndexPath {
    static func fromRow(_ row: Int) -> IndexPath {
        return IndexPath(row: row, section: 0)
    }
}

extension UITableView {
    func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
        beginUpdates()
        deleteRows(at: deletions.map(IndexPath.fromRow), with: .fade)
        insertRows(at: insertions.map(IndexPath.fromRow), with: .fade)
        reloadRows(at: updates.map(IndexPath.fromRow), with: .fade)
        endUpdates()
    }
}
