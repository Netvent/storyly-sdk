import Foundation
import UIKit
import StorylyPlacement
import StorylyCore
import StorylyStoryBar
import StorylyVideoFeed

@objc public class RNStorylyPlacementView: UIView {
    
    private var providerId: String?
    private var placementView: STRPlacementView?
    internal var widgetMap: [String: WeakReference<STRWidgetController>] = [:]
    
    // Callback storage for async operations
    internal var cartUpdateCallbacks: [String: CartCallbacks] = [:]
    internal var wishlistUpdateCallbacks: [String: WishlistCallbacks] = [:]
    
    // Event dispatch closure (set by bridge layer)
    @objc public var dispatchEvent: ((RNPlacementEventType, String?) -> Void)?
  
    private lazy var delegate = STRDelegateImpl(placementView: self)
    private lazy var productDelegate = STRProductDelegateImpl(placementView: self)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc public func configure(providerId: String) {
        DispatchQueue.main.async {
            if providerId == self.providerId {
                print("[RNStorylyPlacement] Already configured with providerId: \(providerId)")
                return
            }
            
            print("[RNStorylyPlacement] Configuring with providerId: \(providerId)")
            self.providerId = providerId
            self.setupPlacementView()
        }
    }

    @objc public func callWidget(id: String, method: String, raw: String?) {
        DispatchQueue.main.async {
            print("[RNStorylyPlacement] callWidget: \(id)-\(method)-\(raw ?? "nil")")
            
            guard let widget = self.widgetMap[id]?.value else { return }
            let params = decodeFromJson(raw)
            
            switch widget.getType() {
                case .storyBar:
                    self.handleStoryBarMethod(widget: widget, method: method, params: params)
                case .videoFeed:
                    self.handleVideoFeedMethod(widget: widget, method: method, params: params)
                case .videoFeedPresenter:
                  self.handleVideoFeedPresenterMethod(widget: widget, method: method, params: params)
                case .banner, .swipeCard, .none:
                  break
                @unknown default:
                  break
            }
        }
    }
  
    @objc public func approveCartChange(responseId: String, raw: String?) {
        DispatchQueue.main.async {
          guard let callbacks = self.cartUpdateCallbacks[responseId] else { return }
            
            var cart: STRCart? = nil
            if let raw = raw,
               let dict = decodeFromJson(raw),
               let cartDict = dict["cart"] as? [String: Any] {
              cart = decodeSTRCart(cartDict)
            }
            
            callbacks.onSuccess?(cart)
            self.cartUpdateCallbacks.removeValue(forKey: responseId)
        }
    }

    @objc public func rejectCartChange(responseId: String, raw: String?) {
        DispatchQueue.main.async {
            guard let callbacks = self.cartUpdateCallbacks[responseId] else { return }
            
            var failMessage = ""
            if let raw = raw,
               let dict = decodeFromJson(raw),
               let message = dict["failMessage"] as? String {
              failMessage = message
            }
            
            callbacks.onFail?(STRCartEventResult(message: failMessage))
            self.cartUpdateCallbacks.removeValue(forKey: responseId)
        }
    }

    @objc public func approveWishlistChange(responseId: String, raw: String?) {
        DispatchQueue.main.async {
            guard let callbacks = self.wishlistUpdateCallbacks[responseId] else { return }
            
            var item: STRProductItem? = nil
            if let raw = raw,
               let dict = decodeFromJson(raw),
               let itemDict = dict["item"] as? [String: Any] {
              item = decodeSTRProductItem(itemDict)
            }
            
            callbacks.onSuccess?(item)
            self.wishlistUpdateCallbacks.removeValue(forKey: responseId)
        }
    }

    @objc public func rejectWishlistChange(responseId: String, raw: String?) {
        DispatchQueue.main.async {
            guard let callbacks = self.wishlistUpdateCallbacks[responseId] else { return }
            
            var failMessage = ""
            if let raw = raw,
               let dict = decodeFromJson(raw),
               let message = dict["failMessage"] as? String {
              failMessage = message
            }
            
            callbacks.onFail?(STRWishlistEventResult(message: failMessage))
            self.wishlistUpdateCallbacks.removeValue(forKey: responseId)
        }
    }
    
    private func setupPlacementView() {
        guard let currentProviderId = providerId else { return }
        
        print("[RNStorylyPlacement] Setting up placement view with providerId: \(currentProviderId)")
        
        guard let providerWrapper = RNPlacementProviderManager.shared.getProvider(id: currentProviderId) else {
            print("[RNStorylyPlacement] Provider not found for id: \(currentProviderId)")
            return
        }
        
        let dataProvider = providerWrapper.provider
        placementView?.removeFromSuperview()
        placementView = createPlacementView(dataProvider: dataProvider)
        
        if let placementView = placementView {
            addSubview(placementView)
            placementView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                placementView.topAnchor.constraint(equalTo: topAnchor),
                placementView.leadingAnchor.constraint(equalTo: leadingAnchor),
                placementView.trailingAnchor.constraint(equalTo: trailingAnchor),
                placementView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
    
    private func createPlacementView(dataProvider: PlacementDataProvider) -> STRPlacementView {
        let view = STRPlacementView(dataProvider: dataProvider)
        
        view.rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        view.delegate = delegate
        view.productDelegate = productDelegate
        
        return view
    }
    
    private func handleStoryBarMethod(widget: STRWidgetController, method: String, params: [String: Any]?) {
        guard let controller = widget as? STRStoryBarController else { return }
        
        switch method {
        case "pause":
            controller.pause(animated: true, completion: nil)
        case "resume":
            controller.resume(animated: true, completion: nil)
        case "close":
            controller.close(animated: true, completion: nil)
        case "open":
            guard let params = params,
                  let uriStr = params["uri"] as? String,
                  let uri = URL(string: uriStr) else { return }
            _ = controller.open(payload: uri)
        case "openWithId":
            guard let params = params,
                  let storyGroupId = params["storyGroupId"] as? String else { return }
            let storyId = params["storyId"] as? String
            let playModeStr = params["playMode"] as? String
            let playMode: PlayMode
            switch playModeStr {
              case "storygroup": playMode = .StoryGroup
              case "story": playMode = .Story
              default: playMode = .Default
            }
            _ = controller.open(storyGroupId: storyGroupId, storyId: storyId, play: playMode)
        default:
            break
        }
    }
    
    private func handleVideoFeedMethod(widget: STRWidgetController, method: String, params: [String: Any]?) {
        guard let controller = widget as? STRVideoFeedController else { return }
        
        switch method {
        case "pause":
            controller.pause(animated: true, completion: nil)
        case "resume":
            controller.resume(animated: true, completion: nil)
        case "close":
            controller.close(animated: true, completion: nil)
        case "open":
            guard let params = params,
                  let uriStr = params["uri"] as? String,
                  let uri = URL(string: uriStr) else { return }
            _ = controller.open(payload: uri)
        case "openWithId":
            guard let params = params,
                  let groupId = params["groupId"] as? String else { return }
            let itemId = params["itemId"] as? String
            let playModeStr = params["playMode"] as? String
            let playMode: VFPlayMode
            switch playModeStr {
              case "feedgroup": playMode = .FeedGroup
              case "feed": playMode = .Feed
              default: playMode = .Default
            }
            _ = controller.open(groupId: groupId, itemId: itemId, play: playMode)
        default:
            break
        }
    }
    
    private func handleVideoFeedPresenterMethod(widget: STRWidgetController, method: String, params: [String: Any]?) {
        guard let controller = widget as? STRVideoFeedPresenterController else { return }
        
        switch method {
        case "pause":
            controller.pause()
        case "play":
            controller.play()
        case "open":
            guard let params = params,
                  let groupId = params["groupId"] as? String else { return }
            _ = controller.open(groupId: groupId)
        default:
            break
        }
    }
}

// MARK: - Callback Type Definitions

struct CartCallbacks {
    let onSuccess: ((STRCart?) -> Void)?
    let onFail: ((STRCartEventResult) -> Void)?
}

struct WishlistCallbacks {
    let onSuccess: ((STRProductItem?) -> Void)?
    let onFail: ((STRWishlistEventResult) -> Void)?
}

// MARK: - STRListener Implementation

private class STRDelegateImpl: NSObject, STRDelegate {
    weak var placementView: RNStorylyPlacementView?
    
    init(placementView: RNStorylyPlacementView) {
        self.placementView = placementView
    }
    
    func onActionClicked(widget: any STRWidgetController, url: String, payload: STRPayload) {
        guard let placementView = placementView else { return }
        
        print("[RNStorylyPlacement] onActionClicked: url=\(url)")
        
        let eventData: [String: Any] = [
            "widget": encodeWidgetController(widget, widgetMap: &placementView.widgetMap),
            "url": url,
            "payload": encodeSTRPayload(payload)
        ]
        
        if let eventJson = encodeToJson(eventData) {
            placementView.dispatchEvent?(.onActionClicked, eventJson)
        }
    }
    
    func onEvent(widget: any STRWidgetController, payload: STREventPayload) {
        guard let placementView = placementView else { return }
        
        print("[RNStorylyPlacement] onEvent: widgetType=\(widget.getType()), payload=\(payload.baseEvent.getType())")
        
        let eventData: [String: Any] = [
            "widget": encodeWidgetController(widget, widgetMap: &placementView.widgetMap),
            "payload": encodeSTREventPayload(payload)
        ]
        
        if let eventJson = encodeToJson(eventData) {
            placementView.dispatchEvent?(.onEvent, eventJson)
        }
    }
    
    func onFail(widget: any STRWidgetController, payload: STRErrorPayload) {
        guard let placementView = placementView else { return }
        
        print("[RNStorylyPlacement] onFail: widget=\(widget.getType()), payload=\(payload.baseError.getType())")
        
        let eventData: [String: Any] = [
            "widget": encodeWidgetController(widget, widgetMap: &placementView.widgetMap),
            "payload": encodeSTRErrorPayload(payload)
        ]
        
        if let eventJson = encodeToJson(eventData) {
            placementView.dispatchEvent?(.onFail, eventJson)
        }
    }
    
  func onWidgetReady(widget: any STRWidgetController, ratio: CGFloat) {
      guard let placementView = placementView else { return }
      
      print("[RNStorylyPlacement] onWidgetReady: ratio=\(ratio)")
      
      let eventData: [String: Any] = [
          "widget": encodeWidgetController(widget, widgetMap: &placementView.widgetMap),
          "ratio": ratio
      ]
      
      if let eventJson = encodeToJson(eventData) {
          placementView.dispatchEvent?(.onWidgetReady, eventJson)
      }
  }
}

// MARK: - STRProductListener Implementation

private class STRProductDelegateImpl: NSObject, STRProductDelegate {
    weak var placementView: RNStorylyPlacementView?
    
    init(placementView: RNStorylyPlacementView) {
        self.placementView = placementView
    }
    
    func onProductEvent(widget: any STRWidgetController, event: STREvent) {
        guard let placementView = placementView else { return }
        
        print("[RNStorylyPlacement] onProductEvent: \(event.getType())")
        
        let eventData: [String: Any] = [
            "widget": encodeWidgetController(widget, widgetMap: &placementView.widgetMap),
            "event": event.getType()
        ]
        
        if let eventJson = encodeToJson(eventData) {
            placementView.dispatchEvent?(.onProductEvent, eventJson)
        }
    }
    
    func onUpdateCart(widget: any STRWidgetController, event: STREvent, cart: STRCart?, change: STRCartItem?, onSuccess: ((STRCart?) -> Void)?, onFail: ((STRCartEventResult) -> Void)?) {
        guard let placementView = placementView else { return }
        
        print("[RNStorylyPlacement] onUpdateCart: \(event.getType())")
        
        let responseId = UUID().uuidString
        placementView.cartUpdateCallbacks[responseId] = CartCallbacks(onSuccess: onSuccess, onFail: onFail)
        
        let eventData: [String: Any?] = [
            "widget": encodeWidgetController(widget, widgetMap: &placementView.widgetMap),
            "event": event.getType(),
            "cart": encodeSTRCart(cart),
            "change": encodeSTRCartItem(change),
            "responseId": responseId
        ]
        
        if let eventJson = encodeToJson(eventData) {
            placementView.dispatchEvent?(.onUpdateCart, eventJson)
        }
    }
    
    func onUpdateWishlist(widget: any STRWidgetController, event: STREvent, item: STRProductItem?, onSuccess: ((STRProductItem?) -> Void)?, onFail: ((STRWishlistEventResult) -> Void)?) {
        guard let placementView = placementView else { return }
        
        print("[RNStorylyPlacement] onUpdateWishlist: \(event.getType())")
        
        let responseId = UUID().uuidString
        placementView.wishlistUpdateCallbacks[responseId] = WishlistCallbacks(onSuccess: onSuccess, onFail: onFail)
        
        let eventData: [String: Any?] = [
            "widget": encodeWidgetController(widget, widgetMap: &placementView.widgetMap),
            "event": event.getType(),
            "item": item != nil ? encodeSTRProductItem(item!) : nil,
            "responseId": responseId
        ]
        
        if let eventJson = encodeToJson(eventData) {
            placementView.dispatchEvent?(.onUpdateWishlist, eventJson)
        }
    }
}

