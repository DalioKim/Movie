
import Foundation

protocol MoviesRepository {
    @discardableResult
    func fetchMovieList(query: MovieQuery,
                        page: Int,
                        completion: @escaping (Result<[MovieListItemCellModel], Error>) -> Void) -> CancelDelegate?
}
