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
    
    let ID: String
    let thumbnail: String
    let title: String
    let content: String
    let type: TypeContent
    let siteID: Int
    let sourceLink: String
    
    func convertToRealmType() -> RealmArticle {
        return RealmArticle(article: self)
    }
    
    init(ID: String,
         thumbnail: String,
         title: String,
         content: String,
         type: TypeContent,
         siteID: Int,
         sourceLink: String) {
        
        self.ID = ID
        self.title = title
        self.thumbnail = thumbnail
        self.content = content
        self.siteID = siteID
        self.sourceLink = sourceLink
        self.type = type
    }
//    
//    init(unboxer: Unboxer) throws {
//        self.ID          = try unboxer.unbox(key: "id")
//        self.title       = try unboxer.unbox(key: "title")
//        self.thumbnail  = unboxer.unbox(key: "thumbnail") ?? ""
//        self.content    = try unboxer.unbox(key: "content")
//        self.type       = unboxer.unbox(key: "type") ?? .unknown
//        self.siteID     = unboxer.unbox(key: "siteID") ?? 0
//        self.sourceLink = unboxer.unbox(key: "sourceLink") ?? ""
//    }
    
}
