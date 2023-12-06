//
//  StorylyBundle.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 22.09.2023.
//
import Storyly


internal class StorylyBundle {
    let storylyView: StorylyView
    
    init(storylyView: StorylyView) {
        self.storylyView = storylyView
    }
    
    public static func build(rawJson: String) -> StorylyBundle? {
        guard let bundleData = rawJson.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: bundleData, options: []) as? NSDictionary else { return nil }
        
        return stStorylyBundle(json: json)
    }
}

private func stStorylyBundle(json: NSDictionary) -> StorylyBundle? {
    print("STR:RCTConvert+Extension:stStorylyBundle(json:\(json))")
    guard let storylyInitJson = json["storylyInit"] as? NSDictionary else { return nil }
    guard let storylyId = storylyInitJson["storylyId"] as? String else { return nil }
    guard let storyGroupStylingJson = json["storyGroupStyling"] as? NSDictionary else { return nil }
    guard let storyBarStylingJson = json["storyBarStyling"] as? NSDictionary else { return nil }
    guard let storyStylingJson = json["storyStyling"] as? NSDictionary else { return nil }
    guard let storyShareConfig = json["storyShareConfig"] as? NSDictionary else { return nil }
    guard let storyProductConfig = json["storyProductConfig"] as? NSDictionary else { return nil }

    var storylyConfigBuilder = StorylyConfig.Builder()
    storylyConfigBuilder = stStorylyInit(json: storylyInitJson, configBuilder: &storylyConfigBuilder)
    storylyConfigBuilder = stStorylyGroupStyling(json: storyGroupStylingJson, configBuilder: &storylyConfigBuilder)
    storylyConfigBuilder = stStoryBarStyling(json: storyBarStylingJson, configBuilder: &storylyConfigBuilder)
    storylyConfigBuilder = stStoryStyling(json: storyStylingJson, configBuilder: &storylyConfigBuilder)
    storylyConfigBuilder = stShareConfig(json: storyShareConfig, configBuilder: &storylyConfigBuilder)
    storylyConfigBuilder = stProductConfig(json: storyProductConfig, configBuilder: &storylyConfigBuilder)

    let storylyView = StorylyView()
    storylyView.storylyInit = StorylyInit(
        storylyId: storylyId,
        config: storylyConfigBuilder
            .build()
    )
    return StorylyBundle(storylyView: storylyView)
}

private func stStorylyInit(
    json: NSDictionary,
    configBuilder: inout StorylyConfig.Builder
) -> StorylyConfig.Builder {
    if let segmentsData = json["storylySegments"] as? [String] { configBuilder = configBuilder.setLabels(labels: Set(segmentsData)) }
    return configBuilder
        .setCustomParameter(parameter: json["customParameter"] as? String)
        .setTestMode(isTest: (json["storylyIsTestMode"] as? Bool) ?? false)
        .setStorylyPayload(payload: json["storylyPayload"] as? String)
        .setUserData(data: json["userProperty"] as? [String: String] ?? [:])
        .setLayoutDirection(direction: getStorylyLayoutDirection(direction: json["storylyLayoutDirection"] as? String))
        .setLocale(locale: json["storylyLocale"] as? String)
}

private func stStorylyGroupStyling(
    json: NSDictionary,
    configBuilder: inout StorylyConfig.Builder
) -> StorylyConfig.Builder {
    var groupStylingBuilder = StorylyStoryGroupStyling.Builder()
    if let iconBorderColorSeenJson = json["iconBorderColorSeen"] as? NSArray {
        groupStylingBuilder = groupStylingBuilder.setIconBorderColorSeen(colors: RCTConvert.uiColorArray(iconBorderColorSeenJson))
    }
    if let iconBorderColorNotSeenJson = json["iconBorderColorNotSeen"] as? NSArray {
        groupStylingBuilder = groupStylingBuilder.setIconBorderColorNotSeen(colors: RCTConvert.uiColorArray(iconBorderColorNotSeenJson))
    }
    if let iconBackgroundColorJson = json["iconBackgroundColor"] as? NSNumber {
        groupStylingBuilder = groupStylingBuilder.setIconBackgroundColor(color: RCTConvert.uiColor(iconBackgroundColorJson))
    }
    if let pinIconColorJson = json["pinIconColor"] as? NSNumber {
        groupStylingBuilder = groupStylingBuilder.setPinIconColor(color: RCTConvert.uiColor(pinIconColorJson))
    }
    if let titleSeenColorJson = json["titleSeenColor"] as? NSNumber {
        groupStylingBuilder = groupStylingBuilder.setTitleSeenColor(color: RCTConvert.uiColor(titleSeenColorJson))
    }
    if let titleNotSeenColorJson = json["titleNotSeenColor"] as? NSNumber {
        groupStylingBuilder = groupStylingBuilder.setTitleNotSeenColor(color: RCTConvert.uiColor(titleNotSeenColorJson))
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
    json: NSDictionary,
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
    if let headerIconBorderColorJson = json["headerIconBorderColor"] as? NSArray {
        storyStylingBuilder = storyStylingBuilder.setHeaderIconBorderColor(colors: RCTConvert.uiColorArray(headerIconBorderColorJson))
    }
    if let titleColorJson = json["titleColor"] as? NSNumber {
        storyStylingBuilder = storyStylingBuilder.setTitleColor(color: RCTConvert.uiColor(titleColorJson))
    }
    if let progressBarColorJson = json["progressBarColor"] as? NSArray {
        storyStylingBuilder = storyStylingBuilder.setProgressBarColor(colors: RCTConvert.uiColorArray(progressBarColorJson))
    }
    return configBuilder
        .setStoryStyling(styling: storyStylingBuilder
            .setTitleFont(font: getCustomFont(typeface: json["titleFont"] as? NSString, fontSize: 14, defaultWeight: .semibold))
            .setInteractiveFont(font: getCustomFont(typeface: json["interactiveFont"] as? NSString, fontSize: 14, defaultWeight: .regular))
            .setTitleVisibility(isVisible: json["isTitleVisible"] as? Bool ?? true)
            .setHeaderIconVisibility(isVisible: json["isHeaderIconVisible"] as? Bool ?? true)
            .setCloseButtonVisibility(isVisible: json["isCloseButtonVisible"] as? Bool ?? true)
            .setCloseButtonIcon(icon: UIImage(named: json["closeButtonIcon"] as? String))
            .setShareButtonIcon(icon: UIImage(named: json["shareButtonIcon"] as? String))
            .build()
        )
}

private func stShareConfig(
    json: NSDictionary,
    configBuilder: inout StorylyConfig.Builder
) -> StorylyConfig.Builder {
    var shareConfigBuilder = StorylyShareConfig.Builder()
    if let facebookAppID = json["storylyFacebookAppID"] as? String {
        shareConfigBuilder = shareConfigBuilder.setFacebookAppID(id: facebookAppID)
    }
    if let url = json["storylyShareUrl"] as? String {
        shareConfigBuilder = shareConfigBuilder.setShareUrl(url: url)
    }
    return configBuilder
        .setShareConfig(config: shareConfigBuilder
            .build()
        )
}

private func stProductConfig(
    json: NSDictionary,
    configBuilder: inout StorylyConfig.Builder
) -> StorylyConfig.Builder {
    var productConfigBuilder = StorylyProductConfig.Builder()
    if let isFallbackEnabled = json["isFallbackEnabled"] as? Bool {
        productConfigBuilder = productConfigBuilder.setFallbackAvailability(isEnabled: isFallbackEnabled)
    }
    if let isCartEnabled = json["isCartEnabled"] as? Bool {
        productConfigBuilder = productConfigBuilder.setCartEnabled(isEnabled: isCartEnabled)
    }

    return configBuilder
        .setProductConfig(config: productConfigBuilder
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

private func getCustomFont(typeface: NSString?, fontSize: CGFloat, defaultWeight: UIFont.Weight = .regular) -> UIFont {
    if let fontName = typeface?.deletingPathExtension,
       let font = UIFont(name: fontName, size: fontSize) { return font }
    return .systemFont(ofSize: fontSize, weight: defaultWeight)
}

internal extension UIImage {
    convenience init?(named: String?) {
        guard let named = named else { return nil }
        self.init(named: named)
    }
}

internal extension UIColor {
    convenience init?(hexString: String?) {
        guard let hexString = hexString else { return nil }

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
