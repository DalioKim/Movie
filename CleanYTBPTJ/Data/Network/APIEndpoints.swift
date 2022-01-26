

import Foundation

struct APIEndpoints {

    static func getMovies(with MovieRequestDTO: MovieRequestDTO) -> Endpoint<MovieResponseDTO> {
        printIfDebug("networkTask - APIEndpoints-getMovies")
        
    
      
        
        return Endpoint(path: "movie.json",
                        method: .get,
                        queryParametersEncodable: MovieRequestDTO)
    }
    
    
    
}
