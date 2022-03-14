//
//  CalculateString.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/03/14.
//

import Foundation
import UIKit

class CalculateString {
    static func calculateHeight(width: CGFloat, title: String, font: UIFont) -> CGFloat {
        let constraintRect =
        CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = title.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
