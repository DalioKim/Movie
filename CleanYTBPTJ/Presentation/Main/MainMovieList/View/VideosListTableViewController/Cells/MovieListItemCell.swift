
import UIKit

class MovieListItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MovieListItemCell.self)
    static let height = CGFloat(300)
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = -1
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let thumbnailImageView = UIImageView()
    
    private weak var viewModel: MovieListItemViewModel?
    private var thumbnailRepository: ThumbnailRepository?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        thumbnailRepository = nil
        thumbnailImageView.image = nil
        titleLabel.attributedText = nil
    }
    
    func configure() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(thumbnailImageView)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(200)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
        }
        thumbnailImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-170)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func bind(with viewModel: MovieListItemViewModel?, thumbnailRepository: ThumbnailRepository?) {
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel
        self.thumbnailRepository = thumbnailRepository
        titleLabel.attributedText = viewModel.title.applyTag()
        updateThumbnailImage(width: 200)
    }
    
    private func updateThumbnailImage(width: Int) {
        guard let thumbnailImagePath = viewModel?.thumbnailImagePath else { return }
        thumbnailRepository?.fetchImage(with: thumbnailImagePath, width: width) { [weak self] in
            self?.thumbnailImageView.image = $0
        }
    }
}
