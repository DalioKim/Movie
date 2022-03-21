
import Foundation
import UIKit


final class DefaultThumbnailRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultThumbnailRepository: ThumbnailRepository {
    static func fetchImage(with imagePath: String, width: Int, completion: @escaping (UIImage?) -> ()) {
        guard let imageURL = URL(string: imagePath) else { return }
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: imageURL) {
                let image = UIImage(data: data)!
                DispatchQueue.main.async { completion(image) }
            } else {
                DispatchQueue.main.async { completion(nil) }
            }
        }
    }
}
