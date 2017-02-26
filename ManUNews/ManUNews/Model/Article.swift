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
        self.ID          = try unboxer.unbox(key: "ID")
        self.title       = try unboxer.unbox(key: "Title")
        self.articleLink = try unboxer.unbox(key: "ArticleLink")
        self.description = try unboxer.unbox(key: "Description")
        self.publishDate = try unboxer.unbox(key: "PublishDate")
        self.imageLink   = try unboxer.unbox(key: "ImageLink")
    }
    
}
