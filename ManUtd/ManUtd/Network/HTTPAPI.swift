//
//  HTTPAPI.swift
//  BATaxiNetwork
//
//  Created by Hoan Pham on 3/7/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation

public struct HTTPAPI {
    
    public static var API: String = "http://app.linkit.vn/api/"
    
    fileprivate static let GoogleDirectionAPI = "https://maps.googleapis.com/maps/api/directions/json?"
    fileprivate static let GoogleGeocodingAPI = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    enum APIs: String, URLStringConvertible {

        case getArticle = "GetResource"
        case getResult = "GetCompetitionResult"
        
        var URLString: String {
            guard HTTPAPI.API.characters.count > 0 else { fatalError("API address did not set") }
            return HTTPAPI.API + self.rawValue
        }
    }
    
    enum Google: URLStringConvertible {
        case direction
        case geocoding
        
        var URLString: String {
            switch self {
            case .direction:
                return HTTPAPI.GoogleDirectionAPI
                
            case .geocoding:
                return HTTPAPI.GoogleGeocodingAPI
            }
            
        }
    }
    
}

public protocol URLStringConvertible {
    /**
     A URL that conforms to RFC 2396.
     
     Methods accepting a `URLStringConvertible` type parameter parse it according to RFCs 1738 and 1808.
     
     See https://tools.ietf.org/html/rfc2396
     See https://tools.ietf.org/html/rfc1738
     See https://tools.ietf.org/html/rfc1808
     */
    var URLString: String { get }
}

extension String: URLStringConvertible {
    public var URLString: String {
        return self
    }
}

extension URL: URLStringConvertible {
    public var URLString: String {
        return absoluteString
    }
}

extension URLComponents: URLStringConvertible {
    public var URLString: String {
        return url!.URLString
    }
}

extension URLRequest: URLStringConvertible {
    public var URLString: String {
        return url!.URLString
    }
}



