
import UIKit

protocol MovieSearchFlowCoordinatorDependencies  {
    func makeMovieListViewController() -> MovieListViewController
}

final class MovieSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MovieSearchFlowCoordinatorDependencies

    private weak var movieListVC: MovieListViewController?

    init(navigationController: UINavigationController,
         dependencies: MovieSearchFlowCoordinatorDependencies) {
        printIfDebug("MoviesSearchFlowCoordinator init")

        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeMovieListViewController()
        navigationController?.pushViewController(vc, animated: false)
        movieListVC = vc
    }
}
