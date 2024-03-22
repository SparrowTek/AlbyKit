@preconcurrency import Foundation

protocol NetworkRouterDelegate: AnyObject, Sendable {
    func intercept(_ request: inout URLRequest) async
    func shouldRetry(error: Error, attempts: Int) async throws -> Bool
}

public enum NetworkError : Error, Sendable {
    case encodingFailed
    case missingURL
    case statusCode(_ statusCode: StatusCode?, data: Data)
    case noStatusCode
    case noData
    case tokenRefresh
}

typealias HTTPHeaders = [String:String]


/// The NetworkRouter is a generic class that has an ``EndpointType`` and it conforms to ``NetworkRouterProtocol``
internal actor NetworkRouter<Endpoint: EndpointType> {
    
    weak var delegate: NetworkRouterDelegate?
    let networking: Networking
    let urlSessionTaskDelegate: URLSessionTaskDelegate?
    let decoder: JSONDecoder
    
    init(networking: Networking? = nil, urlSessionDelegate: URLSessionDelegate? = nil, urlSessionTaskDelegate: URLSessionTaskDelegate? = nil, decoder: JSONDecoder? = nil, delegate: NetworkRouterDelegate? = nil) {
        if let networking = networking {
            self.networking = networking
        } else {
            self.networking = URLSession(configuration: URLSessionConfiguration.default, delegate: urlSessionDelegate, delegateQueue: nil)
        }
        
        self.delegate = delegate
        
        self.urlSessionTaskDelegate = urlSessionTaskDelegate
        
        if let decoder = decoder {
            self.decoder = decoder
        } else {
            self.decoder = JSONDecoder()
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        }
    }
    
    func setDelegate(_ delegate: NetworkRouterDelegate?) {
        self.delegate = delegate
    }
    
    /// This generic method will take a route and return the desired type via a network call
    /// This method is async and it can throw errors
    /// - Returns: The generic type is returned
    func execute<T: Decodable>(_ route: Endpoint, attempts: Int = 1, shouldCheckToken: Bool = true) async throws -> T {
        
        if shouldCheckToken {
            try await checkToken()
        }
        
        guard var request = try? await buildRequest(from: route) else { throw NetworkError.encodingFailed }
        await delegate?.intercept(&request)
        
        let (data, response) = try await networking.data(for: request, delegate: urlSessionTaskDelegate)
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.noStatusCode }
        switch httpResponse.statusCode {
        case 200...299:
            await AlbyEnvironment.current.delegate?.reachabilityNormalPerformance()
            return try decoder.decode(T.self, from: data)
        default:
            let statusCode = StatusCode(rawValue: httpResponse.statusCode)
            let statusNetworkError = AlbyError.network(NetworkError.statusCode(statusCode, data: data))
            
            guard let delegate else { throw statusNetworkError }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let errorToThrow: AlbyError
            if let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) {
                errorToThrow = AlbyError.message(errorMessage)
            } else {
                errorToThrow = statusNetworkError
            }
            
            guard try await delegate.shouldRetry(error: errorToThrow, attempts: attempts) else { throw errorToThrow }
            return try await execute(route, attempts: attempts + 1)
        }
    }
    
    private func checkToken() async throws {
        do {
            try await AlbyEnvironment.current.authManager.validateToken()
        } catch {
            await AlbyEnvironment.current.delegate?.unautherizedUser()
            throw NetworkError.tokenRefresh
        }
    }
    
    func buildRequest(from route: Endpoint) async throws -> URLRequest {
        
        var request = await URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch await route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                await addAdditionalHeaders(route.headers, request: &request)
            case .requestParameters(let parameterEncoding):
                await addAdditionalHeaders(route.headers, request: &request)
                try configureParameters(parameterEncoding: parameterEncoding, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(parameterEncoding: ParameterEncoding, request: inout URLRequest) throws {
        try parameterEncoding.encode(urlRequest: &request)
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
