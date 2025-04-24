@_spi(InternalFramework) 
import Storyly
import UIKit

internal class VerticalFeedInitMapper {

    func getStorylyInit(json: [String: Any]) -> StorylyVerticalFeedInit? {
        guard let storylyInitJson = json["storylyInit"] as? [String: Any],
              let storylyId = storylyInitJson["storylyId"] as? String else {
            return nil
        }

        let storyGroupStylingJson = json["verticalFeedGroupStyling"] as? [String: Any]
        let storyBarStylingJson = json["verticalFeedBarStyling"] as? [String: Any]
        let storyStylingJson = json["verticalFeedCustomization"] as? [String: Any]
        let storyShareConfigJson = json["verticalFeedItemShareConfig"] as? [String: Any]
        let storyProductConfigJson = json["verticalFeedItemProductConfig"] as? [String: Any]

        var storylyConfigBuilder = StorylyVerticalFeedConfig.Builder()
        storylyConfigBuilder = stStorylyInit(json: storylyInitJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stStorylyGroupStyling(json: storyGroupStylingJson, configBuilder: storylyConfigBuilder)
        storylyConfigBuilder = stStoryBarStyling(json: storyBarStylingJson, configBuilder: storylyConfigBuilder)
        storylyConfigBuilder = stStoryStyling(json: storyStylingJson, configBuilder: storylyConfigBuilder)
        storylyConfigBuilder = stShareConfig(json: storyShareConfigJson, configBuilder: storylyConfigBuilder)
        storylyConfigBuilder = stProductConfig(json: storyProductConfigJson, configBuilder: storylyConfigBuilder)

        let storylyConfig = storylyConfigBuilder.build()
        storylyConfig.setFramework(framework: "flutter")

        return StorylyVerticalFeedInit(
            storylyId: storylyId,
            config: storylyConfig
        )
    }

    private func stStorylyInit(json: [String: Any], configBuilder: inout StorylyVerticalFeedConfig.Builder) -> StorylyVerticalFeedConfig.Builder {
        if let segmentsData = json["storylySegments"] as? [String] { configBuilder = configBuilder.setLabels(labels: Set(segmentsData)) }
        return configBuilder
            .setCustomParameter(parameter: json["customParameter"] as? String)
            .setTestMode(isTest: (json["storylyIsTestMode"] as? Bool) ?? false)
            .setUserData(data: json["userProperty"] as? [String: String] ?? [:])
            .setLayoutDirection(direction: getStorylyLayoutDirection(direction: json["storylyLayoutDirection"] as? String))
            .setLocale(locale: json["storylyLocale"] as? String)
    }

    private func stStorylyGroupStyling(json: [String: Any]?, configBuilder: StorylyVerticalFeedConfig.Builder) -> StorylyVerticalFeedConfig.Builder {
        guard let json = json else { return configBuilder }
        var groupStylingBuilder = StorylyVerticalFeedGroupStyling.Builder()
        if let iconBackgroundColor = json["iconBackgroundColor"] as? String {
            groupStylingBuilder = groupStylingBuilder.setIconBackgroundColor(color: UIColor(hexString: iconBackgroundColor))
        }
        if let iconCornerRadius = json["iconCornerRadius"] as? CGFloat {
            groupStylingBuilder = groupStylingBuilder.setIconCornerRadius(radius: iconCornerRadius)
        }
        if let iconHeight = json["iconHeight"] as? CGFloat {
            groupStylingBuilder = groupStylingBuilder.setIconHeight(height: iconHeight)
        }
        if let textColor = json["textColor"] as? String {
            groupStylingBuilder = groupStylingBuilder.setTextColor(UIColor(hexString: textColor))
        }
        if let titleFont = json["titleFont"] as? String {
            let fontSize = json["titleTextSize"] as? CGFloat ?? 12
            groupStylingBuilder = groupStylingBuilder.setFont(font: getCustomFont(typeface: titleFont as NSString, fontSize: fontSize))
        }
        if let titleVisible = json["titleVisible"] as? Bool {
            groupStylingBuilder = groupStylingBuilder.setTitleVisibility(isVisible: titleVisible)
        }
        
        if let groupOrder = json["groupOrder"] as? String,
           let order = getVerticalFeedGroupOrder(order: groupOrder) {
            groupStylingBuilder = groupStylingBuilder.setGroupOrder(order: order)
        }
        if let typeIndicatorVisible = json["typeIndicatorVisible"] as? Bool {
            groupStylingBuilder = groupStylingBuilder.setTypeIndicatorVisibility(typeIndicatorVisible)
        }
        if let minLikeCountToShowIcon = json["minLikeCountToShowIcon"] as? Int {
            groupStylingBuilder = groupStylingBuilder.setMinLikeCountToShowIcon(minLikeCountToShowIcon)
        }
        if let minImpressionCountToShowIcon = json["minImpressionCountToShowIcon"] as? Int {
            groupStylingBuilder = groupStylingBuilder.setMinImpressionCountToShowIcon(minImpressionCountToShowIcon)
        }
        if let impressionIcon = json["impressionIcon"] as? String,
           let icon = UIImage(named: impressionIcon) {
            groupStylingBuilder = groupStylingBuilder.setImpressionIcon(icon)
        }
        if let likeIcon = json["likeIcon"] as? String,
           let icon = UIImage(named: likeIcon) {
            groupStylingBuilder = groupStylingBuilder.setImpressionIcon(icon)
        }

        return configBuilder
            .setVerticalFeedGroupStyling(styling: groupStylingBuilder.build())
    }

    private func stStoryBarStyling(json: [String: Any]?, configBuilder: StorylyVerticalFeedConfig.Builder) -> StorylyVerticalFeedConfig.Builder {
        guard let json = json else { return configBuilder }
        var barStyling = StorylyVerticalFeedBarStyling.Builder()
        if let sections = json["sections"] as? Int {
            barStyling = barStyling.setSection(count: sections)
        }
        if let horizontalEdgePadding = json["horizontalEdgePadding"] as? CGFloat {
            barStyling = barStyling.setHorizontalEdgePadding(padding: horizontalEdgePadding)
        }
        if let verticalEdgePadding = json["verticalEdgePadding"] as? CGFloat {
            barStyling = barStyling.setVerticalEdgePadding(padding: verticalEdgePadding)
        }
        if let horizontalPaddingBetweenItems = json["horizontalPaddingBetweenItems"] as? CGFloat {
            barStyling = barStyling.setHorizontalPaddingBetweenItems(padding: horizontalPaddingBetweenItems)
        }
        if let verticalPaddingBetweenItems = json["verticalPaddingBetweenItems"] as? CGFloat {
            barStyling = barStyling.setVerticalPaddingBetweenItems(padding: verticalPaddingBetweenItems)
        }
        return configBuilder
            .setVerticalFeedBarStyling(styling: barStyling.build())
    }

    private func stStoryStyling(json: [String: Any]?, configBuilder: StorylyVerticalFeedConfig.Builder) -> StorylyVerticalFeedConfig.Builder {
        guard let json = json else { return configBuilder }
        var customization = StorylyVerticalFeedCustomization.Builder()
        if let titleFont = json["titleFont"] as? String,
           let font = getCustomFont(typeface: titleFont, fontSize: 14){
            customization = customization.setTitleFont(font: font)
        }
        if let interactiveFont = json["interactiveFont"] as? String,
           let font = getCustomFont(typeface: interactiveFont, fontSize: 14) {
            customization = customization.setInteractiveFont(font: font)
        }
        if let progressBarColor = json["progressBarColor"] as? [String] {
            customization = customization.setProgressBarColor(colors: progressBarColor.map { UIColor(hexString: $0) })
        }
        if let isTitleVisible = json["isTitleVisible"] as? Bool {
            customization = customization.setTitleVisibility(isVisible: isTitleVisible)
        }
        if let isLikeButtonVisible = json["isLikeButtonVisible"] as? Bool {
            customization = customization.setLikeButtonVisibility(isVisible: isLikeButtonVisible)
        }
        if let isCloseButtonVisible = json["isCloseButtonVisible"] as? Bool {
            customization = customization.setCloseButtonVisibility(isVisible: isCloseButtonVisible)
        }
        if let closeButtonIcon = json["closeButtonIcon"] as? String {
            customization = customization.setCloseButtonIcon(icon: UIImage(named: closeButtonIcon))
        }
        if let likeButtonIcon = json["likeButtonIcon"] as? String {
            customization = customization.setLikeButtonIcon(icon: UIImage(named: likeButtonIcon))
        }
        if let shareButtonIcon = json["shareButtonIcon"] as? String {
            customization = customization.setShareButtonIcon(icon: UIImage(named: shareButtonIcon))
        }

        return configBuilder
            .setVerticalFeedStyling(styling: customization.build())
    }

    private func stShareConfig(json: [String: Any]?, configBuilder: StorylyVerticalFeedConfig.Builder) -> StorylyVerticalFeedConfig.Builder {
        guard let json = json else { return configBuilder }
        var shareConfigBuilder = StorylyShareConfig.Builder()
        if let storylyShareUrl = json["storylyShareUrl"] as? String {
            shareConfigBuilder = shareConfigBuilder.setShareUrl(url: storylyShareUrl)
        }
        if let storylyFacebookAppID = json["storylyFacebookAppID"] as? String {
            shareConfigBuilder = shareConfigBuilder.setFacebookAppID(id: storylyFacebookAppID)
        }
        return configBuilder
            .setShareConfig(config: shareConfigBuilder.build())
    }

    private func stProductConfig(json: [String: Any]?, configBuilder: StorylyVerticalFeedConfig.Builder) -> StorylyVerticalFeedConfig.Builder {
        guard let json = json else { return configBuilder }
        var productConfigBuilder = StorylyProductConfig.Builder()
        if let isFallbackEnabled = json["isFallbackEnabled"] as? Bool {
            productConfigBuilder = productConfigBuilder.setFallbackAvailability(isEnabled: isFallbackEnabled)
        }
        if let isCartEnabled = json["isCartEnabled"] as? Bool {
            productConfigBuilder = productConfigBuilder.setCartEnabled(isEnabled: isCartEnabled)
        }
        if let productFeed = json["productFeed"] as? [String: [[String: Any]]] {
            let feed = productFeed.mapValues { productList in
                productList.map { createSTRProductItem(product: $0) }
            }
            productConfigBuilder = productConfigBuilder.setProductFeed(feed: feed)
        }

        return configBuilder
            .setProductConfig(config: productConfigBuilder.build())
    }

    private func getVerticalFeedGroupOrder(order: String?) -> StorylyVerticalFeedGroupOrder? {
        switch order {
        case "static":
            return .Static
        case "bySeenState":
            return .BySeenState
        default:
            return nil
        }
    }
    
    private func getStorylyLayoutDirection(direction: String?) -> StorylyLayoutDirection {
        switch direction {
        case "ltr": return .LTR
        case "rtl": return .RTL
        default: return .LTR
        }
    }
}

internal func createStoryGroupMap(storyGroup: VerticalFeedGroup?) -> [String: Any?]? {
    guard let storyGroup = storyGroup else { return nil }
    return [
        "id": storyGroup.uniqueId,
        "title": storyGroup.title,
        "index": storyGroup.index,
        "seen": storyGroup.seen,
        "iconUrl": storyGroup.iconUrl?.absoluteString,
        "feedList": storyGroup.feedList.map { story in createStoryMap(story: story) },
        "pinned": storyGroup.pinned,
        "type": storyGroup.type.rawValue,
        "name": storyGroup.name,
        "nudge": storyGroup.nudge
    ]
}

internal func createStoryMap(story: VerticalFeedItem?) -> [String: Any?]? {
    guard let story = story else { return nil }
    return [
        "id": story.uniqueId,
        "title": story.title,
        "name": story.name,
        "index": story.index,
        "seen": story.seen,
        "currentTime": story.currentTime,
        "previewUrl": story.previewUrl?.absoluteString,
        "actionUrl": story.actionUrl,
        "verticalFeedItemComponentList": story.verticalFeedItemComponentList?.map { component in createStoryComponentMap(storyComponent: component) },
        "actionProducts": (story.actionProducts ?? []).map { product in createSTRProductItemMap(product: product) }
    ]
}

internal func createStoryComponentMap(storyComponent: VerticalFeedItemComponent?) -> [String: Any?]? {
    guard let storyComponent = storyComponent else { return nil }
    switch storyComponent {
    case let buttonComponent as VerticalFeedButtonComponent:
        return [
            "type": "buttonaction",
            "id": buttonComponent.id,
            "customPayload": buttonComponent.customPayload,
            "text": buttonComponent.text,
            "actionUrl": buttonComponent.actionUrl,
            "products": (buttonComponent.products ?? []).compactMap { createSTRProductItemMap(product: $0) }
        ]
    case let swipeComponent as VerticalFeedSwipeComponent:
        return [
            "type": "swipeaction",
            "id": swipeComponent.id,
            "customPayload": swipeComponent.customPayload,
            "text": swipeComponent.text,
            "actionUrl": swipeComponent.actionUrl,
            "products": (swipeComponent.products ?? []).compactMap { createSTRProductItemMap(product: $0) }
        ]
    case let productTagComponent as VerticalFeedProductTagComponent:
        return [
            "type": "producttag",
            "id": productTagComponent.id,
            "customPayload": productTagComponent.customPayload,
            "actionUrl": productTagComponent.actionUrl,
            "products": (productTagComponent.products ?? []).compactMap { createSTRProductItemMap(product: $0) }
        ]
    case let productCardComponent as VerticalFeedProductCardComponent:
        return [
            "type": "productcard",
            "id": productCardComponent.id,
            "customPayload": productCardComponent.customPayload,
            "text": productCardComponent.text,
            "actionUrl": productCardComponent.actionUrl,
            "products": (productCardComponent.products ?? []).compactMap { createSTRProductItemMap(product: $0) }
        ]
    case let productCatalogComponent as VerticalFeedProductCatalogComponent:
        return [
            "type": "productcatalog",
            "id": productCatalogComponent.id,
            "customPayload": productCatalogComponent.customPayload,
            "actionUrlList": productCatalogComponent.actionUrlList ?? [],
            "products": (productCatalogComponent.products ?? []).compactMap { createSTRProductItemMap(product: $0) }
        ]
    case let quizComponent as VerticalFeedQuizComponent:
        return [
            "type": "quiz",
            "id": quizComponent.id,
            "customPayload": quizComponent.customPayload,
            "title": quizComponent.title,
            "options": quizComponent.options,
            "rightAnswerIndex": quizComponent.rightAnswerIndex?.intValue,
            "selectedOptionIndex": quizComponent.selectedOptionIndex,
        ]
    case let imageQuizComponent as VerticalFeedImageQuizComponent:
        return [
            "type": "imagequiz",
            "id": imageQuizComponent.id,
            "customPayload": imageQuizComponent.customPayload,
            "title": imageQuizComponent.title,
            "options": imageQuizComponent.options ?? [],
            "rightAnswerIndex": imageQuizComponent.rightAnswerIndex?.intValue,
            "selectedOptionIndex": imageQuizComponent.selectedOptionIndex,
        ]
    case let pollComponent as VerticalFeedPollComponent:
        return [
            "type": "poll",
            "id": pollComponent.id,
            "customPayload": pollComponent.customPayload,
            "title": pollComponent.title,
            "options": pollComponent.options,
            "selectedOptionIndex": pollComponent.selectedOptionIndex
        ]
    case let emojiComponent as VerticalFeedEmojiComponent:
        return [
            "type": "emoji",
            "id": emojiComponent.id,
            "customPayload": emojiComponent.customPayload,
            "emojiCodes": emojiComponent.emojiCodes,
            "selectedEmojiIndex": emojiComponent.selectedEmojiIndex
        ]
    case let ratingComponent as VerticalFeedRatingComponent:
        return [
            "type": "rating",
            "id": ratingComponent.id,
            "customPayload": ratingComponent.customPayload,
            "emojiCode": ratingComponent.emojiCode,
            "rating": ratingComponent.rating
        ]
    case let promoCodeComponent as VerticalFeedPromoCodeComponent:
        return [
            "type": "promocode",
            "id": promoCodeComponent.id,
            "customPayload": promoCodeComponent.customPayload,
            "text": promoCodeComponent.text
        ]
    case let commentComponent as VerticalFeedCommentComponent:
        return [
            "type": "comment",
            "id": commentComponent.id,
            "customPayload": commentComponent.customPayload,
            "text": commentComponent.text
        ]
    default:
        return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType: storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
        ]
        
    }
}
