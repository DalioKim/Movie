//
//  NSObject+ClassName.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/06.
//

import Foundation

@objc
extension NSObject {
    public class var className: String {
        String(describing: self)
    }
}
