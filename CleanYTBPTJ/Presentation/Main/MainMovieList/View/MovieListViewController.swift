
import UIKit
import SnapKit

class MovieListViewController: UIViewController {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private var movieListTableViewController = MovieListTableViewController()
    
    private let movieListTableView: UITableView = {
        let movieListTableView = UITableView()
        return movieListTableView
    }()
    
    private var viewModel: MovieListViewModel
    private var thumbnailRepository: ThumbnailRepository
    
    init(viewModel: MovieListViewModel, thumbnailRepository: ThumbnailRepository){
        self.viewModel = viewModel
        self.thumbnailRepository = thumbnailRepository
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
        debugPrint("setupViews Model: \(viewModel)")
        
        movieListTableViewController.viewModel = viewModel
        movieListTableViewController.thumbnailRepository = thumbnailRepository
        
        movieListTableView.rowHeight = MovieListItemCell.height
        movieListTableView.register(MovieListItemCell.self, forCellReuseIdentifier: MovieListItemCell.reuseIdentifier)
        movieListTableView.dataSource = movieListTableViewController
        movieListTableView.delegate = movieListTableViewController
        self.view.addSubview(movieListTableView)
        self.movieListTableView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
    }
    
    private func setupBehaviours() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
}

// MARK: -  ViewModel 대리자 패턴

extension MovieListViewController: MovieListViewModelDelegate {
    
    func didLoadData() {
        print("모델 카운트: \(viewModel.movies.count)")
        self.movieListTableView.reloadData()
    }
}
