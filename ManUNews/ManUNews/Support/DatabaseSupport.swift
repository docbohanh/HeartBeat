//
//  DatabaseSupport.swift
//  TrakingMe
//
//  Created by Thành Lã on 12/30/16.
//  Copyright © 2016 Bình Anh Electonics. All rights reserved.
//

import Foundation
import RealmSwift
import CleanroomLogger
import PHExtensions

public class DatabaseSupport {
    public static let shared = DatabaseSupport()
    
    func deleteAllData() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        }
        catch {
            Log.message(.error, message: "deleteAllData ERROR: \(error)")
        }
    }
    
    func getAllArticle() -> [RealmArticle] {
        do {
            return try Realm().objects(RealmArticle.self).toArray()
        }
        catch {
            Log.message(.error, message: "get Article ERROR: \(error)")
            return []
        }
    }
    
    func insert(article: [RealmArticle]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(article)
            }
        }
        catch {
            Log.message(.error, message: "insert Article ERROR: \(error)")
        }
    }
}












