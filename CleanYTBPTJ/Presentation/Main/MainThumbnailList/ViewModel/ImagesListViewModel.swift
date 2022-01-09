
import Foundation
import UIKit

//스택에 값타입으로 생성되는 구조체는 속도와 함수형 언어의 특징인 불변성을 유지하는데 유리하다.
//thread safe
//유스케이스 정의
//자료구조와 정렬알고리즘
struct ImagesListViewModelActions {

}

enum ImagesListItemViewModelLoading {
    case fullScreen
    case nextPage
}

protocol ImagesListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didSetDefaultList()

    func didCancelSearch()
    func showQueriesSuggestions()

    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
}

protocol ImagesListViewModelOutput {
//    var items: Observable<[VideosListItemViewModel]> { get }
//    var loading: Observable<ImagesListViewModelLoading?> { get }
    var items: Observable<[ImagesListItemViewModel]> { get }
    var loading: Observable<ImagesListItemViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol ImagesListViewModel: ImagesListViewModelInput, ImagesListViewModelOutput {}

final class DefaultImagesListViewModel: ImagesListViewModel {
    
    
    
    func viewDidLoad() {}
    
    
    
    

    private let searchImagesUseCase: SearchImagesUseCase

    private let actions: ImagesListViewModelActions?

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    private var pages: [VideosPage] = []
    private var videosLoadTask: Cancellable? { willSet { videosLoadTask?.cancel() } }

    // MARK: - OUTPUT
//    let loading: Observable<ImagesListViewModelLoading?> = Observable(.none)
//    let items: Observable<[VideosListItemViewModel]> = Observable([])
    let loading: Observable<ImagesListItemViewModelLoading?> = Observable(.none)
    let items: Observable<[ImagesListItemViewModel]> = Observable([])

    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Movies", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Movies", comment: "")

    // MARK: - Init
    init(searchImagesUseCase: SearchImagesUseCase,
         actions: ImagesListViewModelActions? = nil) {
        print("DefaultImagesListViewModel init")

        self.searchImagesUseCase = searchImagesUseCase
        self.actions = actions
    }

    // MARK: - Private
    private func appendPage(_ imagesPage: ImagesPage) {
        printIfDebug("debug appendPage")

        //유튜브
        //self.items.value =  videosPage.videos.map { $0.id}.map(VideosListItemViewModel.init)

        items.value = imagesPage.images.map(ImagesListItemViewModel.init)
//        imagesPage.images.map{
//            printIfDebug("path 디버깅 : \($0.path)")
//        }
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }

 
    
    private func load(imageQuery: ImageQuery, loading: ImagesListItemViewModelLoading) {
        
        printIfDebug("networkTask - load")
        
        self.loading.value = loading
        query.value = imageQuery.query

        videosLoadTask = searchImagesUseCase.execute(
            requestValue: .init(query: imageQuery, page: nextPage),
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


    
    private func update(imageQuery: ImageQuery) {
        printIfDebug("networkTask update")
        //resetPages()
        load(imageQuery: imageQuery, loading: .fullScreen)
    }
}

// MARK: - INPUT. View event methods
extension DefaultImagesListViewModel {

    //func viewDidLoad() { }
    

    func didLoadNextPage() {
        printIfDebug("networkTask didLoadNextPage")

        guard hasMorePages, loading.value == .none else { return }
        load(imageQuery: .init(query: query.value),
             loading: .nextPage)
    }

    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(imageQuery: ImageQuery(query: query))
    }
    
    func didSetDefaultList() {
        printIfDebug("didSetDefaultList")
        update(imageQuery: ImageQuery(query: "default"))
    }

    func didCancelSearch() {
        videosLoadTask?.cancel()
    }

    func showQueriesSuggestions() {
//        actions?.showVideoQueriesSuggestions(update(videoQuery:))
    }

    func closeQueriesSuggestions() {
  //      actions?.closeVideoQueriesSuggestions()
    }

    func didSelectItem(at index: Int) {
    //    actions?.showVideoDetails(pages.videos[index])
    }
}

// MARK: - Private
//제네릭 사용제약
private extension Array where Element == VideosPage {
    var videos: [Snippet] { flatMap { $0.videos } }
}
