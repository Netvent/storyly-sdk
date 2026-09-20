import Foundation
import StorylyCore

class SPLogManager {

    static func setLogLevel(_ level: String) {
        STRLog.logLevel = decodeLogLevel(level)
    }
}

internal func decodeLogLevel(_ level: String) -> StorylyLogLevel {
    switch level.lowercased() {
    case "debug": return .debug
    case "warning": return .warning
    case "error": return .error
    default: return .off
    }
}
