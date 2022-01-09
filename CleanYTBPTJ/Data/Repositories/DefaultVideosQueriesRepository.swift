

import Foundation

final class DefaultVideosQueriesRepository {
    
    private let dataTransferService: DataTransferService
    //private var VideosQueriesPersistentStorage: VideosQueriesStorage
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
        //self.VideosQueriesPersistentStorage = VideosQueriesPersistentStorage
    }
}


extension DefaultVideosQueriesRepository : VideosQueriesRepository{}
