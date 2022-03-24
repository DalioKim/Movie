
import UIKit

class MovieListItemCell: UICollectionViewCell {
    
    // MARK: - nested type
    
    enum Style {
        static let font = UIFont.systemFont(ofSize: 16)
        static let lines = 10
    }
    enum Size {
        static let imageWidth: CGFloat = 40
        static let imageHeight: CGFloat = 60
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 10
        static let spacing: CGFloat = 10
    }
    
    static let reuseIdentifier = String(describing: MovieListItemCell.self)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = Size.spacing
        stackView.alignment = .center
        
        thumbnailImageView.snp.makeConstraints {
            $0.width.equalTo(Size.imageWidth)
            $0.height.equalTo(Size.imageHeight)
        }
        
        return stackView
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = Style.lines
        titleLabel.textAlignment = .left
        titleLabel.font = Style.font
        titleLabel.lineBreakMode = .byTruncatingTail
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
        updateThumbnailImage(width: Int(Size.imageWidth))
    }
    
    private func updateThumbnailImage(width: Int) {
        guard let thumbnailImagePath = viewModel?.thumbnailImagePath else { return }
        DefaultThumbnailRepository.fetchImage(with: thumbnailImagePath, width: width) { [weak self] in
            self?.thumbnailImageView.image = $0
        }
    }
    
    static func size(width: CGFloat, model: MovieListItemCellModel) -> CGSize {
        let titleWidth = width - Size.imageWidth - Size.spacing - (Size.horizontalPadding * 2)
        let titleHeight = CalcText.height(attributedText: model.title.applyTag(), lineBreakMode: .byTruncatingTail, numberOfLines: Style.lines, width: titleWidth)
        let itemHeight = max(Size.imageHeight, titleHeight) + (Size.verticalPadding * 2)
        return CGSize(width: width, height: itemHeight)
    }
}

