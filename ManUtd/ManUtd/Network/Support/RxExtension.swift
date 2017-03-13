//
//  RxExtension.swift
//  BATaxiNetwork
//
//  Created by Hoan Pham on 2/4/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation
import RxSwift
import CleanroomLogger
import RxCocoa
import Crypto
import RxExtensions
import PHExtensions
import Unbox
import Wrap

//extension ObservableType where E : TCPServerResponseProtocol {
//    public func takeSuccessResponse() -> Observable<Self.E.ResponseType> {
//        return filter { $0.result.isSuccess }.map { $0.result.value! }
//    }
//    public func takeFailureResponse() -> Observable<Error> {
//        return filter { $0.result.isFailure }.map { $0.result.error! }
//    }
//}

extension ObservableType where E: HTTPProtocol, E: HTTPDataRequestProcotol, E: HTTPDataResponseProtocol {
    
    fileprivate func createRequest() -> Observable<(E, URLRequest)> {
        
        return
            flatMapLatest { obj -> Observable<(E, URLRequest)> in
                obj.serialize(obj.request)
                    .do( onNext: { _ in Log.message(.debug, message: "\(type(of: obj)) Request: \(obj.request)") } )
//                    .debugWithLogger(.debug, message: ")
                    .map { try obj.cryptoType.encryptMethod()($0) }
                    .map { $0.toBase64String() }
                    .map { ["Param" : $0] }
                    .map { try JSONSerialization.data(withJSONObject: $0, options: []) }
                    .map { data -> URLRequest in
                        guard let url = URL(string: obj.URL.URLString) else {
                            throw HTTPError.invalidURL
                        }
                        
                        var request = URLRequest(url: url)
                        request.httpBody = data
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        return request
                    }
                    .map { (obj, $0) }
        }
    }
    
    public func doRequestAndCatchError() -> Observable<Result<E.ResponseType>> {
        
        return createRequest()
            .flatMapLatest { requestObj, request -> Observable<Result<E.ResponseType>> in
                URLSession.shared
                    .rx.data(request: request)
                    .timeout(requestObj.timeoutInterval, scheduler: ConcurrentMainScheduler.instance)
                    .map { response -> String in
                        guard let result = String(data: response, encoding: .utf8), result.characters.count > 0
                            else { throw HTTPError.cannotConvertDataToString }
                        return result
                    }
                    .map { try $0.base64ToNSData() }
                    .map { try requestObj.cryptoType.decryptMethod()($0) }
                    .map { try requestObj.deserialize(origin: requestObj.request, data: $0) }
                    .map { .success($0) }
                    .catchError { error -> Observable<Result<E.ResponseType>> in
                        if (error as NSError).code == -1009 { return Observable.error(RxError.timeout) }
                        return Observable.error(error)
                    }
                    .do(
                        onNext: { Log.message(.info, message: "\(type(of: requestObj)) Response: \($0)") },
                        onError: { Log.message(.error, message: "\(type(of: requestObj)) Response: \($0)") }
                    )
                    .catchError { Observable.just(.failure($0)) }
//                    .debugWithLogger(.debug, message: "\(requestObj.dynamicType) Response: ")
            }
    }
   
}

extension ObservableType where E: HTTPProtocol, E: HTTPWrapRequestProtocol, E: HTTPUnboxResponseProtocol {
    fileprivate func createRequest() -> Observable<(E, URLRequest)> {
        
        return flatMapLatest { obj -> Observable<(E, URLRequest)> in
            Observable.just()
                .map { _ -> Data in try wrap(obj.request) }
                .map { try obj.cryptoType.encryptMethod()($0) }
                .map { $0.toBase64String() }
                .map { ["Param" : $0] }
                .map { try JSONSerialization.data(withJSONObject: $0, options: []) }
                .map { data -> URLRequest in
                    guard let url = URL(string: obj.URL.URLString) else {
                        throw HTTPError.invalidURL
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpBody = data
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
                }
                .map { request -> (E, URLRequest) in (obj, request) }
        }
    }
    
    public func doRequestAndCatchError(debug: Bool = false) -> Observable<Result<E.ResponseType>> {
        
        return createRequest()
            .flatMapLatest { obj, request -> Observable<Result<E.ResponseType>> in
                URLSession.shared
                    .rx.data(request: request)
                    .timeout(obj.timeoutInterval, scheduler: ConcurrentMainScheduler.instance)
                    .map { response -> String in
                        guard let result = String(data: response, encoding: .utf8), result.characters.count > 0
                            else { throw HTTPError.cannotConvertDataToString }
                        return result
                    }
                    .map { try $0.base64ToNSData() }
                    .map { try obj.cryptoType.decryptMethod()($0) }
                    .map { try Unboxer(data: $0) }
                    .do(
                        onNext: { if debug { Log.message(.info, message: "\(type(of: obj)) Response: \($0.dictionary)") } }
                    )
                    .map { try obj.deserialize(unboxer: $0) }
                    .map { .success($0) }
                    .catchError { error -> Observable<Result<E.ResponseType>> in
                        if (error as NSError).code == -1009 { return Observable.error(RxError.timeout) }
                        return Observable.error(error)
                    }
                    .do(
                        onNext: { Log.message(.info, message: "\(type(of: obj)) Response: \($0)") },
                        onError: { Log.message(.error, message: "\(type(of: obj)) Response: \($0)") }
                    )
                    .catchError { Observable.just(.failure($0)) }
            }
        
    }
}

extension ObservableType where E: HTTPProtocol, E: HTTPWrapRequestProtocol, E: HTTPUnboxWithContextResponseProtocol {
    fileprivate func createRequest() -> Observable<(E, URLRequest)> {
        
        return flatMapLatest { obj -> Observable<(E, URLRequest)> in
            Observable.just()
                .map { _ -> Data in try wrap(obj.request) }
                .map { try obj.cryptoType.encryptMethod()($0) }
                .map { $0.toBase64String() }
                .map { ["Param" : $0] }
                .map { try JSONSerialization.data(withJSONObject: $0, options: []) }
                .map { data -> URLRequest in
                    guard let url = URL(string: obj.URL.URLString) else {
                        throw HTTPError.invalidURL
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpBody = data
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
                }
                .map { request -> (E, URLRequest) in (obj, request) }
        }
    }
    
    public func doRequestAndCatchError(debug: Bool = false) -> Observable<Result<E.ResponseType>> {
        
        return createRequest()
            .flatMapLatest { obj, request -> Observable<Result<E.ResponseType>> in
                URLSession.shared
                    .rx.data(request: request)
                    .timeout(obj.timeoutInterval, scheduler: ConcurrentMainScheduler.instance)
                    .map { response -> String in
                        guard let result = String(data: response, encoding: .utf8), result.characters.count > 0
                            else { throw HTTPError.cannotConvertDataToString }
                        return result
                    }
                    .map { try $0.base64ToNSData() }
                    .map { try obj.cryptoType.decryptMethod()($0) }
                    .map { try Unboxer(data: $0) }
                    .do(
                        onNext: { if debug { Log.message(.info, message: "\(type(of: obj)) Response: \($0.dictionary)") } }
                    )
                    .map { try obj.deserialize(origin: obj.request, unboxer: $0) }
                    .map { .success($0) }
                    .catchError { error -> Observable<Result<E.ResponseType>> in
                        if (error as NSError).code == -1009 { return Observable.error(RxError.timeout) }
                        return Observable.error(error)
                    }
                    .do(
                        onNext: { Log.message(.info, message: "\(type(of: obj)) Response: \($0)") },
                        onError: { Log.message(.error, message: "\(type(of: obj)) Response: \($0)") }
                    )
                    .catchError { Observable.just(.failure($0)) }
        }
        
    }
}

/*
extension ObservableType where E: HTTPProtocol, E: HTTPJSONRequestProtocol, E: HTTPJSONResponseProtocol {
    fileprivate func createRequest() -> Observable<(E, URLRequest)> {
        return
            flatMapLatest { obj -> Observable<(E, URLRequest)> in
                obj.serialize(obj.request)
                    .do( onNext: { _ in Log.message(.debug, message: "\(type(of: obj)) Request: \(obj.request)") } )
                    .map { $0.data(using: .utf8) }
                    .filterNil()
                    .map { try obj.cryptoType.encryptMethod()($0) }
                    .map { $0.toBase64String() }
                    .map { ["Param" : $0] }
                    .map { try JSONSerialization.data(withJSONObject: $0, options: []) }
                    .map { data -> URLRequest in
                        guard let url = URL(string: obj.URL.URLString) else {
                            throw HTTPError.invalidURL
                        }
                        
                        var request = URLRequest(url: url)
                        request.httpBody = data
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        return request
                    }
                    .map { (obj, $0) }
        }
    }
    
    public func doRequestAndCatchError() -> Observable<Result<E.ResponseType>> {
        
        return createRequest()
            .flatMapLatest { requestObj, request -> Observable<Result<E.ResponseType>> in
                URLSession.shared
                    .rx.data(request: request)
                    .timeout(requestObj.timeoutInterval, scheduler: ConcurrentMainScheduler.instance)
                    .map { response -> String in
                        guard let result = String(data: response, encoding: .utf8), result.characters.count > 0
                            else { throw HTTPError.cannotConvertDataToString }
                        return result
                    }
                    .map { try $0.base64ToNSData() }
                    .map { try requestObj.cryptoType.decryptMethod()($0) }
                    .map { String(data: $0, encoding: .utf8) }
                    .flatMap { x -> Observable<String> in
                        guard let string = x else { return Observable.error(HTTPError.couldNotDecryptResponseMessage) }
                        return Observable.just(string)
                    }
                    .map { try requestObj.deserialize(origin: requestObj.request, response: $0) }
                    .map { .success($0) }
                    .catchError { error -> Observable<Result<E.ResponseType>> in
                        if (error as NSError).code == -1009 { return Observable.error(RxError.timeout) }
                        return Observable.error(error)
                    }
                    .do(
                        onNext: { Log.message(.info, message: "\(type(of: requestObj)) Response: \($0)") },
                        onError: { Log.message(.error, message: "\(type(of: requestObj)) Response: \($0)") }
                    )
                    .catchError { Observable.just(.failure($0)) }
                //                    .debugWithLogger(.debug, message: "\(requestObj.dynamicType) Response: ")
        }
    }
}
*/

/*
extension ObservableType where E: HTTPProtocol, E: HTTPGoogleRequestProtocol, E: HTTPGoogleResponseProtocol {
    
    fileprivate func createRequest() -> Observable<(E, URLRequest)> {
        
        return
            flatMapLatest { obj -> Observable<(E, URLRequest)> in
                obj.serialize(obj.request)
//                    .do(onNext: { _ in Log.message(.debug, message: "\(type(of: obj)) Request: \(obj.request)") })
                    .map { obj.URL.URLString + $0.stringFromHttpParameters() }
                    .map { URL(string: $0) }
                    .filterNil()
                    .map { url -> URLRequest in
                        var request = URLRequest(url: url)
                        request.httpMethod = "GET"
                        return request
                    }
                    .map { (obj, $0) }
        }
    }
    
    public func doRequestAndCatchError() -> Observable<Result<E.ResponseType>> {
        return createRequest()
            .flatMapLatest { requestObj, request -> Observable<Result<E.ResponseType>> in
                URLSession.shared
                    .rx.json(request: request)
                    .timeout(requestObj.timeoutInterval, scheduler: ConcurrentMainScheduler.instance)
                    .map { JSON($0) }
                    .map { try requestObj.deserialize(origin: requestObj.request, data: $0) }
                    .map { .success($0) }
                    .catchError { error -> Observable<Result<E.ResponseType>> in
                        if (error as NSError).code == -1009 { return Observable.error(RxError.timeout) }
                        return Observable.error(error)
                    }
                    .do(
                        onNext: { Log.message(.info, message: "\(type(of: requestObj)) Response: \($0)") },
                        onError: { Log.message(.error, message: "\(type(of: requestObj)) Response: \($0)") }
                    )
                    .catchError { error -> Observable<Result<E.ResponseType>> in
                        Observable.just(.failure(error))
                    }
            }
        
    }
    
}

 */



extension ObservableType {
    public func ifTimeoutThenRetryWhenReachable(maxAttempt times: Int) -> Observable<E> {
        
        return catchError { error -> Observable<E> in
            guard case RxError.timeout = error else {
                return Observable.error(error)
            }
            
            return self.asObservable()
                .catchError { (e) -> Observable<E> in
                    ReachabilitySupport.instance
                        // Reachability changed là một observable
                        .reachabilityStatus
                        .skip(1)
                        // Filter chỉ chấp nhận các kết quả có kết nối
                        .filter { $0 == .reachable }
                        .flatMap { _ in Observable.error(e) }
                }
                .retry(times)
        }
    }
}

extension ObservableType where E: ResultProtocol {
    public func takeSuccessResponse() -> Observable<Self.E.ValueType> {
        return filter { $0.isSuccess }.map { $0.value! }
    }
    
    public func takeFailureResponse() -> Observable<Error> {
        return filter { $0.isFailure }.map { $0.error! }
    }
}


//public protocol ResultPhantomType {
//    associatedtype ValueType
//    var result: Result<ValueType> { get }
//}
//
//
//extension ObservableType where E: ResultProtocol {
//    public func takeSuccessResponse() -> Observable<Self.E.ValueType> {
//        return filter { $0.isSuccess }.map { $0.value! }
//    }
//    
//    public func takeFailureResponse() -> Observable<ErrorType> {
//        return filter { $0.isFailure }.map { $0.error! }
//    }
//    
//}
//
//extension ObservableType where E: ResultPhantomType {
//    
//    public func takeSuccessResponse() -> Observable<Self.E.ValueType> {
//        return map { $0.result }.filter { $0.isSuccess }.map { $0.value! }
//    }
//    
//    public func takeFailureResponse() -> Observable<ErrorType> {
//        return map { $0.result }.filter { $0.isFailure }.map { $0.error! }
//
//    }
//    
//}

