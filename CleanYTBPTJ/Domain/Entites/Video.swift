//
//  Video.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2021/12/27.
//

import Foundation

//Equatable을 통해 페이지비교를 가능케한다.
//유튜브
struct Video: Equatable {

    let title: String?

}

struct VideosPage: Equatable {
    let videos: [Snippet]
}

struct Snippet: Equatable {
    let id: Video
}


