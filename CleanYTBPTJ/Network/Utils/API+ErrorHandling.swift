//
//  API+ErrorHandling.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/14.
//
import RxSwift
import Moya
import Alamofire

extension API {
    static func handleInternetConnection<T: Any>(error: Error) throws -> Single<T> {
        guard
            let urlError = Self.converToURLError(error),
            Self.isNotConnection(error: error)
        else { throw error }
        throw NetworkError.internetConnection(urlError)
    }
    
    static func handleTimeOut<T: Any>(error: Error) throws -> Single<T> {
        guard
            let urlError = Self.converToURLError(error),
            urlError.code == .timedOut
        else { throw error }
        throw NetworkError.requestTimeout(urlError)
    }
    
    static func handleREST<T: Any>(error: Error) throws -> Single<T> {
        guard error is NetworkError else {
            throw NetworkError.restError(
                error,
                statusCode: (error as? MoyaError)?.response?.statusCode,
                errorCode: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["code"] as? String
            )
        }
        throw error
    }
}

extension API {
    static func converToURLError(_ error: Error) -> URLError? {
        print("\(#function) error : \(error)")
        switch error {
        case let MoyaError.underlying(afError as AFError, _):
            fallthrough
        case let afError as AFError:
            return afError.underlyingError as? URLError
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            return urlError
        default:
            return nil
        }
    }
    
    static func isNotConnection(error: Error) -> Bool {
        Self.converToURLError(error)?.code == .notConnectedToInternet
    }
    
    static func isLostConnection(error: Error) -> Bool {
        switch error {
        case let AFError.sessionTaskFailed(error: posixError as POSIXError)
            where posixError.code == .ECONNABORTED: 
            print("\(#function) error : \(error)")
            break
        case let MoyaError.underlying(urlError as URLError, _):
            fallthrough
        case let urlError as URLError:
            guard urlError.code == URLError.networkConnectionLost else { fallthrough }
            print("\(#function) error : \(error)")
            break
        default:
            return false
        }
        return true
    }
}
