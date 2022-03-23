//
//  ThumbnailAPI.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/03/24.
//

import Kingfisher

class ThumbnailAPI {
    static func fetchImage(with imagePath: String, completion: @escaping (UIImage?) -> ()) {
        let cache = ImageCache.default
        cache.retrieveImage(forKey: imagePath, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    completion(image)
                } else {
                    guard let imageURL = URL(string: imagePath) else { return }
                    let resource = ImageResource(downloadURL: imageURL)
                    KingfisherManager.shared.retrieveImage(with: resource) { result in
                        switch(result) {
                        case .success(let imageResult):
                            completion(imageResult.image)
                        case .failure(_):
                            completion(nil)
                        }
                    }
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
}
