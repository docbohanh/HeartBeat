//
//  Result.swift
//  G5TaxiUser
//
//  Created by Hoan Pham on 10/9/15.
//  Copyright © 2015 Hoan Pham. All rights reserved.
//

import Foundation

/**
Used to represent whether a request was successful or encountered an error.
- Success: The request and all post processing operations were successful resulting in the serialization of the
provided associated value.
- Failure: The request encountered an error resulting in a failure. The associated values are the original data
provided by the server as well as the error that caused the failure.
*/


public protocol ResultProtocol {
    associatedtype ValueType
    
    var isFailure: Bool { get }
    var isSuccess: Bool { get }
    
    var value: ValueType? { get }
    var error: Error? { get }
}

public enum Result<Value>: ResultProtocol {
    case success(Value)
    case failure(Error)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

// MARK: - CustomStringConvertible

extension Result: CustomStringConvertible {
    /// The textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure.
    public var description: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}

// MARK: - CustomDebugStringConvertible

extension Result: CustomDebugStringConvertible {
    /// The debug textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure in addition to the value or error.
    public var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}
