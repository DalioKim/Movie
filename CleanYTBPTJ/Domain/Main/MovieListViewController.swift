
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let movieListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let movieListView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        movieListView.register(MovieListItemCell.self, forCellWithReuseIdentifier: MovieListItemCell.reuseIdentifier)
        return movieListView
    }()
    
    private var viewModel: MovieListViewModel
    private let disposeBag = DisposeBag()
    
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
        bindMovieListView()
    }
    
    private func bindMovieListView() {
        movieListView.rx.setDelegate(self).disposed(by: disposeBag)
        guard let viewModel = viewModel as? DefaultMovieListViewModel else { return }
        viewModel.cellModelsObs
            .bind(to: movieListView.rx.items) { [weak self] movieListView, index, cellModel in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = movieListView.dequeueReusableCell(withReuseIdentifier: MovieListItemCell.reuseIdentifier, for: indexPath)
                (cell as? Bindable).map { $0.bind(cellModel) }
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.addSubview(movieListView)
        movieListView.snp.makeConstraints {
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
        let width = collectionView.frame.width
        guard let viewModel = viewModel as? DefaultMovieListViewModel else { return .zero }
        guard viewModel.cellModels.indices ~= indexPath.item else { return .zero }
        let cellModel = viewModel.cellModels[indexPath.item]
        return MovieListItemCell.size(width: width, model: cellModel)
    }
}
