import Flutter
import UIKit

public class StorylyPlacementFlutterPlugin: NSObject, FlutterPlugin {
  private let channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "storyly_placement_flutter", binaryMessenger: registrar.messenger())
    let instance = StorylyPlacementFlutterPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
      
    let factory = StorylyPlacementFlutterViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "storyly_placement_flutter_view")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "createProvider":
        if let providerId = call.arguments as? String {
            let wrapper = SPPlacementProviderManager.shared.createProvider(id: providerId)
            wrapper.sendEvent = { [weak self] id, event, eventData in
                DispatchQueue.main.async {
                    let payload: [String: Any] = [
                        "providerId": id,
                        "raw": eventData
                    ]
                    self?.channel.invokeMethod(event.eventName, arguments: payload)
                }
            }
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "providerId is required", details: nil))
        }
    case "destroyProvider":
        if let providerId = call.arguments as? String {
            SPPlacementProviderManager.shared.destroyProvider(id: providerId)
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "providerId is required", details: nil))
        }
    case "updateConfig":
        if let args = call.arguments as? [String: Any],
           let providerId = args["providerId"] as? String,
           let config = args["config"] as? String {
            SPPlacementProviderManager.shared.getProvider(id: providerId)?.configure(configJson: config)
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "providerId and config are required", details: nil))
        }
    case "hydrateProducts":
        if let args = call.arguments as? [String: Any],
           let providerId = args["providerId"] as? String,
           let products = args["products"] as? String {
            SPPlacementProviderManager.shared.getProvider(id: providerId)?.hydrateProducts(productsJson: products)
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "providerId and products are required", details: nil))
        }
    case "hydrateWishlist":
        if let args = call.arguments as? [String: Any],
           let providerId = args["providerId"] as? String,
           let products = args["products"] as? String {
            SPPlacementProviderManager.shared.getProvider(id: providerId)?.hydrateWishlist(productsJson: products)
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "providerId and products are required", details: nil))
        }
    case "updateCart":
        if let args = call.arguments as? [String: Any],
           let providerId = args["providerId"] as? String,
           let cart = args["cart"] as? String {
            SPPlacementProviderManager.shared.getProvider(id: providerId)?.updateCart(cartJson: cart)
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "providerId and cart are required", details: nil))
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

class StorylyPlacementFlutterViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return StorylyPlacementFlutterView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            messenger: messenger
        )
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class StorylyPlacementFlutterView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var placementView: SPStorylyPlacementView
    private var methodChannel: FlutterMethodChannel

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        placementView = SPStorylyPlacementView()
        
        methodChannel = FlutterMethodChannel(name: "storyly_placement_flutter/view_\(viewId)", binaryMessenger: messenger)
        
        super.init()
        
        if let args = args as? [String: Any],
           let providerId = args["providerId"] as? String {
            placementView.configure(providerId: providerId)
        }
        
        setupMethodChannel()
        setupCallbacks()
        
        placementView.frame = frame
        placementView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _view.addSubview(placementView)
    }

    func view() -> UIView {
        return _view
    }
    
    private func setupMethodChannel() {
        methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            
            switch call.method {
            case "configure":
                if let args = call.arguments as? [String: Any],
                   let providerId = args["providerId"] as? String {
                    self.placementView.configure(providerId: providerId)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "providerId is required", details: nil))
                }
            case "callWidget":
                 if let args = call.arguments as? [String: Any],
                    let viewId = args["viewId"] as? String,
                    let method = args["method"] as? String,
                    let raw = args["raw"] as? String {
                     self.placementView.callWidget(id: viewId, method: method, raw: raw)
                     result(nil)
                 } else {
                     result(FlutterError(code: "INVALID_ARGUMENT", message: "viewId, method and params are required", details: nil))
                 }
            case "approveCartChange":
                if let args = call.arguments as? [String: Any],
                   let responseId = args["responseId"] as? String,
                   let raw = args["raw"] as? String {
                    self.placementView.approveCartChange(responseId: responseId, raw: raw)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "responseId and cart are required", details: nil))
                }
            case "rejectCartChange":
                if let args = call.arguments as? [String: Any],
                   let responseId = args["responseId"] as? String,
                   let raw = args["raw"] as? String {
                    self.placementView.rejectCartChange(responseId: responseId, raw: raw)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "responseId and failMessage are required", details: nil))
                }
            case "approveWishlistChange":
                if let args = call.arguments as? [String: Any],
                   let responseId = args["responseId"] as? String,
                   let raw = args["raw"] as? String {
                    self.placementView.approveWishlistChange(responseId: responseId, raw: raw)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "responseId and item are required", details: nil))
                }
            case "rejectWishlistChange":
                if let args = call.arguments as? [String: Any],
                   let responseId = args["responseId"] as? String,
                   let raw = args["failMessage"] as? String {
                    self.placementView.rejectWishlistChange(responseId: responseId, raw: raw)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "responseId and failMessage are required", details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func setupCallbacks() {
        placementView.dispatchEvent = { [weak self] event, eventData in
            self?.methodChannel.invokeMethod(event.eventName, arguments: eventData)
        }
    }
}
