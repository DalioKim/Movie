
import Foundation

protocol ImagesRepository {
    @discardableResult
    func fetchImagesList(query: ImageQuery, page: Int,
                         cached: @escaping (ImagesPage) -> Void,
                         completion: @escaping (Result<ImagesPage, Error>) -> Void) -> Cancellable?
}
