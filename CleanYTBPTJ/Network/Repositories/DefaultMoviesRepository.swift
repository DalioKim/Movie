
import Foundation

final class DefaultMoviesRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultMoviesRepository: MoviesRepository {
    func fetchMovieList(query: MovieQuery, page: Int, completion: @escaping (Result<[MovieListItemCellModel], Error>) -> Void) -> CancelDelegate? {
        let requestDTO = MovieRequestDTO(query: query.value)
        let task = RepositoryTask()
        let endpoint = APIEndpoints.getMovies(with: requestDTO)
        
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                printIfDebug("networkTask - fetchMovieList-success")
                let models = responseDTO.toDomain().movies.map { MovieListItemCellModel(movie: $0) }
                completion(.success(models))
            case .failure(let error):
                printIfDebug("networkTask - fetchMovieList-success")
                completion(.failure(error))
            }
        }
        return task
    }
}
