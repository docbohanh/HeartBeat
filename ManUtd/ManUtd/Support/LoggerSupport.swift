//
//  LoggerSupport.swift
//  G5TaxiUser
//
//  Created by Hoan Pham on 10/30/15.
//  Copyright © 2015 Hoan Pham. All rights reserved.
//

import Foundation
import CleanroomLogger

public struct CustomLogConfiguration: LogConfiguration {
    
    /** The minimum `LogSeverity` supported by the configuration. */
    public let minimumSeverity: LogSeverity
    
    /** The list of `LogFilter`s to be used for filtering log messages. */
    public let filters: [LogFilter]
    
    /** The list of `LogRecorder`s to be used for recording messages to the
     underlying logging facility. */
    public let recorders: [LogRecorder]
    
    /** A flag indicating when synchronous mode should be used for the
     configuration. */
    public let synchronousMode: Bool
    
    public init(minimumSeverity: LogSeverity, dayToKeep: Int, filePath: String?) {
        self.minimumSeverity = minimumSeverity
        self.filters = []
        self.synchronousMode = false
        let fileformatter = StandardLogFormatter(timestampStyle: .custom("HH:mm:ss.sss"), severityStyle: .xcode, delimiterStyle: .spacedPipe, showCallSite: false, showCallingThread: false, colorizer: nil, colorTable: nil)
        let formatter = XcodeLogFormatter(timestampStyle: .custom("HH:mm:ss.sss"), severityStyle: .xcode, delimiterStyle: .spacedPipe, colorTable: nil)
        let config = XcodeLogConfiguration(minimumSeverity: .verbose, logToASL: false, colorizer: nil, colorTable: nil, filters: [], formatter: formatter)
        
        //        self.recorders = config.recorders
        
        //        let ASLRecorder = ASLLogRecorder(formatters: [formatter])
        guard let path = filePath else { self.recorders = config.recorders ; return }
        let dailyLogger = RotatingLogFileRecorder(daysToKeep: 7, directoryPath: path, formatters: [fileformatter])
        self.recorders = config.recorders +  [dailyLogger]
        
    }
    
    
    
    
}


public struct CustomColorTable: ColorTable {
    
    public func foreground(forSeverity severity: LogSeverity) -> Color? {
        switch severity {
        case .verbose:
            return Color(r: 100, g: 100, b: 100)
            
        case .debug:
            return Color(r: 175, g: 175, b: 175)
            
        case .info:
            return Color(r: 16, g: 162, b: 99)
            
        case .warning:
            return Color(r: 255, g: 207, b: 80)
            
        case .error:
            return Color(r: 222, g: 80, b: 68)
            
        }
    }
    
    public func background(forSeverity severity: LogSeverity) -> Color? {
        return Color(r: 0, g: 0, b: 0)
    }
}

