//
//  Image.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/01/08.
//

import Foundation

struct Image: Equatable {

    let title: String?
    let path : String?

}

struct ImagesPage: Equatable {
    let images: [Image]
}
