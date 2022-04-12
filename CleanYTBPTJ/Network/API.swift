//
//  API.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/03.
//

import RxSwift

class API {
    static func fetchMovieList<T>(_ apiTarget: T) -> Single<MovieResponseDTO> where T: TargetType {
        Single.create { single in
            guard let request = apiTarget.endPoint else {
                single(.failure(NetworkError.urlGeneration))
                return Disposables.create()
            }
            URLSession.shared.dataTask(with: request) { data, result, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let data = data else {
                    single(.failure(NetworkError.noData))
                    return
                }
                guard let response = try? JSONDecoder().decode(MovieResponseDTO.self, from: data) else {
                    single(.failure(NetworkError.parseError))
                    return
                }
                single(.success(response))
            }.resume()
            return Disposables.create()
        }
    }
}
