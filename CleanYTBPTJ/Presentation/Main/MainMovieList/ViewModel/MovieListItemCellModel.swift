
import Foundation
import SwiftUI

class MovieListItemCellModel {
    let _title: String
    let thumbnailImagePath: String?
    
    var title: String {
        get {
            return _title.removeTag()
        }
    }
    var atttributedTitle: NSMutableAttributedString {
        get {
            return _title.applyTag()
        }
    }
    
    init(movie: Movie) {
        _title = movie.title ?? ""
        thumbnailImagePath
        = movie.path
    }
}
