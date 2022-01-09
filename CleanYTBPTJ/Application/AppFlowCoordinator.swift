

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        printIfDebug("AppFlowCoordinator init")
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        printIfDebug("AppFlowCoordinator")
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let ThumbnailsSceneDIContainer = appDIContainer.makeThumbnailsSceneDIContainer()
        let flow = ThumbnailsSceneDIContainer.makeThumbnailsSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
