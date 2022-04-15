//
//  NetworkError.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/04.
//

import Moya

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case noData
    case parseError
}
