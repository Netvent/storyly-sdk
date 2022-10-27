//
//  STStorylyManager.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//


@objc (STStorylyCustomViewManager)
class STStorylyCustomViewManager: RCTViewManager {
    
    override func view() -> UIView! { return STStorylyCustomView() }
    
    override class func requiresMainQueueSetup() -> Bool { return true }
}

class STStorylyCustomView: UIView {}
