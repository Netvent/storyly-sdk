//
//  STStorylyManager.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//


@objc (STVerticalFeedManager)
class STVerticalFeedManager: RCTViewManager {
    
    override func view() -> UIView! {
        print("STR:STStorylyManager:view()")
        return STVerticalFeedBarView()
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
            if let stStorylyView = view as? STVerticalFeedBarView {
                stStorylyView.refresh()
            } else {
                STLogErr("Invalid view returned from registry, expecting STVerticalFeedBarView, got: \(String(describing: view))")
            }
            
        }
    }

    @objc(resumeStory:)
    func resumeStory(reactTag: NSNumber) {
        print("STR:STStorylyManager:resumeStory()")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedBarView {
                stStorylyView.resumeStory()
            } else {
                STLogErr("Invalid view returned from registry, expecting STVerticalFeedBarView, got: \(String(describing: view))")
            }
            
        }
    }

    @objc(pauseStory:)
    func pauseStory(reactTag: NSNumber) {
        print("STR:STStorylyManager:pauseStory()")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedBarView {
                stStorylyView.pauseStory()
            } else {
                STLogErr("Invalid view returned from registry, expecting STVerticalFeedBarView, got: \(String(describing: view))")
            }
            
        }
    }

    @objc(closeStory:)
    func closeStory(reactTag: NSNumber) {
        print("STR:STStorylyManager:closeStory()")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedBarView {
                stStorylyView.closeStory()
            } else {
                STLogErr("Invalid view returned from registry, expecting STVerticalFeedBarView, got: \(String(describing: view))")
            }
            
        }
    }
    
    @objc(openStory:payload:)
    func openStory(reactTag: NSNumber, payload: NSURL) {
        print("STR:STStorylyManager:openStory(payload:\(payload.absoluteString ?? ""))")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedBarView {
                _ = stStorylyView.openStory(payload: payload as URL)
            } else {
                STLogErr("Invalid view returned from registry, expecting STVerticalFeedBarView, got: \(String(describing: view))")
            }
        }
    }
    
    @objc(openStoryWithId:storyGroupId:storyId:playMode:)
    func openStory(reactTag: NSNumber, storyGroupId: String, storyId: String?, playMode: String?) {
        print("STR:STStorylyManager:openStory(storyGroupId:\(storyGroupId):storyId:\(storyId))")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedBarView {
                _ = stStorylyView.openStory(storyGroupId: storyGroupId , storyId: storyId, playMode: playMode)
            } else {
                STLogErr("Invalid view returned from registry, expecting STVerticalFeedBarView, got: \(String(describing: view))")
            }
        }
    }

    @objc(hydrateProducts:products:)
    func hydrateProducts(reactTag: NSNumber, products: [NSDictionary]) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedBarView {
                let products = products.map { createSTRProductItem(productItem: $0)}
                stStorylyView.hydrateProducts(products: products)
            } else {
                STLogErr("Invalid view returned from registry, expecting STVerticalFeedBarView, got: \(String(describing: view))")
            }
        }
    }
    
    @objc(updateCart:cartMap:)
    func updateCart(reactTag: NSNumber, cartMap: NSDictionary) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedBarView {
                stStorylyView.updateCart(cart: createSTRCart(cartMap: cartMap))
            } else {
                STLogErr("Invalid view returned from registry, expecting STVerticalFeedBarView, got: \(String(describing: view))")
            }
        }
    }
    
    @objc(approveCartChange:responseId:cart:)
    func approveCartChange(reactTag: NSNumber, responseId: String, cart: NSDictionary?) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedBarView {
                if let _cart = cart {
                    stStorylyView.approveCartChange(responseId: responseId, cart: createSTRCart(cartMap: _cart))
                } else {
                    stStorylyView.approveCartChange(responseId: responseId)
                }
            } else {
                STLogErr("Invalid view returned from registry, expecting STVerticalFeedBarView, got: \(String(describing: view))")
            }
        }
    }
    
    @objc(rejectCartChange:responseId:failMessage:)
    func rejectCartChange(reactTag: NSNumber, responseId: String, failMessage: String) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STVerticalFeedBarView {
                stStorylyView.rejectCartChange(responseId: responseId, failMessage: failMessage)
            } else {
                STLogErr("Invalid view returned from registry, expecting STVerticalFeedBarView, got: \(String(describing: view))")
            }
        }
    }
}
