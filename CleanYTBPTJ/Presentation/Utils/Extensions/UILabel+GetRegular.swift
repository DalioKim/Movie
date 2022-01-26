import Foundation
import UIKit

extension UILabel {

    func getRegular(title : String, titleLabel : UILabel) -> UILabel{
        printIfDebug("getRegular")
        var RegularTitle = title.replacingOccurrences(of: "<b>", with: "")

        RegularTitle = RegularTitle.replacingOccurrences(of: "</b>", with: "")
        
        titleLabel.text = RegularTitle
        return titleLabel
    }
}
