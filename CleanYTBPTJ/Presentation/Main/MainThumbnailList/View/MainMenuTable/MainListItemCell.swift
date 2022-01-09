//
//  MoviesListItemCell.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2021/11/28.
//

import UIKit


class MainListItemCell: UITableViewCell {

    //private과 weak,strong 차이 좀 더 명확하게
    @IBOutlet private var ThumbnailView: UIImageView!
    @IBOutlet private var TitleLabel: UILabel!
    var name = "!23"

    
    static let reuseIdentifier = String(describing: MainListItemCell.self)

    
    
    func fill(index : Int){
        TitleLabel.text = "test\(index)"
    }
    
    
    
    //동시성 처리
    private func updatePosterImage(width: Int) {

    }

}
