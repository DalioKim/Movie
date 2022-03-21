
import UIKit
import SnapKit

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
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: MovieListViewModel) {
        debugPrint("viewModel: \(viewModel)")
        (viewModel as? DefaultMovieListViewModel).flatMap { $0.delegate = self }
    }
    
    private func setupViews() {
        movieListView.delegate = self
        movieListView.dataSource = self
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

// MARK: -  ViewModel 대리자 패턴

extension MovieListViewController: MovieListViewModelDelegate {
    func updateItems() {
        print("모델 카운트: \(viewModel.movies.count)")
        movieListView.reloadData()
    }
}

// MARK: -  CollectionViewDelegate

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListItemCell.reuseIdentifier, for: indexPath) as? MovieListItemCell else { fatalError() }
        cell.bind(with: viewModel.movies[safe: indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        guard let model = viewModel.movies[safe: indexPath.item] else { return .zero }
        return MovieListItemCell.size(width: width, model: model)
    }
}
