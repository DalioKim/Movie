
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    // MARK: - private
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieListItemCell.self, forCellWithReuseIdentifier: MovieListItemCell.reuseIdentifier)
        return collectionView
    }()
    
    private var viewModel: MovieListViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBehaviours()
        bindCollectionView()
    }
    
    // MARK: - private
    
    private func bindCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.movies
            .compactMap { $0 }
            .drive(collectionView.rx.items) { collectionView, index, cellModel in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListItemCell.reuseIdentifier, for: indexPath)
                (cell as? Bindable).map { $0.bind(cellModel) }
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupBehaviours() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellModels = viewModel.cellModels, cellModels.indices ~= indexPath.item else { return .zero }
        let cellModel = cellModels[indexPath.item]
        let width = collectionView.frame.size.width - ((collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.horizontal ?? 0)
        return MovieListItemCell.size(width: width, model: cellModel)
    }
}
