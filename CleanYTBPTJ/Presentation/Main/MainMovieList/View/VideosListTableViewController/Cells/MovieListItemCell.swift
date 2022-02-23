//
//  MovieListItemCell.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/01/05.
//

import UIKit

class MovieListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MovieListItemCell.self)
    static let height = CGFloat(300)
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        return titleLabel
      }()
    private var dateLabel = UILabel()
    private var overviewLabel = UILabel()
    private var thumbnailImageView = UIImageView()
    
    private var viewModel: MovieListItemViewModel!
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
    
    func bind(with viewModel: MovieListItemViewModel?, thumbnailRepository: ThumbnailRepository?) {
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel
        self.thumbnailRepository = thumbnailRepository
        titleLabel.text = viewModel.title
        titleLabel = titleLabel.getRegular(title: titleLabel.text ?? "", titleLabel: titleLabel)
        updateThumbnailImage(width: 200)
    }
    
    private func updateThumbnailImage(width: Int) {
        printIfDebug("updateThumbnailImage \(viewModel.thumbnailImagePath)")
        thumbnailImageView.image = nil
        guard let thumbnailImagePath = viewModel.thumbnailImagePath else { return }
        thumbnailRepository?.fetchImage(with: thumbnailImagePath, width: width) { [weak self] in
            self?.thumbnailImageView.image = $0
        }
    }
}
