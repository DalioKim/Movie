//
//  VideosRequestDTO+Mapping.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/01/05.
//

import Foundation

//유튜브
struct VideosRequestDTO: Encodable {
    let part: String
    let q: String
    let type: String
    let videoEmbeddable: String
    let maxResults: Int
}




//struct spinnets  : Codable{
//    let title : String
//}
