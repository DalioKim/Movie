
import Foundation

struct Movie: Equatable {
    let title: String?
    let path: String?
}

struct MoviesPage: Equatable {
    let movies: [Movie]
}

enum MovieQuery: Equatable {
    case initial
    case search(value: String)
    
    var value: String {
        switch self {
        case .initial: return "마블"
        case .search(let value): return value
        }
    }
}

struct MovieRequest: Codable, Equatable {
    let query: String
}
