//
//  STStorylyManager.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//


@objc (STStorylyManager)
class STStorylyManager: RCTViewManager {
    
    override func view() -> UIView! {
       return STStorylyView()
    }
    
    @objc(refresh:)
    func refresh(reactTag: NSNumber) {
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
