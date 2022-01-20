//
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/01/05.
//

import Foundation
import UIKit

protocol ThumbnailRepository {
    
    func fetchImage(with imagePath: String, width: Int, completion: @escaping (UIImage?) -> ())
}
