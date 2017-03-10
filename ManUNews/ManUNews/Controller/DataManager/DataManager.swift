//
//  DataManager.swift
//  ManUNews
//
//  Created by MILIKET on 2/28/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
import CleanroomLogger

protocol DataManagerDelagate: class {
    func downloadArticle(status: Bool, articles: [Article])
}

public class DataManager {
    static let shared = DataManager()
    weak var delegate: DataManagerDelagate?
}

extension DataManager {
    
    internal func getArticle() {
        
        let request = HTTPGetArticle.RequestType(pageIndex: 1, pageSize: 10, siteID: 5, isVideo: false)
        
        HTTPManager.shared.request(
            type: HTTPGetArticle.self,
            request: request,
            debug: .all
            
        ) { (result) in
                switch result {
                case .success(let value):
                    Log.message(.debug, message: "Cập nhật thành công: \(value.articles.count) bản tin")
                    self.delegate?.downloadArticle(status: true, articles: value.articles)
                    
                case .failure(let error):
                    Log.message(.debug, message: "Cập nhật tin tức lỗi: \(error)")
                    self.delegate?.downloadArticle(status: false, articles: [])
                }
        }
        
    }
}
