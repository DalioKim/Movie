
import UIKit

class MovieListItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MovieListItemCell.self)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(thumbnailImageView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 150, bottom: 5, right: 5))
        }
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 150))
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
    
    static func size(width: CGFloat, viewModel: MovieListItemViewModel?) -> CGSize {
        guard let viewModel = viewModel else { return CGSize(width: width, height: 60) }
        let itemHeight = viewModel.title.removeTag().calculateHeight(withConstrainedWidth: width)
        return CGSize(width: width, height: itemHeight + 60)
    }
}
