import Flutter
import UIKit

public class SwiftStorylyFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FlutterStorylyViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "FlutterStorylyView")
        registrar.publish(factory)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}
