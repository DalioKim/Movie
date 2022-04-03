
import Foundation

enum resultType {
    case objectType(_: [String: AnyObject])
    case stringType(_: String)
    case none
}

public protocol NetworkCancelDelegate {
    func cancel()
}

extension URLSessionTask: NetworkCancelDelegate {} //추후 삭제 혹은 구현 예정

public protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancelDelegate?
}

public protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancelDelegate
}

public protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

// MARK: - Implementation

public final class DefaultNetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    public init(config: NetworkConfigurable,
                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
                logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancelDelegate {
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            if let requestError = requestError {
                printIfDebug("networkTask - DefaultNetworkService-requestError")
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
        logger.log(request: request)
        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultNetworkService: NetworkService {
    
    public func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancelDelegate? {
        printIfDebug("networkTask - extensionDefaultNetworkService-request")
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            printIfDebug("netwotktask urlRequest : \(urlRequest)")
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}

// MARK: - Default Network Session Manager

public class DefaultNetworkSessionManager: NetworkSessionManager {
    
    public init() {} //추후 삭제 혹은 구현 예정
    
    public func request(_ request: URLRequest,
                        completion: @escaping CompletionHandler) -> NetworkCancelDelegate {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}

// MARK: - Logger

public final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    
    public init() {} //추후 삭제 혹은 구현 예정
    
    let classified = { (httpBody: Data) -> resultType in
        if let objectType = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject] {
            return resultType.objectType(objectType)
        } else if let stringType = String(data: httpBody, encoding: .utf8) {
            return resultType.stringType(stringType)
        } else {
            return resultType.none
        }
    }
    
    public func log(request: URLRequest) {
        guard let httpBody = request.httpBody else { return } // request에 httpBody 없음
        switch classified(httpBody) {
        case .objectType(_: let objectPrint):
            printIfDebug("body: \(objectPrint.prettyPrint())")
        case .stringType(_: let stringPrint):
            printIfDebug("body: \(stringPrint)")
        case .none:
            break
        }
    }
    
    public func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }
    
    public func log(error: Error) {
        printIfDebug("\(error)")
    }
}

// MARK: - NetworkError extension

extension NetworkError {
    
    public var isNotFoundError: Bool { return hasStatusCode(404) }
    
    public func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}

extension Dictionary where Key == String {
    
    func prettyPrint() -> String {
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return data
            .flatMap { NSString(data: $0, encoding: String.Encoding.utf8.rawValue) }
            .map { $0 as String } ?? ""
    }
}

func printIfDebug(_ string: String) {
#if DEBUG
    print(string)
#endif
}
