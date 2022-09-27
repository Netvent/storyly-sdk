//import StorylyMonetization
import Storyly
import React


@objc(RNStorylyMonetization)
class RNStorylyMonetization: RCTEventEmitter {

    @objc(setAdViewProvider:withTestParam:)
    func setAdViewProvider(reactViewId: NSNumber, testParam: NSString) {
        print("[Storyly] storylyView \(reactViewId) \(testParam)")
        RCTUnsafeExecuteOnMainQueueSync {
            guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
//            RCTUIManager* uiManager = [self.bridge moduleForClass:[RCTUIManager class]];
//            RNCWebView* webView = (RNCWebView*)[uiManager viewForReactTag:reactTag];
            guard let uiManager = self.bridge.module(forName: RCTBridgeModuleNameForClass(RCTUIManager.self)) as? RCTUIManager else { return }
            print("[Storyly] uiManager \(uiManager)")
            let findView = uiManager.view(forReactTag: reactViewId)
            guard let storylyView = findView?.subviews[0] as? StorylyView else { return }
            print("[Storyly] storylyView \(storylyView)")
//            let adViewProvider = StorylyAdViewProvider(rootViewController: rootViewController, adMobAdUnitId: "", adMobAdExtras: [:])
//            storylyView.storylyAdViewProvider = adViewProvider
        }
    }
    
    override func supportedEvents() -> [String] {
        return ["setAdViewProvider"]
    }
}
