
import Foundation
import UIKit
import RxSwift
import RxCocoa

struct MovieListViewModelActions {} // 추후 삭제 혹은 구현 예정

protocol MovieListViewModelInput {
    func refresh(query: String)
    func loadMore()
    func didCancelSearch()
    func didSelectItem(at index: Int)
}

protocol MovieListViewModelOutput {
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol MovieListViewModel: MovieListViewModelInput, MovieListViewModelOutput {} // 제거 예정

final class DefaultMovieListViewModel: MovieListViewModel {
    
    private let searchMovieUseCase: SearchMovieUseCase
    private let actions: MovieListViewModelActions?
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    private var moviesLoadTask: CancelDelegate? {
        willSet {
            moviesLoadTask?.cancel()
        }
    }
    
    // MARK: - Rx
    
    var cellModelsObs: Observable<[MovieListItemCellModel]> {
        cellModelsRelay.asObservable()
    }
    var cellModels: [MovieListItemCellModel] {
        cellModelsRelay.value
    }
    
    private let cellModelsRelay = BehaviorRelay<[MovieListItemCellModel]>(value: [])
    private let disposeBag = DisposeBag()
    
    // MARK: - OUTPUT
    
    var isEmpty: Bool { cellModels.isEmpty }
    let screenTitle = NSLocalizedString("Movies", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Movies", comment: "")
    
    // MARK: - Init
    
    init(searchMovieUseCase: SearchMovieUseCase, actions: MovieListViewModelActions? = nil) {
        print("DefaultMoviesListViewModel init")
        self.searchMovieUseCase = searchMovieUseCase
        self.actions = actions
        fetch(movieQuery: .initial)
    }
    
    // MARK: - Private
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
    }
    
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
        resetPages()
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
