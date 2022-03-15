
import Foundation
import UIKit

struct MovieListViewModelActions {} // 추후 삭제 혹은 구현 예정


protocol MovieListViewModelDelegate: AnyObject {
    func updateItems()
}

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

protocol MovieListViewModel: MovieListViewModelInput, MovieListViewModelOutput {
    var movies: [MovieListItemCellModel] { get set }
}

final class DefaultMovieListViewModel: MovieListViewModel {
    
    private let searchMovieUseCase: SearchMovieUseCase
    private let actions: MovieListViewModelActions?
    
    var movies: [MovieListItemCellModel]
    weak var delegate: MovieListViewModelDelegate?
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    private var pages: [MoviesPage] = []
    private var moviesLoadTask: CancelDelegate? {
        willSet {
            moviesLoadTask?.cancel()
        }
    }
    
    // MARK: - OUTPUT
    
    var isEmpty: Bool { movies.isEmpty }
    let screenTitle = NSLocalizedString("Movies", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Movies", comment: "")
    
    // MARK: - Init
    
    init(searchMovieUseCase: SearchMovieUseCase,
         actions: MovieListViewModelActions? = nil,
         movies: [MovieListItemCellModel] = [MovieListItemCellModel]()) {
        print("DefaultMoviesListViewModel init")
        self.searchMovieUseCase = searchMovieUseCase
        self.actions = actions
        self.movies = movies
        fetch(movieQuery: MovieQuery(query: "default"))
    }
    
    // MARK: - Private
    
    private func appendPage(_ moviesPage: MoviesPage) {
        printIfDebug("debug appendPage")
        movies = moviesPage.movies.map {
            MovieListItemCellModel(movie: $0)
        }
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        movies.removeAll()
    }
    
    private func fetch(movieQuery: MovieQuery) {
        moviesLoadTask = searchMovieUseCase.execute(
            requestValue: .init(query: movieQuery, page: nextPage),
            cached: appendPage,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let page):
                    self.appendPage(page)
                case .failure:
                    break
                }
                self.moviesLoadTask = nil
                self.delegate?.updateItems()
            })
    }
}

// MARK: - INPUT. View event methods

extension DefaultMovieListViewModel {
    
    func refresh(query: String) {
        guard !query.isEmpty else { return }
        resetPages()
        fetch(movieQuery: MovieQuery(query: query))
    }
    
    func loadMore() {
        fetch(movieQuery: MovieQuery(query: "default")) //쿼리 저장방식 추가예정
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
