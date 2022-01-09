

import UIKit

protocol ThumbnailsSearchFlowCoordinatorDependencies  {
    func makeThumbnailListViewController(actions: ImagesListViewModelActions) -> ThumbnailListViewController
}

final class ThumbnailsSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: ThumbnailsSearchFlowCoordinatorDependencies

    private weak var ThumbnailsListVC: ThumbnailListViewController?
    private weak var VideosQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: ThumbnailsSearchFlowCoordinatorDependencies) {
        printIfDebug("ThumbnailsSearchFlowCoordinator init")

        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        printIfDebug("ThumbnailsSearchFlowCoordinator start()")

        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = ImagesListViewModelActions()
        printIfDebug("ThumbnailsSearchFlowCoordinator vc before")

        let vc = dependencies.makeThumbnailListViewController(actions: actions)
        printIfDebug("ThumbnailsSearchFlowCoordinator vc after")

        navigationController?.pushViewController(vc, animated: false)
        ThumbnailsListVC = vc
    }
    
  

    
}
