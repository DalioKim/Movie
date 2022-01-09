
import Foundation
import CoreData

final class CoreDataVideosResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
//
//    // MARK: - Private
//
//    private func fetchRequest(for requestDto: VideosRequestDTO) -> NSFetchRequest<VideosRequestEntity> {
//        let request: NSFetchRequest = VideosRequestEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
//                                        #keyPath(VideosRequestEntity.query), requestDto.query,
//                                        #keyPath(VideosRequestEntity.page), requestDto.page)
//        return request
//    }
//
//    private func deleteResponse(for requestDto: VideosRequestDTO, in context: NSManagedObjectContext) {
//        let request = fetchRequest(for: requestDto)
//
//        do {
//            if let result = try context.fetch(request).first {
//                context.delete(result)
//            }
//        } catch {
//            print(error)
//        }
//    }
//}
//
//extension CoreDataVideosResponseStorage: VideosResponseStorage {
//
//    func getResponse(for requestDto: VideosRequestDTO, completion: @escaping (Result<VideosResponseDTO?, CoreDataStorageError>) -> Void) {
//        coreDataStorage.performBackgroundTask { context in
//            do {
//                let fetchRequest = self.fetchRequest(for: requestDto)
//                let requestEntity = try context.fetch(fetchRequest).first
//
//                completion(.success(requestEntity?.response?.toDTO()))
//            } catch {
//                completion(.failure(CoreDataStorageError.readError(error)))
//            }
//        }
//    }
//
//    func save(response responseDto: VideosResponseDTO, for requestDto: VideosRequestDTO) {
//        coreDataStorage.performBackgroundTask { context in
//            do {
//                self.deleteResponse(for: requestDto, in: context)
//
//                let requestEntity = requestDto.toEntity(in: context)
//                requestEntity.response = responseDto.toEntity(in: context)
//
//                try context.save()
//            } catch {
//                // TODO: - Log to Crashlytics
//                debugPrint("CoreDataVideosResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
//            }
//        }
//    }
}

extension CoreDataVideosResponseStorage : VideosResponseStorage{}
