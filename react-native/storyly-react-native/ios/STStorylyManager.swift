//
//  STStorylyManager.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//


@objc (STStorylyManager)
class STStorylyManager: RCTViewManager {
    
    override func view() -> UIView! {
        print("STR:STStorylyManager:view()")
        return STStorylyView()
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
            if let stStorylyView = view as? STStorylyView {
                stStorylyView.refresh()
            } else {
                STLogErr("Invalid view returned from registry, expecting STStorylyView, got: \(String(describing: view))")
            }
            
        }
    }
    
    @objc(open:)
    func open(reactTag: NSNumber) {
        print("STR:STStorylyManager:open()")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STStorylyView {
                stStorylyView.open()
            } else {
                STLogErr("Invalid view returned from registry, expecting STStorylyView, got: \(String(describing: view))")
            }
            
        }
    }
    
    @objc(close:)
    func close(reactTag: NSNumber) {
        print("STR:STStorylyManager:close()")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STStorylyView {
                stStorylyView.close()
            } else {
                STLogErr("Invalid view returned from registry, expecting STStorylyView, got: \(String(describing: view))")
            }
            
        }
    }
    
    @objc(openStory:payload:)
    func openStory(reactTag: NSNumber, payload: NSURL) {
        print("STR:STStorylyManager:openStory(payload:\(payload.absoluteString ?? ""))")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STStorylyView {
                _ = stStorylyView.openStory(payload: payload as URL)
            } else {
                STLogErr("Invalid view returned from registry, expecting STStorylyView, got: \(String(describing: view))")
            }
        }
    }
    
    @objc(openStoryWithId:storyGroupId:storyId:)
    func openStory(reactTag: NSNumber, storyGroupId: String, storyId: String) {
        print("STR:STStorylyManager:openStory(storyGroupId:\(storyGroupId):storyId:\(storyId))")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STStorylyView {
                _ = stStorylyView.openStory(storyGroupId: storyGroupId , storyId: storyId)
            } else {
                STLogErr("Invalid view returned from registry, expecting STStorylyView, got: \(String(describing: view))")
            }
        }
    }

    @objc(hydrateProducts:products:)
    func hydrateProducts(reactTag: NSNumber, products: [NSDictionary]) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STStorylyView {
                let products = products.map { createSTRProductItem(productItem: $0)}
                stStorylyView.hydrateProducts(products: products)
            } else {
                STLogErr("Invalid view returned from registry, expecting STStorylyView, got: \(String(describing: view))")
            }
        }
    }
    
    @objc(updateCart:cartMap:)
    func updateCart(reactTag: NSNumber, cartMap: NSDictionary) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STStorylyView {
                stStorylyView.updateCart(cart: createSTRCart(cartMap: cartMap))
            } else {
                STLogErr("Invalid view returned from registry, expecting STStorylyView, got: \(String(describing: view))")
            }
        }
    }
    
    @objc(approveCart:successId:cartMap:)
    func approveCart(reactTag: NSNumber, successId: String, cartMap: NSDictionary?) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STStorylyView {
                if let _cartMap = cartMap {
                    stStorylyView.approveCart(successId: successId, cart: createSTRCart(cartMap: _cartMap))
                } else {
                    stStorylyView.approveCart(successId: successId)
                }
            } else {
                STLogErr("Invalid view returned from registry, expecting STStorylyView, got: \(String(describing: view))")
            }
        }
    }
    
    @objc(rejectCart:failId:failMessage:)
    func rejectCart(reactTag: NSNumber, failId: String, failMessage: String) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STStorylyView {
                stStorylyView.rejectCart(failId: failId, failMessage: failMessage)
            } else {
                STLogErr("Invalid view returned from registry, expecting STStorylyView, got: \(String(describing: view))")
            }
        }
    }
}
