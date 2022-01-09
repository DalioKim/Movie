
import Foundation
import UIKit


final class DefaultThumbnailRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }

   
}

extension DefaultThumbnailRepository: ThumbnailRepository {
    
    
    func fetchImage(with imagePath: String, width: Int, completion: @escaping (UIImage?) -> ()) {
        printIfDebug("DefaultThumbnailRepository fetchImage")

        printIfDebug("fetchImage imagePath : \(imagePath)")
                guard let imageURL = URL(string: imagePath) else { return }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: imageURL) {
                printIfDebug("fetchImage data : \(data)")

                let image = UIImage(data: data)!
                printIfDebug("fetchImage image : \(image)")

                DispatchQueue.main.async {
                    completion(image)
                    
                }
                
            } else {
                DispatchQueue.main.async { completion(nil) }
                
            }
            
        }


    }
    
    
    
  
}
