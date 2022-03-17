
import UIKit
import Kingfisher

class MovieListItemCell: UICollectionViewCell {
    
    // MARK: - nested type
    
    enum Font {
        static let titleFont = UIFont.systemFont(ofSize: 16)
    }
    enum Size {
        static let defaultHeight: CGFloat = 60
        static let thumbnailDefaultWidth: Int = 200
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 0
    }
    
    static let reuseIdentifier = String(describing: MovieListItemCell.self)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: Size.verticalPadding, left: Size.horizontalPadding, bottom: Size.verticalPadding, right: Size.horizontalPadding)
        return stackView
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.font = Font.titleFont
        titleLabel.lineBreakMode = .byTruncatingTail
        return titleLabel
    }()
    private let thumbnailImageView = UIImageView()
    
    private weak var viewModel: MovieListItemCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        thumbnailImageView.image = nil
        titleLabel.attributedText = nil
    }
    
    func setupViews() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(with model: MovieListItemCellModel?) {
        guard let model = model else { return }
        self.viewModel = model
        titleLabel.attributedText = model.title.applyTag()
        updateThumbnailImage()
    }
    
    private func updateThumbnailImage() {
        guard let thumbnailImagePath = viewModel?.thumbnailImagePath else { return }
        let cache = ImageCache.default
        cache.retrieveImage(forKey: thumbnailImagePath, options: nil) { [weak self] result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self?.thumbnailImageView.image = image
                } else {
                    guard let imageURL = URL(string: thumbnailImagePath) else { return }
                    self?.thumbnailImageView.kf.setImage(with: imageURL)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func size(width: CGFloat, model: MovieListItemCellModel) -> CGSize {
        let itemHeight = CalculateString.calculateHeight(width: width, title: model.title.removeTag(), font: Font.titleFont) + Size.defaultHeight
        return CGSize(width: width, height: itemHeight)
    }
}
