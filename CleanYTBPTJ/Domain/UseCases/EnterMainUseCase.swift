
import Foundation

protocol EnterMainUseCase {
    func execute(requestValue: EnterMainUseCaseRequestValue,
                 completion: @escaping (Result<[MovieListItemCellModel], Error>) -> Void) -> CancelDelegate?
}


final class DefaultEnterMainUseCase: EnterMainUseCase {
    
    private let moviesRepository: MoviesRepository
    
    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func execute(requestValue: EnterMainUseCaseRequestValue,
                 completion: @escaping (Result<[MovieListItemCellModel], Error>) -> Void) -> CancelDelegate? {
        
        printIfDebug("networkTask - execute")
    
        return moviesRepository.fetchMovieList(
            query: requestValue.query,
            page: requestValue.page,
            completion: { result in
                completion(result)
            })
    }
}

struct EnterMainUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}
