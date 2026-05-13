//
//  RCTConvert+Storyly.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//
@_spi(InternalFramework) 
import Storyly

@objc(VerticalFeedBundle)
class VerticalFeedBundle: NSObject {
    let storylyView: StorylyVerticalFeedView
    
    init(storylyView: StorylyVerticalFeedView) {
        self.storylyView = storylyView
    }
}

extension RCTConvert {
    @objc(stVerticalFeedBundle:)
    static func stVerticalFeedBundle(json: NSDictionary) -> VerticalFeedBundle? {
        print("STR:RCTConvert+Extension:stStorylyBundle(json:\(json))")
        
        guard let storylyInitJson = json["storylyInit"] as? NSDictionary else { return nil }
        guard let storylyId = storylyInitJson["storylyId"] as? String else { return nil }
        guard let storyGroupStylingJson = json["verticalFeedGroupStyling"] as? NSDictionary else { return nil }
        guard let storyBarStylingJson = json["verticalFeedBarStyling"] as? NSDictionary else { return nil }
        guard let storyStylingJson = json["verticalFeedCustomization"] as? NSDictionary else { return nil }
        guard let storyShareConfig = json["verticalFeedItemShareConfig"] as? NSDictionary else { return nil }
        guard let storyProductConfig = json["verticalFeedItemProductConfig"] as? NSDictionary else { return nil }

        var storylyConfigBuilder = StorylyVerticalFeedConfig.Builder()
        storylyConfigBuilder = stVerticalFeedInit(json: storylyInitJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stVerticalFeedGroupStyling(json: storyGroupStylingJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stVerticalFeedItemBarStyling(json: storyBarStylingJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stVerticalFeedCustomization(json: storyStylingJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stShareConfig(json: storyShareConfig, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stProductConfig(json: storyProductConfig, configBuilder: &storylyConfigBuilder)

        let storylyConfig = storylyConfigBuilder.build()
        storylyConfig.setFramework(framework: "rn")

        let storylyView = StorylyVerticalFeedView()
        storylyView.storylyVerticalFeedInit = StorylyVerticalFeedInit(
            storylyId: storylyId,
            config: storylyConfig
        )
        return VerticalFeedBundle(storylyView: storylyView)
    }
}

private func stVerticalFeedInit(
    json: NSDictionary,
    configBuilder: inout StorylyVerticalFeedConfig.Builder
) -> StorylyVerticalFeedConfig.Builder {
    if let segmentsData = json["storylySegments"] as? [String] { configBuilder = configBuilder.setLabels(labels: Set(segmentsData)) }
    return configBuilder
        .setCustomParameter(parameter: json["customParameter"] as? String)
        .setTestMode(isTest: (json["storylyIsTestMode"] as? Bool) ?? false)
        .setUserData(data: json["userProperty"] as? [String: String] ?? [:])
        .setLayoutDirection(direction: getStorylyLayoutDirection(direction: json["storylyLayoutDirection"] as? String))
        .setLocale(locale: json["storylyLocale"] as? String)
}

private func stVerticalFeedGroupStyling(
    json: NSDictionary,
    configBuilder: inout StorylyVerticalFeedConfig.Builder
) -> StorylyVerticalFeedConfig.Builder {
    var groupStylingBuilder = StorylyVerticalFeedGroupStyling.Builder()
    
    if let iconBackgroundColor = json["iconBackgroundColor"] as? NSNumber {
        groupStylingBuilder = groupStylingBuilder.setIconBackgroundColor(color: RCTConvert.uiColor(iconBackgroundColor))
    }
    if let iconHeight = json["iconHeight"] as? CGFloat {
        groupStylingBuilder = groupStylingBuilder.setIconHeight(height: iconHeight)
    }
    if let iconCornerRadius = json["iconCornerRadius"] as? CGFloat {
        groupStylingBuilder = groupStylingBuilder.setIconCornerRadius(radius: iconCornerRadius)
    }
    if let titleVisible = json["titleVisible"] as? Bool {
        groupStylingBuilder = groupStylingBuilder.setTitleVisibility(isVisible: titleVisible)
    }
    if let textTypeface = json["textTypeface"] as? NSString {
        groupStylingBuilder = groupStylingBuilder.setFont(font: getCustomFont(typeface: json["titleFont"] as? NSString, fontSize: 14, defaultWeight: .semibold))
    }
    if let textColor = json["textColor"] as? NSNumber {
        groupStylingBuilder = groupStylingBuilder.setTextColor(RCTConvert.uiColor(textColor))
    }
    if let typeIndicatorVisible = json["typeIndicatorVisible"] as? Bool {
        groupStylingBuilder = groupStylingBuilder.setTypeIndicatorVisibility(typeIndicatorVisible)
    }
    if let groupOrder = json["groupOrder"] as? String {
        groupStylingBuilder = groupStylingBuilder.setGroupOrder(order: getStorylyGroupOrder(groupOrder: groupOrder))
    }
    if let minLikeCountToShowIcon = json["minLikeCountToShowIcon"] as? Int {
        groupStylingBuilder = groupStylingBuilder.setMinLikeCountToShowIcon(minLikeCountToShowIcon)
    }
    if let minImpressionCountToShowIcon = json["minImpressionCountToShowIcon"] as? Int {
        groupStylingBuilder = groupStylingBuilder.setMinImpressionCountToShowIcon(minImpressionCountToShowIcon)
    }

    if let impressionIcon = json["impressionIcon"] as? String {
        if let image = UIImage(named: impressionIcon) {
            groupStylingBuilder = groupStylingBuilder.setImpressionIcon(image)
        }
    }
    
    if let likeIcon = json["likeIcon"] as? String {
        if let image = UIImage(named: likeIcon) {
            groupStylingBuilder = groupStylingBuilder.setLikeIcon(image)
        }
    }

    return configBuilder.setVerticalFeedGroupStyling(
        styling: groupStylingBuilder.build()
    )
}

private func stVerticalFeedItemBarStyling(
    json: NSDictionary,
    configBuilder: inout StorylyVerticalFeedConfig.Builder
) -> StorylyVerticalFeedConfig.Builder {
    var barStylingBuilder = StorylyVerticalFeedBarStyling.Builder()
    
    if let section = json["sections"] as? Int {
        barStylingBuilder = barStylingBuilder.setSection(count: section)
    }
    
    if let edgePadding = json["horizontalEdgePadding"] as? CGFloat {
        barStylingBuilder = barStylingBuilder.setHorizontalEdgePadding(padding: edgePadding)
    }
    
    if let edgePadding = json["verticalEdgePadding"] as? CGFloat {
        barStylingBuilder = barStylingBuilder.setVerticalEdgePadding(padding: edgePadding)
    }
    
    if let paddingBetweenItems = json["horizontalPaddingBetweenItems"] as? CGFloat {
        barStylingBuilder = barStylingBuilder.setHorizontalPaddingBetweenItems(padding: paddingBetweenItems)
    }
    
    if let paddingBetweenItems = json["verticalPaddingBetweenItems"] as? CGFloat {
        barStylingBuilder = barStylingBuilder.setVerticalPaddingBetweenItems(padding: paddingBetweenItems)
    }
    
    return configBuilder.setVerticalFeedBarStyling(styling: barStylingBuilder.build())
}

private func stVerticalFeedCustomization(
    json: NSDictionary,
    configBuilder: inout StorylyVerticalFeedConfig.Builder
) -> StorylyVerticalFeedConfig.Builder {
    var storyStylingBuilder = StorylyVerticalFeedCustomization.Builder()
    
    if let titleFont = json["titleFont"] as? NSString {
        storyStylingBuilder = storyStylingBuilder.setTitleFont(font: getCustomFont(typeface: titleFont, fontSize: 14, defaultWeight: .semibold))
    }
    if let interactiveFont = json["interactiveFont"] as? NSString {
        storyStylingBuilder = storyStylingBuilder.setInteractiveFont(font: getCustomFont(typeface: interactiveFont, fontSize: 14, defaultWeight: .semibold))
    }
    if let progressBarColorJson = json["progressBarColor"] as? NSArray {
        storyStylingBuilder = storyStylingBuilder.setProgressBarColor(colors: RCTConvert.uiColorArray(progressBarColorJson))
    }
    if let isTitleVisible = json["isTitleVisible"] as? Bool {
        storyStylingBuilder = storyStylingBuilder.setTitleVisibility(isVisible: isTitleVisible)
    }
    if let isProgressBarVisible = json["isProgressBarVisible"] as? Bool {
        storyStylingBuilder = storyStylingBuilder.setProgressBarVisibility(isVisible: isProgressBarVisible)
    }
    if let isCloseButtonVisible = json["isCloseButtonVisible"] as? Bool {
        storyStylingBuilder = storyStylingBuilder.setCloseButtonVisibility(isVisible: isCloseButtonVisible)
    }
    if let isLikeButtonVisible = json["isLikeButtonVisible"] as? Bool {
        storyStylingBuilder = storyStylingBuilder.setLikeButtonVisibility(isVisible: isLikeButtonVisible)
    }
    if let isShareButtonVisible = json["isShareButtonVisible"] as? Bool {
        storyStylingBuilder = storyStylingBuilder.setShareButtonVisibility(isVisible: isShareButtonVisible)
    }

    if let closeButtonIconName = json["closeButtonIcon"] as? String {
        if let image = UIImage(named: closeButtonIconName) {
            storyStylingBuilder = storyStylingBuilder.setCloseButtonIcon(icon: image)
        }
    }
    if let closeButtonIconName = json["shareButtonIcon"] as? String {
        if let image = UIImage(named: closeButtonIconName) {
            storyStylingBuilder = storyStylingBuilder.setShareButtonIcon(icon: image)
        }
    }
    if let closeButtonIconName = json["likeButtonIcon"] as? String {
        if let image = UIImage(named: closeButtonIconName) {
            storyStylingBuilder = storyStylingBuilder.setLikeButtonIcon(icon: image)
        }
    }

    return configBuilder.setVerticalFeedStyling(
        styling: storyStylingBuilder.build()
    )
}

private func stShareConfig(
    json: NSDictionary,
    configBuilder: inout StorylyVerticalFeedConfig.Builder
) -> StorylyVerticalFeedConfig.Builder {
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
    configBuilder: inout StorylyVerticalFeedConfig.Builder
) -> StorylyVerticalFeedConfig.Builder {
    var productConfigBuilder = StorylyProductConfig.Builder()
    if let isFallbackEnabled = json["isFallbackEnabled"] as? Bool {
        productConfigBuilder = productConfigBuilder.setFallbackAvailability(isEnabled: isFallbackEnabled)
    }
    if let isCartEnabled = json["isCartEnabled"] as? Bool {
        productConfigBuilder = productConfigBuilder.setCartEnabled(isEnabled: isCartEnabled)
    }
    
    if let feedMap = json["productFeed"] as? [String: [NSDictionary]]  {
        var feed: [String: [STRProductItem]] = [:]
        feedMap.forEach { key, value in
            feed[key] = value.map({ createSTRProductItem(productItem: $0) })
        }
        productConfigBuilder = productConfigBuilder.setProductFeed(feed: feed)
    }

    return configBuilder
        .setProductConfig(config: productConfigBuilder
            .build()
        )
}

private func getStorylyLayoutDirection(direction: String?) -> StorylyLayoutDirection {
    switch direction {
        case "ltr": return .LTR
        case "rtl": return .RTL
        default: return .LTR
    }
}

private func getStorylyGroupOrder(groupOrder: String?) -> StorylyVerticalFeedGroupOrder {
    switch groupOrder {
    case "bySeenState":
        return .BySeenState
    default:
        return .Static
    }
}

private func getCustomFont(typeface: NSString?, fontSize: CGFloat, defaultWeight: UIFont.Weight = .regular) -> UIFont {
    if let fontName = typeface?.deletingPathExtension,
       let font = UIFont(name: fontName, size: fontSize) { return font }
    return .systemFont(ofSize: fontSize, weight: defaultWeight)
}
