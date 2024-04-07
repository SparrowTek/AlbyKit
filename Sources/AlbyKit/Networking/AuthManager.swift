import Foundation

actor AuthManager {
    private var refreshTask: Task<Void, Error>?
    
    func validateToken() async throws {
        if let refreshTask {
            try await refreshTask.value
            self.refreshTask = nil
            await AlbyEnvironment.current.setTokenRefreshRequired(false)
        } else if await AlbyEnvironment.current.tokenRefreshRequired {
            try await refreshToken()
        } else if let token = Storage.retrieve(AlbyEnvironment.Constants.token, from: .documents, as: TokenMetadata.self) {
            
            guard let createdAt = token.createdAt, let expiresIn = token.expiresIn else {
                try await refreshToken()
                return
            }
            
            let tokenExpirationDate = createdAt.addingTimeInterval(TimeInterval(expiresIn))
            let timeDiff = tokenExpirationDate.timeIntervalSince(createdAt)
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
            await AlbyEnvironment.current.setTokenRefreshRequired(false)
        }
    }
}
