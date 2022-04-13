
import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - DIContainers of scenes
    
    func makeMovieSceneDIContainer() -> MovieSceneDIContainer {
        return MovieSceneDIContainer()
    }
}
