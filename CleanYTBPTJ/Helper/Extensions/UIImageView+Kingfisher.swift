//
//  UIImageView+Kingfisher.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/03/24.
//

import Kingfisher

extension UIImageView {
    func setImage(_ imagePath: String) {
        getCacheImage(imagePath) { image in
            switch image {
            case .some(let image):
                self.image = image
            case .none:
                guard let imageURL = URL(string: imagePath) else { return }
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imagePath)
                self.kf.indicatorType = .activity
                self.kf.setImage(with: resource)
            }
        }
    }
    
    private func getCacheImage(_ imagePath: String, completion: @escaping ((UIImage?) -> Void)) {
        let cache = ImageCache.default
        cache.retrieveImage(forKey: imagePath, options: nil) { result in
            switch result {
            case .success(let value):
                guard let image = value.image else { return completion(nil) }
                completion(image)
            case .failure(_):
                self.image = nil
            }
        }
    }
}
