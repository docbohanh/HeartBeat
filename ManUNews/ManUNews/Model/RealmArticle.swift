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
    dynamic var thumbnail: String = ""
    dynamic var title: String = ""
    dynamic var content: String = ""
    dynamic var type: Int = 0
    dynamic var siteID: Int = 0
    dynamic var sourceLink: String = ""
    
    convenience init(
        ID: String,
        thumbnail: String,
        title: String,
        content: String,
        type: Int,
        siteID: Int,
        sourceLink: String) {
        
        self.init()
        
        self.ID = ID
            self.thumbnail = thumbnail
            self.title = title
            self.content = content
            self.type = type
            self.siteID = siteID
            self.sourceLink = sourceLink
    }
    
    convenience init(article: Article) {
        self.init()
        self.ID = article.ID
        self.thumbnail = article.thumbnail
        self.title = article.title
        self.content = article.content
        self.type = article.type.rawValue
        self.siteID = article.siteID
        self.sourceLink = article.sourceLink
    }
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
    func convertToSyncType() -> Article {
        return Article(
            ID: self.ID,
            thumbnail: self.thumbnail,
            title: self.title,
            content: self.content,
            type: Article.TypeContent(rawValue: self.type) ?? .unknown,
            siteID:  self.siteID,
            sourceLink: self.sourceLink
        )
    }
    
    
}
