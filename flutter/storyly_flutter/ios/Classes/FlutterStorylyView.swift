import Storyly
import UIKit

public class FlutterStorylyViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return FlutterStorylyView(frame, viewId: viewId, args: args as? [String : Any] ?? [:], messenger: self.messenger)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

public class FlutterStorylyView: NSObject, FlutterPlatformView {
    private let frame: CGRect
    private let viewId: Int64
    private let args: [String: Any]
    private let methodChannel: FlutterMethodChannel

    private lazy var storylyViewWrapper = FlutterStorylyViewWrapper(frame: self.frame, args: self.args, methodChannel: self.methodChannel)

    init(_ frame: CGRect, viewId: Int64, args: [String: Any], messenger: FlutterBinaryMessenger) {
        self.frame = frame
        self.viewId = viewId
        self.args = args
        self.methodChannel = FlutterMethodChannel(name: "com.appsamurai.storyly/flutter_storyly_view_\(viewId)", binaryMessenger: messenger)
    }

    public func view() -> UIView {
        return self.storylyViewWrapper
    }
}
