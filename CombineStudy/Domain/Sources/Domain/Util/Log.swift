//
//  Log.swift
//  Domain
//
//  Created by 김호성 on 2025.06.28.
//

import Foundation
import os

public final class Log {
    
    private static let subsystem: String = Bundle.main.bundleIdentifier ?? "com.hosungkim.cleanarchitecturemvi"
    private static let logger: Logger = Logger(subsystem: subsystem, category: "Log")
    
    private static let enabled: Bool = true
    
    private init() { }
    
    public enum OutputMethod {
        public typealias Closure = (_ object: Any?...) -> Void
        
        case oslog
        case nslog
        case print
        case custom(Closure)
    }
    
    public static func d(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #file, line: Int = #line, funcName: String = #function) {
        #if DEBUG
        log(objects, separator: separator, level: .debug, method: method, filename: filename, line: line, funcName: funcName)
        #endif
    }
    
    public static func i(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #file, line: Int = #line, funcName: String = #function) {
        log(objects, separator: separator, level: .info, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    public static func n(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #file, line: Int = #line, funcName: String = #function) {
        log(objects, separator: separator, level: .notice, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    public static func e(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #file, line: Int = #line, funcName: String = #function) {
        log(objects, separator: separator, level: .error, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    public static func f(_ objects: Any?..., separator: String = " ", method: OutputMethod = .oslog, filename: String = #file, line: Int = #line, funcName: String = #function) {
        log(objects, separator: separator, level: .fault, method: method, filename: filename, line: line, funcName: funcName)
    }
    
    private enum Level: String {
        case debug  = "DEBUG"
        case info   = "INFO"
        case notice = "NOTICE"
        case error  = "ERROR"
        case fault  = "FAULT"
        
        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .notice:
                return .default
            case .error:
                return .error
            case .fault:
                return .fault
            }
        }
    }
    
    private static func log(_ objects: [Any?], separator: String, level: Level, method: OutputMethod, filename: String, line: Int, funcName: String) {
        guard enabled else { return }
        let objectsMessage: String = objects.map({ "\($0 ?? "nil")" }).joined(separator: separator)
        let message: String = "\(dateFormatter.string(from: Date())) [\(level.rawValue)] [\(getThreadName())] [\(getFileName(filename)):\(line)] \(funcName) : \(objectsMessage)"
        switch method {
        case .oslog:
            logger.log(level: level.osLogType, "\(message)")
        case .nslog:
            NSLog(message)
        case .print:
            print(message)
        case .custom(let closure):
            closure(objects)
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    private static func getFileName(_ file: String) -> String {
        return file.components(separatedBy: "/").last ?? file
    }
    
    private static func getThreadName() -> String {
        if Thread.current.isMainThread {
            return "Main"
        } else {
            // <NSThread: 0x600001709040>{number = 6, name = (null)}
            let threadNumber = Thread.current.description.split(separator: ",").first!.split(separator: "=").last!.trimmingCharacters(in: .whitespaces)
            return "\(threadNumber)"
        }
    }
}
