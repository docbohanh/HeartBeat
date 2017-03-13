//
//  DataManager.swift
//  ManUNews
//
//  Created by MILIKET on 2/28/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
import CleanroomLogger

protocol DataManagerDelegate: class {
    func downloadedArticle(status: Bool, articles: [Article])
}

public class DataManager {
    static let shared = DataManager()
    weak var delegate: DataManagerDelegate?
}

extension DataManager {
    
    internal func getNewArticle(page: Int) {
        
        let request = HTTPGetArticle.RequestType(appID: 5, catID: 12, page: page, pageSize: 10)
        
        HTTPManager.shared.request(
            type: HTTPGetArticle.self,
            request: request,
            debug: .none
            
        ) { (result) in
                switch result {
                case .success(let value):
                    Log.message(.debug, message: "Cập nhật thành công: \(value.articles.count) bản tin")
                    self.delegate?.downloadedArticle(status: true, articles: value.articles)
                    
                case .failure(let error):
                    Log.message(.debug, message: "Cập nhật tin tức lỗi: \(error)")
                    self.delegate?.downloadedArticle(status: false, articles: [])
                }
        }
        
    }
}
