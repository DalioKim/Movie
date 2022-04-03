//
//  API.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/03.
//

import Foundation

enum API: Equatable {
    case initial
    case search(value: String)
}

extension API {
  var baseURL: URL { self.getBaseURL() }
  var path: String { self.getPath() }
  var urlRequest: URLRequest { self.getURLRequest() }
}
