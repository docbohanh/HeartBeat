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
    
    dynamic var resourceId: Int = 0
    dynamic var path: String = ""
    dynamic var avatar: String = ""
    dynamic var title: String = ""
    dynamic var sapo: String = ""
    dynamic var content: String = ""
    dynamic var datePublished: TimeInterval = 0
    dynamic var isActive: Bool = true
    dynamic var type: Int = 0
    dynamic var catId: Int = 0
    dynamic var appId: Int = 0
    
    convenience init(
        resourceId: Int,
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
        
        self.init()
        
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
    
    convenience init(article: Article) {
        self.init()
        self.resourceId = article.resourceId
        self.path       = article.path
        self.avatar     = article.avatar
        self.title      = article.title
        self.sapo       = article.sapo
        self.content    = article.content
        self.datePublished = article.datePublished
        self.isActive   = article.isActive
        self.type       = article.type
        self.catId      = article.catId
        self.appId      = article.appId
        
    }
    
    override static func primaryKey() -> String? {
        return "resourceId"
    }
    
    func convertToSyncType() -> Article {
        return Article(
            resourceId: self.resourceId,
            path: self.path,
            avatar: self.avatar,
            title: self.title,
            sapo: self.sapo,
            content: self.content,
            datePublished: self.datePublished,
            isActive: self.isActive,
            type: self.type,
            catId: self.catId,
            appId: self.appId
        )
    }
    
    
}
