import Foundation

struct MovieListItemViewModel: Equatable {
    let title : String
    let thumbnailImagePath : String
    
    init(title: String?, thumbnailImagePath: String?) {
       self.title = title ?? ""
       self.thumbnailImagePath = thumbnailImagePath ?? ""
   }
}


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
