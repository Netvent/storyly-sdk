import Flutter
import UIKit

public class SwiftStorylyFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let storylyViewFactory = FlutterStorylyViewFactory(messenger: registrar.messenger())
        registrar.register(storylyViewFactory, withId: "FlutterStorylyView")
        registrar.publish(storylyViewFactory)
        
        let verticalFeedViewFactory = FlutterVerticalFeedViewFactory(messenger: registrar.messenger())
        registrar.register(verticalFeedViewFactory, withId: "FlutterVerticalFeed")
        registrar.publish(verticalFeedViewFactory)
        
        let verticalFeedBarViewFactory = FlutterVerticalFeedBarViewFactory(messenger: registrar.messenger())
        registrar.register(verticalFeedBarViewFactory, withId: "FlutterVerticalFeedBar")
        registrar.publish(verticalFeedBarViewFactory)
        
        let verticalFeedPresenterViewFactory = FlutterVerticalFeedPresenterViewFactory(messenger: registrar.messenger())
        registrar.register(verticalFeedPresenterViewFactory, withId: "FlutterVerticalFeedPresenter")
        registrar.publish(verticalFeedPresenterViewFactory)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}
