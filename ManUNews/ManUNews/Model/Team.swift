//
//  Team.swift
//  ManUNews
//
//  Created by MILIKET on 3/4/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation

enum OrderType: Int {
    case descend = -1
    case normal = 0
    case ascend = 1
    
    var icon: UIImage {
        switch self {
        case .descend:
            return Icon.Article.orderDescend
        case .ascend:
            return Icon.Article.orderAscend
        default:
            return Icon.Article.orderNormal
        }
    }
}

struct Team {
    
    var orderType: OrderType //(Thứ hạng so với vòng trước: -1: Giảm, 0: Giữ nguyên, 1: Tăng)
    var order: Int // Thứ hạng
    var logo: UIImage // Logo đội bóng
    var teamName: String // Tên đội bóng
    var matched: Int // Số trận đã đấu
    var goals: String // Số bàn thắng : Số bàn thua
    var difference: Int // Hiệu số
    var score: Int // Điểm
    
    init(orderType: OrderType,
         order: Int,
         logo: UIImage,
         teamName: String,
         matched: Int,
         goals: String,
         difference: Int,
         score: Int) {
        
        self.orderType = orderType
        self.order = order
        self.logo = logo
        self.teamName = teamName
        self.matched = matched
        self.goals = goals
        self.difference = difference
        self.score = score
    }
}
