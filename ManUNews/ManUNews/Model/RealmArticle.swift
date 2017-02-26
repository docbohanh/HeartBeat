//
//  RealmArticle.swift
//  ManuNews
//
//  Created by MILIKET on 2/23/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import RealmSwift
import UIKit

class RealmArticle: Object {
    
//    dynamic var ID              : String = ""
//    dynamic var image           : String = ""
//    dynamic var time            : TimeInterval = 0
//    dynamic var title           : String = ""
//    dynamic var contentShort    : String = ""
//    dynamic var isRead          : Bool = false
//    dynamic var commentCount    : Int = 0
//    dynamic var articleImg      : String = ""
//    dynamic var order           : Int = 0
//    dynamic var queryType       : Int = 0
//    dynamic var version         : Int = 0
//    
//    convenience init(ID: String, image: String, time: Double, title: String, contentShort: String, isRead: Bool, commentCount: Int, articleImg: String, order: Int, queryType: Int = 0, version: Int) {
//        self.init()
//        self.ID                 = ID
//        self.image              = image
//        self.time               = time
//        self.title              = title
//        self.contentShort       = contentShort
//        self.isRead             = isRead
//        self.commentCount       = commentCount
//        self.articleImg         = articleImg
//        self.order              = order
//        self.queryType          = queryType
//        self.version            = version
//    }
    
    dynamic var ID: String = ""
    dynamic var title: String = ""
    dynamic var articleLink: String = ""
    dynamic var descrip: String = ""
    dynamic var publishDate: String = ""
    dynamic var imageLink: String = ""
    
    convenience init(
        ID: String,
        title: String,
        articleLink: String,
        description: String,
        publishDate: String,
        imageLink: String) {
        self.init()
        self.ID = ID
        self.title = title
        self.articleLink = articleLink
        self.descrip = description
        self.publishDate = publishDate
        self.imageLink = imageLink
    }
    
    convenience init(article: Article) {
        self.init()
        self.ID = article.ID
        self.title = article.title
        self.articleLink = article.articleLink
        self.descrip = article.description
        self.publishDate = article.publishDate
        self.imageLink = article.imageLink
    }
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
    func convertToSyncType() -> Article {
        return Article(
            ID: self.ID,
            title: self.title,
            articleLink: self.articleLink,
            description: self.descrip,
            publishDate: self.publishDate,
            imageLink: self.imageLink
        )
    }
    
    
}
