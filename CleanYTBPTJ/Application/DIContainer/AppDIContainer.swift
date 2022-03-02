
import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    
    lazy var apiDataTransferService: DataTransferService = {
        guard let baseURL = URL(string: appConfiguration.apiBaseURL) else { fatalError("API주소 URL변경 에러") }
        let config = ApiDataNetworkConfig(baseURL: baseURL,
                                          headers: ["X-Naver-Client-Id": appConfiguration.id,"X-Naver-Client-Secret": appConfiguration.apiKey])
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    // MARK: - DIContainers of scenes
    
    func makeMovieSceneDIContainer() -> MovieSceneDIContainer {
        printIfDebug("AppDIContainer makeThumbnailsSceneDIContainer")
        let dependencies = MovieSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return MovieSceneDIContainer(dependencies: dependencies)
    }
}
