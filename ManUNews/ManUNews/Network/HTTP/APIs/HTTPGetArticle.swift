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
        
        var pageIndex: Int
        var pageSize: Int
        var siteID: Int
        var isVideo: Bool
        
        public init(
            pageIndex: Int,
            pageSize: Int,
            siteID: Int,
            isVideo: Bool) {
            
            self.pageIndex = pageIndex
            self.pageSize = pageSize
            self.siteID = siteID
            self.isVideo = isVideo
        }
        
    }
    
    public required init(request: RequestType) {
        self.request = request
    }
    
    public func serialize(_ request: RequestType) -> Observable<Data> {
        var data = Data()
        
        data.appendInt32(request.pageIndex)
        data.appendInt32(request.pageSize)
        data.appendInt32(request.siteID)
        data.appendBool(request.isVideo)
        
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
                    ID: try data.readString(),
                    thumbnail: try data.readString(),
                    title: try data.readString(),
                    content: try data.readString(),
                    type: try Article.TypeContent(rawValue: data.readInt8()) ?? .unknown,
                    siteID: try data.readInt32(),
                    sourceLink: try data.readString())
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
