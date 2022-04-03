//
//  API.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/01.
//

import RxSwift

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case noData
}

extension API {
    static func fetchMovieList(_ Api: API) -> Single<MovieResponseDTO> {
        Single.create { single in
            URLSession.shared.dataTask(with: Api.urlRequest) { data, result, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let data = data else {
                    single(.failure(NetworkError.noData))
                    return
                }
                guard let response = try? JSONDecoder().decode(MovieResponseDTO.self, from: data) else { fatalError() }
                single(.success(response))
            }.resume()
            return Disposables.create()
        }
    }
}
