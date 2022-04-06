//
//  APITarget.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/04.
//

import Foundation
import Alamofire

public protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: [URLQueryItem] { get }
    var headers: [String: String]? { get }
    var endPoint: URLRequest { get }
}

enum APITarget: Codable {
    case search(query: String)
}

extension APITarget {
    static private let clientId = "TWoWW_E7wbQRF4USjpy9"
    static private let clientKey = "Q0kcELtfaA"
}

extension APITarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://openapi.naver.com") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/search/movie.json?"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var task: [URLQueryItem] {
        switch self {
        case .search(let query):
            return ["query": query]
                .toDictionary().map {
                    URLQueryItem(name: $0.key, value: "\($0.value)")
                }
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .search:
            return ["X-Naver-Client-Id": APITarget.clientId, "X-Naver-Client-Secret": APITarget.clientKey]
        }
    }
    
    var endPoint: URLRequest {
        let urlSting = baseURL.absoluteString + path
        guard var urlComponents = URLComponents(string:urlSting) else { fatalError() }
        urlComponents.queryItems = task
        guard let url = urlComponents.url else { fatalError() }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
}

private extension Encodable {
    func toDictionary() -> [String: Any] {
        do {
            let jsonEncoder = JSONEncoder()
            let encodedData = try jsonEncoder.encode(self)
            
            let dictionaryData = try JSONSerialization.jsonObject(
                with: encodedData,
                options: .allowFragments
            ) as? [String: Any]
            return dictionaryData ?? [:]
        } catch {
            return [:]
        }
    }
}
