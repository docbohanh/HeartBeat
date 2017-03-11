//
//  HTTPGetArticle.swift
//  ManUNews
//
//  Created by MILIKET on 2/26/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
import Crypto
import PHExtensions
import Unbox

import RxSwift
import CleanroomLogger

public class HTTPGetArticle: HTTPProtocol, HTTPDataRequestProcotol, HTTPDataResponseProtocol {
    
    //--------------- HTTPProtocol ---------------
    
    public var URL: URLStringConvertible {
        return HTTPAPI.APIs.getArticle
    }
    
    public var timeoutInterval: TimeInterval = 30.seconds
    
    public var cryptoType: HTTPCrypto = .none
    
    public typealias RequestType = Request
    
    public var request: RequestType
    
    public class Request {
        
        var appID: Int
        var catID: Int
        var page: Int
        var pageSize: Int
        
        public init(
            appID: Int,
            catID: Int,
            page: Int,
            pageSize: Int) {
            
            self.appID = appID
            self.catID = catID
            self.page = page
            self.pageSize = pageSize
        }
        
    }
    
    public required init(request: RequestType) {
        self.request = request
    }
    
    public func serialize(_ request: RequestType) -> Observable<Data> {
        var data = Data()
        
        data.appendInt32(request.appID)
        data.appendInt32(request.catID)
        data.appendInt32(request.page)
        data.appendInt32(request.pageSize)
        
        return Observable.just(data)
    }
    
    //--------------- HTTPResponseProtocol ---------------
    public class Response: CustomStringConvertible {
        let articles: [Article]
        
        init(articles: [Article]) {
            self.articles = articles
        }
        
        public var description: String {
            return "Getting \(articles.count) article)"
        }
    }
    
    public typealias ResponseType = Response
    
    public func deserialize(origin: RequestType, data rawData: Data) throws -> ResponseType {
        do {
            var data = rawData
            
            let articles = try (0..<data.readInt16()).map { _ in
                Article(
                    resourceId: try data.readInt32(),
                    path: try data.readString(),
                    avatar: "http://mobile.linkit.vn" + (try data.readString()),
                    title: try data.readString(),
                    sapo: try data.readString(),
                    content: try data.readString(),
                    datePublished: TimeInterval(try data.readInt64()),
                    isActive: try data.readBool(),
                    type: try data.readInt32(),
                    catId: try data.readInt32(),
                    appId: try data.readInt32()
                )
            }
            
            return Response(articles: articles)
        }
        catch {
            throw error
        }
    }
}

/*
public class HTTPGetArticle: HTTPProtocol, HTTPWrapRequestProtocol, HTTPUnboxResponseProtocol {
    
    //--------------- HTTPProtocol ---------------
    
    public var URL: URLStringConvertible {
        return HTTPAPI.APIs.getArticle
    }
    
    public var timeoutInterval: TimeInterval = 30.seconds
    
    public var cryptoType: HTTPCrypto = .none
    
    public typealias RequestType = Request
    
    public var request: HTTPGetArticle.Request
    
    public class Request {
        
        var pageNumber: Int
        var rowPerPage: Int
        
        public init(pageNumber: Int, rowPerPage: Int) {
            self.pageNumber = pageNumber
            self.rowPerPage = rowPerPage
        }
        
    }
    
    public required init(request: RequestType) {
        self.request = request
    }
    
    //--------------- HTTPResponseProtocol ---------------
    
    public typealias ResponseType = Response
    
    public class Response: Unboxable {
        let articles: [Article]
        
        public required init(unboxer: Unboxer) throws {
            self.articles = try unboxer.unbox(key: "articles")
        }
        
    }
    
    public func deserialize(unboxer: Unboxer) throws -> ResponseType {
        return try ResponseType(unboxer: unboxer)
    }
}
*/
