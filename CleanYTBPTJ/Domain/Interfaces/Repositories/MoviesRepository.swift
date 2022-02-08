
import Foundation

protocol MoviesRepository {
    
    @discardableResult
    func fetchMovieList(query: MovieQuery,
                        page: Int,
                        cached: @escaping (MoviesPage) -> [MovieListItemViewModel],
                        completion: @escaping (Result<MoviesPage, Error>) -> Void) -> CancelDelegate?
}
