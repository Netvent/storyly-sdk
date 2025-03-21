import Storyly
import UIKit

internal class FlutterStorylyViewWrapper: UIView, StorylyDelegate {
    internal lazy var storylyView: StorylyView = StorylyView(frame: self.frame)
    
    private let methodChannel: FlutterMethodChannel
    
    private var cartUpdateSuccessFailCallbackMap: [String: (((STRCart?) -> Void)?, ((STRCartEventResult) -> Void)?)] = [:]
    private var wishlistUpdateSuccessFailCallbackMap: [String: (((STRProductItem?) -> Void)?, ((STRWishlistEventResult) -> Void)?)] = [:]

    init(frame: CGRect,
         args: [String: Any],
         methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        super.init(frame: frame)
        
        self.methodChannel.setMethodCallHandler { [weak self] call, _ in
            guard let self = self else { return }
            let callArguments = call.arguments as? [String: Any]
            switch call.method {
                case "refresh": self.storylyView.refresh()
                case "resumeStory": self.storylyView.resumeStory(animated: true)
                case "pauseStory": self.storylyView.pauseStory(animated: true)
                case "closeStory": self.storylyView.closeStory(animated: true)
                case "openStory":
                    _ = self.storylyView.openStory(storyGroupId: callArguments?["storyGroupId"] as? String ?? "",
                                                    storyId: callArguments?["storyId"] as? String)
                case "openStoryUri":
                    if let payloadString = callArguments?["uri"] as? String,
                       let payloadUrl = URL(string: payloadString) {
                        _ = self.storylyView.openStory(payload: payloadUrl)
                    }
                case "hydrateProducts":
                    if let products = callArguments?["products"] as? [[String : Any?]] {
                        let storylyProducts = products.compactMap { createSTRProductItem(product: $0) }
                        self.storylyView.hydrateProducts(products: storylyProducts)
                    }
                 case "hydrateWishlist":
                    if let products = callArguments?["products"] as? [[String : Any?]] {
                        let storylyProducts = products.compactMap { createSTRProductItem(product: $0) }
                        self.storylyView.hydrateWishlist(products: storylyProducts)
                    }
                case "updateCart":
                    if let cart = callArguments?["cart"] as? [String : Any?] {
                        self.storylyView.updateCart(cart: createSTRCart(cartMap: cart))
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
                case "approveWishlistChange":
                    if let responseId = callArguments?["responseId"] as? String,
                       let onSuccess = self.wishlistUpdateSuccessFailCallbackMap[responseId]?.0 as? (STRProductItem?) -> Void {
                        if let item = callArguments?["item"] as? [String : Any?] {
                            onSuccess(createSTRProductItem(product: item))
                        } else {
                            onSuccess(nil)
                        }
                        self.wishlistUpdateSuccessFailCallbackMap.removeValue(forKey: responseId)
                    }
                case "rejectWishlistChange":
                    if let responseId = callArguments?["responseId"] as? String,
                       let onFail = self.wishlistUpdateSuccessFailCallbackMap[responseId]?.1 as? (STRWishlistEventResult) -> Void,
                       let failMessage = callArguments?["failMessage"] as? String {
                        onFail(STRWishlistEventResult(message: failMessage))
                        self.wishlistUpdateSuccessFailCallbackMap.removeValue(forKey: responseId)
                    }
                default: do {}
            }
        }
        
        guard let storylyInit = StorylyInitMapper().getStorylyInit(json: args) else { return }
        self.storylyView = StorylyView(frame: self.frame)
        self.storylyView.translatesAutoresizingMaskIntoConstraints = false
        self.storylyView.storylyInit = storylyInit
        self.storylyView.delegate = self
        self.storylyView.productDelegate = self
        self.storylyView.rootViewController = UIApplication.shared.keyWindow?.rootViewController?.getPresentedViewController()
        self.addSubview(storylyView)
        self.storylyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.storylyView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        if let storylyBackgroundColor = args["storylyBackgroundColor"] as? String { storylyView.backgroundColor = UIColor(hexString: storylyBackgroundColor) }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

extension FlutterStorylyViewWrapper: StorylyProductDelegate {
    
    func storylyHydration(_ storylyView: StorylyView, products: [Storyly.STRProductInformation]) {
        self.methodChannel.invokeMethod("storylyOnHydration",
                                        arguments: [
                                            "products": products.map { productInfo in createSTRProductInformationMap(productInfo: productInfo)},
                                        ])
    }
    
    func storylyEvent(_ storylyView: StorylyView,
                      event: StorylyEvent) {
        self.methodChannel.invokeMethod(
            "storylyProductEvent",
            arguments: [
                "event": event.stringValue
            ]
        )
    }
    
    func storylyUpdateCartEvent(
        storylyView: StorylyView,
        event: StorylyEvent,
        cart: STRCart?,
        change: STRCartItem?,
        onSuccess: ((STRCart?) -> Void)?,
        onFail: ((STRCartEventResult) -> Void)?) {
            let responseId = UUID().uuidString
            self.cartUpdateSuccessFailCallbackMap[responseId] = (onSuccess, onFail)
            
            self.methodChannel.invokeMethod(
                "storylyOnProductCartUpdated",
                arguments: [
                    "event": event.stringValue,
                    "cart": createSTRCartMap(cart: cart),
                    "change": createSTRCartItemMap(cartItem: change),
                    "responseId": responseId
                ]
            )
        
    }
    
    func storylyUpdateWishlistEvent(
        storylyView: StorylyView,
        item: STRProductItem?,
        event: StorylyEvent,
        onSuccess: ((STRProductItem?) -> Void)?,
        onFail: ((STRWishlistEventResult) -> Void)?) {
            let responseId = UUID().uuidString
            self.wishlistUpdateSuccessFailCallbackMap[responseId] = (onSuccess, onFail)
            
            self.methodChannel.invokeMethod(
                "storylyOnWishlistUpdated",
                arguments: [
                    "event": event.stringValue,
                    "item": createSTRProductItemMap(product: item),
                    "responseId": responseId
                ]
            )
    }
}


extension FlutterStorylyViewWrapper {
    func storylyLoaded(_ storylyView: Storyly.StorylyView,
                       storyGroupList: [Storyly.StoryGroup],
                       dataSource: StorylyDataSource) {
        self.methodChannel.invokeMethod(
            "storylyLoaded",
            arguments: [
                "storyGroups": storyGroupList.map { storyGroup in createStoryGroupMap(storyGroup: storyGroup)},
                "dataSource": dataSource.description])
    }
    
    func storylyLoadFailed(_ storylyView: Storyly.StorylyView, errorMessage: String) {
        self.methodChannel.invokeMethod("storylyLoadFailed", arguments: errorMessage)
    }
    
    func storylyEvent(_ storylyView: StorylyView, event: StorylyEvent, storyGroup: StoryGroup?, story: Story?, storyComponent: StoryComponent?) {
        var storyGroupMap: [String: Any?]? = nil
        if let storyGroup = storyGroup { storyGroupMap = createStoryGroupMap(storyGroup: storyGroup) }
        
        var storyMap: [String: Any?]? = nil
        if let story = story { storyMap = createStoryMap(story: story) }
        
        var storyComponentMap: [String: Any?]? = nil
        if let storyComponent = storyComponent { storyComponentMap = createStoryComponentMap(storyComponent: storyComponent) }
        self.methodChannel.invokeMethod(
            "storylyEvent",
            arguments: [
                "event": event.stringValue,
                "storyGroup": storyGroupMap,
                "story": storyMap,
                "storyComponent": storyComponentMap
            ])
    }
    
    func storylyActionClicked(_ storylyView: Storyly.StorylyView,
                              rootViewController: UIViewController,
                              story: Storyly.Story) {
        self.methodChannel.invokeMethod(
            "storylyActionClicked",
            arguments: createStoryMap(story: story))
    }
    
    func storylyStoryPresented(_ storylyView: Storyly.StorylyView) {
        self.methodChannel.invokeMethod("storylyStoryPresented", arguments: nil)
    }
    
    func storylyStoryDismissed(_ storylyView: Storyly.StorylyView) {
        self.methodChannel.invokeMethod("storylyStoryDismissed", arguments: nil)
    }
    
    func storylyUserInteracted(_ storylyView: StorylyView,
                               storyGroup: StoryGroup,
                               story: Story,
                               storyComponent: StoryComponent) {
        self.methodChannel.invokeMethod(
            "storylyUserInteracted",
            arguments: [
                "storyGroup": createStoryGroupMap(storyGroup: storyGroup),
                "story": createStoryMap(story: story),
                "storyComponent": createStoryComponentMap(storyComponent: storyComponent)
            ])
    }

    func storylySizeChanged(_ storylyView: StorylyView,
                            size: CGSize) {
        self.methodChannel.invokeMethod(
            "storylySizeChanged",
            arguments: [
                "width": size.width,
                "height": size.height
            ])
    }
}
