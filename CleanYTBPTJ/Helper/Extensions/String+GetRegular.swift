import Foundation
import UIKit

extension String {
    
    func getRegular() -> String {
        return self.replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
    }
}
