//
//  API+Method.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/03.
//

import Foundation

extension API {
    func getPath() -> String {
        switch self {
        case .initial: return "마블"
        case .search(let query): return query
        }
    }
    
    func getBaseURL() -> URL {
        guard var urlComponents = URLComponents(string: "https://openapi.naver.com/v1/search/movie.json?") else { fatalError() }
        let query = URLQueryItem(name: "query", value: getPath())
        urlComponents.queryItems?.append(query)
        guard let url = urlComponents.url else { fatalError() }
        return url
    }
    
    func getURLRequest() -> URLRequest {
        let appConfiguration = AppConfiguration()
        var request = URLRequest(url: getBaseURL())
        request.addValue(appConfiguration.id, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(appConfiguration.apiKey, forHTTPHeaderField: "X-Naver-Client-Secret")
        return request
    }
}
