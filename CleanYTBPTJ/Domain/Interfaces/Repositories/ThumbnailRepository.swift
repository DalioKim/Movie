
import Foundation
import UIKit

protocol ThumbnailRepository {
    func fetchImage(with imagePath: String, width: Int, completion: @escaping (UIImage?) -> ())
}
