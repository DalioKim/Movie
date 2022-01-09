import Foundation

struct VideosListItemViewModel: Equatable {
    let title: String
//    let overview: String
//    let releaseDate: String
//    let thumbnailImagePath: String?
}

extension VideosListItemViewModel {

    init(video: Video) {
        self.title = video.title ?? ""
//        self.thumbnailImagePath = video.thumbnailImagePath
//        if let releaseDate = video.releaseDate {
//            self.releaseDate = "\(NSLocalizedString("Release Date", comment: "")): \(dateFormatter.string(from: releaseDate))"
//        } else {
//            self.releaseDate = NSLocalizedString("To be announced", comment: "")
//        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
