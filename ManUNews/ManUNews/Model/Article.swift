//
//  Article.swift
//  ManuNews
//
//  Created by MILIKET on 2/26/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import Foundation

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
    
}
