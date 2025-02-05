import UIKit
import Storyly


public class FlutterVerticalFeedBarViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    private var viewList: [Int64: Weak<FlutterVerticalFeedBarView>] = [:]
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let flutterStorylyView =  FlutterVerticalFeedBarView(frame, viewId: viewId, args: args as? [String : Any] ?? [:], messenger: self.messenger)
        self.viewList[viewId] = Weak<FlutterVerticalFeedBarView>(value: flutterStorylyView)
        flutterStorylyView.onDispose = { [weak self] viewId in
            self?.viewList.removeValue(forKey: viewId)
        }
        return flutterStorylyView
    }
    
    public func getViewById(id: Int) -> StorylyVerticalFeedBarView? {
        guard let view = viewList[Int64(id)] else { return nil }
        return view.value?.getStorylyView()
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

public class FlutterVerticalFeedBarView: NSObject, FlutterPlatformView {
    private let frame: CGRect
    private let viewId: Int64
    private let args: [String: Any]
    private let methodChannel: FlutterMethodChannel
    
    internal var onDispose: ((_ viewId: Int64) -> ())? = nil
    
    private lazy var storylyViewWrapper = FlutterVerticalFeedViewBarWrapper(frame: self.frame, args: self.args, methodChannel: self.methodChannel)
    
    init(_ frame: CGRect, viewId: Int64, args: [String: Any], messenger: FlutterBinaryMessenger) {
        self.frame = frame
        self.viewId = viewId
        self.args = args
        self.methodChannel = FlutterMethodChannel(name: "com.appsamurai.storyly/flutter_vertical_feed_bar_\(viewId)", binaryMessenger: messenger)
    }
    
    public func getStorylyView() -> StorylyVerticalFeedBarView {
        return storylyViewWrapper.verticalFeedView
    }
    
    public func view() -> UIView {
        return self.storylyViewWrapper
    }
    
    deinit {
        onDispose?(viewId)
    }
}

internal class FlutterVerticalFeedViewBarWrapper: UIView {
    internal let verticalFeedView: StorylyVerticalFeedBarView
    
    private let methodChannel: FlutterMethodChannel
    
    private var cartUpdateSuccessFailCallbackMap: [String: (((STRCart?) -> Void)?, ((STRCartEventResult) -> Void)?)] = [:]
    
    init(frame: CGRect,
         args: [String: Any],
         methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        self.verticalFeedView = StorylyVerticalFeedBarView(frame: frame)
        super.init(frame: frame)
        
        self.methodChannel.setMethodCallHandler { [weak self] call, _ in
            guard let self = self else { return }
            let callArguments = call.arguments as? [String: Any]
            switch call.method {
            case "refresh": self.verticalFeedView.refresh()
            case "start": self.verticalFeedView.resumeVerticalFeed(animated: true)
            case "pauseStory": self.verticalFeedView.pauseVerticalFeed(animated: true)
            case "closeStory": self.verticalFeedView.closeVerticalFeed(animated: true)
            case "openStory":
                _ = self.verticalFeedView.openStory(storyGroupId: callArguments?["storyGroupId"] as? String ?? "",
                                                    storyId: callArguments?["storyId"] as? String)
            case "openStoryUri":
                if let payloadString = callArguments?["uri"] as? String,
                   let payloadUrl = URL(string: payloadString) {
                    _ = self.verticalFeedView.openStory(payload: payloadUrl)
                }
            case "hydrateProducts":
                if let products = callArguments?["products"] as? [[String : Any?]] {
                    let storylyProducts = products.compactMap { createSTRProductItem(product: $0) }
                    self.verticalFeedView.hydrateProducts(products: storylyProducts)
                }
            case "updateCart":
                if let cart = callArguments?["cart"] as? [String : Any?] {
                    self.verticalFeedView.updateCart(cart: createSTRCart(cartMap: cart))
                }
            case "approveCartChange":
                if let responseId = callArguments?["responseId"] as? String,
                   let onSuccess = self.cartUpdateSuccessFailCallbackMap[responseId]?.0 as? (STRCart?) -> Void {
                    if let cart = callArguments?["cart"] as? [String : Any?] {
                        onSuccess(createSTRCart(cartMap: cart))
                    } else {
                        onSuccess(nil)
                    }
                    self.cartUpdateSuccessFailCallbackMap.removeValue(forKey: responseId)
                }
            case "rejectCartChange":
                if let responseId = callArguments?["responseId"] as? String,
                   let onFail = self.cartUpdateSuccessFailCallbackMap[responseId]?.1 as? (STRCartEventResult) -> Void,
                   let failMessage = callArguments?["failMessage"] as? String {
                    onFail(STRCartEventResult(message: failMessage))
                    self.cartUpdateSuccessFailCallbackMap.removeValue(forKey: responseId)
                }
            default: do {}
            }
        }
        
        guard let storylyInit = VerticalFeedInitMapper().getStorylyInit(json: args) else { return }
        self.verticalFeedView.translatesAutoresizingMaskIntoConstraints = false
        self.verticalFeedView.storylyVerticalFeedInit = storylyInit
        self.verticalFeedView.storylyVerticalFeedDelegate = self
        self.verticalFeedView.storylyVerticalFeedProductDelegate = self
        self.verticalFeedView.rootViewController = UIApplication.shared.keyWindow?.rootViewController?.getPresentedViewController()
        self.addSubview(verticalFeedView)
        
        self.verticalFeedView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.verticalFeedView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.verticalFeedView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.verticalFeedView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

extension FlutterVerticalFeedViewBarWrapper: StorylyVerticalFeedProductDelegate {
    
    func verticalFeedEvent(
        _ view: STRVerticalFeedView,
        event: VerticalFeedEvent
    ) {
        
        methodChannel.invokeMethod(
            "verticalFeedEvent",
            arguments: ["event": event.stringValue]
        )
    }
    
    func verticalFeedHydration(
        _ view: STRVerticalFeedView,
        products: [STRProductInformation]
    ) {
        methodChannel.invokeMethod(
            "verticalFeedOnHydration",
            arguments: [
                "products": products.map { createSTRProductInformationMap(productInfo: $0) }
            ]
        )
    }
    
    func verticalFeedUpdateCartEvent(
        view: STRVerticalFeedView,
        event: VerticalFeedEvent,
        cart: STRCart?,
        change: STRCartItem?,
        onSuccess: ((STRCart?) -> Void)?,
        onFail: ((STRCartEventResult) -> Void)?
    ) {
        let responseId = UUID().uuidString
        cartUpdateSuccessFailCallbackMap[responseId] = (onSuccess, onFail)
        
        methodChannel.invokeMethod(
            "verticalFeedOnProductCartUpdated",
            arguments: [
                "event": event.stringValue,
                "cart": createSTRCartMap(cart: cart),
                "change": createSTRCartItemMap(cartItem: change),
                "responseId": responseId
            ]  as [String: Any?]
        )
    }
}


extension FlutterVerticalFeedViewBarWrapper: StorylyVerticalFeedDelegate {
    func verticalFeedLoaded(
        _ view: STRVerticalFeedView,
        feedGroupList: [VerticalFeedGroup],
        dataSource: StorylyDataSource
    ) {
        methodChannel.invokeMethod(
            "verticalFeedLoaded",
            arguments: [
                "feedGroupList": feedGroupList.map { createStoryGroupMap(storyGroup: $0) },
                "dataSource": dataSource.description
            ]
        )
    }
    
    func verticalFeedLoadFailed(
        _ view: STRVerticalFeedView,
        errorMessage: String
    ) {
        methodChannel.invokeMethod("verticalFeedLoadFailed", arguments: errorMessage)
    }
    
    func verticalFeedEvent(
        _ view: STRVerticalFeedView,
        event: VerticalFeedEvent,
        feedGroup: VerticalFeedGroup?,
        feedItem: VerticalFeedItem?,
        feedItemComponent: VerticalFeedItemComponent?
    ) {
        methodChannel.invokeMethod(
            "verticalFeedEvent",
            arguments: [
                "event": event.stringValue,
                "feedGroup": createStoryGroupMap(storyGroup: feedGroup),
                "feedItem": createStoryMap(story: feedItem),
                "feedItemComponent": createStoryComponentMap(storyComponent: feedItemComponent)
            ] as [String: Any?]
        )
    }
    
    func verticalFeedPresented(_ view: STRVerticalFeedView) {
        methodChannel.invokeMethod("verticalFeedShown", arguments: nil)
    }
    
    func verticalFeedPresentFailed(
        _ view: STRVerticalFeedView,
        errorMessage: String
    ) {
        methodChannel.invokeMethod("verticalFeedShowFailed", arguments: errorMessage)
    }
    
    func verticalFeedDismissed(_ view: STRVerticalFeedView) {
        methodChannel.invokeMethod("verticalFeedDismissed", arguments: nil)
    }
    
    func verticalFeedActionClicked(
        _ view: STRVerticalFeedView,
        rootViewController: UIViewController,
        feedItem: VerticalFeedItem) {
        methodChannel.invokeMethod(
            "verticalFeedActionClicked",
            arguments: createStoryMap(story: feedItem)
        )
    }
    
    func verticalFeedUserInteracted(
        _ view: STRVerticalFeedView,
        feedGroup: VerticalFeedGroup,
        feedItem: VerticalFeedItem,
        feedItemComponent: VerticalFeedItemComponent
    ) {
        methodChannel.invokeMethod(
            "verticalFeedUserInteracted",
            arguments: [
                "feedGroup": createStoryGroupMap(storyGroup: feedGroup),
                "feedItem": createStoryMap(story: feedItem),
                "feedItemComponent": createStoryComponentMap(storyComponent: feedItemComponent)
            ] as [String: Any?]
        )
    }
}
