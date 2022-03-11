
import Foundation

class MovieListItemViewModel {
    let title: String
    let thumbnailImagePath: String?
    
    init(movie: Movie) {
        title = movie.title ?? ""
        thumbnailImagePath = movie.path
    }
}
