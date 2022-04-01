
import UIKit
import RxSwift

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
    
    // MARK: - private
    
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
    
    private weak var cellModel: MovieListItemCellModel?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellModel = nil
        titleLabel.attributedText = nil
        thumbnailImageView.clear()
    }
    
    func setupViews() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.horizontalPadding)
            $0.top.bottom.equalToSuperview().inset(Size.verticalPadding)
        }
    }
}

extension MovieListItemCell: Bindable {
    func bind(_ model: Any?) {
        guard let model = model as? MovieListItemCellModel else { return }
        self.cellModel = model
        titleLabel.attributedText = model.title.applyTag()
        thumbnailImageView.setImage(model.thumbnailImagePath)
    }
}

extension MovieListItemCell {
    static func size(width: CGFloat, model: MovieListItemCellModel) -> CGSize {
        let titleWidth = width - Size.Thumbnail.width - Size.spacing - (Size.horizontalPadding * 2)
        let titleHeight = CalcText.height(attributedText: model.title.applyTag(), lineBreakMode: Style.Title.lineBreakMode, numberOfLines: Style.Title.lines, width: titleWidth)
        let itemHeight = max(Size.Thumbnail.height, titleHeight) + (Size.verticalPadding * 2)
        return CGSize(width: width, height: itemHeight)
    }
}

extension MovieListItemCell: Bindable {
    func bind(_ model: Any?) {
        guard let model = model as? MovieListItemCellModel else { return }
        self.viewModel = model
        titleLabel.attributedText = model.title.applyTag()
        thumbnailImageView.setImage(viewModel?.thumbnailImagePath)
    }
}
