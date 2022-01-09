//
//  ImagesResponseDTO+Mapping.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/01/08.
//

import Foundation

struct ImageResponseDTO  : Decodable{
  
    let items: [ImageDTO]
}

extension ImageResponseDTO{
    struct ImageDTO : Decodable{
     
        let title : String?
        let image : String?

        
    }
}

extension ImageResponseDTO {
    func toDomain() -> ImagesPage {
        return .init(
            images: items.map { $0.toDomain() })
    }
}

extension ImageResponseDTO.ImageDTO {
    func toDomain() -> Image {
        return .init(title: title,
                     path : image)
    }

}
