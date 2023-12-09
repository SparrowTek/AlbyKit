import Foundation

struct OAuthService {
    private let router = NetworkRouter<OAtuhAPI>(decoder: .albyDecoder)
    
    
}

enum OAtuhAPI {
//    case auth
    case token
}

extension OAtuhAPI: EndpointType {
    public var baseURL: URL {
        guard let environmentURL = AlbyEnvironment.current.api else { fatalError("You must call the AlbyKit Setup method before using AlbyKit") }
        guard let url = URL(string: environmentURL.rawValue) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
//        case .auth: "/oauth"
        case .token: "/oauth/token"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
//        case .auth:
//                return .get
        case .token:
                return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
//        case .auth:
//            return .request
        case .token:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
