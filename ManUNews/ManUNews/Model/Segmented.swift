//
//  Segmented.swift
//  ManuNews
//
//  Created by Thành Lã on 2/24/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import Foundation
func == (l: Segmented, r: Segmented) -> Bool {
    switch (l.value, r.value) {
    case (.fixedValue(let x), .fixedValue(let y)):
        return x == y
        
    case (.rangeValue(let x1, let x2), .rangeValue(let y1, let y2)):
        return x1 == y1 && x2 == y2
        
    default:
        return false
    }
}

struct Segmented: Equatable {
    
    enum SegmentValue {
        case fixedValue(TimeInterval)
        case rangeValue(TimeInterval, TimeInterval)
    }
    
    let index: Int
    let title: String
    let value: SegmentValue
    
    init(index: Int, title: String, value: SegmentValue) {
        self.index = index
        self.title = title
        self.value = value
    }
}
