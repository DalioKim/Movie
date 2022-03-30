//
//  API.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/03/22.
//

import RxSwift
import Moya

class API {
    static func fetchMovieList(_ query: String) -> Single<[MovieResponse.Movie]> {
        Single.create { single in
            let provider = MoyaProvider<MovieAPI>()
            provider.rx.request(.initial)
                .map(MovieResponse.self)
                .compactMap { $0.items }
                .subscribe(onSuccess: { items in
                    single(.success(items))
                }, onError: { error in
                    single(.failure(error))
                })
            return Disposables.create()
        }
    }
        
    static func read(itemNo: Int) -> Single<Void> {
        Single.create { single in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                single(.success(()))
            }
            return Disposables.create()
        }
    }
}


