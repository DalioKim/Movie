
import Foundation
import UIKit
import SwiftUI

struct MovieListViewModelActions {}

enum MovieListItemViewModelLoading {
    
    case fullScreen
    case nextPage
}

protocol MovieListViewModelDelegate : AnyObject {
    
    func didLoadData()
}

protocol MovieListViewModelInput {
    
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didSetDefaultList()
    
    func didCancelSearch()
    func showQueriesSuggestions()
    
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
}

protocol MovieListViewModelOutput {
    
    var loading: MovieListItemViewModelLoading? { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol MovieListViewModel: MovieListViewModelInput, MovieListViewModelOutput {
    // MARK: - 이 부분 좀 더 꼬민 
    var movies: [MovieListItemViewModel]  { get set }
}

final class DefaultMovieListViewModel: MovieListViewModel {

    func viewDidLoad() {}
    
    private let searchMovieUseCase: SearchMovieUseCase
    private let actions: MovieListViewModelActions?
    
    var loading: MovieListItemViewModelLoading?
    var movies: [MovieListItemViewModel]
    var delegate: MovieListViewModelDelegate?
    
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
    
    var isEmpty: Bool { return movies.isEmpty }
    let screenTitle = NSLocalizedString("Movies", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Movies", comment: "")
    
    // MARK: - Init
    init(searchMovieUseCase: SearchMovieUseCase,
         actions: MovieListViewModelActions? = nil,
         movies : [MovieListItemViewModel]) {
        print("DefaultMoviesListViewModel init")
        
        self.searchMovieUseCase = searchMovieUseCase
        self.actions = actions
        self.movies = movies
        
    }
    
    // MARK: - Private
    
    private func appendPage(_ moviesPage: MoviesPage) {
        printIfDebug("debug appendPage")
        movies = moviesPage.movies.map {
            MovieListItemViewModel.init(title: $0.title, thumbnailImagePath: $0.path)
        }
    }
    
    private func resetPages() {
        
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
    }
    
    private func load(movieQuery: MovieQuery, loading: MovieListItemViewModelLoading) {
        printIfDebug("networkTask - load")
        moviesLoadTask = searchMovieUseCase.execute(
            requestValue: .init(query: movieQuery, page: nextPage),
            cached: appendPage,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let page):
                    self.appendPage(page)
                case .failure(let error):
                    self.handle(error: error)
                }
                self.moviesLoadTask = nil
                self.delegate?.didLoadData()
            })
    }
    
    private func handle(error: Error) {}
    
    private func update(movieQuery: MovieQuery) {
        printIfDebug("networkTask update")
        //resetPages()
        load(movieQuery: movieQuery, loading: .fullScreen)
    }
}

// MARK: - INPUT. View event methods
extension DefaultMovieListViewModel {
    
    //func viewDidLoad() { }
    
    // MARK: - 좀 더 고민
    func didLoadNextPage() { }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(movieQuery: MovieQuery(query: query))
    }
    
    func didSetDefaultList() {
        printIfDebug("didSetDefaultList")
        update(movieQuery: MovieQuery(query: "default"))
    }
    
    func didCancelSearch() {
        moviesLoadTask?.cancel()
        moviesLoadTask = nil
    }
    
    func showQueriesSuggestions() {}
    func closeQueriesSuggestions() {}
    func didSelectItem(at index: Int) {}
}


