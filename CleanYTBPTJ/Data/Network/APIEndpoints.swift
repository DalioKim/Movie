

import Foundation

struct APIEndpoints {
    
    static func getVideos(with VideosRequestDTO: VideosRequestDTO) -> Endpoint<VideosResponseDTO> {
        printIfDebug("networkTask - APIEndpoints-getVideos")
        
    
      
        
        return Endpoint(path: "search",
                        method: .get,
                        queryParametersEncodable: VideosRequestDTO)
    }

    static func getMovies(with MovieRequestDTO: MovieRequestDTO) -> Endpoint<MovieResponseDTO> {
        printIfDebug("networkTask - APIEndpoints-getVideos")
        
    
      
        
        return Endpoint(path: "movie.json",
                        method: .get,
                        queryParametersEncodable: MovieRequestDTO)
    }
    
    
    
}
