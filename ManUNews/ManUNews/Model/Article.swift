//
//  Article.swift
//  ManuNews
//
//  Created by MILIKET on 2/26/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import Foundation
import Unbox

struct Article {
    
    enum TypeContent: Int {
        case unknown = 0, html, image, youtube, video
    }
    
    
    let resourceId: Int
    let path: String
    let avatar: String
    let title: String
    let sapo: String
    let content: String
    let datePublished: TimeInterval
    let isActive: Bool
    let type: Int
    let catId: Int
    let appId: Int
 
    init(resourceId: Int,
         path: String,
         avatar: String,
         title: String,
         sapo: String,
         content: String,
         datePublished: TimeInterval,
         isActive: Bool,
         type: Int,
         catId: Int,
         appId: Int) {
        
        self.resourceId = resourceId
        self.path = path
        self.avatar = avatar
        self.title = title
        self.sapo = sapo
        self.content = content
        self.datePublished = datePublished
        self.isActive = isActive
        self.type = type
        self.catId = catId
        self.appId = appId
    }
    
    func convertToRealmType() -> RealmArticle {
        return RealmArticle(article: self)
    }
    
}
