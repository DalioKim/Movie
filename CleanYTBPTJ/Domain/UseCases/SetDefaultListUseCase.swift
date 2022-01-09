
import Foundation

protocol SetDefaultListUseCase {
    func execute(requestValue: SetDefaultListUseCaseRequestValue,
                 cached: @escaping (ImagesPage) -> Void,
                 completion: @escaping (Result<ImagesPage, Error>) -> Void) -> Cancellable?
}


final class DefaultSetDefaultListUseCase: SetDefaultListUseCase {
    
    
    func execute(requestValue: SetDefaultListUseCaseRequestValue, cached: @escaping (ImagesPage) -> Void, completion: @escaping (Result<ImagesPage, Error>) -> Void) -> Cancellable? {
        printIfDebug("networkTask - execute")

                return imagesRepository.fetchImagesList(query: requestValue.query,
                                                        page: requestValue.page,
                                                        cached: cached,
                                                        completion: { result in
        
        
                    completion(result)
                })
    }
    
 
    

    private let imagesRepository: ImagesRepository
    
    init(imagesRepository: ImagesRepository) {

        self.imagesRepository = imagesRepository
    }
    


}

struct SetDefaultListUseCaseRequestValue {
    //let query: VideoQuery
    let query: ImageQuery
    let page: Int
}
