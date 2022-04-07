
import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay

protocol MovieListViewModelInput {
    func refresh(query: String)
    func loadMore()
    func didCancelSearch()
    func didSelectItem(at index: Int)
}

protocol MovieListViewModel: MovieListViewModelInput {  // 삭제 예정
    var cellModels: [MovieListItemCellModel] { get }
    var cellModelsObs: Observable<[MovieListItemCellModel]> { get }
}

final class DefaultMovieListViewModel: MovieListViewModel {
    
    enum ViewAction {
        case popViewController
        case showDetail(viewModel: DefaultMovieListViewModel)
        case showFeature(itemNo: Int)
    }
    
    // MARK: - private
    
    private var moviesLoadTask: CancelDelegate? {
        willSet {
            moviesLoadTask?.cancel()
        }
    }
    
    private let cellModelsRelay = BehaviorRelay<[MovieListItemCellModel]?>(value: nil)
    private let viewActionRelay = PublishRelay<ViewAction>() // 사용 예정
    private let disposeBag = DisposeBag() // 사용 예정
    
    // MARK: - Observer
    
    var cellModelsObs: Observable<[MovieListItemCellModel]> {
        cellModelsRelay.map { $0 ?? [] }
    }
    var cellModels: [MovieListItemCellModel] {
        cellModelsRelay.value ?? []
    }
    var viewActionObs: Observable<ViewAction> {  // 사용 예정
        viewActionRelay.asObservable()
    }
    
    // MARK: - paging
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var nextPage: Int { (cellModels.count > 10) ? currentPage + 1 : currentPage }
    
    // MARK: - Init
    
    init() {
        fetch(.search(query: "마블")) // FIXED: 임시
    }
    
    // MARK: - Private
    
    private func fetch(_ movieQuery: APITarget) {
        API.fetchMovieList(movieQuery)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let models):
                    let cellModels = models.items.map { MovieListItemCellModel(movie: Movie(title: $0.title, path: $0.image)) }
                    self.cellModelsRelay.accept(cellModels)
                case .failure:
                    break
                }
            }
    }
}

// MARK: - INPUT. View event methods

extension DefaultMovieListViewModel {
    func refresh(query: String) {
        guard !query.isEmpty else { return }
        fetch(.search(query: "마블")) // FIXED: 임시
    }
    
    func loadMore() {
        fetch(.search(query: "마블")) // FIXED: 임시
    }
    
    func didCancelSearch() {
        moviesLoadTask?.cancel()
        moviesLoadTask = nil
    }
    
    //didSelectItem 기능 추가 예정
    func didSelectItem(at index: Int) {
        print("\(index)번 아이템")
    }
}
