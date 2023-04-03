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
    
    @objc(setExternalData:externalData:)
    func setExternalData(reactTag: NSNumber, externalData: [NSDictionary]) {
        print("STR:STStorylyManager:setExternalData(externalData:\(externalData))")
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            let view = viewRegistry?[reactTag]
            if let stStorylyView = view as? STStorylyView {
                _ = stStorylyView.setExternalData(externalData: externalData)
            } else {
                STLogErr("Invalid view returned from registry, expecting STStorylyView, got: \(String(describing: view))")
            }
        }
    }
}
