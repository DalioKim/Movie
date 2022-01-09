
import Foundation

final class DefaultImagesRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }

   
}

extension DefaultImagesRepository: ImagesRepository {
    
    
    
    func fetchImagesList(query: ImageQuery, page: Int, cached: @escaping (ImagesPage) -> Void, completion: @escaping (Result<ImagesPage, Error>) -> Void) -> Cancellable? {
        
        printIfDebug("networkTask - fetchImagesList")
        
        let requestDTO = ImageRequestDTO(query: "마블")
        
        
        let task = RepositoryTask()



        let endpoint = APIEndpoints.getImages(with: requestDTO)
        

        
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {

            case .success(let responseDTO):
                printIfDebug("networkTask - fetchImagesList-success")


                
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                printIfDebug("networkTask - fetchImagesList-success")


                completion(.failure(error))
            }
        }
    
        return task
    }
    

  
}
