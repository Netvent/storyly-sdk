import Storyly
import UIKit

public class FlutterStorylyViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    private var viewList: [Int64: Weak<FlutterStorylyView>] = [:]
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let flutterStorylyView =  FlutterStorylyView(frame, viewId: viewId, args: args as? [String : Any] ?? [:], messenger: self.messenger)
        self.viewList[viewId] = Weak<FlutterStorylyView>(value: flutterStorylyView)
        flutterStorylyView.onDispose = { [weak self] viewId in
            self?.viewList.removeValue(forKey: viewId)
        }
        return flutterStorylyView
    }
    
    public func getViewById(id: Int) -> StorylyView? {
        guard let view = viewList[Int64(id)] else { return nil }
        return view.value?.getStorylyView()
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
    
    internal var onDispose: ((_ viewId: Int64) -> ())? = nil

    private lazy var storylyViewWrapper = FlutterStorylyViewWrapper(frame: self.frame, args: self.args, viewId: self.viewId, methodChannel: self.methodChannel)

    init(_ frame: CGRect, viewId: Int64, args: [String: Any], messenger: FlutterBinaryMessenger) {
        self.frame = frame
        self.viewId = viewId        
        self.args = args
        self.methodChannel = FlutterMethodChannel(name: "com.appsamurai.storyly/flutter_storyly_view_\(viewId)", binaryMessenger: messenger)
    }
    
    public func getStorylyView() -> StorylyView {
        return storylyViewWrapper.storylyView
    }

    public func view() -> UIView {
        return self.storylyViewWrapper
    }
    
    deinit {
        onDispose?(viewId)
    }
}

internal class Weak<T: AnyObject> {
  internal weak var value : T?

  init (value: T) {
    self.value = value
  }
}
