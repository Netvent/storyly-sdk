import Foundation
import UIKit
import StorylyPlacement
import StorylyCore
import StorylyStoryBar
import StorylyVideoFeed

@objc public class SPStorylyPlacementView: UIView {
    
    private var providerId: String?
    private var placementView: STRPlacementView?
    internal var widgetMap: [String: WeakReference<STRWidgetController>] = [:]
    
    // Callback storage for async operations
    internal var cartUpdateCallbacks: [String: CartCallbacks] = [:]
    internal var wishlistUpdateCallbacks: [String: WishlistCallbacks] = [:]
    
    // Event dispatch closure (set by bridge layer)
    @objc public var dispatchEvent: ((SPPlacementEventType, String?) -> Void)?
  
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
                print("[SPStorylyPlacement] Already configured with providerId: \(providerId)")
                return
            }
            
            print("[SPStorylyPlacement] Configuring with providerId: \(providerId)")
            self.providerId = providerId
            self.setupPlacementView()
        }
    }

    @objc public func callWidget(id: String, method: String, raw: String?) {
        DispatchQueue.main.async {
            print("[SPStorylyPlacement] callWidget: \(id)-\(method)-\(raw ?? "nil")")

            guard let widget = self.widgetMap[id]?.value else { return }
            let params = decodeFromJson(raw)

            switch method {
            case "pause":
                widget.pause()
                return
            case "resume":
                widget.resume()
                return
            case "open":
                guard let params = params,
                      let uriStr = params["uri"] as? String,
                      let uri = URL(string: uriStr) else { return }
                _ = widget.open(payload: uri)
                return
            default:
                break
            }

            switch widget.getType() {
                case .storyBar:
                    self.handleStoryBarMethod(widget: widget, method: method, params: params)
                case .videoFeed:
                    self.handleVideoFeedMethod(widget: widget, method: method, params: params)
                case .videoFeedPresenter:
                  self.handleVideoFeedPresenterMethod(widget: widget, method: method, params: params)
                case .banner, .swipeCard, .canvas, .none:
                  break
                @unknown default:
                  break
            }
        }
    }
  
    @objc public func approveCartChange(responseId: String) {
        DispatchQueue.main.async {
          guard let callbacks = self.cartUpdateCallbacks[responseId] else { return }
            
            callbacks.onSuccess?()
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
            
            callbacks.onFail?(failMessage)
            self.cartUpdateCallbacks.removeValue(forKey: responseId)
        }
    }

    @objc public func approveWishlistChange(responseId: String) {
        DispatchQueue.main.async {
            guard let callbacks = self.wishlistUpdateCallbacks[responseId] else { return }
            callbacks.onSuccess?()
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
            
            callbacks.onFail?(failMessage)
            self.wishlistUpdateCallbacks.removeValue(forKey: responseId)
        }
    }
    
    private func setupPlacementView() {
        guard let currentProviderId = providerId else { return }
        
        print("[SPStorylyPlacement] Setting up placement view with providerId: \(currentProviderId)")
        
        guard let providerWrapper = SPPlacementProviderManager.shared.getProvider(id: currentProviderId) else {
            print("[SPStorylyPlacement] Provider not found for id: \(currentProviderId)")
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
    
    private func createPlacementView(dataProvider: STRPlacementDataProvider) -> STRPlacementView {
        let view = STRPlacementView(dataProvider: dataProvider)
        
        view.rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        view.delegate = delegate
        view.productDelegate = productDelegate
        
        return view
    }
    
    private func handleStoryBarMethod(widget: STRWidgetController, method: String, params: [String: Any]?) {
        guard let controller = widget as? STRStoryBarController else { return }

        switch method {
        case "openWithId":
            guard let params = params,
                  let storyGroupId = params["storyGroupId"] as? String else { return }
            let storyId = params["storyId"] as? String
            let playModeStr = params["playMode"] as? String
            let playMode: STRStoryBarPlayMode
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
        case "openWithId":
            guard let params = params,
                  let feedGroupId = params["feedGroupId"] as? String else { return }
            let feedId = params["feedId"] as? String
            let playModeStr = params["playMode"] as? String
            let playMode: STRVideoFeedPlayMode
            switch playModeStr {
              case "feedgroup": playMode = .FeedGroup
              case "feed": playMode = .Feed
              default: playMode = .Default
            }
            _ = controller.open(feedGroupId: feedGroupId, feedId: feedId, play: playMode)
        default:
            break
        }
    }
    
    private func handleVideoFeedPresenterMethod(widget: STRWidgetController, method: String, params: [String: Any]?) {
        guard let controller = widget as? STRVideoFeedPresenterController else { return }

        switch method {
        case "play":
            controller.play()
        case "openWithId":
            guard let params = params,
                  let feedGroupId = params["feedGroupId"] as? String else { return }
            _ = controller.open(feedGroupId: feedGroupId)
        default:
            break
        }
    }
}

// MARK: - Callback Type Definitions

struct CartCallbacks {
    let onSuccess: (() -> Void)?
    let onFail: ((String) -> Void)?
}

struct WishlistCallbacks {
    let onSuccess: (() -> Void)?
    let onFail: ((String) -> Void)?
}

// MARK: - STRListener Implementation

private class STRDelegateImpl: NSObject, STRDelegate {
    weak var placementView: SPStorylyPlacementView?
    
    init(placementView: SPStorylyPlacementView) {
        self.placementView = placementView
    }
    
    func onActionClicked(widget: any STRWidgetController, url: String, payload: STRPayload) {
        guard let placementView = placementView else { return }
        
        print("[SPStorylyPlacement] onActionClicked: url=\(url)")
        
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
        
        print("[SPStorylyPlacement] onEvent: widgetType=\(widget.getType()), payload=\(payload.baseEvent.getType())")
        
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
        
        print("[SPStorylyPlacement] onFail: widget=\(widget.getType()), payload=\(payload.baseError.getType())")
        
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
      
      print("[SPStorylyPlacement] onWidgetReady: ratio=\(ratio)")
      
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
    weak var placementView: SPStorylyPlacementView?
    
    init(placementView: SPStorylyPlacementView) {
        self.placementView = placementView
    }
    
    func onProductEvent(widget: any STRWidgetController, event: STRProductEvent) {
        guard let placementView = placementView else { return }
        
        print("[SPStorylyPlacement] onProductEvent: \(event.getType())")
        
        let eventData: [String: Any] = [
            "widget": encodeWidgetController(widget, widgetMap: &placementView.widgetMap),
            "event": event.getType()
        ]
        
        if let eventJson = encodeToJson(eventData) {
            placementView.dispatchEvent?(.onProductEvent, eventJson)
        }
    }
    
    func onUpdateCart(widget: any STRWidgetController, item: STRCartItem?, onSuccess: (() -> Void)?, onFail: ((String) -> Void)?) {
        guard let placementView = placementView else { return }
        
        print("[SPStorylyPlacement] onUpdateCart")
        
        let responseId = UUID().uuidString
        placementView.cartUpdateCallbacks[responseId] = CartCallbacks(onSuccess: onSuccess, onFail: onFail)
        
        let eventData: [String: Any?] = [
            "widget": encodeWidgetController(widget, widgetMap: &placementView.widgetMap),
            "item": encodeSTRCartItem(item),
            "responseId": responseId
        ]
        
        if let eventJson = encodeToJson(eventData) {
            placementView.dispatchEvent?(.onUpdateCart, eventJson)
        }
    }
    
    func onUpdateWishlist(widget: any STRWidgetController, event: STRProductEvent, item: STRProductItem?, onSuccess: (() -> Void)?, onFail: ((String) -> Void)?) {
        guard let placementView = placementView else { return }
        
        print("[SPStorylyPlacement] onUpdateWishlist: \(event.getType())")
        
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

