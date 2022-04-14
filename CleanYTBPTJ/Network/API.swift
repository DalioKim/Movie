//
//  API.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/03.
//

import RxSwift
import Moya

class API {
    static private let provider = MoyaProvider<APITarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    static func fetchMovieList(query: String) -> Single<MovieResponseDTO> {
        return provider.rx.request(.search(query: query))
            .filterSuccessfulStatusCodes()
            .map(MovieResponseDTO.self)
            .catch(self.handleInternetConnection)
            .catch(self.handleTimeOut)
            .catch(self.handleREST)
    }
}
