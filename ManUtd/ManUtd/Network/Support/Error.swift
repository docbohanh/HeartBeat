//
//  Error.swift
//  GPSNetwork
//
//  Created by Hoan Pham on 3/25/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation
/*
public enum TCPError: Error {
    case invalidMessageType
    case networkUnreachable
    case invalidSessionKey
    
    case loginFailed(String)
//    case DisruptedRetryableMessage(TCPClientRetryableProtocol)
    
//    case TCPEndedAndCancelSendingMessage(TCPClientProtocol)
    
    case pingMessageCancelledBecauseClientDisconnected
    case retryableMessageFinishedWithNoResponse(TCPClientRetryableProtocol)
    
    case invalidHeader
    case invalidMessageCode
    case invalidChecksum
    
    case extractingMessageOverFlow

    
    case couldNotInitializeMessage(Error, TCPServerProtocol.Type)
//    case CouldNotInitializeReloginMessage(TCPServerProtocol.Type)

    case reloginFailed
    
    case reloginStateError
}
*/
public enum HTTPError: Error {
    case companyLocked
    case couldNotDecryptResponseMessage
    case decryptionError(Error)
    case requestNotSerialized
    case cannotConvertNSDataResponseToString
    case networkUnreachable
    case invalidMessageStatus(HTTPProtocol.Type)
    case invalidSyncGroupIdentity
    case invalidSyncType
    case cannotConvertResponseToJSON
    case cannotConvertStringToURL
    case loginUnsuccessful
    case invalidResponseCode(Int)
    case updateRequired
    
    case sendFeedbackFailed
    case remoteMessageInvalidCode(Int)
    
    case cannotGetAddressOfVehicle(String)
    case invalidURL
    case cannotConvertDataToString
}

public enum HTTPGoogleError: Error {
    case invalidResponseStatus
    case noGeocodingFound
    case noDirectionFound
}

public enum AppError: Error {
    case invalidCoordinate
}
