//
//  StorylyMonetizationFlutter.swift
//  storyly_monetization_flutter
//
//  Created by Haldun Melih Fadillioglu on 12.10.2022.
//

import Storyly
import StorylyMonetization
import storyly_flutter

class StorylyMonetizationFlutter {
    
    private var methodChannel: FlutterMethodChannel
    
    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        self.methodChannel.setMethodCallHandler { [weak self] call, _ in
            guard let self = self else { return }
            let callArguments = call.arguments as? [String: Any]
            switch call.method {
                case "setAdViewProvider":
                    guard let callArguments = callArguments,
                          let viewId = callArguments["viewId"] as? Int else { return }
                    self.setAdViewProvider(viewId: viewId, adViewProvider: callArguments["adViewProvider"] as? [String: Any])
                default: do {}
            }
        }
    }
    
    private static var strongAdViewProviderKey = "strongAdViewProviderKey"
    
    private func setAdViewProvider(viewId: Int, adViewProvider: [String: Any]?) {
        guard let storylyView = FlutterStorylyViewFactory.instance?.getViewById(id: viewId) else { return }
        guard let rootViewController = storylyView.rootViewController else { return }
        
        guard let adViewProvider = adViewProvider else {
            self.setAdViewProvider(storylyView: storylyView, adViewProvider: nil)
            return
        }
                        
        guard let adMobUnitId = adViewProvider["adMobAdUnitId"] as? String else { return }
        let adMobAdExtras = adViewProvider["adMobAdExtras"] as? [String: Any]

        let storylyAdViewProvider = StorylyMonetization.StorylyAdViewProvider(rootViewController: rootViewController,adMobAdUnitId: adMobUnitId, adMobAdExtras: adMobAdExtras)
        self.setAdViewProvider(storylyView: storylyView, adViewProvider: storylyAdViewProvider)

    }

    private func setAdViewProvider(storylyView: StorylyView, adViewProvider: StorylyMonetization.StorylyAdViewProvider?) {
        objc_setAssociatedObject(storylyView,
                                 &StorylyMonetizationFlutter.strongAdViewProviderKey,
                                 adViewProvider, .OBJC_ASSOCIATION_RETAIN)
        storylyView.storylyAdViewProvider = adViewProvider
    }
}
