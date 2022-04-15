//
//  API.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/03.
//

import RxSwift
import Moya

class API {
    static private let provider = MoyaProvider<APITarget>()
        
    static func search(_ query: String) -> Single<MovieResponseDTO> {
        return API.provider.rx.request(.search(query: query))
            .filterSuccessfulStatusCodes()
            .map(MovieResponseDTO.self)
    }
}
