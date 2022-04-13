//
//  API.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/03.
//

import RxSwift
import Moya

class API {
    static func fetchMovieList(query: String) -> Single<MovieResponseDTO> {
        Single.create { single in
            let provider = MoyaProvider<APITarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
            provider.rx.request(.search(query: query))
                .filterSuccessfulStatusCodes()
                .map(MovieResponseDTO.self)
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        single(.success(response))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}
