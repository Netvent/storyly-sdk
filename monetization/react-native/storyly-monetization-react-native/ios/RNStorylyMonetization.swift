import StorylyMonetization
import Storyly
import React

@objc(RNStorylyMonetization)
class RNStorylyMonetization: RCTEventEmitter {
    
    private static var strongAdViewProviderKey: String = "strongAdViewProviderKey"

    @objc(setAdViewProvider:withAdMobAdUnitId:)
    func setAdViewProvider(reactViewId: NSNumber, adMobAdUnitId: NSString) {
        DispatchQueue.main.async {
            guard let uiManager = self.bridge.module(forName: RCTBridgeModuleNameForClass(RCTUIManager.self)) as? RCTUIManager else { return }
            let findView = uiManager.view(forReactTag: reactViewId)
            guard let storylyView = findView?.subviews[0] as? StorylyView else { return }
            guard let rootViewController = storylyView.rootViewController else { return }
            let adViewProvider = StorylyMonetization.StorylyAdViewProvider(rootViewController: rootViewController,
                                                       adMobAdUnitId: adMobAdUnitId as String,
                                                       adMobAdExtras: nil)
            objc_setAssociatedObject(storylyView, &RNStorylyMonetization.strongAdViewProviderKey,
                                     adViewProvider, .OBJC_ASSOCIATION_RETAIN)
            storylyView.storylyAdViewProvider = adViewProvider
        }
    }
    
    override func supportedEvents() -> [String] {
        return ["setAdViewProvider"]
    }
}
