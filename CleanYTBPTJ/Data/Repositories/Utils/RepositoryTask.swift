
import Foundation

class RepositoryTask: CancelDelegate {
    
    var networkTask: NetworkCancelDelegate?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
