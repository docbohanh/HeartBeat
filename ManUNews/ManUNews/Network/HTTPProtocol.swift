//
//  HTTPProtocol.swift
//  BATaxiNetwork
//
//  Created by Hoan Pham on 3/4/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation
import RxSwift
import Crypto
import Wrap
import Unbox

public protocol HTTPProtocol {
    var URL: URLStringConvertible { get }
    var timeoutInterval: TimeInterval { get }
    var cryptoType: HTTPCrypto { get }
}

public protocol HTTPDataRequestProcotol {
    associatedtype RequestType
    var request: RequestType { get }
    func serialize(_ data: RequestType) -> Observable<Data>
    init(request: RequestType)
}

public protocol HTTPDataResponseProtocol {
    associatedtype RequestType
    associatedtype ResponseType
    func deserialize(origin: RequestType, data rawData: Data) throws -> ResponseType
}

//------------------------------------

public protocol HTTPGoogleProtocol { }

public protocol HTTPWrapRequestProtocol {
    associatedtype RequestType
    var request: RequestType { get }
    init(request: RequestType)
}

public protocol  HTTPUnboxResponseProtocol {
    associatedtype RequestType
    associatedtype ResponseType: Unboxable
    func deserialize(unboxer: Unboxer) throws -> ResponseType
}

public protocol HTTPUnboxWithContextResponseProtocol {
    associatedtype RequestType
    associatedtype ResponseType: UnboxableWithContext
    func deserialize(origin: RequestType, unboxer: Unboxer) throws -> ResponseType
}


