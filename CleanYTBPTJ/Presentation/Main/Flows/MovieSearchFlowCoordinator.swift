

import UIKit

protocol MovieSearchFlowCoordinatorDependencies  {
    func makeMovieListViewController(actions: MovieListViewModelActions) -> MovieListViewController
}

final class MovieSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MovieSearchFlowCoordinatorDependencies

    private weak var MovieListVC: MovieListViewController?

    init(navigationController: UINavigationController,
         dependencies: MovieSearchFlowCoordinatorDependencies) {
        printIfDebug("MoviesSearchFlowCoordinator init")

        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        printIfDebug("MoviesSearchFlowCoordinator start()")

        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = MovieListViewModelActions()
        printIfDebug("MoviesSearchFlowCoordinator vc before")

        let vc = dependencies.makeMovieListViewController(actions: actions)
        printIfDebug("MoviesSearchFlowCoordinator vc after")

        navigationController?.pushViewController(vc, animated: false)
        MovieListVC = vc
    }
    
  

    
}
