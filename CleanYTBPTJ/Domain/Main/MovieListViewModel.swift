
import Foundation
import UIKit
import RxSwift
import RxCocoa

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
    
    private let searchMovieUseCase: SearchMovieUseCase // 삭제 예정
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
    
    init(searchMovieUseCase: SearchMovieUseCase) {
        print("DefaultMoviesListViewModel init")
        self.searchMovieUseCase = searchMovieUseCase
        fetch(movieQuery: .initial)
    }
    
    // MARK: - Private
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
    }
    
    private func fetch(_ movieQuery: APITarget) {
        API.fetchMovieList(movieQuery)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                switch result {
                case .success(let models):
                    self.cellModelsRelay.accept(models)
                case .failure:
                    break
                }
                self.moviesLoadTask = nil
            })
    }
}

// MARK: - INPUT. View event methods

extension DefaultMovieListViewModel {
    func refresh(query: String) {
        guard !query.isEmpty else { return }
        fetch(movieQuery: .search(value: query))
    }
    
    func loadMore() {
        fetch(.search("임시")) //쿼리 저장방식 추가예정
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
