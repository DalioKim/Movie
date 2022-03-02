
import Foundation

protocol EnterMainUseCase {
    func execute(requestValue: EnterMainUseCaseRequestValue,
                 cached: @escaping (MoviesPage) -> Void,
                 completion: @escaping (Result<MoviesPage, Error>) -> Void) -> CancelDelegate?
}


final class DefaultEnterMainUseCase: EnterMainUseCase {
    
    private let moviesRepository: MoviesRepository
    
    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func execute(requestValue: EnterMainUseCaseRequestValue,
                 cached: @escaping (MoviesPage) -> Void,
                 completion: @escaping (Result<MoviesPage, Error>) -> Void) -> CancelDelegate? {
        
        printIfDebug("networkTask - execute")
    
        return moviesRepository.fetchMovieList(
            query: requestValue.query,
            page: requestValue.page,
            cached: cached,
            completion: { result in
                completion(result)
            })
    }
}

struct EnterMainUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}
