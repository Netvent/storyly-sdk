import Foundation

@objc public enum SPPlacementEventType: Int {
  case onWidgetReady
  case onFail
  case onVisibilityChange
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
    case .onVisibilityChange:
      return "onVisibilityChange"
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
    return [.onWidgetReady, .onFail, .onVisibilityChange, .onEvent, .onActionClicked, .onProductEvent, .onUpdateCart, .onUpdateWishlist]
  }
}

