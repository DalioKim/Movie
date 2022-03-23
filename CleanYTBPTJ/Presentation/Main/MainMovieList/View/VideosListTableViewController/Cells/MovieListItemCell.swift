
import UIKit
import Kingfisher

class MovieListItemCell: UICollectionViewCell {
    
    // MARK: - nested type
    
    enum Size {
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 10
        static let spacing: CGFloat = 10
        enum Thumbnail {
            static let width: CGFloat = 40
            static let height: CGFloat = 60
        }
    }
    enum Style {
        enum Title {
            static let font = UIFont.systemFont(ofSize: 16)
            static let lines = 10
            static let lineBreakMode: NSLineBreakMode = .byTruncatingTail
        }
    }
    
    static let reuseIdentifier = String(describing: MovieListItemCell.self)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = Size.spacing
        stackView.alignment = .center
        
        thumbnailImageView.snp.makeConstraints {
            $0.width.equalTo(Size.Thumbnail.width)
            $0.height.equalTo(Size.Thumbnail.height)
        }
        
        return stackView
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = Style.Title.lines
        titleLabel.textAlignment = .left
        titleLabel.font = Style.Title.font
        titleLabel.lineBreakMode = Style.Title.lineBreakMode
        return titleLabel
    }()
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
            $0.leading.trailing.equalToSuperview().inset(Size.horizontalPadding)
            $0.top.bottom.equalToSuperview().inset(Size.verticalPadding)
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
        let titleWidth = width - Size.Thumbnail.width - Size.spacing - (Size.horizontalPadding * 2)
        let titleHeight = CalcText.height(attributedText: model.title.applyTag(), lineBreakMode: Style.Title.lineBreakMode, numberOfLines: Style.Title.lines, width: titleWidth)
        let itemHeight = max(Size.Thumbnail.height, titleHeight) + (Size.verticalPadding * 2)
        return CGSize(width: width, height: itemHeight)
    }
}
