import StorylyMonetization
import Storyly
import React

@objc(RNStorylyMonetization)
class RNStorylyMonetization: RCTEventEmitter {
    
    private var strongAdViewProviderKey: String = "strongAdViewProviderKey"
    
    private let AD_MOB_AD_UNIT_ID = "adMobAdUnitId"
    private let AD_MOB_AD_EXTRAS = "adMobAdExtras"

    @objc(setAdViewProvider:withAdViewProvider:)
    func setAdViewProvider(reactViewId: NSNumber, adViewProvider: NSDictionary?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let uiManager = self.bridge.module(forName: RCTBridgeModuleNameForClass(RCTUIManager.self)) as? RCTUIManager else { return }
            let findView = uiManager.view(forReactTag: reactViewId)
            guard let storylyView = findView?.subviews[0] as? StorylyView else { return }
            guard let rootViewController = storylyView.rootViewController else { return }
            
            guard let adViewProvider = adViewProvider else {
                self.setAdViewProvider(storylyView: storylyView, adViewProvider: nil)
                return
            }
            
            guard let adMobUnitId = adViewProvider[self.AD_MOB_AD_UNIT_ID] as? String else { return }
            let adMobAdExtras = adViewProvider[self.AD_MOB_AD_EXTRAS] as? [String: Any]

            let storylyAdViewProvider = StorylyMonetization.StorylyAdViewProvider(rootViewController: rootViewController,
                                                       adMobAdUnitId: adMobUnitId,
                                                       adMobAdExtras: adMobAdExtras)
            self.setAdViewProvider(storylyView: storylyView, adViewProvider: storylyAdViewProvider)
            
        }
    }
    
    private func setAdViewProvider(storylyView: StorylyView, adViewProvider: StorylyMonetization.StorylyAdViewProvider?) {
        objc_setAssociatedObject(storylyView, &self.strongAdViewProviderKey,
                                 adViewProvider, .OBJC_ASSOCIATION_RETAIN)
        storylyView.storylyAdViewProvider = adViewProvider
    }
    
    override func supportedEvents() -> [String] {
        return ["setAdViewProvider"]
    }
}
