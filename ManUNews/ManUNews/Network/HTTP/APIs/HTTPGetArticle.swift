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
