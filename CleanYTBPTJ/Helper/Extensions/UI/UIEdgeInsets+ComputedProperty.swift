//
//  UIEdgeInsets.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/03/16.
//

import UIKit

extension UIEdgeInsets {
    var horizontal: CGFloat {
        left + right
    }
    var vertical: CGFloat {
        top + bottom
    }
}
