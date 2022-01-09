

import Foundation

struct APIEndpoints {
    
    static func getVideos(with VideosRequestDTO: VideosRequestDTO) -> Endpoint<VideosResponseDTO> {
        printIfDebug("networkTask - APIEndpoints-getVideos")
        
    
      
        
        return Endpoint(path: "search",
                        method: .get,
                        queryParametersEncodable: VideosRequestDTO)
    }

    static func getImages(with ImageRequestDTO: ImageRequestDTO) -> Endpoint<ImageResponseDTO> {
        printIfDebug("networkTask - APIEndpoints-getVideos")
        
    
      
        
        return Endpoint(path: "movie.json",
                        method: .get,
                        queryParametersEncodable: ImageRequestDTO)
    }
    
    
    
}
