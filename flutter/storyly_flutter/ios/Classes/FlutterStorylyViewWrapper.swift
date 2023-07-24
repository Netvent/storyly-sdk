import Storyly
import UIKit

internal class FlutterStorylyViewWrapper: UIView, StorylyDelegate {
    internal lazy var storylyView: StorylyView = StorylyView(frame: self.frame)
    
    private let methodChannel: FlutterMethodChannel
    
    init(frame: CGRect,
         args: [String: Any],
         methodChannel: FlutterMethodChannel) {
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
                case "hydrateProducts":
                    if let products = callArguments?["products"] as? [[String : Any?]] {
                        let storylyProducts = products.compactMap { self?.createSTRProductItem(product: $0) }
                        _ = self?.storylyView.hydrateProducts(products: storylyProducts)
                    }
                default: do {}
            }
        }
        
        guard let storylyInit = getStorylyInit(json: args) else { return }
        self.storylyView = StorylyView(frame: self.frame)
        self.storylyView.translatesAutoresizingMaskIntoConstraints = false
        self.storylyView.storylyInit = storylyInit
        self.storylyView.delegate = self
        self.storylyView.productDelegate = self
        self.storylyView.rootViewController = UIApplication.shared.keyWindow?.rootViewController?.getPresentedViewController()
        self.addSubview(storylyView)
        self.storylyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.storylyView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        if let storylyBackgroundColor = args["storylyBackgroundColor"] as? String { storylyView.backgroundColor = UIColor(hexString: storylyBackgroundColor) }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func getStorylyInit(
        json: [String: Any]
    ) -> StorylyInit? {
        guard let storylyInitJson = json["storylyInit"] as? [String: Any] else { return nil }
        guard let storylyId = storylyInitJson["storylyId"] as? String else { return nil }
        guard let storyGroupStylingJson = json["storyGroupStyling"] as? [String: Any] else { return nil }
        guard let storyBarStylingJson = json["storyBarStyling"] as? [String: Any] else { return nil }
        guard let storyStylingJson = json["storyStyling"] as? NSDictionary else { return nil }
        
        var storylyConfigBuilder = StorylyConfig.Builder()
        storylyConfigBuilder = stStorylyInit(json: storylyInitJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stStorylyGroupStyling(json: storyGroupStylingJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stStoryBarStyling(json: storyBarStylingJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stStoryStyling(json: storyStylingJson, configBuilder: &storylyConfigBuilder )
        if let shareUrl = json["storylyShareUrl"] as? String { storylyConfigBuilder = storylyConfigBuilder.setShareUrl(url: shareUrl) }
        
        return StorylyInit(
            storylyId: storylyId,
            config: storylyConfigBuilder
                .setLayoutDirection(direction: getStorylyLayoutDirection(direction: json["storylyLayoutDirection"] as? String))
                .build()
        )
    }
    
    private func stStorylyInit(
        json: [String: Any],
        configBuilder: inout StorylyConfig.Builder
    ) -> StorylyConfig.Builder {
        if let segmentsData = json["storylySegments"] as? [String] { configBuilder = configBuilder.setLabels(labels: Set(segmentsData)) }
        return configBuilder
            .setCustomParameter(parameter: json["customParameter"] as? String)
            .setTestMode(isTest: (json["storylyIsTestMode"] as? Bool) ?? false)
            .setStorylyPayload(payload: json["storylyPayload"] as? String)
            .setUserData(data: json["userProperty"] as? [String: String] ?? [:])
    }
    
    private func stStorylyGroupStyling(
        json: [String: Any],
        configBuilder: inout StorylyConfig.Builder
    ) -> StorylyConfig.Builder {
        var groupStylingBuilder = StorylyStoryGroupStyling.Builder()
        
        if let iconBorderColorSeenJson = json["iconBorderColorSeen"] as? [String] {
            groupStylingBuilder = groupStylingBuilder.setIconBorderColorSeen(colors: iconBorderColorSeenJson.map { UIColor(hexString: $0) })
        }
        if let iconBorderColorNotSeenJson = json["iconBorderColorNotSeen"] as? [String] {
            groupStylingBuilder = groupStylingBuilder.setIconBorderColorNotSeen(colors: iconBorderColorNotSeenJson.map { UIColor(hexString: $0) })
        }
        if let iconBackgroundColorJson = json["iconBackgroundColor"] as? String {
            groupStylingBuilder = groupStylingBuilder.setIconBackgroundColor(color: UIColor(hexString: iconBackgroundColorJson))
        }
        if let pinIconColorJson = json["pinIconColor"] as? String {
            groupStylingBuilder = groupStylingBuilder.setPinIconColor(color: UIColor(hexString: pinIconColorJson))
        }
        if let titleSeenColorJson = json["titleSeenColor"] as? String {
            groupStylingBuilder = groupStylingBuilder.setTitleSeenColor(color: UIColor(hexString: titleSeenColorJson))
        }
        if let titleNotSeenColorJson = json["titleNotSeenColor"] as? String {
            groupStylingBuilder = groupStylingBuilder.setTitleNotSeenColor(color: UIColor(hexString: titleNotSeenColorJson))
        }
        return configBuilder
            .setStoryGroupStyling(
                styling: groupStylingBuilder
                    .setIconHeight(height: json["iconHeight"] as? CGFloat ?? 80)
                    .setIconWidth(width: json["iconWidth"] as? CGFloat ?? 80)
                    .setIconCornerRadius(radius: json["iconCornerRadius"] as? CGFloat ?? 40)
                    .setSize(size: getStoryGroupSize(groupSize: json["groupSize"] as? String))
                    .setIconBorderAnimation(animation: getStoryGroupAnimation(groupAnimation: json["iconBorderAnimation"] as? String))
                    .setTitleLineCount(count: json["titleLineCount"] as? Int ?? 2)
                    .setTitleFont(font: getCustomFont(typeface: json["titleFont"] as? NSString, fontSize: CGFloat(json["titleTextSize"] as? Int ?? 12)))
                    .setTitleVisibility(isVisible: json["titleVisible"] as? Bool ?? true)
                    .build()
            )
    }
    
    private func stStoryBarStyling(
        json: [String: Any],
        configBuilder: inout StorylyConfig.Builder
    ) -> StorylyConfig.Builder {
        return configBuilder
            .setBarStyling(
                styling: StorylyBarStyling.Builder()
                    .setOrientation(orientation: getStoryGroupListOrientation(orientation: json["orientation"] as? String))
                    .setSection(count: json["sections"] as? Int ?? 1)
                    .setHorizontalEdgePadding(padding: json["horizontalEdgePadding"] as? CGFloat ?? 4)
                    .setVerticalEdgePadding(padding: json["verticalEdgePadding"] as? CGFloat ?? 4)
                    .setHorizontalPaddingBetweenItems(padding: json["horizontalPaddingBetweenItems"] as? CGFloat ?? 8)
                    .setVerticalPaddingBetweenItems(padding: json["verticalPaddingBetweenItems"] as? CGFloat ?? 8)
                    .build()
            )
    }
    
    private func stStoryStyling(
        json: NSDictionary,
        configBuilder: inout StorylyConfig.Builder
    ) -> StorylyConfig.Builder {
        var storyStylingBuilder = StorylyStoryStyling.Builder()
        if let headerIconBorderColorJson = json["headerIconBorderColor"] as? [String] {
            storyStylingBuilder = storyStylingBuilder.setHeaderIconBorderColor(colors: headerIconBorderColorJson.map { UIColor(hexString: $0) })
        }
        if let titleColorJson = json["titleColor"] as? String {
            storyStylingBuilder = storyStylingBuilder.setTitleColor(color: UIColor(hexString: titleColorJson))
        }
        if let progressBarColorJson = json["progressBarColor"] as? [String] {
            storyStylingBuilder = storyStylingBuilder.setProgressBarColor(colors: progressBarColorJson.map { UIColor(hexString: $0)})
        }
        if let closeButtonIconJson = json["closeButtonIcon"] as? String {
            storyStylingBuilder = storyStylingBuilder.setCloseButtonIcon(icon: UIImage(named: closeButtonIconJson))
        }
        if let shareButtonIconJson = json["shareButtonIcon"] as? String {
            storyStylingBuilder = storyStylingBuilder.setShareButtonIcon(icon: UIImage(named: shareButtonIconJson))
        }
        return configBuilder
            .setStoryStyling(styling: storyStylingBuilder
                .setTitleFont(font: getCustomFont(typeface: json["titleFont"] as? NSString, fontSize: 14, defaultWeight: .semibold))
                .setInteractiveFont(font: getCustomFont(typeface: json["interactiveFont"] as? NSString, fontSize: 14, defaultWeight: .regular))
                .setTitleVisibility(isVisible: json["isTitleVisible"] as? Bool ?? true)
                .setHeaderIconVisibility(isVisible: json["isHeaderIconVisible"] as? Bool ?? true)
                .setCloseButtonVisibility(isVisible: json["isCloseButtonVisible"] as? Bool ?? true)
                .build()
            )
    }
    
    private func getStoryGroupSize(groupSize: String?) -> StoryGroupSize {
        switch groupSize {
            case "small": return .Small
            case "custom": return .Custom
            default: return .Large
        }
    }
    
    private func getStoryGroupAnimation(groupAnimation: String?) -> StoryGroupAnimation {
        switch groupAnimation {
            case "border-rotation": return .BorderRotation
            case "disabled": return .Disabled
            default: return .BorderRotation
        }
    }
    
    private func getStorylyLayoutDirection(direction: String?) -> StorylyLayoutDirection {
        switch direction {
            case "ltr": return .LTR
            case "rtl": return .RTL
            default: return .LTR
        }
    }
    
    private func getStoryGroupListOrientation(orientation: String?) -> StoryGroupListOrientation {
        switch orientation {
            case "horizontal": return .Horizontal
            case "vertical": return .Vertical
            default: return .Horizontal
        }
    }
    
    private func getCustomFont(
        typeface: NSString?,
        fontSize: CGFloat,
        defaultWeight: UIFont.Weight = .regular
    ) -> UIFont {
        if let fontName = typeface?.deletingPathExtension,
           let font = UIFont(name: fontName, size: fontSize) { return font }
        return .systemFont(ofSize: fontSize, weight: defaultWeight)
    }
}

extension FlutterStorylyViewWrapper: StorylyProductDelegate {
    
    func storylyHydration(_ storylyView: StorylyView, productIds: [String]) {
        self.methodChannel.invokeMethod("storylyOnHydration",
                                        arguments: ["productIds": productIds])
    }
    
    func storylyEvent(_ storylyView: StorylyView,
                      event: StorylyEvent,
                      product: STRProductItem?, extras: [String:String]) {
        var storylyProductItem : [String: Any?]? = nil
        if let product = product {
            storylyProductItem = self.createSTRProductItemMap(product: product)
        }
        self.methodChannel.invokeMethod(
            "storylyProductEvent",
            arguments: [
                "event": event.stringValue,
                "product": storylyProductItem,
                "extras": extras]
        )
    }
}


extension FlutterStorylyViewWrapper {
    func storylyLoaded(_ storylyView: Storyly.StorylyView,
                       storyGroupList: [Storyly.StoryGroup],
                       dataSource: StorylyDataSource) {
        self.methodChannel.invokeMethod(
            "storylyLoaded",
            arguments: [
                "storyGroups": storyGroupList.map { storyGroup in self.createStoryGroupMap(storyGroup: storyGroup)},
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
        self.methodChannel.invokeMethod(
            "storylyEvent",
            arguments: [
                "event": event.stringValue,
                "storyGroup": storyGroupMap,
                "story": storyMap,
                "storyComponent": storyComponentMap
            ])
    }
    
    func storylyActionClicked(_ storylyView: Storyly.StorylyView,
                              rootViewController: UIViewController,
                              story: Storyly.Story) {
        self.methodChannel.invokeMethod(
            "storylyActionClicked",
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
        self.methodChannel.invokeMethod(
            "storylyUserInteracted",
            arguments: [
                "storyGroup": self.createStoryGroupMap(storyGroup: storyGroup),
                "story": self.createStoryMap(story: story),
                "storyComponent": self.createStoryComponentMap(storyComponent: storyComponent)
            ])
    }
    
    private func createStoryGroupMap(storyGroup: StoryGroup) -> [String: Any?] {
        return [
            "id": storyGroup.uniqueId,
            "title": storyGroup.title,
            "index": storyGroup.index,
            "seen": storyGroup.seen,
            "iconUrl": storyGroup.iconUrl?.absoluteString,
            "stories": storyGroup.stories.map { story in self.createStoryMap(story: story)},
            "thematicIconUrls": storyGroup.thematicIconUrls?.mapValues { $0.absoluteString },
            "coverUrl": storyGroup.coverUrl,
            "pinned": storyGroup.pinned,
            "type": storyGroup.type.rawValue
        ]
    }
    
    private func createStoryMap(story: Story) -> [String: Any?] {
        return [
            "id": story.uniqueId,
            "title": story.title,
            "name": story.name,
            "index": story.index,
            "seen": story.seen,
            "currentTime": story.currentTime,
            "media": [
                "type": story.media.type.rawValue,
                "storyComponentList": story.media.storyComponentList?.map { createStoryComponentMap(storyComponent:$0) },
                "actionUrl": story.media.actionUrl,
                "previewUrl": story.media.previewUrl?.absoluteString,
                "actionUrlList": story.media.actionUrlList
            ]
        ]
    }
    
    internal func createSTRProductItemMap(product: STRProductItem) -> [String: Any?] {
        return [
            "productId" : product.productId,
            "productGroupId" : product.productGroupId,
            "title" : product.title,
            "desc" : product.desc,
            "price" : product.price,
            "salesPrice" : product.salesPrice,
            "currency" : product.currency,
            "imageUrls" : product.imageUrls,
            "variants" : product.variants?.compactMap { createSTRProductVariantMap(variant: $0) }
        ]
    }
    
    internal func createSTRProductVariantMap(variant: STRProductVariant) -> [String: Any?] {
        return [
            "name" : variant.name,
            "value" : variant.value
        ]
    }
    
    internal func createSTRProductItem(product: [String: Any?]) -> STRProductItem {
        return STRProductItem(
            productId: product["productId"] as? String ?? "",
            productGroupId: product["productGroupId"] as? String ?? "",
            title: product["title"] as? String ?? "",
            url: product["url"] as? String ?? "",
            description: product["desc"] as? String ?? "",
            price: Float((product["price"] as! Double)),
            salesPrice: product["salesPrice"] as? NSNumber,
            currency: product["currency"] as? String ?? "",
            imageUrls: product["imageUrls"] as? [String],
            variants: createSTRProductVariant(variants: product["variants"] as? [[String: Any?]])
        )
    }
    
    internal func createSTRProductVariant(variants: [[String: Any?]]?) -> [STRProductVariant] {
        return variants?.map {
            STRProductVariant(
                name: $0["name"] as? String ?? "",
                value: $0["value"] as? String ?? ""
            )
        } ?? []
    }
    
    private func createStoryComponentMap(storyComponent: StoryComponent) -> [String: Any?] {
        switch storyComponent {
            case let quizComponent as StoryQuizComponent:
                return [
                    "type": "quiz",
                    "id": quizComponent.id,
                    "title": quizComponent.title,
                    "options": quizComponent.options,
                    "rightAnswerIndex": quizComponent.rightAnswerIndex?.intValue,
                    "selectedOptionIndex": quizComponent.selectedOptionIndex,
                    "customPayload": quizComponent.customPayload]
            case let pollComponent as StoryPollComponent:
                return [
                    "type": "poll",
                    "id": pollComponent.id,
                    "title": pollComponent.title,
                    "options": pollComponent.options,
                    "selectedOptionIndex": pollComponent.selectedOptionIndex,
                    "customPayload": pollComponent.customPayload
                ]
            case let emojiComponent as StoryEmojiComponent:
                return [
                    "type": "emoji",
                    "id": emojiComponent.id,
                    "emojiCodes": emojiComponent.emojiCodes,
                    "selectedEmojiIndex": emojiComponent.selectedEmojiIndex,
                    "customPayload": emojiComponent.customPayload]
            case let ratingComponent as StoryRatingComponent:
                return [
                    "type": "rating",
                    "id": ratingComponent.id,
                    "emojiCode": ratingComponent.emojiCode,
                    "rating": ratingComponent.rating,
                    "customPayload": ratingComponent.customPayload]
            case let promoCodeComponent as StoryPromoCodeComponent:
                return [
                    "type": "promocode",
                    "id": promoCodeComponent.id,
                    "text": promoCodeComponent.text]
            case let commentComponent as StoryCommentComponent:
                return [
                    "type": "comment",
                    "id": commentComponent.id,
                    "text": commentComponent.text]
            default:
                return [
                    "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
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
