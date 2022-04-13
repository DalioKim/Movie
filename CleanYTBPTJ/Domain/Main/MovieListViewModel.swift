
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
    var searchRelay: BehaviorRelay<String> { get }
}

final class DefaultMovieListViewModel: MovieListViewModel {
    
    enum ViewAction {
        case popViewController
        case showDetail(viewModel: DefaultMovieListViewModel)
        case showFeature(itemNo: Int)
    }
    
    // MARK: - Relay & Observer
    private let disposeBag = DisposeBag()
    
    private let cellModelsRelay = BehaviorRelay<[MovieListItemCellModel]?>(value: nil)
    private let viewActionRelay = PublishRelay<ViewAction>() // 사용 예정
    private let fetchStatusTypeRelay = BehaviorRelay<FetchStatusType>(value: .none(.initial))
    private let fetch = PublishRelay<FetchType>()
    private let queryRelay = BehaviorRelay<String>(value: "마블")
    let searchRelay = BehaviorRelay<String>(value: "")
    
    var cellModelsObs: Observable<[MovieListItemCellModel]> {
        cellModelsRelay.map { $0 ?? [] }
    }
    var cellModels: [MovieListItemCellModel] {
        cellModelsRelay.value ?? []
    }
    var viewActionObs: Observable<ViewAction> {  // 사용 예정
        viewActionRelay.asObservable()
    }
    var fetchStatusTypeObs: Observable<FetchStatusType> {
        fetchStatusTypeRelay.asObservable()
    }
    
    // MARK: - paging
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var nextPage: Int { (cellModels.count > 10) ? currentPage + 1 : currentPage }
    
    // MARK: - Init
    
    init() {
        bindFetch()
        bindSearch()
        fetch.accept(.initial)
    }
    
    // MARK: - Private
    
    private func bindFetch() {
        Observable.combineLatest(fetch, queryRelay)
            .do(onNext: { [weak self] (fetchType, _) in
                self?.fetchStatusTypeRelay.accept(.fetching(fetchType))
            })
            .flatMapLatest { (_, query) -> Observable<Result<[MovieListItemCellModel], Error>> in
                return API.search(query)
                    .asObservable()
                    .map {
                        $0.items.map { MovieListItemCellModel(movie: Movie(title: $0.title, path: $0.image)) }
                    }
                    .map { .success($0) }
                    .catch { .just((.failure($0))) }
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                let fetchType = self.fetchStatusTypeRelay.value.type
                switch result {
                case .success(let models):
                    let list = fetchType == .more ? (self.cellModelsRelay.value ?? []) + models : models
                    self.cellModelsRelay.accept(list)
                    self.fetchStatusTypeRelay.accept(.success(fetchType))
                case .failure(let error):
                    self.fetchStatusTypeRelay.accept(.failure(fetchType, error: error))
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindSearch() {
        searchRelay
            .filter { $0.count > 1 }
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { [weak self] (query) in
                self?.refresh(query: query)
            }.disposed(by: disposeBag)
    }
}

// MARK: - INPUT. View event methods

extension DefaultMovieListViewModel {
    func refresh(query: String) {
        guard !query.isEmpty else { return }
        fetch.accept(.refresh)
        queryRelay.accept(query)
    }
    
    func loadMore() {
        fetch.accept(.more)
    }
    
    func didCancelSearch() {} //구현 예정
    
    //didSelectItem 기능 추가 예정
    func didSelectItem(at index: Int) {
        print("\(index)번 아이템")
    }
}
