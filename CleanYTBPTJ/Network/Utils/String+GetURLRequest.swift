//
//  String+GetURLRequest.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/03/23.
//

import Foundation

extension String {
    var getURLRequest: URLRequest {
        let appConfiguration = AppConfiguration()
        let urlString = "https://openapi.naver.com/v1/search/movie.json?query=" + self
        
        guard let url = URL(string: urlString) else { fatalError() }
        var request = URLRequest(url: url)
        request.addValue(appConfiguration.id, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(appConfiguration.apiKey, forHTTPHeaderField: "X-Naver-Client-Secret")
        return request
    }
}
