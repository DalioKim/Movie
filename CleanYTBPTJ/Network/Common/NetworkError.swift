//
//  NetworkError.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/04.
//

import Moya

enum NetworkError: Error {
    case empty
    case requestTimeout(Error)
    case restError(Error, statusCode: Int? = nil, errorCode: String? = nil)
    case internetConnection(Error)
    case cancelled
    case generic(Error)
    case urlGeneration
    case noData
    case parseError
    
    var statusCode: Int? {
        switch self {
        case let .restError(_, statusCode, _):
            return statusCode
        default:
            return nil
        }
    }
    var errorCodes: [String] {
        switch self {
        case let .restError(_, _, errorCode):
            return [errorCode].compactMap { $0 }
        default:
            return []
        }
    }
}
