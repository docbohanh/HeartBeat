//
//  Extensions.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//


import UIKit
import RealmSwift
import PHExtensions

extension Results {
    func toArray() -> [Results.Iterator.Element] {
        return Array(self)
    }
}

