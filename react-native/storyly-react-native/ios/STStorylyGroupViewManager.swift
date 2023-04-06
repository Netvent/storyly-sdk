//
//  STStorylyGroupViewManager.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//


@objc (STStorylyGroupViewManager)
class STStorylyGroupViewManager: RCTViewManager {
    
    override func view() -> UIView! {
        print("STR:STStorylyGroupViewManager:view()")
        return STStorylyGroupView()
    }
    
    override class func requiresMainQueueSetup() -> Bool {
        print("STR:STStorylyGroupViewManager:requiresMainQueueSetup:view()")
        return true
    }
}

class STStorylyGroupView: UIView {}
