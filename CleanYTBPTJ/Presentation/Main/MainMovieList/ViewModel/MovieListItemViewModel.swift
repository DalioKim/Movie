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

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
