//
//  STStorylyManager.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//


@objc(STVerticalFeedPresenterManager)
class STVerticalFeedPresenterManager: RCTViewManager {
    
    override func view() -> UIView! {
        print("STR:STStorylyManager:view()")
        return STVerticalFeedPresenterView()
    }
    
    override class func requiresMainQueueSetup() -> Bool {
        print("STR:STStorylyManager:requiresMainQueueSetup()")
        return true
    }
    
    @objc(refresh:)
    func refresh(reactTag: NSNumber) {
        print("STR:STStorylyManager:refresh()")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedPresenterView {
                stStorylyView.refresh()
            }
        }
    }

    @objc(resumeStory:)
    func resumeStory(reactTag: NSNumber) {
        print("STR:STStorylyManager:resumeStory()")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedPresenterView {
                stStorylyView.resumeStory()
            }
        }
    }

    @objc(pauseStory:)
    func pauseStory(reactTag: NSNumber) {
        print("STR:STStorylyManager:pauseStory()")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedPresenterView {
                stStorylyView.pauseStory()
            }
        }
    }

    @objc(hydrateProducts:products:)
    func hydrateProducts(reactTag: NSNumber, products: [NSDictionary]) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedPresenterView {
                let products = products.map { createSTRProductItem(productItem: $0)}
                stStorylyView.hydrateProducts(products: products)
            }
        }
    }
    
    @objc(hydrateWishlist:products:)
    func hydrateWishlist(reactTag: NSNumber, products: [NSDictionary]) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedPresenterView {
                let products = products.map { createSTRProductItem(productItem: $0)}
                stStorylyView.hydrateWishlist(products: products)
            }
        }
    }
    
    @objc(updateCart:cartMap:)
    func updateCart(reactTag: NSNumber, cartMap: NSDictionary) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedPresenterView {
                stStorylyView.updateCart(cart: createSTRCart(cartMap: cartMap))
            }
        }
    }
    
    @objc(approveCartChange:responseId:cart:)
    func approveCartChange(reactTag: NSNumber, responseId: String, cart: NSDictionary?) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedPresenterView {
                if let _cart = cart {
                    stStorylyView.approveCartChange(responseId: responseId, cart: createSTRCart(cartMap: _cart))
                } else {
                    stStorylyView.approveCartChange(responseId: responseId)
                }
            }
        }
    }
    
    @objc(rejectCartChange:responseId:failMessage:)
    func rejectCartChange(reactTag: NSNumber, responseId: String, failMessage: String) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedPresenterView {
                stStorylyView.rejectCartChange(responseId: responseId, failMessage: failMessage)
            }
        }
    }
    
    @objc(approveWishlistChange:responseId:item:)
    func approveWishlistChange(reactTag: NSNumber, responseId: String, item: NSDictionary?) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedPresenterView {
                if let _item = item {
                    stStorylyView.approveWishlistChange(responseId: responseId, item: createSTRProductItem(productItem: _item))
                } else {
                    stStorylyView.approveWishlistChange(responseId: responseId)
                }
            }
        }
    }
    
    @objc(rejectWishlistChange:responseId:failMessage:)
    func rejectWishlistChange(reactTag: NSNumber, responseId: String, failMessage: String) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedPresenterView {
                stStorylyView.rejectWishlistChange(responseId: responseId, failMessage: failMessage)
            }
        }
    }
}
