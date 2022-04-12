//
//  APITarget.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/04.
//

import Moya

enum APITarget {
    case search(query: String)
}

extension APITarget {
    static private let clientId = "TWoWW_E7wbQRF4USjpy9"
    static private let clientKey = "Q0kcELtfaA"
}

extension APITarget: Moya.TargetType {
    var baseURL: URL {
        return URL(string: "https://openapi.naver.com") ?? URL(fileURLWithPath: "")
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/search/movie.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .search(let query):
            return .requestParameters(parameters: ["query": query], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .search:
            return ["X-Naver-Client-Id": APITarget.clientId, "X-Naver-Client-Secret": APITarget.clientKey]
        }
    }
}
