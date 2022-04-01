//
//  MovieAPI.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/01.
//

import RxSwift

class MovieAPI {
    static func fetchMovieList(_ query: MovieQuery) -> Single<MovieResponseDTO> {
        Single.create { single in
            URLSession.shared.dataTask(with: query.value.getURLRequest) { data, result, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let data = data else {
                    let httpResponse = result as! HTTPURLResponse
                    single(.failure(NSError(domain: "no data", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }
                guard let response = try? JSONDecoder().decode(MovieResponseDTO.self, from: data) else { fatalError() }
                single(.success(response))
            }.resume()
            return Disposables.create()
        }
    }
}
