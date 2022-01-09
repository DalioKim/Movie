

import Foundation

//유튜브
struct VideosResponseDTO : Decodable  {
    private enum CodingKeys: String, CodingKey {
        case Videos = "items"
    }
    let Videos: [SnippetDTO]
}

extension VideosResponseDTO{
    struct SnippetDTO  : Decodable {
        private enum CodingKeys: String, CodingKey {
            case id = "snippet"

        }

        let id: VideoDTO
    }
}

extension VideosResponseDTO {
    struct VideoDTO  : Decodable {
        enum GenreDTO: String, Decodable {
            case adventure
            case scienceFiction = "science_fiction"
        }
        let title: String?
        let genre: GenreDTO?

    }
}

// MARK: - Mappings to Domain

extension VideosResponseDTO {
    func toDomain() -> VideosPage {
        return .init(
                     videos: Videos.map { $0.toDomain() })
    }
}

extension VideosResponseDTO.SnippetDTO {
    func toDomain() -> Snippet {
        return .init(id: id.toDomain())
      //  return .init(id: Video.init(title: "test"))

    }
}

extension VideosResponseDTO.VideoDTO {
    func toDomain() -> Video {
        return .init(title: title)
    }
}



// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
