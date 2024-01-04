import Foundation

public enum API: String {
    case prod = "https://api.getalby.com"
    case dev =  "https://api.regtest.getalby.com"
}

class AlbyEnvironment {
    static var current: AlbyEnvironment = .init()
    
    var api: API?
    var clientID: String?
    var clientSecret: String?
    var redirectURI: String?
    
    private init() {}
    
    func setup(api: API, clientID: String, clientSecret: String, redirectURI: String) {
        self.api = api
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
}
