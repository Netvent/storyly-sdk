import Foundation

@objc public enum SPPlacementEventType: Int {
  case onWidgetReady
  case onFail
  case onEvent
  case onActionClicked
  case onProductEvent
  case onUpdateCart
  case onUpdateWishlist
  
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
    case .onUpdateCart:
      return "onUpdateCart"
    case .onUpdateWishlist:
      return "onUpdateWishlist"
    }
  }
  
  static var allCases: [SPPlacementEventType] {
    return [.onWidgetReady, .onFail, .onEvent, .onActionClicked, .onProductEvent, .onUpdateCart, .onUpdateWishlist]
  }
}

