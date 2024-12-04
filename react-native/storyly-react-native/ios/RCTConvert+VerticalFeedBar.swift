//
//  RCTConvert+Storyly.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 25.10.2022.
//
import Storyly

@objc(VerticalFeedBarBundle)
class VerticalFeedBarBundle: NSObject {
    let storylyView: StorylyVerticalFeedBarView
    
    init(storylyView: StorylyVerticalFeedBarView) {
        self.storylyView = storylyView
    }
}

extension RCTConvert {
    @objc(setVerticalFeedBarBundle:)
    static func setVerticalFeedBarBundle(json: NSDictionary) -> VerticalFeedBarBundle? {
        print("STR:RCTConvert+Extension:stStorylyBundle(json:\(json))")
        
        guard let storylyInitJson = json["storylyInit"] as? NSDictionary else { return nil }
        guard let storylyId = storylyInitJson["storylyId"] as? String else { return nil }
        guard let storyGroupStylingJson = json["storyGroupStyling"] as? NSDictionary else { return nil }
        guard let storyGroupViewFactoryJson = json["storyGroupViewFactory"] as? NSDictionary else { return nil }
        guard let storyBarStylingJson = json["storyBarStyling"] as? NSDictionary else { return nil }
        guard let storyStylingJson = json["storyStyling"] as? NSDictionary else { return nil }
        guard let storyShareConfig = json["storyShareConfig"] as? NSDictionary else { return nil }
        guard let storyProductConfig = json["storyProductConfig"] as? NSDictionary else { return nil }

        var storylyConfigBuilder = StorylyVerticalFeedConfig.Builder()
        storylyConfigBuilder = stVerticalFeedInit(json: storylyInitJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stVerticalFeedGroupStyling(json: storyGroupStylingJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stVerticalFeedBarStyling(json: storyBarStylingJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stVerticalFeedCustomization(json: storyStylingJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stShareConfig(json: storyShareConfig, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stProductConfig(json: storyProductConfig, configBuilder: &storylyConfigBuilder)

        let storylyView = StorylyVerticalFeedBarView()
        storylyView.storylyVerticalFeedInit = StorylyVerticalFeedInit(
            storylyId: storylyId,
            config: storylyConfigBuilder
                .build()
        )
        return VerticalFeedBarBundle(storylyView: storylyView)
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
    if let iconBackgroundColorJson = json["iconBackgroundColor"] as? NSNumber {
        groupStylingBuilder = groupStylingBuilder.setIconBackgroundColor(color: RCTConvert.uiColor(iconBackgroundColorJson))
    }
    return configBuilder
        .setVerticalFeedGroupStyling(
            styling: groupStylingBuilder
                .setIconHeight(height: json["iconHeight"] as? CGFloat ?? 80)
                .setIconCornerRadius(radius: json["iconCornerRadius"] as? CGFloat ?? 40)
                .setFont(font: getCustomFont(typeface: json["titleFont"] as? NSString, fontSize: CGFloat(json["titleTextSize"] as? Int ?? 12)))
                .setTitleVisibility(isVisible: json["titleVisible"] as? Bool ?? true)
                .build()
        )
}

private func stVerticalFeedBarStyling(
    json: NSDictionary,
    configBuilder: inout StorylyVerticalFeedConfig.Builder
) -> StorylyVerticalFeedConfig.Builder {
    return configBuilder
        .setVerticalFeedBarStyling(
            styling: StorylyVerticalFeedBarStyling.Builder()
                .setSection(count: (json["sections"] as? Int ) ?? 1)
                .setHorizontalEdgePadding(padding: (json["horizontalEdgePadding"] as? CGFloat) ?? 4)
                .setVerticalEdgePadding(padding: (json["verticalEdgePadding"] as? CGFloat) ?? 4)
                .setHorizontalPaddingBetweenItems(padding: (json["horizontalPaddingBetweenItems"] as? CGFloat) ?? 8)
                .setVerticalPaddingBetweenItems(padding: (json["verticalPaddingBetweenItems"] as? CGFloat) ?? 8)
                .build()
        )
}

private func stVerticalFeedCustomization(
    json: NSDictionary,
    configBuilder: inout StorylyVerticalFeedConfig.Builder
) -> StorylyVerticalFeedConfig.Builder {
    var storyStylingBuilder = StorylyVerticalFeedCustomization.Builder()
    if let progressBarColorJson = json["progressBarColor"] as? NSArray {
        storyStylingBuilder = storyStylingBuilder.setProgressBarColor(colors: RCTConvert.uiColorArray(progressBarColorJson))
    }
    return configBuilder
        .setVerticalFeedStyling(styling: storyStylingBuilder
            .setTitleFont(font: getCustomFont(typeface: json["titleFont"] as? NSString, fontSize: 14, defaultWeight: .semibold))
            .setInteractiveFont(font: getCustomFont(typeface: json["interactiveFont"] as? NSString, fontSize: 14, defaultWeight: .regular))
            .setTitleVisibility(isVisible: json["isTitleVisible"] as? Bool ?? true)
            .setCloseButtonVisibility(isVisible: json["isCloseButtonVisible"] as? Bool ?? true)
            .setCloseButtonIcon(icon: UIImage(named: json["closeButtonIcon"] as? String))
            .setShareButtonIcon(icon: UIImage(named: json["shareButtonIcon"] as? String))
            .build()
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

private func getCustomFont(typeface: NSString?, fontSize: CGFloat, defaultWeight: UIFont.Weight = .regular) -> UIFont {
    if let fontName = typeface?.deletingPathExtension,
       let font = UIFont(name: fontName, size: fontSize) { return font }
    return .systemFont(ofSize: fontSize, weight: defaultWeight)
}
