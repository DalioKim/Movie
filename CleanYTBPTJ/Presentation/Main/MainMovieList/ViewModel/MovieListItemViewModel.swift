import Foundation

class MovieListItemViewModel {
    let title: String
    let thumbnailImagePath: String?
    
    init(movie: Movie) {
        self.title = movie.title ?? ""
        self.thumbnailImagePath = movie.path
    }
}
