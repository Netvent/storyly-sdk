import Foundation

@objc public enum SPPlacementProviderEventType: Int {
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
  
    static var allCases: [SPPlacementProviderEventType] = [.onLoad, .onLoadFail, .onHydration]
}

