//
//  ReachabilitySupport.swift
//  PhuongTrangTaxi
//
//  Created by Hoan Pham on 12/11/15.
//  Copyright © 2015 Hoan Pham. All rights reserved.
//

import Foundation
import Reachability
import RxSwift


public enum ReachabilityStatus: Int {
    case reachable, unreachable
}

public class ReachabilitySupport {
    
    fileprivate let reachabilityRef = Reachability()!
    
    fileprivate let _reachabilityChangedSubject = PublishSubject<ReachabilityStatus>()
    
    public var reachabilityStatus : Observable<ReachabilityStatus> {
        return _reachabilityChangedSubject
            .asObservable()
            .startWith(networkReachable ? .reachable : .unreachable)
            .shareReplay(1)
    }
    
    // singleton
    public static let instance = ReachabilitySupport()
    
    init(){
        reachabilityRef.whenReachable = { reachability in
            self._reachabilityChangedSubject.on(.next(.reachable))
        }
        
        reachabilityRef.whenUnreachable = { reachability in
            self._reachabilityChangedSubject.on(.next(.unreachable))
        }
        
        try! reachabilityRef.startNotifier()
        
    }
    
    public var networkReachable: Bool {
        return reachabilityRef.isReachable
    }
}

extension ObservableConvertibleType {
    public func retryOnBecomesReachable(_ valueOnFailure:E, reachabilityService: ReachabilitySupport) -> Observable<E> {
        return self
            //Tạo observable
            .asObservable()
            
            // Nếu observable gặp event error (kết thúc) thì tiếp tục bằng obserable tạo từ handler
            .catchError { (e) -> Observable<E> in
                
                reachabilityService
                    // Reachability changed là một observable
                    .reachabilityStatus
                    .skip(1)
                    // Filter chỉ chấp nhận các kết quả có kết nối
                    .filter { $0 == .reachable }
                    // 
                    .flatMap { _ in Observable.error(e) }
                    .startWith(valueOnFailure)
            }
            .retry()
    }
}
