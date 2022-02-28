import Foundation
import UIKit

extension String {
    
    enum AttributedCase: String {
        case bold = "<b>"
        case h1 = "<h1>"
        case br = "<br>"
        case none
        
        func getAttributes() -> [NSAttributedString.Key: Any] {
            switch self {
            case .bold:
                let font = UIFont.boldSystemFont(ofSize: 16)
                let attributes: [NSAttributedString.Key: Any] = [.font: font]
                return attributes
            case .h1:
                let font = UIFont.systemFont(ofSize: 22)
                let attributes: [NSAttributedString.Key: Any] = [.font: font]
                return attributes
            default:
                let font = UIFont.systemFont(ofSize: 16)
                let attributes: [NSAttributedString.Key: Any] = [.font: font]
                return attributes
            }
        }
        
        func replacedTag() -> String {
            switch self {
            case .br:
                return "\n"
            default:
                return ""
            }
        }
    }
    
    func removeTag() -> NSMutableAttributedString {
        let wordRegex = "(<|</)[a-z0-9]*>(.*?)(<|</)[a-z0-9]*>"
        let tagRegex = "(<|</)[a-z0-9]*>+"
        let startTagRegex = "(<)[a-z0-9]*>+"
        
        guard let tagRange = self.range(of: startTagRegex, options: .regularExpression) else { return NSMutableAttributedString(string: self) }
        let attributedCase = AttributedCase(rawValue: String(self[tagRange]))
        guard let attributes = attributedCase?.getAttributes() else { return NSMutableAttributedString(string: self) }
        guard let wordRange = self.range(of: wordRegex, options: .regularExpression) else { return NSMutableAttributedString(string: self) }
        let word =  String(self[wordRange]).replacingOccurrences(of: tagRegex, with: "", options: .regularExpression)
        
        let resultSelf = self.replacingOccurrences(of: tagRegex, with: "", options: .regularExpression)
        let result = NSMutableAttributedString(string: self.replacingOccurrences(of: tagRegex, with: attributedCase?.replacedTag() ?? "", options: .regularExpression))
        let range = (resultSelf as NSString).range(of: word)
        result.addAttributes(attributes, range: range)
        return result
    }
}
