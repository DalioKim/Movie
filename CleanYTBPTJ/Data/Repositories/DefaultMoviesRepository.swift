
import Foundation

final class DefaultMoviesRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }

   
}

extension DefaultMoviesRepository: MoviesRepository {
    
    
    
    func fetchMovieList(query: MovieQuery, page: Int, cached: @escaping (MoviesPage) -> Void,
                        completion: @escaping (Result<MoviesPage, Error>) -> Void) -> CancelDelegate? {
        
        printIfDebug("networkTask - fetchMovieList")
        let requestDTO = MovieRequestDTO(query: "마블")
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getMovies(with: requestDTO)
        
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                printIfDebug("networkTask - fetchMovieList-success")
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                printIfDebug("networkTask - fetchMovieList-success")
                completion(.failure(error))
            }
        }
        return task
    }
}
