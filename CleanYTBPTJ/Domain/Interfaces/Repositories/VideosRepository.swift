
import Foundation

protocol VideosRepository {
    @discardableResult
    func fetchVideosList(query: VideoQuery, page: Int,
                         cached: @escaping (VideosPage) -> Void,
                         completion: @escaping (Result<VideosPage, Error>) -> Void) -> Cancellable?
}
