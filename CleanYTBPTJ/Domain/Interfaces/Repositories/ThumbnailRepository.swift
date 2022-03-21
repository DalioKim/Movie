
import Foundation
import UIKit

protocol ThumbnailRepository {
    static func fetchImage(with imagePath: String, width: Int, completion: @escaping (UIImage?) -> ())
}
