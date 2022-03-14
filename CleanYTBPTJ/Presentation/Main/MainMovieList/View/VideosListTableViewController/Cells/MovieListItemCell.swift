
import UIKit

class MovieListItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MovieListItemCell.self)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = -1
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let thumbnailImageView = UIImageView()
    
    private weak var viewModel: MovieListItemCellModel?
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
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(with viewModel: MovieListItemCellModel?, thumbnailRepository: ThumbnailRepository?) {
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel
        self.thumbnailRepository = thumbnailRepository
        titleLabel.attributedText = viewModel.atttributedTitle
        updateThumbnailImage(width: 200)
    }
    
    private func updateThumbnailImage(width: Int) {
        guard let thumbnailImagePath = viewModel?.thumbnailImagePath else { return }
        thumbnailRepository?.fetchImage(with: thumbnailImagePath, width: width) { [weak self] in
            self?.thumbnailImageView.image = $0
        }
    }
    
    static func size(width: CGFloat, viewModel: MovieListItemCellModel?) -> CGSize {
        guard let viewModel = viewModel else { return CGSize(width: 0, height: 0) }
        let itemHeight = CalculateString.calculateHeight(width: width, title: viewModel.title, font: UIFont.systemFont(ofSize: 16)) + 40
        return CGSize(width: width - 40, height: itemHeight)
    }
}
