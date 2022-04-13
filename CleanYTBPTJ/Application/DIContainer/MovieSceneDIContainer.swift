
import UIKit
import SwiftUI

final class MovieSceneDIContainer: MovieSearchFlowCoordinatorDependencies {
    
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
