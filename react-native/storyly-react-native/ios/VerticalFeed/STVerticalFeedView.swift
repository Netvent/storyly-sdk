//
//  STStorylyView.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 26.10.2022.
//

import Storyly


@objc(STVerticalFeedView)
class STVerticalFeedView: UIView {
    
    private var cartUpdateSuccessFailCallbackMap: [String: (((STRCart?) -> Void)?, ((STRCartEventResult) -> Void)?)] = [:]
    private var wishlistUpdateSuccessFailCallbackMap: [String: (((STRProductItem?) -> Void)?, ((STRWishlistEventResult) -> Void)?)] = [:]

    @objc(storylyBundle)
    var storylyBundle: VerticalFeedBundle? = nil {
        didSet {
            self.storylyView = self.storylyBundle?.storylyView
        }
    }
    
    private var storylyView: StorylyVerticalFeedView? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            guard let storylyView = storylyView else { return }
            storylyView.rootViewController = UIApplication.shared.delegate?.window??.rootViewController
            storylyView.storylyVerticalFeedDelegate = self
            storylyView.storylyVerticalFeedProductDelegate = self
            addSubview(storylyView)
            
            storylyView.translatesAutoresizingMaskIntoConstraints = false
            storylyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            storylyView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            storylyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            storylyView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
    @objc(onStorylyLoaded)
    var onStorylyLoaded: RCTBubblingEventBlock?

    @objc(onStorylyLoadFailed)
    var onStorylyLoadFailed: RCTBubblingEventBlock?

    @objc(onStorylyEvent)
    var onStorylyEvent: RCTBubblingEventBlock?

    @objc(onStorylyActionClicked)
    var onStorylyActionClicked: RCTBubblingEventBlock?

    @objc(onStorylyStoryPresented)
    var onStorylyStoryPresented: RCTBubblingEventBlock?
    
    @objc(onStorylyStoryPresentFailed)
    var onStorylyStoryPresentFailed: RCTBubblingEventBlock?
    
    @objc(onStorylyStoryDismissed)
    var onStorylyStoryDismissed: RCTBubblingEventBlock?
    
    @objc(onStorylyUserInteracted)
    var onStorylyUserInteracted: RCTBubblingEventBlock?
    
    @objc(onCreateCustomView)
    var onCreateCustomView: RCTBubblingEventBlock?
    
    @objc(onUpdateCustomView)
    var onUpdateCustomView: RCTBubblingEventBlock?

    @objc(onStorylyProductHydration)
    var onProductHydration: RCTBubblingEventBlock?
    
    @objc(onStorylyProductEvent)
    var onStorylyProductEvent: RCTBubblingEventBlock?
    
    @objc(onStorylyCartUpdated)
    var onStorylyCartUpdated: RCTBubblingEventBlock?
    
    @objc(onStorylyWishlistUpdated)
    var onStorylyWishlistUpdated: RCTBubblingEventBlock?
    
    override init(frame: CGRect) {
        print("STR:STStorylyView:init(frame:\(frame))")
        self.storylyView = StorylyVerticalFeedView(frame: frame)
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        print("STR:STStorylyView:init:rootViewController:\(UIApplication.shared.delegate?.window??.rootViewController)")
        _ = UIApplication.shared.delegate?.window??.rootViewController?.observe(\.self,
                                                                                 options: [.initial, .old, .new]){ object, change in
            print("STR:STStorylyView:init:observe:rootViewController:newValue:\(change.newValue):oldValue:\(change.oldValue)")
        }
        
        print("STR:STStorylyView:init:StorylyBundle:\(Bundle(for: StorylyView.self).infoDictionary)")
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func removeReactSubview(_ subview: UIView!) {}
}

extension STVerticalFeedView {
    
    func refresh() {
        print("STR:STStorylyView:refresh()")
        storylyView?.refresh()
    }
    
    func open(payload: URL) {
        print("STR:STStorylyView:open(payload:\(payload))")
        storylyView?.open(payload: payload)
    }
    
    func open(groupId: String, itemId: String?, playMode: String?) {
        print("STR:STStorylyView:open(groupId:\(groupId):itemId:\(itemId))")
        storylyView?.open(groupId: groupId, itemId: itemId, play: getPlayMode(playMode: playMode))
    }

    func hydrateProducts(products: [STRProductItem]) {
        storylyView?.hydrateProducts(products: products)
    }
    
    func hydrateWishlist(products: [STRProductItem]) {
        storylyView?.hydrateWishlist(products: products)
    }

    func updateCart(cart: STRCart) {
        storylyView?.updateCart(cart: cart)
    }
    
    func approveCartChange(responseId: String, cart: STRCart? = nil) {
        guard let onSuccess = cartUpdateSuccessFailCallbackMap[responseId]?.0 else { return }
        if let cart = cart {
            onSuccess(cart)
        } else {
            onSuccess(nil)
        }
        cartUpdateSuccessFailCallbackMap.removeValue(forKey: responseId)
    }
    
    func rejectCartChange(responseId: String, failMessage: String) {
        guard let onFail = cartUpdateSuccessFailCallbackMap[responseId]?.1 else { return }
        onFail(STRCartEventResult(message: failMessage))
        cartUpdateSuccessFailCallbackMap.removeValue(forKey: responseId)
    }
    
    func approveWishlistChange(responseId: String, item: STRProductItem? = nil) {
        guard let onSuccess = wishlistUpdateSuccessFailCallbackMap[responseId]?.0 else { return }
        if let item = item {
            onSuccess(item)
        } else {
            onSuccess(nil)
        }
        wishlistUpdateSuccessFailCallbackMap.removeValue(forKey: responseId)
    }
    
    func rejectWishlistChange(responseId: String, failMessage: String) {
        guard let onFail = wishlistUpdateSuccessFailCallbackMap[responseId]?.1 else { return }
        onFail(STRWishlistEventResult(message: failMessage))
        wishlistUpdateSuccessFailCallbackMap.removeValue(forKey: responseId)
    }
    
    func resumeStory() {
        print("STR:STStorylyView:resumeStory()")
        storylyView?.resumeVerticalFeed(animated: false)
    }

    func pauseStory() {
        print("STR:STStorylyView:pauseStory()")
        storylyView?.pauseVerticalFeed(animated: false)
    }

    func closeStory() {
        print("STR:STStorylyView:closeStory()")
        storylyView?.closeVerticalFeed(animated: false)
    }
    
    private func getPlayMode(playMode: String?) -> PlayMode {
        switch playMode {
            case "story-group": return .StoryGroup
            case "story": return .Story
            default: return .Default
        }
    }
}

extension STVerticalFeedView: StorylyVerticalFeedDelegate {
    func verticalFeedLoaded(_ view: STRVerticalFeedView, feedGroupList: [VerticalFeedGroup], dataSource: StorylyDataSource) {
        let map: [String : Any] = [
            "feedGroupList": feedGroupList.map { createVerticalFeedGroupMap(storyGroup: $0) },
            "dataSource": dataSource.description
        ]
        self.onStorylyLoaded?(map)
    }
    
    func verticalFeedLoadFailed(_ view: STRVerticalFeedView, errorMessage: String) {
        self.onStorylyLoadFailed?(["errorMessage": errorMessage])
    }
    
    func verticalFeedActionClicked(_ view: STRVerticalFeedView,
                                   rootViewController: UIViewController,
                                   feedItem: VerticalFeedItem) {
        self.onStorylyActionClicked?(["feedItem": createVerticalFeedItemMap(story: feedItem)])
    }
    
    func verticalFeedEvent(_ view: STRVerticalFeedView, event: VerticalFeedEvent, feedGroup: VerticalFeedGroup?, feedItem: VerticalFeedItem?, feedItemComponent: VerticalFeedItemComponent?) {
        let map: [String : Any] = [
            "event": VerticalFeedEventHelper.verticalFeedEventName(event: event),
            "feedGroup": createVerticalFeedGroupMap(feedGroup) as Any,
            "feedItem": createVerticalFeedItemMap(feedItem) as Any,
            "feedItemComponent": createVerticalFeedItemComponentMap(feedItemComponent) as Any
        ]
        self.onStorylyEvent?(map)
    }
    
    func verticalFeedPresented(_ view: STRVerticalFeedView) {
        self.onStorylyStoryPresented?([:])
    }
    
    func verticalFeedPresentFailed(_ view: STRVerticalFeedView, errorMessage: String) {
        self.onStorylyStoryPresentFailed?(["errorMessage": errorMessage])
    }
    
    func verticalFeedDismissed(_ view: STRVerticalFeedView) {
        self.onStorylyStoryDismissed?([:])
    }
    
    func verticalFeedUserInteracted(_ view: STRVerticalFeedView, feedGroup: VerticalFeedGroup, feedItem: VerticalFeedItem, feedItemComponent: VerticalFeedItemComponent) {
        let map: [String : Any] = [
            "feedGroup": createVerticalFeedGroupMap(storyGroup: feedGroup),
            "feedItem": createVerticalFeedItemMap(story: feedItem),
            "feedItemComponent": createVerticalFeedItemComponentMap(storyComponent: feedItemComponent)
        ]
        self.onStorylyUserInteracted?(map)
    }
}

extension STVerticalFeedView: StorylyVerticalFeedProductDelegate {
    func verticalFeedEvent(_ view: STRVerticalFeedView, event: VerticalFeedEvent) {
        let map: [String : Any] = [
            "event": VerticalFeedEventHelper.verticalFeedEventName(event: event)
        ]
        self.onStorylyProductEvent?(map)
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
        let map: [String : Any] = [
            "event": VerticalFeedEventHelper.verticalFeedEventName(event: event),
            "cart": createSTRCartMap(cart: cart),
            "change": createSTRCartItemMap(cartItem: change),
            "responseId": responseId
        ]
        self.onStorylyCartUpdated?(map)
    }
    
    func verticalFeedUpdateWishlistEvent(view: STRVerticalFeedView, item: STRProductItem?, event: StorylyEvent, onSuccess: ((STRProductItem?) -> Void)?, onFail: ((STRWishlistEventResult) -> Void)?) {
        let responseId = UUID().uuidString
        wishlistUpdateSuccessFailCallbackMap[responseId] = (onSuccess, onFail)
        let map: [String : Any] = [
            "event": StorylyEventHelper.storylyEventName(event: event),
            "item": createSTRProductItemMap(product: item),
            "responseId": responseId
        ]
        self.onStorylyWishlistUpdated?(map)
    }

    func verticalFeedHydration(_ view: STRVerticalFeedView, products: [STRProductInformation]) {
        let map: [String : Any] = [
            "products": products.map { createSTRProductInformationMap(productInfo: $0) },
        ]
        self.onProductHydration?(map)
    }
}
