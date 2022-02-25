import Foundation

struct MovieListItemViewModel: Equatable {
    let title : String
    let thumbnailImagePath : String?
}

extension MovieListItemViewModel {
    
    init(movie: Movie) {
        self.title = movie.title ?? ""
        self.thumbnailImagePath = movie.path
    }
}
