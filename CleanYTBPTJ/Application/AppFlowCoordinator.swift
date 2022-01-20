

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
        let MovieSceneDIContainer = appDIContainer.makeMovieSceneDIContainer()
        
        let flow = MovieSceneDIContainer.makeMovieSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
