
import Foundation

struct MovieResponseDTO: Decodable {
    let items: [MovieDTO]
}

extension MovieResponseDTO {
    struct MovieDTO: Decodable {
        let title: String?
        let image: String?
    }
}

extension MovieResponseDTO {
    func toDomain() -> MoviesPage {
        return .init(movies: items.map { $0.toDomain() })
    }
}

extension MovieResponseDTO.MovieDTO {
    func toDomain() -> Movie {
        return .init(title: title, path: image)
    }
}
