//
//  STStorylyGroupViewManager.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//


@objc (STStorylyGroupViewManager)
class STStorylyGroupViewManager: RCTViewManager {
    
    override func view() -> UIView! { return STStorylyGroupView() }
    
    override class func requiresMainQueueSetup() -> Bool { return true }
}

class STStorylyGroupView: UIView {}
