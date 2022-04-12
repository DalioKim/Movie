
import UIKit
import SwiftUI

final class MovieSceneDIContainer: MovieSearchFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
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

    func makeMovieListViewController() -> MovieListViewController {
        return MovieListViewController(viewModel: makeMovieListViewModel())
    }
    
    func makeMovieListViewModel() -> MovieListViewModel {
        return DefaultMovieListViewModel()
    }
    
    // MARK: - Flow Coordinators
    func makeMovieSearchFlowCoordinator(navigationController: UINavigationController) -> MovieSearchFlowCoordinator {
        return MovieSearchFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
