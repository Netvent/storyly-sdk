import Storyly
import UIKit

internal class FlutterStorylyViewWrapper: UIView, StorylyDelegate {
    private let ARGS_STORYLY_ID = "storylyId"
    private let ARGS_STORY_GROUP_ICON_BORDER_COLOR_SEEN = "storyGroupIconBorderColorSeen"
    private let ARGS_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN = "storyGroupIconBorderColorNotSeen"
    private let ARGS_STORY_GROUP_ICON_BACKGROUND_COLOR = "storyGroupIconBackgroundColor"
    private let ARGS_STORY_GROUP_TEXT_COLOR = "storyGroupTextColor"
    private let ARGS_STORY_GROUP_PIN_ICON_COLOR = "storyGroupPinIconColor"
    private let ARGS_STORY_ITEM_ICON_BORDER_COLOR = "storyItemIconBorderColor"
    private let ARGS_STORY_ITEM_TEXT_COLOR = "storyItemTextColor"
    private let ARGS_STORY_ITEM_PROGRESS_BAR_COLOR = "storyItemProgressBarColor"
    
    private lazy var storylyView: StorylyView = StorylyView(frame: self.frame)
    
    private let args: [String: Any]
    private let methodChannel: FlutterMethodChannel
    
    init(frame: CGRect,
         args: [String: Any],
         methodChannel: FlutterMethodChannel) {
        self.args = args
        self.methodChannel = methodChannel
        super.init(frame: frame)
        
        self.methodChannel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
                case "refresh": self?.storylyView.refresh()
                case "show": self?.storylyView.present(animated: false)
                case "dismiss": self?.storylyView.dismiss(animated: false)
                default: do { }
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let storylyView = StorylyView(frame: self.frame)
        storylyView.storylyId = self.args[self.ARGS_STORYLY_ID] as? String ?? ""
        storylyView.delegate = self
        storylyView.rootViewController = UIApplication.shared.keyWindow?.rootViewController
        self.updateThemeFor(storylyView: storylyView, args: args)
        self.addSubview(storylyView)
        storylyView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        storylyView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func updateThemeFor(storylyView: StorylyView, args: [String: Any]) {
        if let storyGroupIconBorderColorSeen = self.args[ARGS_STORY_GROUP_ICON_BORDER_COLOR_SEEN] as? [String] {
            storylyView.storyGroupIconBorderColorSeen = storyGroupIconBorderColorSeen.map{ UIColor(hexString: $0) }
        }
        
        if let storyGroupIconBorderColorNotSeen = self.args[ARGS_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN] as? [String] {
            storylyView.storyGroupIconBorderColorNotSeen = storyGroupIconBorderColorNotSeen.map{ UIColor(hexString: $0) }
        }
        
        if let storyGroupTextColor = self.args[ARGS_STORY_GROUP_TEXT_COLOR] as? String {
            storylyView.storyGroupTextColor = UIColor.init(hexString: storyGroupTextColor)
        }
        
        if let storyGroupIconBackgroundColor = self.args[ARGS_STORY_GROUP_ICON_BACKGROUND_COLOR] as? String {
            storylyView.storyGroupIconBackgroundColor = UIColor.init(hexString: storyGroupIconBackgroundColor)
        }
        
        if let storyGroupPinIconColor = self.args[ARGS_STORY_GROUP_PIN_ICON_COLOR] as? String {
            storylyView.storyGroupPinIconColor = UIColor.init(hexString: storyGroupPinIconColor)
        }
        
        if let storyItemIconBorderColor = self.args[ARGS_STORY_ITEM_ICON_BORDER_COLOR] as? [String] {
            storylyView.storyItemIconBorderColor = storyItemIconBorderColor.map{ UIColor(hexString: $0) }
        }
        
        if let storyItemTextColor = self.args[ARGS_STORY_ITEM_TEXT_COLOR] as? String {
            storylyView.storyItemTextColor = UIColor.init(hexString: storyItemTextColor)
        }
        
        if let storyItemProgressBarColor = self.args[ARGS_STORY_ITEM_PROGRESS_BAR_COLOR] as? [String] {
            storylyView.storylyItemProgressBarColor = storyItemProgressBarColor.map{ UIColor(hexString: $0) }
        }
    }
}

extension FlutterStorylyViewWrapper {
    func storylyLoaded(_ storylyView: Storyly.StorylyView, storyGroupList: [Storyly.StoryGroup]) {
        self.methodChannel.invokeMethod("storylyLoaded", arguments: storyGroupList.map { storyGroup in
            ["index": storyGroup.index,
             "title": storyGroup.title,
             "stories": storyGroup.stories.map { story in
                ["index": story.index,
                 "title": story.title,
                 "media": ["type": story.media.type.rawValue,
                           "url": story.media.url.absoluteString,
                           "actionUrl": story.media.actionUrl]]
            }]
        })
    }
    
    func storylyLoadFailed(_ storylyView: Storyly.StorylyView, errorMessage: String) {
        self.methodChannel.invokeMethod("storylyLoadFailed", arguments: errorMessage)
    }
    
    func storylyActionClicked(_ storylyView: Storyly.StorylyView, rootViewController: UIViewController, story: Storyly.Story) -> Bool {
        self.methodChannel.invokeMethod("storylyActionClicked",
                                        arguments: ["index": story.index,
                                                    "title": story.title,
                                                    "media": ["type": story.media.type.rawValue,
                                                              "url": story.media.url.absoluteString,
                                                              "actionUrl": story.media.actionUrl]])
        return true
    }
    
    func storylyStoryPresented(_ storylyView: Storyly.StorylyView) {
        self.methodChannel.invokeMethod("storylyStoryPresented", arguments: nil)
    }
    
    func storylyStoryDismissed(_ storylyView: Storyly.StorylyView) {
        self.methodChannel.invokeMethod("storylyStoryDismissed", arguments: nil)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...])
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 1
        scanner.scanHexInt64(&hexNumber)
        
        let red, green, blue, alpha: CGFloat
        if hexString.count == 9 {
            alpha = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            red = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            green = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            blue = CGFloat(hexNumber & 0x000000ff) / 255
        } else {
            red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            blue = CGFloat(hexNumber & 0x0000ff) / 255
            alpha = 1
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
