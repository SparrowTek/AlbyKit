import Foundation

public enum HelperError: Error {
    case badLightningAddress
    case regexErrors
}

public struct Helpers: Sendable {
    public func findLightningAddressInText(_ text: String) throws -> String {
        // Define the regex patterns with case insensitivity
        let lightningPattern = #"(?i)((⚡|⚡️):?|lightning:|lnurl:)\s?([\w\-.]+@[\w\-.]+\.[\w\-.]+)"#
        let albyLinkPattern = #"(?i)http(s)?://(www\.)?getalby\.com/p/(\w+)"#
        let albyUserPattern = #"^(https?:\/\/)?(www\.)?(\w+)@getalby\.com$"#

        // Search for the lightning pattern
        if let match = try? text.firstMatch(of: Regex(lightningPattern)) {
            return String(match.output.index(2, offsetBy: 0))
        }

        // Search for the Alby link pattern
        if let matchAlbyLink = try? text.firstMatch(of: Regex(albyLinkPattern)) {
            return "\(matchAlbyLink.output.index(3, offsetBy: 0))@getalby.com"
        }
        
        if let matchAlbyUser = try? text.firstMatch(of: Regex(albyUserPattern)) {
            return String(matchAlbyUser.output.index(2, offsetBy: 0))
        }

        throw HelperError.badLightningAddress
    }
}
