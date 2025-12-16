import Foundation

@objc public enum RNPlacementEventType: Int {
  case onWidgetReady
  case onFail
  case onEvent
  case onActionClicked
  case onProductEvent
  case onCartUpdate
  case onWishlistUpdate
  
  public var eventName: String {
    switch self {
    case .onWidgetReady:
      return "onWidgetReady"
    case .onFail:
      return "onFail"
    case .onEvent:
      return "onEvent"
    case .onActionClicked:
      return "onActionClicked"
    case .onProductEvent:
      return "onProductEvent"
    case .onCartUpdate:
      return "onCartUpdate"
    case .onWishlistUpdate:
      return "onWishlistUpdate"
    }
  }
}

