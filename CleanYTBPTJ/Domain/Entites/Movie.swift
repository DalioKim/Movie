
import Foundation

struct Movie: Equatable {
    let title: String?
    let path: String?
}

struct MoviesPage: Equatable {
    let movies: [Movie]
}
