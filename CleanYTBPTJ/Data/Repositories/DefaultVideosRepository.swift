
import Foundation

final class DefaultVideosRepository {

    private let dataTransferService: DataTransferService
    private let cache: VideosResponseStorage

    init(dataTransferService: DataTransferService, cache: VideosResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }

   
}

extension DefaultVideosRepository: VideosRepository {
    
    
    
    func fetchVideosList(query: VideoQuery, page: Int, cached: @escaping (VideosPage) -> Void, completion: @escaping (Result<VideosPage, Error>) -> Void) -> Cancellable? {
        
        printIfDebug("networkTask - fetchVideosList")

        let requestDTO = VideosRequestDTO(part: "snippet", q: "짱구", type: "video", videoEmbeddable: "true", maxResults: page)

        
        
        let task = RepositoryTask()



        let endpoint = APIEndpoints.getVideos(with: requestDTO)
        

        
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {

            case .success(let responseDTO):
                printIfDebug("networkTask - fetchVideosList-success")

//                printIfDebug("success result : \(responseDTO)")
//
//                printIfDebug("networkTask success")
                
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                printIfDebug("networkTask - fetchVideosList-success")

             //   printIfDebug("networkTask failure")

                completion(.failure(error))
            }
        }
    
        return task
    }
    

  
}
