//
//  Article.swift
//  ManuNews
//
//  Created by MILIKET on 2/26/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import Foundation
import Unbox

struct Article: Unboxable {
    
    let ID: String
    let title: String
    let articleLink: String
    let description: String
    let publishDate: String
    let imageLink: String
    
    func convertToRealmType() -> RealmArticle {
        return RealmArticle(article: self)
    }
    
    init(ID: String,
         title: String,
         articleLink: String,
         description: String,
         publishDate: String,
         imageLink: String) {
        
        self.ID = ID
        self.title = title
        self.articleLink = articleLink
        self.description = description
        self.publishDate = publishDate
        self.imageLink = imageLink
    }
    
    init(unboxer: Unboxer) throws {
        self.ID          = try unboxer.unbox(key: "id")
        self.title       = try unboxer.unbox(key: "title")
        self.articleLink = unboxer.unbox(key: "articleLink") ?? ""
        self.description = try unboxer.unbox(key: "description")
        self.publishDate = unboxer.unbox(key: "publishDate") ?? ""
        self.imageLink   = unboxer.unbox(key: "imageLink") ?? ""
    }
    
}
