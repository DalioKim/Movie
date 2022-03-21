
import UIKit
import SwiftUI

final class MovieSceneDIContainer: MovieSearchFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        printIfDebug("MovieSceneDIContainer init")
        let actions = MovieListViewModelActions()
        makeMovieListViewController(actions: actions)
    }
    
    // MARK: - Use Cases
    func makeSearchMovieUseCase() -> SearchMovieUseCase {
        debugPrint("makeSearchMovieUseCase")
        return DefaultSearchMovieUseCase(moviesRepository: makeMoviesRepository())
    }
    
    func makeMoviesRepository() -> MoviesRepository {
        debugPrint("makeMovieRepository")
        return DefaultMoviesRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    // MARK: - Movie List

    func makeMovieListViewController(actions: MovieListViewModelActions) -> MovieListViewController {
        debugPrint("MovieSceneDIContainer makeMovieListViewController")
        return MovieListViewController(viewModel: makeMovieListViewModel(actions: actions))
    }
    
    func makeMovieListViewModel(actions: MovieListViewModelActions) -> MovieListViewModel {
        debugPrint("makeMovieListViewModel")
        return DefaultMovieListViewModel(searchMovieUseCase: makeSearchMovieUseCase())
    }
    
    // MARK: - Flow Coordinators
    func makeMovieSearchFlowCoordinator(navigationController: UINavigationController) -> MovieSearchFlowCoordinator {
        return MovieSearchFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

