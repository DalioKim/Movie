
import Foundation
import UIKit

extension String {
    
    enum AttributedCase: String {
        case bold = "<b>"
        case h1 = "<h1>"
        case br = "<br>"
        case none
        
        func getAttributes() -> [NSAttributedString.Key: Any] {
            var attributes: [NSAttributedString.Key: Any]
            var font: UIFont // MARK: font 사이즈는 임시로 하드코딩 처리, 추후에 상수 처리 및 기종별 사이즈적용
            
            switch self {
            case .bold:
                font = .boldSystemFont(ofSize: 16)
                attributes = [.font: font]
                return attributes
            case .h1:
                font = .systemFont(ofSize: 22)
                attributes = [.font: font]
                return attributes
            case .br:
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byTruncatingHead
                paragraphStyle.lineSpacing = 2
                attributes = [.paragraphStyle: paragraphStyle]
                return attributes
            default:
                font = .systemFont(ofSize: 16)
                attributes = [.font: font]
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
    
    func applyTag() -> NSMutableAttributedString {
        let tagRegex = "(<|</)[a-z0-9]*>+"
        guard let tagInfo = searchTag(),
              let wordRange = tagInfo["wordRange"] as? Range<String.Index>,
              let replaceTag = tagInfo["replaceTag"] as? String,
              let attributes = tagInfo["attributes"] as? [NSAttributedString.Key: Any]
        else { return NSMutableAttributedString(string: self) }
        
        let word =  String(self[wordRange]).replacingOccurrences(of: tagRegex, with: "", options: .regularExpression)
        let removedTagText = self.replacingOccurrences(of: tagRegex, with: "", options: .regularExpression)
        let attributeText = NSMutableAttributedString(string: self.replacingOccurrences(of: tagRegex, with: replaceTag, options: .regularExpression))
        let range = (removedTagText as NSString).range(of: word)
        attributeText.addAttributes(attributes, range: range)
        return attributeText
    }
    
    func searchTag() -> Dictionary<String, Any>? {
        let wordRegex = "(<|</)[a-z0-9]*>(.*?)(<|</)[a-z0-9]*>"
        let startTagRegex = "(<)[a-z0-9]*>+"
        
        guard let tagRange = self.range(of: startTagRegex, options: .regularExpression) else { return nil }
        
        let attributedCase = AttributedCase(rawValue: String(self[tagRange]))
        let replaceTag = attributedCase?.replacedTag() ?? ""
        guard let wordRange = self.range(of: wordRegex, options: .regularExpression),
              let attributes = attributedCase?.getAttributes() else { return nil }
        
        let tagInfo = ["wordRange": wordRange, "replaceTag": replaceTag, "attributes": attributes] as [String: Any]
        return tagInfo
    }
}
