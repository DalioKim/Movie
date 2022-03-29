//
//  CalculateHeightTest.swift
//  CleanYTBPTJTests
//
//  Created by 김동현 on 2022/03/23.
//

import XCTest
@testable import CleanYTBPTJ

class CalculateHeightTest: XCTestCase {
    
    let baseChar = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let beforeRandomBase: UInt32 = 20
    let beforeWidthbase: CGFloat = 1000
    let afterRandomBase: UInt32 = 300
    let afterWidthbase: CGFloat = 100
    
    func testExample() throws {
        //        testCalculateHeight(randomBase: beforeRandomBase, widthbase: beforeWidthbase)
        testCalculateHeight(randomBase: afterRandomBase, widthbase: afterWidthbase)
    }
    
    func testCalculateHeight(randomBase: UInt32, widthbase: CGFloat) {
        
        let firstRandomsize = arc4random_uniform(randomBase) + randomBase
        let firstTestableTitle = baseChar.createRandomStr(length: Int(firstRandomsize))
        let firstTitleHeight = CalculateString.calculateHeight(width: widthbase, title: firstTestableTitle, font: MovieListItemCell.Font.titleFont)
        
        let secRandomsize = arc4random_uniform(randomBase) + randomBase
        let secTestableTitle = baseChar.createRandomStr(length: Int(secRandomsize))
        let secTitleHeight = CalculateString.calculateHeight(width: widthbase, title: secTestableTitle, font: MovieListItemCell.Font.titleFont)
        
        if firstTestableTitle.count > secTestableTitle.count {
            print("1번 타이틀 글자수는 \(firstTestableTitle.count), 2번 타이틀 글자수는 \(secTestableTitle.count)입니다. 1번 타이틀 높이\(firstTitleHeight)가 2번 타이틀 높이\(secTitleHeight)보다 높아야 합니다.")
            XCTAssertGreaterThan(firstTitleHeight, secTitleHeight)
        } else {
            print("2번 타이틀 글자수는 \(secTestableTitle.count), 1번 타이틀 글자수는 \(firstTestableTitle.count)입니다. 2번 타이틀 높이\(secTitleHeight)가 1번 타이틀 높이\(firstTitleHeight)보다 높아야 합니다.")
            XCTAssertGreaterThan(secTitleHeight, firstTitleHeight)
        }
    }
}

extension String {
    func createRandomStr(length: Int) -> String {
        let str = (0 ..< length).map{ _ in self.randomElement()! }
        return String(str)
    }
}
