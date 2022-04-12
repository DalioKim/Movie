//
//  API.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/03.
//

import RxSwift
import Moya

class API {
    static private let disposeBag = DisposeBag()
    
    static func fetchMovieList(query: String) -> Single<MovieResponseDTO> {
        Single.create { single in
            let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
            let provider = MoyaProvider<APITarget>(plugins: [plugin])
            provider.rx.request(.search(query: query))
                .filterSuccessfulStatusCodes()
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        guard let cellModels = try? JSONDecoder().decode(MovieResponseDTO.self, from: response.data) else {
                            single(.failure(NetworkError.parseError))
                            return
                        }
                        single(.success(cellModels))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }.disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}
