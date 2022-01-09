

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        //유튜브 할당량 초과
//        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
//                                          queryParameters: ["key": appConfiguration.apiKey])
        
        //네이버 오픈 api
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          headers: ["X-Naver-Client-Id": appConfiguration.id,"X-Naver-Client-Secret": appConfiguration.apiKey])
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
 
    
    // MARK: - DIContainers of scenes
    func makeThumbnailsSceneDIContainer() -> ThumbnailsSceneDIContainer {
        printIfDebug("AppDIContainer makeThumbnailsSceneDIContainer")
        let dependencies = ThumbnailsSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return ThumbnailsSceneDIContainer(dependencies: dependencies)
    }
}
