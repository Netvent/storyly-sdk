import Storyly
import UIKit

internal class FlutterStorylyViewWrapper: UIView, StorylyDelegate {
    private let ARGS_STORYLY_ID = "storylyId"
    private let ARGS_STORYLY_SEGMENTS = "storylySegments"
    private let ARGS_STORYLY_USER_PROPERTY = "storylyUserProperty"
    private let ARGS_STORYLY_PAYLOAD = "storylyPayload"
    private let ARGS_STORYLY_CUSTOM_PARAMETERS = "storylyCustomParameters"
    private let ARGS_STORYLY_SHARE_URL = "storylyShareUrl"
    private let ARGS_STORYLY_IS_TEST_MODE = "storylyIsTestMode"
    
    private let ARGS_STORYLY_BACKGROUND_COLOR = "storylyBackgroundColor"
    
    private let ARGS_STORY_GROUP_SIZE = "storyGroupSize"
    private let ARGS_STORY_GROUP_ICON_STYLING = "storyGroupIconStyling"
    private let ARGS_STORY_GROUP_LIST_STYLING = "storyGroupListStyling"
    private let ARGS_STORY_GROUP_ICON_IMAGE_THEMATIC_LABEL = "storyGroupIconImageThematicLabel"
    private let ARGS_STORY_GROUP_TEXT_STYLING = "storyGroupTextStyling"
    private let ARGS_STORY_HEADER_STYLING = "storyHeaderStyling"
    private let ARGS_STORYLY_LAYOUT_DIRECTION = "storylyLayoutDirection"
    
    private let ARGS_STORY_GROUP_ICON_BORDER_COLOR_SEEN = "storyGroupIconBorderColorSeen"
    private let ARGS_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN = "storyGroupIconBorderColorNotSeen"
    private let ARGS_STORY_GROUP_ICON_BACKGROUND_COLOR = "storyGroupIconBackgroundColor"
    private let ARGS_STORY_GROUP_PIN_ICON_COLOR = "storyGroupPinIconColor"
    private let ARGS_STORY_ITEM_ICON_BORDER_COLOR = "storyItemIconBorderColor"
    private let ARGS_STORY_ITEM_TEXT_COLOR = "storyItemTextColor"
    private let ARGS_STORY_ITEM_TEXT_TYPEFACE = "storyItemTextTypeface"
    private let ARGS_STORY_INTERACTIVE_TEXT_TYPEFACE = "storyInteractiveTextTypeface"
    private let ARGS_STORY_ITEM_PROGRESS_BAR_COLOR = "storyItemProgressBarColor"
    
    internal lazy var storylyView: StorylyView = StorylyView(frame: self.frame)
    
    private let args: [String: Any]
    private let methodChannel: FlutterMethodChannel
    
    init(frame: CGRect,
         args: [String: Any],
         methodChannel: FlutterMethodChannel) {
        self.args = args
        self.methodChannel = methodChannel
        super.init(frame: frame)
        
        self.methodChannel.setMethodCallHandler { [weak self] call, _ in
            let callArguments = call.arguments as? [String: Any]
            switch call.method {
                case "refresh": self?.storylyView.refresh()
                case "show": self?.storylyView.present(animated: true)
                case "dismiss": self?.storylyView.dismiss(animated: true)
                case "openStory":
                    _ = self?.storylyView.openStory(storyGroupId: callArguments?["storyGroupId"] as? String ?? "",
                                                    storyId: callArguments?["storyId"] as? String)
                case "openStoryUri":
                    if let payloadString = callArguments?["uri"] as? String,
                       let payloadUrl = URL(string: payloadString) {
                        _ = self?.storylyView.openStory(payload: payloadUrl)
                    }
                case "setExternalData":
                    if let externalData = callArguments?["externalData"] as? [[String : Any?]] {
                        _ = self?.storylyView.setExternalData(externalData: externalData)
                    }
                default: do {}
            }
        }
        
        guard let storylyId = self.args[ARGS_STORYLY_ID] as? String else { return }
        var storylySegments: Set<String>?
        if let argsSegments = self.args[ARGS_STORYLY_SEGMENTS] as? [String] { storylySegments = Set(argsSegments) }
        self.storylyView = StorylyView(frame: self.frame)
        self.storylyView.translatesAutoresizingMaskIntoConstraints = false
        self.storylyView.storylyInit = StorylyInit(storylyId: storylyId,
                                                   segmentation: StorylySegmentation(segments: storylySegments),
                                                   customParameter: self.args[self.ARGS_STORYLY_CUSTOM_PARAMETERS] as? String,
                                                   isTestMode: self.args[self.ARGS_STORYLY_IS_TEST_MODE] as? Bool ?? false,
                                                   storylyPayload: self.args[ARGS_STORYLY_PAYLOAD] as? String)
        if let userProperty = self.args[ARGS_STORYLY_USER_PROPERTY] as? [String: String] {
            self.storylyView.storylyInit.userData = userProperty
        }
        if let shareUrl = self.args[ARGS_STORYLY_SHARE_URL] as? String {
            self.storylyView.storylyShareUrl = shareUrl
        }
        self.storylyView.delegate = self
        self.storylyView.rootViewController = UIApplication.shared.keyWindow?.rootViewController?.getPresentedViewController()
        self.updateTheme(storylyView: storylyView, args: self.args)
        self.addSubview(storylyView)
        self.storylyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.storylyView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func updateTheme(storylyView: StorylyView, args: [String: Any]) {
        if let storylyBackgroundColor = args[ARGS_STORYLY_BACKGROUND_COLOR] as? String {
            storylyView.backgroundColor = UIColor(hexString: storylyBackgroundColor)
        }
        
        storylyView.storyGroupSize = args[self.ARGS_STORY_GROUP_SIZE] as? String ?? "large"
        
        if let storyGroupIconStyling = args[ARGS_STORY_GROUP_ICON_STYLING] as? [String: Any] {
            if let width = storyGroupIconStyling["width"] as? Int,
               let height = storyGroupIconStyling["height"] as? Int,
               let cornerRadius = storyGroupIconStyling["cornerRadius"] as? Int {
                storylyView.storyGroupIconStyling = StoryGroupIconStyling(height: CGFloat(height),
                                                                          width: CGFloat(width),
                                                                          cornerRadius: CGFloat(cornerRadius))
            }
        }
        
        if let storyGroupListStyling = args[ARGS_STORY_GROUP_LIST_STYLING] as? [String: Any] {
            if let edgePadding = storyGroupListStyling["edgePadding"] as? Int,
               let paddingBetweenItems = storyGroupListStyling["paddingBetweenItems"] as? Int {
                storylyView.storyGroupListStyling = StoryGroupListStyling(edgePadding: CGFloat(edgePadding),
                                                                          paddingBetweenItems: CGFloat(paddingBetweenItems))
            }
        }
        
        if let storyGroupIconImageThematicLabel = args[ARGS_STORY_GROUP_ICON_IMAGE_THEMATIC_LABEL] as? String {
            storylyView.storyGroupIconImageThematicLabel = storyGroupIconImageThematicLabel
        }
        
        if let storyGroupTextStyling = args[ARGS_STORY_GROUP_TEXT_STYLING] as? [String: Any] {
            let isVisible = storyGroupTextStyling["isVisible"] as? Bool ?? true
            let fontSize = CGFloat(storyGroupTextStyling["textSize"] as? Int ?? 12)
            let lines = storyGroupTextStyling["lines"] as? Int ?? 2
            let typeface = storyGroupTextStyling["typeface"] as? String
            let colorSeen = UIColor(hexString: storyGroupTextStyling["colorSeen"] as? String ?? "#FF000000")
            let colorNotSeen = UIColor(hexString: storyGroupTextStyling["colorNotSeen"] as? String ?? "#FF000000")

            var font = UIFont.systemFont(ofSize: fontSize)
            if let fontName = (typeface as? NSString)?.deletingPathExtension {
                if let updateFont = UIFont(name: fontName, size: fontSize) {
                    font = updateFont
                }
            }
            
            storylyView.storyGroupTextStyling = StoryGroupTextStyling(isVisible: isVisible,
                                                                      colorSeen: colorSeen,
                                                                      colorNotSeen: colorNotSeen,
                                                                      font: font,
                                                                      lines: lines)
        }
        
      if let storyHeaderStyling = args[ARGS_STORY_HEADER_STYLING] as? [String: Any] {
            let isTextVisible = storyHeaderStyling["isTextVisible"] as? Bool ?? true
            let isIconVisible = storyHeaderStyling["isIconVisible"] as? Bool ?? true
            let isCloseButtonVisible = storyHeaderStyling["isCloseButtonVisible"] as? Bool ?? true
                
            var closeIconImage: UIImage? = nil
            if let closeIcon = storyHeaderStyling["closeIcon"] as? String {
                 closeIconImage = UIImage(named: closeIcon)
            }
            var shareIconImage: UIImage? = nil
            if let shareIcon = storyHeaderStyling["shareIcon"] as? String {
                shareIconImage = UIImage(named: shareIcon)
            }
                
            storylyView.storyHeaderStyling = StoryHeaderStyling(isTextVisible: isTextVisible,
                                                                isIconVisible: isIconVisible,
                                                                isCloseButtonVisible: isCloseButtonVisible,
                                                                closeButtonIcon: closeIconImage,
                                                                shareButtonIcon: shareIconImage)
        }

        if let storylyLayoutDirection = args[self.ARGS_STORYLY_LAYOUT_DIRECTION] as? String {
            switch storylyLayoutDirection {
                case "ltr": storylyView.storylyLayoutDirection = .LTR
                case "rtl": storylyView.storylyLayoutDirection = .RTL
                default:  storylyView.storylyLayoutDirection = .LTR
            }
        }
        
        if let storyGroupIconBorderColorSeen = args[ARGS_STORY_GROUP_ICON_BORDER_COLOR_SEEN] as? [String] {
            storylyView.storyGroupIconBorderColorSeen = storyGroupIconBorderColorSeen.map { UIColor(hexString: $0) }
        }
        
        if let storyGroupIconBorderColorNotSeen = args[ARGS_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN] as? [String] {
            storylyView.storyGroupIconBorderColorNotSeen = storyGroupIconBorderColorNotSeen.map { UIColor(hexString: $0) }
        }
        
        if let storyGroupIconBackgroundColor = args[ARGS_STORY_GROUP_ICON_BACKGROUND_COLOR] as? String {
            storylyView.storyGroupIconBackgroundColor = UIColor(hexString: storyGroupIconBackgroundColor)
        }
        
        if let storyGroupPinIconColor = args[ARGS_STORY_GROUP_PIN_ICON_COLOR] as? String {
            storylyView.storyGroupPinIconColor = UIColor(hexString: storyGroupPinIconColor)
        }
        
        if let storyItemIconBorderColor = args[ARGS_STORY_ITEM_ICON_BORDER_COLOR] as? [String] {
            storylyView.storyItemIconBorderColor = storyItemIconBorderColor.map { UIColor(hexString: $0) }
        }
        
        if let storyItemTextColor = args[ARGS_STORY_ITEM_TEXT_COLOR] as? String {
            storylyView.storyItemTextColor = UIColor(hexString: storyItemTextColor)
        }
        
        if let storyItemTextTypeface = args[ARGS_STORY_ITEM_TEXT_TYPEFACE] as? String {
            let fontName = (storyItemTextTypeface as NSString).deletingPathExtension
            if let updateFont = UIFont(name: fontName, size: 14) {
                storylyView.storyItemTextFont = updateFont
            }
        }
        
        if let storyInteractiveTextTypeface = args[ARGS_STORY_INTERACTIVE_TEXT_TYPEFACE] as? String {
            let fontName = (storyInteractiveTextTypeface as NSString).deletingPathExtension
            if let updateFont = UIFont(name: fontName, size: 14) {
                storylyView.storyInteractiveFont = updateFont
            }
        }
        
        if let storyItemProgressBarColor = args[ARGS_STORY_ITEM_PROGRESS_BAR_COLOR] as? [String] {
            storylyView.storylyItemProgressBarColor = storyItemProgressBarColor.map { UIColor(hexString: $0) }
        }
    }
}

extension FlutterStorylyViewWrapper {
    func storylyLoaded(_ storylyView: Storyly.StorylyView,
                       storyGroupList: [Storyly.StoryGroup],
                       dataSource: StorylyDataSource) {
        self.methodChannel.invokeMethod("storylyLoaded",
                                        arguments: ["storyGroups": storyGroupList.map { storyGroup in self.createStoryGroupMap(storyGroup: storyGroup)},
                                                    "dataSource": dataSource.description])
    }
    
    func storylyLoadFailed(_ storylyView: Storyly.StorylyView, errorMessage: String) {
        self.methodChannel.invokeMethod("storylyLoadFailed", arguments: errorMessage)
    }
    
    func storylyEvent(_ storylyView: StorylyView, event: StorylyEvent, storyGroup: StoryGroup?, story: Story?, storyComponent: StoryComponent?) {
        var storyGroupMap: [String: Any?]? = nil
        if let storyGroup = storyGroup { storyGroupMap = self.createStoryGroupMap(storyGroup: storyGroup) }
        
        var storyMap: [String: Any?]? = nil
        if let story = story { storyMap = self.createStoryMap(story: story) }
        
        var storyComponentMap: [String: Any?]? = nil
        if let storyComponent = storyComponent { storyComponentMap = self.createStoryComponentMap(storyComponent: storyComponent) }
        self.methodChannel.invokeMethod("storylyEvent",
                                        arguments: ["event": event.stringValue,
                                                    "storyGroup": storyGroupMap,
                                                    "story": storyMap,
                                                    "storyComponent": storyComponentMap])
    }
    
    func storylyActionClicked(_ storylyView: Storyly.StorylyView,
                              rootViewController: UIViewController,
                              story: Storyly.Story) {
        self.methodChannel.invokeMethod("storylyActionClicked",
                                        arguments: self.createStoryMap(story: story))
    }
    
    func storylyStoryPresented(_ storylyView: Storyly.StorylyView) {
        self.methodChannel.invokeMethod("storylyStoryPresented", arguments: nil)
    }
    
    func storylyStoryDismissed(_ storylyView: Storyly.StorylyView) {
        self.methodChannel.invokeMethod("storylyStoryDismissed", arguments: nil)
    }
    
    func storylyUserInteracted(_ storylyView: StorylyView,
                               storyGroup: StoryGroup,
                               story: Story,
                               storyComponent: StoryComponent) {
        self.methodChannel.invokeMethod("storylyUserInteracted",
                                        arguments: ["storyGroup": self.createStoryGroupMap(storyGroup: storyGroup),
                                                    "story": self.createStoryMap(story: story),
                                                    "storyComponent": self.createStoryComponentMap(storyComponent: storyComponent)])
    }
    
    private func createStoryGroupMap(storyGroup: StoryGroup) -> [String: Any?] {
        return ["id": storyGroup.uniqueId,
                "title": storyGroup.title,
                "index": storyGroup.index,
                "seen": storyGroup.seen,
                "iconUrl": storyGroup.iconUrl.absoluteString,
                "stories": storyGroup.stories.map { story in self.createStoryMap(story: story)},
                "groupTheme": storyGroup.groupTheme,
                "thematicIconUrls": storyGroup.thematicIconUrls?.mapValues { $0.absoluteString },
                "coverUrl": storyGroup.coverUrl,
                "pinned": storyGroup.pinned,
                "type": storyGroup.type.rawValue]
    }
    
    private func createStoryMap(story: Story) -> [String: Any?] {
        return ["id": story.uniqueId,
                "title": story.title,
                "name": story.name,
                "index": story.index,
                "seen": story.seen,
                "currentTime": story.currentTime,
                "media": ["type": story.media.type.rawValue,
                          "storyComponentList": story.media.storyComponentList?.map { createStoryComponentMap(storyComponent:$0) },
                          "actionUrl": story.media.actionUrl,
                          "previewUrl": story.media.previewUrl?.absoluteString,
                          "actionUrlList": story.media.actionUrlList ]]
    }
    
    private func createStoryComponentMap(storyComponent: StoryComponent) -> [String: Any?] {
        switch storyComponent {
            case let quizComponent as StoryQuizComponent:
                return ["type": "quiz",
                        "id": quizComponent.id,
                        "title": quizComponent.title,
                        "options": quizComponent.options,
                        "rightAnswerIndex": quizComponent.rightAnswerIndex?.intValue,
                        "selectedOptionIndex": quizComponent.selectedOptionIndex,
                        "customPayload": quizComponent.customPayload]
            case let pollComponent as StoryPollComponent:
                return ["type": "poll",
                        "id": pollComponent.id,
                        "title": pollComponent.title,
                        "options": pollComponent.options,
                        "selectedOptionIndex": pollComponent.selectedOptionIndex,
                        "customPayload": pollComponent.customPayload]
            case let emojiComponent as StoryEmojiComponent:
                return ["type": "emoji",
                        "id": emojiComponent.id,
                        "emojiCodes": emojiComponent.emojiCodes,
                        "selectedEmojiIndex": emojiComponent.selectedEmojiIndex,
                        "customPayload": emojiComponent.customPayload]
            case let ratingComponent as StoryRatingComponent:
                return ["type": "rating",
                        "id": ratingComponent.id,
                        "emojiCode": ratingComponent.emojiCode,
                        "rating": ratingComponent.rating,
                        "customPayload": ratingComponent.customPayload]
            case let promoCodeComponent as StoryPromoCodeComponent:
                return ["type": "promocode",
                        "id": promoCodeComponent.id,
                        "text": promoCodeComponent.text]
            case let commentComponent as StoryCommentComponent:
                return ["type": "comment",
                        "id": commentComponent.id,
                        "text": commentComponent.text]
            default:
                return ["type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
                        "id": storyComponent.id]

        }
    }
}

extension UIViewController {
    internal func getPresentedViewController() -> UIViewController? {
        guard let vc = self.presentedViewController else {
            return self
        }
        return vc.getPresentedViewController()
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
