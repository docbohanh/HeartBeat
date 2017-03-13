//
//  HTTPManager.swift
//  BAMapTools
//
//  Created by Hoan Pham on 10/19/16.
//  Copyright © 2016 Binh Anh. All rights reserved.
//

import Foundation
import RxSwift
import CleanroomLogger
import PHExtensions
import Crypto
import Unbox
import Wrap

public struct HTTPDebugOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    public static let none = HTTPDebugOptions(rawValue: 0)
    public static let `default` = HTTPDebugOptions(rawValue: 1 << 0)
    public static let rawRequest = HTTPDebugOptions(rawValue: 1 << 1)
    public static let rawResponse = HTTPDebugOptions(rawValue: 1 << 2)
    public static let all = HTTPDebugOptions(rawValue: 1 << 0 | 1 << 1 | 1 << 2)
}

class HTTPManager {
    
    static let shared = HTTPManager()
    
    private let stack = PublishSubject<String>()
    
    private let bag = DisposeBag()
    
    func request<T, Request, Response>(type: T.Type, request content: Request, debug: HTTPDebugOptions = .default, completionHandler: @escaping (Result<Response>) -> Void)
        where T: HTTPProtocol,
        T: HTTPDataRequestProcotol,
        T: HTTPDataResponseProtocol,
        Request == T.RequestType,
        Response == T.ResponseType {
            
            
            let object = type.init(request: content)
            stack.onNext(object.URL.URLString)
            
            Observable.just(object)
                .flatMap { $0.serialize(content) }
                .do( onNext: { _ in Log.message(.debug, message: "\(type(of: object)) Request: \(object.request)") } )
                .map { try object.cryptoType.encryptMethod()($0) }
                .map { $0.toBase64String() }
                .map { ["Param" : $0] }
                .debugWithLogger(.debug, message: "Request content")
                .map { try JSONSerialization.data(withJSONObject: $0, options: []) }
                .map { data -> URLRequest in
                    guard let url = URL(string: object.URL.URLString) else {
                        throw HTTPError.invalidURL
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpBody = data
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
                }
                .flatMap { [unowned self, object] request -> Observable<Result<Response>> in
                    URLSession.shared.rx.data(request: request)
                        .takeUntil(self.stack.asObservable().filter { $0 == object.URL.URLString })
                        .timeout(object.timeoutInterval, scheduler: ConcurrentMainScheduler.instance)
                        .map { response -> String in
                            guard let result = String(data: response, encoding: .utf8), result.characters.count > 0
                                else { throw HTTPError.cannotConvertDataToString }
                            //                            Log.message(.debug, message: "RAW RESPONSE: \(result)")
                            return result
                        }
                        .map { try $0.base64ToNSData() }
                        .map { try object.cryptoType.decryptMethod()($0) }
                        .map { try object.deserialize(origin: object.request, data: $0) }
                        .map { .success($0) }
                        .catchError { error -> Observable<Result<Response>> in
                            if (error as NSError).code == -1009 { return Observable.error(RxError.timeout) }
                            return Observable.error(error)
                        }
                        .do(
                            onNext: { if debug.contains(.default) { Log.message(.info, message: "\(type(of: object)) Response: \($0)") } },
                            onError: { Log.message(.error, message: "\(type(of: object)) Response: \($0)") }
                        )
                        .catchError { Observable.just(.failure($0)) }
                }
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { completionHandler($0) })
                .addDisposableTo(bag)
            
    }
    
    /*
    func request<T, Request, Response>(type: T.Type, request content: Request, completionHandler: @escaping (Result<Response>) -> Void)
        where T: HTTPProtocol,
        T: HTTPDataRequestProcotol,
        T: HTTPDataResponseProtocol,
        Request == T.RequestType,
        Response == T.ResponseType {
            
            let object = type.init(request: content)
            stack.onNext(object.URL.URLString)

            Observable.just(object)
                .flatMap { $0.serialize(content) }
                .do( onNext: { _ in Log.message(.debug, message: "\(type(of: object)) Request: \(object.request)") } )
                .map { try object.cryptoType.encryptMethod()($0) }
                .map { $0.toBase64String() }
                .map { ["Param" : $0] }
                .map { try JSONSerialization.data(withJSONObject: $0, options: []) }
                .map { data -> URLRequest in
                    guard let url = URL(string: object.URL.URLString) else {
                        throw HTTPError.invalidURL
                    }
                    Log.message(.debug, message: "url: \(url)")
                    var request = URLRequest(url: url)
                    request.httpBody = data
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
                }
                .flatMap { [unowned self, object] request -> Observable<Result<Response>> in
                    URLSession.shared.rx.data(request: request)
                        .takeUntil(self.stack.asObservable().filter { $0 == object.URL.URLString })
                        .timeout(object.timeoutInterval, scheduler: ConcurrentMainScheduler.instance)
                        .map { response -> String in
                            guard let result = String(data: response, encoding: .utf8), result.characters.count > 0
                                else { throw HTTPError.cannotConvertDataToString }
                            return result
                        }
                        .map { try $0.base64ToNSData() }
                        .map { try object.cryptoType.decryptMethod()($0) }
                        .map { try object.deserialize(origin: object.request, data: $0) }
                        .map { .success($0) }
                        .catchError { error -> Observable<Result<Response>> in
                            if (error as NSError).code == -1009 { return Observable.error(RxError.timeout) }
                            return Observable.error(error)
                        }
                        .do(
                            onNext: { Log.message(.info, message: "\(type(of: object)) Response: \($0)") },
                            onError: { Log.message(.error, message: "\(type(of: object)) Response: \($0)") }
                        )
                        .catchError { Observable.just(.failure($0)) }
                }
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { completionHandler($0) })
                .addDisposableTo(bag)

    }
    
    func request<T, Request, Response>(type: T.Type, request content: Request, debug: HTTPDebugOptions = .default, completionHandler: @escaping (Result<Response>) -> Void)
        where T: HTTPProtocol,
        T: HTTPWrapRequestProtocol,
        T: HTTPUnboxWithContextResponseProtocol,
        Request == T.RequestType,
        Response == T.ResponseType {
            
            let object = type.init(request: content)
            stack.onNext(object.URL.URLString)
            
            let urlRequest: Observable<URLRequest>
            if type is HTTPGoogleProtocol {
                urlRequest = createGoogleJSONRequest(object: object, debug: debug)
            } else {
                urlRequest = createJSONRequest(object: object, debug: debug)
            }
            
            urlRequest
                .flatMap { [unowned self, object] request -> Observable<Result<Response>> in
                    self.doJSONRequest(object: object, request: request, debug: debug)
                        .map { try object.deserialize(origin: object.request, unboxer: $0) }
                        .map { .success($0) }
                        .catchError { error -> Observable<Result<Response>> in
                            if (error as NSError).code == -1009 { return Observable.error(RxError.timeout) }
                            return Observable.error(error)
                        }
                        .do(
                            onNext: { if debug.contains(.default) { Log.message(.info, message: "\(type(of: object)) Response: \($0)") } },
                            onError: { Log.message(.error, message: "\(type(of: object)) Response: \($0)") }
                        )
                        .catchError { Observable.just(.failure($0)) }
                }
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { completionHandler($0) })
                .addDisposableTo(bag)
    }
    
    func request<T, Request, Response>(type: T.Type, request content: Request, debug: HTTPDebugOptions = .default, completionHandler: @escaping (Result<Response>) -> Void)
        where T: HTTPProtocol,
        T: HTTPWrapRequestProtocol,
        T: HTTPUnboxResponseProtocol,
        Request == T.RequestType,
        Response == T.ResponseType {
            
            let object = type.init(request: content)
            stack.onNext(object.URL.URLString)
            Log.message(.debug, message: "url: \(object.URL.URLString)")
            let urlRequest: Observable<URLRequest>
            if object is HTTPGoogleProtocol {
                urlRequest = createGoogleJSONRequest(object: object, debug: debug)
            } else {
                urlRequest = createJSONRequest(object: object, debug: debug)
            }
            
            urlRequest
                .flatMap { [unowned self, object] request -> Observable<Result<Response>> in
                    self.doJSONRequest(object: object, request: request, debug: debug)
                        .map { try object.deserialize(unboxer: $0) }
                        .map { .success($0) }
                        .catchError { error -> Observable<Result<Response>> in
                            if (error as NSError).code == -1009 { return Observable.error(RxError.timeout) }
                            return Observable.error(error)
                        }
                        .do(
                            onNext: { if debug.contains(.default) { Log.message(.info, message: "\(type(of: object)) Response: \($0)") } },
                            onError: { Log.message(.error, message: "\(type(of: object)) Response: \($0)") }
                        )
                        .catchError { Observable.just(.failure($0)) }
                }
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { completionHandler($0) })
                .addDisposableTo(bag)
    }

    
    fileprivate func createJSONRequest<T, Request>(object: T, debug: HTTPDebugOptions) -> Observable<URLRequest>
        where T: HTTPProtocol,
        T: HTTPWrapRequestProtocol,
        Request == T.RequestType {
            
            return Observable.just()
                .do(
                    onNext: { _ in
                        if debug.contains(.default) {
                            let dictionary: WrappedDictionary = try wrap(object.request)
                            Log.message(.debug, message: "\(type(of: object)) Request content: \(dictionary)")
                        }
                    }
                )
                .map { _ -> Data in try wrap(object.request) }
                .map { $0.toBase64String() }
                .map { ["Param" : $0] }
                .do(
                    onNext: { if debug.contains(.rawRequest) { Log.message(.debug, message: "Raw Resquest: \($0)") } }
                )
                .map { try JSONSerialization.data(withJSONObject: $0, options: []) }
                .map { data -> URLRequest in
                    guard let url = URL(string: object.URL.URLString) else {
                        throw HTTPError.invalidURL
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpBody = data
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
            }
    }
    
    private func createGoogleJSONRequest<T, Request> (object: T, debug: HTTPDebugOptions) -> Observable<URLRequest>
        where T: HTTPProtocol,
        T: HTTPWrapRequestProtocol,
        Request == T.RequestType {
            return Observable.just()
                .do(
                    onNext: { _ in
                        if debug.contains(.default) {
                            let dictionary: WrappedDictionary = try wrap(object.request)
                            Log.message(.debug, message: "\(type(of: object)) Request content: \(dictionary)")
                        }
                    }
                )
                .map { _ -> WrappedDictionary in try wrap(object.request) }
                .map { object.URL.URLString + $0.stringFromHttpParameters() }
                .map { URL(string: $0) }
                .filterNil()
                .map { url -> URLRequest in
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    return request
            }
    }
    
    fileprivate func doJSONRequest<T>(object: T, request: URLRequest, debug: HTTPDebugOptions) -> Observable<Unboxer> where T: HTTPProtocol  {
        let response = URLSession.shared.rx.data(request: request)
            .takeUntil(self.stack.asObservable().filter { $0 == object.URL.URLString })
            .timeout(object.timeoutInterval, scheduler: ConcurrentMainScheduler.instance)
            .map { response -> String in
                guard let result = String(data: response, encoding: .utf8), result.characters.count > 0
                    else { throw HTTPError.cannotConvertDataToString }
                return result
            }
            .do(
                onNext: {
                    if debug.contains(.rawResponse) { Log.message(.debug, message: "RAW RESPONSE: \($0)") }
                }
            )
            
        if object is HTTPGoogleProtocol {
            return response
                .map { $0.data(using: .utf8) }
                .filterNil()
                .map { try Unboxer(data: $0) }
        } else {
            return response
                .map { try $0.base64ToNSData() }
                .map { try Unboxer(data: $0) }
                .do(
                    onNext: { if debug.contains(.default) { Log.message(.info, message: "\(type(of: object)) Response: \($0.dictionary)") } }
                )
            
        }
        
    }
    
    
    func request<T, Request, Response>(type: T.Type, request content: Request, completionHandler: @escaping (Result<Response>) -> Void)
        where T: HTTPProtocol,
        T: HTTPGoogleRequestProtocol,
        T: HTTPGoogleResponseProtocol,
        Request == T.RequestType,
        Response == T.ResponseType {
            let object = type.init(request: content)
            stack.onNext(object.URL.URLString)
            
            Observable.just(object)
                .flatMap { $0.serialize(content) }
                .do( onNext: { _ in Log.message(.debug, message: "\(type(of: object)) Request: \(object.request)") } )
                .map { object.URL.URLString + $0.stringFromHttpParameters() }
                .map { URL(string: $0) }
                .filterNil()
                .map { url -> URLRequest in
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    return request
                }
                .flatMap { [unowned self, object] request -> Observable<Result<Response>> in
                    URLSession.shared
                        .rx.data(request: request)
                        .takeUntil(self.stack.asObservable().filter { $0 == object.URL.URLString })
                        .timeout(object.timeoutInterval, scheduler: ConcurrentMainScheduler.instance)
                        .map { try JSONSerialization.jsonObject(with: $0, options: []) }
                        .map { JSON($0) }
                        .map { try object.deserialize(origin: object.request, data: $0) }
                        .map { .success($0) }
                        .catchError { error -> Observable<Result<Response>> in
                            if (error as NSError).code == -1009 { return Observable.error(RxError.timeout) }
                            return Observable.error(error)
                        }
                        .do(
                            onNext: { Log.message(.info, message: "\(type(of: object)) Response: \($0)") },
                            onError: { Log.message(.error, message: "\(type(of: object)) Response: \($0)") }
                        )
                        .catchError { error -> Observable<Result<Response>> in
                            Observable.just(.failure(error))
                    }
                }
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { completionHandler($0) })
                .addDisposableTo(bag)

    }
    
     */
    
    
}

