//
//  CalculateString.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/03/14.
//

import UIKit
import Foundation

class CalculateString {
    static func calculateHeight(width: CGFloat, title: String, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        return title.handledLineBreak.reduce(0) { $0 + $1.calculateBoundingRect(constraintRect, attributes: attributes) }
    }
}

extension String {
    func calculateBoundingRect(_ size: CGSize, options: NSStringDrawingOptions = [], attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        return self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).height
    }
}
