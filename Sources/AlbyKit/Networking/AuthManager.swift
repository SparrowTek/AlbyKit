import Foundation

actor AuthManager {
    private var refreshTask: Task<Void, Error>?
    var tokenRefreshRequired = false
    
    func triggerTokenRefreshRequired() {
        guard tokenRefreshRequired else { return }
        tokenRefreshRequired = true
    }
    
    func validateToken() async throws {
        if let refreshTask {
            try await refreshTask.value
            self.refreshTask = nil
            tokenRefreshRequired = false
        } else if tokenRefreshRequired {
            try await refreshToken()
        } else if let token = Storage.retrieve(AlbyEnvironment.Constants.token, from: .documents, as: TokenMetadata.self) {
            let tokenExpirationDate = token.createdAt.addingTimeInterval(TimeInterval(token.expiresIn))
            let timeDiff = tokenExpirationDate.timeIntervalSince(token.createdAt)
            let fiveMinutesInSeconds: Double = 5 * 60
            
            if timeDiff <= fiveMinutesInSeconds {
                try await refreshToken()
            }
        } else {
            try await refreshToken()
        }
    }
    
    private func refreshToken() async throws {
        if let refreshTask {
            try await refreshTask.value
            self.refreshTask = nil
        } else {
            let task = Task.detached(priority: .high) {
                try await OAuthService().refreshAccessToken()
            }
            
            refreshTask = task
            try await task.value
            refreshTask = nil
            tokenRefreshRequired = false
        }
    }
}
