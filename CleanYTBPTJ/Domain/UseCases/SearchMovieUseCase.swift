
import Foundation

protocol SearchMovieUseCase {
    func execute(requestValue: SearchMovieUseCaseRequestValue,
                 completion: @escaping (Result<[MovieListItemCellModel], Error>) -> Void) -> CancelDelegate?
}

final class DefaultSearchMovieUseCase: SearchMovieUseCase {
    
    private let moviesRepository: MoviesRepository
    
    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func execute(requestValue: SearchMovieUseCaseRequestValue,
                 completion: @escaping (Result<[MovieListItemCellModel], Error>) -> Void) -> CancelDelegate? {

        return moviesRepository.fetchMovieList(
            query: requestValue.query,
            page: requestValue.page,
            completion: { result in
                completion(result)
            })
    }
}

struct SearchMovieUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}
