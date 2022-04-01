//
//  UIImageView+Kingfisher.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/03/24.
//

import Kingfisher

extension UIImageView {
    func setImage(_ imagePath: String?, errorImage: UIImage? = nil) {
        getCacheImage(imagePath) { [weak self] image in
            switch image {
            case .some(let image):
                self?.image = image
            case .none:
                guard let imagePath = imagePath, let imageURL = URL(string: imagePath) else {
                    self?.image = errorImage
                    return
                }
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imagePath)
                self?.kf.indicatorType = .activity
                self?.kf.setImage(with: resource) { [weak self] result in
                    if case let .failure(error) = result, !error.isTaskCancelled {
                        self?.image = errorImage
                    }
                }
            }
        }
    }
    
    func clear() {
        self.kf.cancelDownloadTask()
        self.image = nil
    }
    
    private func getCacheImage(_ imagePath: String?, completion: @escaping ((UIImage?) -> Void)) {
        guard let imagePath = imagePath else {
            completion(nil)
            return
        }
        ImageCache.default.retrieveImage(forKey: imagePath, options: [.cacheMemoryOnly]) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    static func initializeKingfisher() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
        ImageCache.default.memoryStorage.config.countLimit = 100
        ImageCache.default.memoryStorage.config.expiration = .days(30)
    }
    
}
