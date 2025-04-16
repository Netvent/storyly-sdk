//
//  STStorylyView.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 26.10.2022.
//

import UIKit
import Storyly


@objc(STStorylyView)
public class STStorylyView: UIView {
    
    internal var cartUpdateSuccessFailCallbackMap: [String: (((STRCart?) -> Void)?, ((STRCartEventResult) -> Void)?)] = [:]
    
    private lazy var stStorylyDelegate = STStorylyDelegate(view: self)
    private lazy var stStorylyProductDelegate = STStorylyProductDelegate(view: self)
    
    
    @objc(storyBundleRaw)
    public var storyBundleRaw: String? = nil {
        didSet {
            guard let storyBundleRaw = storyBundleRaw,
                  let storylyBundle = StorylyBundle.build(rawJson: storyBundleRaw) else {
                storylyView = nil
                storyGroupViewFactory = nil
                return
            }
            storylyView = storylyBundle.storylyView
            storyGroupViewFactory = storylyBundle.storyGroupViewFactory
        }
    }
    
    private var storylyView: StorylyView? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            guard let storylyView = storylyView else { return }
            storylyView.rootViewController = UIApplication.shared.delegate?.window??.rootViewController
            storylyView.delegate = stStorylyDelegate
            storylyView.productDelegate = stStorylyProductDelegate
            addSubview(storylyView)
            storylyView.translatesAutoresizingMaskIntoConstraints = false
            storylyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            storylyView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            storylyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
    }
    
    private var storyGroupViewFactory: STStoryGroupViewFactory? = nil {
        didSet {
            guard let storyGroupViewFactory = storyGroupViewFactory else { return }
            storyGroupViewFactory.onCreateCustomView = { [weak self] in
                self?.onCreateCustomView?()
            }
            storyGroupViewFactory.onUpdateCustomView = { [weak self] data in
                guard let event = encodeEvent(json: data) else { return }
                self?.onUpdateCustomView?(event)
            }
        }
     }
    
    @objc(onStorylyLoaded)
    public var onStorylyLoaded: ((String) -> Void)?
    
    @objc(onStorylyLoadFailed)
    public var onStorylyLoadFailed: ((String) -> Void)?

    @objc(onStorylyEvent)
    public var onStorylyEvent: ((String) -> Void)?
    
    @objc(onStorylyProductEvent)
    public var onStorylyProductEvent: ((String) -> Void)?
    
    @objc(onStorylyActionClicked)
    public var onStorylyActionClicked: ((String) -> Void)?
    
    @objc(onStorylyStoryPresented)
    public var onStorylyStoryPresented: (() -> Void)?
    
    @objc(onStorylyStoryPresentFailed)
    public var onStorylyStoryPresentFailed: ((String) -> Void)?
    
    @objc(onStorylyStoryDismissed)
    public var onStorylyStoryDismissed: (() -> Void)?
    
    @objc(onStorylyUserInteracted)
    public var onStorylyUserInteracted: ((String) -> Void)?
    
    @objc(onStorylyProductHydration)
    public var onStorylyProductHydration: ((String) -> Void)?
    
    @objc(onStorylyCartUpdated)
    public var onStorylyCartUpdated: ((String) -> Void)?
    
    @objc(onStorylySizeChanged)
    public var onStorylySizeChanged: ((String) -> Void)?
    
    @objc(onCreateCustomView)
    public var onCreateCustomView: (() -> Void)?
    
    @objc(onUpdateCustomView)
    public var onUpdateCustomView: ((String) -> Void)?
    
    
    public override init(frame: CGRect) {
        print("STR:STStorylyView:init(frame:\(frame))")
        super.init(frame: frame)
        backgroundColor = .clear
        
        storylyView = StorylyView(frame: frame)
        print("STR:STStorylyView:init:rootViewController:\(UIApplication.shared.delegate?.window??.rootViewController)")
        _ = UIApplication.shared.delegate?.window??.rootViewController?.observe(\.self,
                                                                                 options: [.initial, .old, .new]){ object, change in
            print("STR:STStorylyView:init:observe:rootViewController:newValue:\(change.newValue):oldValue:\(change.oldValue)")
        }
        print("STR:STStorylyView:init:StorylyBundle:\(Bundle(for: StorylyView.self).infoDictionary)")
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
        storyGroupViewFactory?.attachCustomReactNativeView(subview: subview, index: atIndex)
    }
}

extension STStorylyView {
    @objc(refresh)
    public func refresh() {
        print("STR:STStorylyView:refresh()")
        storylyView?.refresh()
    }
    
    @objc(resumeStory)
    public func resumeStory() {
        print("STR:STStorylyView:resumeStory()")
        storylyView?.resumeStory(animated: false)
    }
    
    @objc(pauseStory)
    public func pauseStory() {
        print("STR:STStorylyView:pauseStory()")
        storylyView?.pauseStory(animated: false)
    }
    
    @objc(closeStory)
    public func closeStory() {
        print("STR:STStorylyView:closeStory()")
        storylyView?.closeStory(animated: false)
    }
    
    @objc(openStory:)
    public func openStory(raw: String) {
        guard let map = decodePayload(raw: raw),
              let urlStr = map["url"] as? String,
              let payload = URL(string: urlStr) else { return }
        print("STR:STStorylyView:openStory(payload:\(payload))")
        _ = storylyView?.openStory(payload: payload)
    }
    
    @objc(openStoryId:)
    public func openStoryId(raw: String) {
        guard let map = decodePayload(raw: raw),
        let storyGroupId = map["groupId"] as? String else { return }
        let storyId = map["storyId"] as? String
        let playMode = map["playMode"] as? String
        print("STR:STStorylyView:openStory(storyGroupId:\(storyGroupId):storyId:\(storyId))")
        _ = storylyView?.openStory(storyGroupId: storyGroupId, storyId: storyId, play: getPlayMode(playMode: playMode))
    }
    
    @objc(hydrateProducts:)
    public func hydrateProducts(raw: String) {
        guard let map = decodePayload(raw: raw),
              let productMap = map["products"] as? [NSDictionary?] else { return }
        let products = productMap.map({ createSTRProductItem(productItem: $0) })
        print("STR:STStorylyView:hydrateProducts(productIds:\(products.map { $0.productId })")
        storylyView?.hydrateProducts(products: products)
    }
    
    @objc(updateCart:)
    public func updateCart(raw: String) {
        guard let map = decodePayload(raw: raw),
              let cartMap = map["cart"] as? NSDictionary,
              let cart = createSTRCart(cartMap: cartMap) else { return }
        print("STR:STStorylyView:updateCart(cartProductIds:\(cart.items.map { $0.item.productId})")
        storylyView?.updateCart(cart: cart)
    }
    
    @objc(approveCartChange:)
    public func approveCartChange(raw: String) {
        guard let map = decodePayload(raw: raw),
              let responseId = map["responseId"] as? String else { return }
        
        guard let onSuccess = cartUpdateSuccessFailCallbackMap[responseId]?.0 else { return }
        if let cart = createSTRCart(cartMap: map["cart"] as? NSDictionary) {
            onSuccess(cart)
        } else {
            onSuccess(nil)
        }
        cartUpdateSuccessFailCallbackMap.removeValue(forKey: responseId)
    }
    
    @objc(rejectCartChange:)
    public func rejectCartChange(raw: String) {
        guard let map = decodePayload(raw: raw),
              let responseId = map["responseId"] as? String,
              let failMessage = map["failMessage"] as? String else { return }
        
        guard let onFail = cartUpdateSuccessFailCallbackMap[responseId]?.1 else { return }
        onFail(STRCartEventResult(message: failMessage))
        cartUpdateSuccessFailCallbackMap.removeValue(forKey: responseId)
    }

    private func getPlayMode(playMode: String?) -> PlayMode {
        switch playMode {
            case "story-group": return .StoryGroup
            case "story": return .Story
            default: return .Default
        }
    }
}

class STStorylyDelegate: StorylyDelegate {
    
    private weak var view: STStorylyView?
    
    init(view: STStorylyView) {
        self.view = view
    }
    
    func storylyLoaded(_ storylyView: StorylyView, storyGroupList: [StoryGroup], dataSource: StorylyDataSource) {
        let map: [String : Any] = [
            "storyGroupList": storyGroupList.map { createStoryGroupMap(storyGroup: $0) },
            "dataSource": dataSource.description
        ]
        guard let eventJson = encodeEvent(json: map) else { return }
        view?.onStorylyLoaded?(eventJson)
    }
    
    func storylyLoadFailed(_ storylyView: StorylyView, errorMessage: String) {
        guard let rawMap = try? JSONSerialization.data(withJSONObject: ["errorMessage": errorMessage], options: []),
              let rawMapString = String(data: rawMap, encoding: .utf8) else { return }
        view?.onStorylyLoadFailed?(rawMapString)
    }
    
    func storylyActionClicked(_ storylyView: StorylyView, rootViewController: UIViewController, story: Story) {
        guard let eventJson = encodeEvent(json: ["story": createStoryMap(story: story)]) else { return }
        view?.onStorylyActionClicked?(eventJson)
    }
    
    func storylyEvent(_ storylyView: StorylyView, event: StorylyEvent, storyGroup: StoryGroup?, story: Story?, storyComponent: StoryComponent?) {
        let map: [String : Any?] = [
            "event": StorylyEventHelper.storylyEventName(event: event),
            "storyGroup": createStoryGroupMap(storyGroup: storyGroup),
            "story": createStoryMap(story: story),
            "storyComponent": createStoryComponentMap(storyComponent: storyComponent)
        ]
        guard let eventJson = encodeEvent(json: map) else { return }
        view?.onStorylyEvent?(eventJson)
    }
    
    func storylyStoryPresented(_ storylyView: StorylyView) {
        view?.onStorylyStoryPresented?()
    }
    
    func storylyStoryPresentFailed(_ storylyView: StorylyView, errorMessage: String) {
        guard let eventJson = encodeEvent(json: ["errorMessage": errorMessage]) else { return }
        view?.onStorylyStoryPresentFailed?(eventJson)
    }
    
    func storylyStoryDismissed(_ storylyView: StorylyView) {
        view?.onStorylyStoryDismissed?()
    }
    
    func storylyUserInteracted(_ storylyView: StorylyView, storyGroup: StoryGroup, story: Story, storyComponent: StoryComponent) {
        let map: [String : Any?] = [
            "storyGroup": createStoryGroupMap(storyGroup: storyGroup),
            "story": createStoryMap(story: story),
            "storyComponent": createStoryComponentMap(storyComponent: storyComponent)
        ]
        guard let eventJson = encodeEvent(json: map) else { return }
        view?.onStorylyUserInteracted?(eventJson)
    }
    
    
    func storylySizeChanged(_ storylyView: StorylyView, size: CGSize) {
        let map: [String : Any?] = [
            "width": size.width,
            "height": size.height,
        ]
        guard let eventJson = encodeEvent(json: map) else { return }
        view?.onStorylySizeChanged?(eventJson)
    }
}


class STStorylyProductDelegate: StorylyProductDelegate {
    
    private weak var view: STStorylyView?
    
    init(view: STStorylyView) {
        self.view = view
    }
    
    
    func storylyEvent(
        _ storylyView: StorylyView,
        event: StorylyEvent
    ) {
        let map: [String : Any] = [
            "event": StorylyEventHelper.storylyEventName(event: event)
        ]
        guard let eventJson = encodeEvent(json: map) else { return }
        view?.onStorylyProductEvent?(eventJson)
    }
    
    
    func storylyUpdateCartEvent(
        storylyView: StorylyView,
        event: StorylyEvent,
        cart: STRCart?,
        change: STRCartItem?,
        onSuccess: ((STRCart?) -> Void)?,
        onFail: ((STRCartEventResult) -> Void)?
    ) {
        let responseId = UUID().uuidString
        view?.cartUpdateSuccessFailCallbackMap[responseId] = (onSuccess, onFail)
        let map: [String : Any] = [
            "event": StorylyEventHelper.storylyEventName(event: event),
            "cart": createSTRCartMap(cart: cart) as Any,
            "change": createSTRCartItemMap(cartItem: change),
            "responseId": responseId
        ]
        guard let eventJson = encodeEvent(json: map) else { return }
        view?.onStorylyCartUpdated?(eventJson)
    }
    
    
    func storylyHydration(_ storylyView: Storyly.StorylyView, products: [STRProductInformation]) {
        let map: [String : Any] = [
            "products": products.map { createSTRProductInformationMap(productInfo: $0) },
        ]
        guard let eventJson = encodeEvent(json: map) else { return }
        view?.onStorylyProductHydration?(eventJson)
    }
    
    func storylyUpdateWishlistEvent(storylyView: StorylyView, item: STRProductItem?, event: StorylyEvent, onSuccess: ((STRProductItem?) -> Void)?, onFail: ((STRWishlistEventResult) -> Void)?) {
        print("storylyUpdateWishlistEvent not implemented")
        onFail?(STRWishlistEventResult(message: "storylyUpdateWishlistEvent not implemented"))
    }
}
