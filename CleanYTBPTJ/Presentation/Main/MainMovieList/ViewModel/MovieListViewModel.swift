
import Foundation
import UIKit

//스택에 값타입으로 생성되는 구조체는 속도와 함수형 언어의 특징인 불변성을 유지하는데 유리하다.
//thread safe
//유스케이스 정의
//자료구조와 정렬알고리즘
struct MovieListViewModelActions {

}

enum MovieListItemViewModelLoading {
    case fullScreen
    case nextPage
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
    var items: Observable<[MovieListItemViewModel]> { get }
    var loading: Observable<MovieListItemViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol MovieListViewModel: MovieListViewModelInput, MovieListViewModelOutput {}

final class DefaultMovieListViewModel: MovieListViewModel {
    
    
    
    func viewDidLoad() {}
    
    
    
    

    private let searchMovieUseCase: SearchMovieUseCase

    private let actions: MovieListViewModelActions?

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    private var pages: [MoviesPage] = []
    private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }

    // MARK: - OUTPUT
    let loading: Observable<MovieListItemViewModelLoading?> = Observable(.none)
    let items: Observable<[MovieListItemViewModel]> = Observable([])

    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Movies", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Movies", comment: "")

    // MARK: - Init
    init(searchMovieUseCase: SearchMovieUseCase,
         actions: MovieListViewModelActions? = nil) {
        print("DefaultMoviesListViewModel init")

        self.searchMovieUseCase = searchMovieUseCase
        self.actions = actions
    }

    // MARK: - Private
    private func appendPage(_ moviesPage: MoviesPage) {
        printIfDebug("debug appendPage")

        items.value = moviesPage.movies.map(MovieListItemViewModel.init)
        moviesPage.movies.map{
            printIfDebug("path 디버깅 : \($0.path)")
        }
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }

 
    
    private func load(movieQuery: MovieQuery, loading: MovieListItemViewModelLoading) {
        
        printIfDebug("networkTask - load")
        
        self.loading.value = loading
        query.value = movieQuery.query

        moviesLoadTask = searchMovieUseCase.execute(
            requestValue: .init(query: movieQuery, page: nextPage),
            cached: appendPage,
            completion: { result in
                switch result {
                case .success(let page):
                    self.appendPage(page)
                case .failure(let error):
                    self.handle(error: error)
                }
                self.loading.value = .none
        })
    }
    

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading images", comment: "")
    }


    
    private func update(movieQuery: MovieQuery) {
        printIfDebug("networkTask update")
        //resetPages()
        load(movieQuery: movieQuery, loading: .fullScreen)
    }
}

// MARK: - INPUT. View event methods
extension DefaultMovieListViewModel {

    //func viewDidLoad() { }
    

    func didLoadNextPage() {
        printIfDebug("networkTask didLoadNextPage")

        guard hasMorePages, loading.value == .none else { return }
        load(movieQuery: .init(query: query.value),
             loading: .nextPage)
    }

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
    }

    func showQueriesSuggestions() {}

    func closeQueriesSuggestions() {}

    func didSelectItem(at index: Int) {}
}


