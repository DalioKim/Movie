import Foundation

struct ImagesListItemViewModel: Equatable {
    let title : String
    let thumbnailImagePath : String?

}

extension ImagesListItemViewModel {

    init(image: Image) {
        self.title = image.title ?? ""
        self.thumbnailImagePath = image.path


    }
}
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
