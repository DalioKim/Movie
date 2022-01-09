

import UIKit
import SwiftUI

final class ThumbnailsSceneDIContainer: ThumbnailsSearchFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies


    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        printIfDebug("ThumbnailsSceneDIContainer init")
        let actions = ImagesListViewModelActions()
        makeThumbnailListViewController(actions: actions)

    }
    
    // MARK: - Use Cases
    func makeSearchVideosUseCase() -> SearchImagesUseCase {
        debugPrint("makeSearchVideosUseCase")

        return DefaultSearchImagesUseCase(ImagesRepository: makeImagesRepository())
    }
    

    
    // MARK: - Repositories
    func makeThumbnailRepository() -> ThumbnailRepository {
        debugPrint("makeThumbnailRepository")

        return DefaultThumbnailRepository(dataTransferService: dependencies.apiDataTransferService)
    }

    
    func makeImagesRepository() -> ImagesRepository {
        debugPrint("makeVideosRepository")

        return DefaultImagesRepository(dataTransferService: dependencies.apiDataTransferService)
    }
   

    
    // MARK: - Videos List
    func makeThumbnailListViewController(actions: ImagesListViewModelActions) -> ThumbnailListViewController {
        debugPrint("ThumbnailsSceneDIContainer makeThumbnailListViewController")
        return ThumbnailListViewController.create(with: makeImagesListViewModel(actions: actions), thumbnailRepository: makeThumbnailRepository())
    }
    
    func makeImagesListViewModel(actions: ImagesListViewModelActions) -> ImagesListViewModel {
        debugPrint("makeImagesListViewModel")

        return DefaultImagesListViewModel(searchImagesUseCase: makeSearchVideosUseCase(),
                                          actions: actions)
    }
    
    

//    // MARK: - Flow Coordinators
    func makeThumbnailsSearchFlowCoordinator(navigationController: UINavigationController) -> ThumbnailsSearchFlowCoordinator {
        return ThumbnailsSearchFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
}

