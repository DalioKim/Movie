//
//  VideosListTableViewCell.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/01/05.
//

import UIKit

class ThumbnailListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ThumbnailListItemCell.self)
    static let height = CGFloat(300)

     private var titleLabel: UILabel!
     private var dateLabel: UILabel!
     private var overviewLabel: UILabel!
     private var thumbnailImageView: UIImageView!

    private var viewModel: ImagesListItemViewModel!

    private var thumbnailRepository: ThumbnailRepository?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    func configure() {
        titleLabel = UILabel(frame: .zero)
         self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
             $0.left.equalToSuperview().offset(200)
             $0.right.equalToSuperview().offset(-10)
             $0.top.equalToSuperview().offset(0)
             $0.bottom.equalToSuperview().offset(0)
         }
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

 
        
        thumbnailImageView = UIImageView(frame: .zero)
         self.contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
             $0.left.equalToSuperview().offset(10)
             $0.right.equalToSuperview().offset(-170)
             $0.top.equalToSuperview().offset(10)
             $0.bottom.equalToSuperview().offset(-10)
         }
        
        
        
     }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    

    func fill(with viewModel: ImagesListItemViewModel, thumbnailRepository: ThumbnailRepository?) {

        self.viewModel = viewModel
        self.thumbnailRepository = thumbnailRepository
        printIfDebug("fill")

        titleLabel.text = viewModel.title
        titleLabel = titleLabel.getRegular(title: titleLabel.text ?? "", titleLabel: titleLabel)


        updateThumbnailImage(width: 200)

    }

    private func updateThumbnailImage(width: Int) {
        printIfDebug("updateThumbnailImage")
        thumbnailImageView.image = nil
            
        guard let thumbnailImagePath = viewModel.thumbnailImagePath else { return }

        thumbnailRepository?.fetchImage(with: thumbnailImagePath, width: width, completion: { UIImage in
            self.thumbnailImageView.image = UIImage
            
        })
        
        
        
        
    }

}
