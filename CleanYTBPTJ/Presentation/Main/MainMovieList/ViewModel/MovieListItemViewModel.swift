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

// MARK: - Safe Array

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
