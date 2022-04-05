
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
    var cellModels: [MovieListItemCellModel]? { get }
    var movies: Driver<[MovieListItemCellModel]?> { get }
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
    
    private let moviesRelay = BehaviorRelay<[MovieListItemCellModel]?>(value: nil)
    private let viewActionRelay = PublishRelay<ViewAction>() // 사용 예정
    private let disposeBag = DisposeBag() // 사용 예정
    
    // MARK: - Observer
    
    var movies: Driver<[MovieListItemCellModel]?> {
        moviesRelay.asDriver()
    }
    var cellModels: [MovieListItemCellModel]? {
        moviesRelay.value
    }
    var viewActionObs: Observable<ViewAction> {  // 사용 예정
        viewActionRelay.asObservable()
    }
    
    // MARK: - paging
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var nextPage: Int { (cellModels?.count ?? 0) > 10 ? currentPage + 1 : currentPage }
    
    // MARK: - Init
    
    init(searchMovieUseCase: SearchMovieUseCase) {
        print("DefaultMoviesListViewModel init")
        self.searchMovieUseCase = searchMovieUseCase
        fetch(movieQuery: .initial)
    }
    
    // MARK: - Private
    
    private func fetch(movieQuery: MovieQuery) {
        moviesLoadTask = searchMovieUseCase.execute(
            requestValue: .init(query: movieQuery, page: nextPage),
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let models):
                    self.moviesRelay.accept(models)
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
        fetch(movieQuery: .search(value: "임시")) //쿼리 저장방식 추가예정
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
