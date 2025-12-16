import Foundation

@objc public enum RNPlacementProviderEventType: Int {
    case onLoad
    case onLoadFail
    case onHydration
    
    public var eventName: String {
        switch self {
        case .onLoad:
            return "onLoad"
        case .onLoadFail:
            return "onLoadFail"
        case .onHydration:
            return "onHydration"
        }
    }
}

