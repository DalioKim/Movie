
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

protocol MovieListViewModel: MovieListViewModelInput {} // 제거 예정

final class DefaultMovieListViewModel: MovieListViewModel {
    
    enum ViewAction {
        case popViewController
        case showDetail(viewModel: DefaultMovieListViewModel)
        case showFeature(itemNo: Int)
    }
    
    private let searchMovieUseCase: SearchMovieUseCase
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var nextPage: Int { (cellModels?.count ?? 0) > 10 ? currentPage + 1 : currentPage }
    
    private var moviesLoadTask: CancelDelegate? {
        willSet {
            moviesLoadTask?.cancel()
        }
    }
    
    // MARK: - Rx
    
    var cellModelsObs: Observable<[MovieListItemCellModel]?> {
        cellModelsRelay.asObservable()
    }
    var cellModels: [MovieListItemCellModel]? {
        cellModelsRelay.value
    }
    
    var viewActionObs: Observable<ViewAction> {
        viewActionRelay.asObservable()
    }
    
    private let cellModelsRelay = BehaviorRelay<[MovieListItemCellModel]?>(value: nil)
    private let viewActionRelay = PublishRelay<ViewAction>()

    private let disposeBag = DisposeBag()
    
    
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
        fetch(movieQuery: .search(value: "임시"))
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
