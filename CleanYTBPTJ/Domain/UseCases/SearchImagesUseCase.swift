
import Foundation

protocol SearchImagesUseCase {
    func execute(requestValue: SearchImagesUseCaseRequestValue,
                 cached: @escaping (ImagesPage) -> Void,
                 completion: @escaping (Result<ImagesPage, Error>) -> Void) -> Cancellable?
}


/*
 유스케이스에서 레포짓을 파라미터로 받는 이육가 뭐지?
 */
final class DefaultSearchImagesUseCase: SearchImagesUseCase {
 
    

    private let ImagesRepository: ImagesRepository

    init(ImagesRepository: ImagesRepository) {

        self.ImagesRepository = ImagesRepository
    }
    


    func execute(requestValue: SearchImagesUseCaseRequestValue,
                 cached: @escaping (ImagesPage) -> Void,
                 completion: @escaping (Result<ImagesPage, Error>) -> Void) -> Cancellable? {
        printIfDebug("networkTask - execute")

        return ImagesRepository.fetchImagesList(query: requestValue.query,
                                                page: requestValue.page,
                                                cached: cached,
                                                completion: { result in

//            if case .success = result {
//                self.ImagesQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
//            }

            completion(result)
        })
    }
}

struct SearchImagesUseCaseRequestValue {
    let query: ImageQuery
    let page: Int
}
