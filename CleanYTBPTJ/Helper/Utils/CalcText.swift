//
//  CalcText.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/03/24.
//

import Foundation
import UIKit

class CalcText {
    static func height(text: String, numberOfLines: Int, width: CGFloat, font: UIFont) -> CGFloat {
        let attributedText = NSAttributedString(string: text, attributes: [
            .font: font
        ])
        return height(attributedText: attributedText, numberOfLines: numberOfLines, width: width)
    }

    static func height(attributedText: NSAttributedString, numberOfLines: Int, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        if attributedText.string.isEmpty {
            return attributedText.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).height
        }
        let attributedText = NSMutableAttributedString(attributedString: attributedText)
        let style = (attributedText.attributes(at: 0, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) ?? NSParagraphStyle()
        let paragraphStyle = (style.mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = paragraphStyle.lineBreakMode == .byCharWrapping ? .byCharWrapping : .byWordWrapping
        attributedText.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText.length))

        let boundingSize = attributedText.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
        if numberOfLines == 0 {
            return boundingSize.height
        } else if let font = attributedText.attributes(at: 0, effectiveRange: nil)[.font] as? UIFont {
            var lineHeight = font.lineHeight
            if style.maximumLineHeight != 0 {
                lineHeight = min(lineHeight, style.maximumLineHeight)
            }
            if style.minimumLineHeight != 0 {
                lineHeight = max(lineHeight, style.minimumLineHeight)
            }
            let lineCount = min(Int(ceil(boundingSize.height / lineHeight)), numberOfLines)
            return min(lineHeight * CGFloat(lineCount), boundingSize.height)
        }
        return boundingSize.height
    }
}
