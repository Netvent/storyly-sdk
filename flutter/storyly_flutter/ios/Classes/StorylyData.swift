@_spi(InternalFramework) 
import Storyly
import UIKit

internal class StorylyInitMapper {
    
    internal func getStorylyInit(
        json: [String: Any]
    ) -> StorylyInit? {
        guard let storylyInitJson = json["storylyInit"] as? [String: Any] else { return nil }
        guard let storylyId = storylyInitJson["storylyId"] as? String else { return nil }
        guard let storyGroupStylingJson = json["storyGroupStyling"] as? [String: Any] else { return nil }
        guard let storyBarStylingJson = json["storyBarStyling"] as? [String: Any] else { return nil }
        guard let storyStylingJson = json["storyStyling"] as? NSDictionary else { return nil }
        guard let shareConfigJson = json["storyShareConfig"] as? NSDictionary else { return nil }
        guard let productConfigJson = json["storyProductConfig"] as? NSDictionary else { return nil }
        
        var storylyConfigBuilder = StorylyConfig.Builder()
        storylyConfigBuilder = stStorylyInit(json: storylyInitJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stStorylyGroupStyling(json: storyGroupStylingJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stStoryBarStyling(json: storyBarStylingJson, configBuilder: &storylyConfigBuilder)
        storylyConfigBuilder = stStoryStyling(json: storyStylingJson, configBuilder: &storylyConfigBuilder )
        storylyConfigBuilder = stShareConfig(json: shareConfigJson, configBuilder: &storylyConfigBuilder )
        storylyConfigBuilder = stProductConfig(json: productConfigJson, configBuilder: &storylyConfigBuilder )
        
        let storylyConfig = storylyConfigBuilder.build()
        storylyConfig.setFramework(framework: "flutter")

        return StorylyInit(
            storylyId: storylyId,
            config: storylyConfig
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
            .setUserData(data: json["userProperty"] as? [String: String] ?? [:])
            .setLayoutDirection(direction: getStorylyLayoutDirection(direction: json["storylyLayoutDirection"] as? String))
            .setLocale(locale: json["storylyLocale"] as? String)
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
    
    private func stShareConfig(
        json: NSDictionary,
        configBuilder: inout StorylyConfig.Builder
    ) -> StorylyConfig.Builder {
        var shareConfigBuilder = StorylyShareConfig.Builder()
        if let url = json["storylyShareUrl"] as? String {
            shareConfigBuilder = shareConfigBuilder.setShareUrl(url: url)
        }
        if let facebookAppID = json["storylyFacebookAppID"] as? String {
            shareConfigBuilder = shareConfigBuilder.setFacebookAppID(id: facebookAppID)
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
        if let feedMap = json["productFeed"] as? [String: [[String: Any?]]]  {
            var feed: [String: [STRProductItem]] = [:]
            feedMap.forEach { key, value in
                feed[key] = value.map({ createSTRProductItem(product: $0) })
            }
            productConfigBuilder = productConfigBuilder.setProductFeed(feed: feed)
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
}

internal func createStoryGroupMap(storyGroup: StoryGroup) -> [String: Any?] {
    return [
        "id": storyGroup.uniqueId,
        "title": storyGroup.title,
        "index": storyGroup.index,
        "seen": storyGroup.seen,
        "iconUrl": storyGroup.iconUrl?.absoluteString,
        "stories": storyGroup.stories.map { story in createStoryMap(story: story)},
        "pinned": storyGroup.pinned,
        "type": storyGroup.type.rawValue,
        "name": storyGroup.name,
        "nudge": storyGroup.nudge
    ]
}

internal func createStoryMap(story: Story) -> [String: Any?] {
    return [
        "id": story.uniqueId,
        "title": story.title,
        "name": story.name,
        "index": story.index,
        "seen": story.seen,
        "currentTime": story.currentTime,
        "previewUrl": story.previewUrl?.absoluteString,
        "actionUrl": story.actionUrl,
        "storyComponentList": story.storyComponentList?.map { createStoryComponentMap(storyComponent:$0) },
        "actionProducts": (story.actionProducts ?? []).map { createSTRProductItemMap(product: $0) }
    ]
}

internal func createSTRProductItemMap(product: STRProductItem?) -> [String: Any?] {
    guard let product = product else { return [:] }
    return [
        "productId" : product.productId,
        "productGroupId" : product.productGroupId,
        "title" : product.title,
        "url": product.url,
        "desc" : product.desc,
        "price" : product.price,
        "salesPrice" : product.salesPrice,
        "currency" : product.currency,
        "imageUrls" : product.imageUrls,
        "ctaText": product.ctaText,
        "variants" : product.variants?.compactMap { createSTRProductVariantMap(variant: $0) }
    ]
}

internal func createSTRProductVariantMap(variant: STRProductVariant) -> [String: Any?] {
    return [
        "name" : variant.name,
        "value" : variant.value,
        "key": variant.key
    ]
}

internal func createSTRProductInformationMap(productInfo: STRProductInformation) -> [String: Any?] {
    return [
        "productId": productInfo.productId,
        "productGroupId": productInfo.productGroupId
    ]
}

internal func createSTRProductItem(product: [String: Any?]?) -> STRProductItem {
    return STRProductItem(
        productId: product?["productId"] as? String ?? "",
        productGroupId: product?["productGroupId"] as? String ?? "",
        title: product?["title"] as? String ?? "",
        url: product?["url"] as? String ?? "",
        description: product?["desc"] as? String ?? "",
        price: Float((product?["price"] as! Double)),
        salesPrice: product?["salesPrice"] as? NSNumber,
        currency: product?["currency"] as? String ?? "",
        imageUrls: product?["imageUrls"] as? [String],
        variants: createSTRProductVariant(variants: product?["variants"] as? [[String: Any?]]),
        ctaText: product?["ctaText"] as? String
    )
}

internal func createSTRProductVariant(variants: [[String: Any?]]?) -> [STRProductVariant] {
    return variants?.map {
        STRProductVariant(
            name: $0["name"] as? String ?? "",
            value: $0["value"] as? String ?? "",
            key: $0["key"] as? String ?? ""
        )
    } ?? []
}

internal func createSTRCartMap(cart: STRCart?) -> [String: Any?]? {
    guard let cart = cart else { return nil }
    return [
        "items": cart.items.map { createSTRCartItemMap(cartItem: $0) },
        "oldTotalPrice": cart.oldTotalPrice,
        "totalPrice": cart.totalPrice,
        "currency": cart.currency
    ]
}

internal func createSTRCartItemMap(cartItem: STRCartItem?) -> [String: Any?] {
    guard let cartItem = cartItem else { return [:] }
    return [
        "item": createSTRProductItemMap(product: cartItem.item),
        "quantity": cartItem.quantity,
        "oldTotalPrice": cartItem.oldTotalPrice,
        "totalPrice": cartItem.totalPrice
    ]
}

internal func createSTRCartItem(cartItemMap: [String : Any?]) -> STRCartItem {
    return STRCartItem(
        item: createSTRProductItem(product: cartItemMap["item"] as? [String: Any?]),
        quantity: cartItemMap["quantity"] as? Int ?? 0,
        totalPrice: cartItemMap["totalPrice"] as? NSNumber,
        oldTotalPrice: cartItemMap["oldTotalPrice"] as? NSNumber
    )
}

internal func createSTRCart(cartMap: [String : Any?]) -> STRCart {
    return STRCart(
        items: (cartMap["items"] as? [[String : Any?]])?.map { createSTRCartItem(cartItemMap: $0) } ?? [],
        totalPrice: cartMap["totalPrice"] as? Float ?? 0.0,
        oldTotalPrice: cartMap["oldTotalPrice"] as? NSNumber,
        currency: cartMap["currency"] as? String ?? ""
    )
}

internal func createStoryComponentMap(storyComponent: StoryComponent) -> [String: Any?] {
    switch storyComponent {
    case let buttonActionComponent as StoryButtonComponent:
        return [
            "type": "buttonaction",
            "id": buttonActionComponent.id,
            "customPayload": buttonActionComponent.customPayload,
            "text": buttonActionComponent.text,
            "actionUrl": buttonActionComponent.actionUrl,
            "products": (buttonActionComponent.products ?? []).compactMap { createSTRProductItemMap(product: $0) }
        ]
    case let swipeButtonActionComponent as StorySwipeComponent:
        return [
            "type": "swipeaction",
            "id": swipeButtonActionComponent.id,
            "customPayload": swipeButtonActionComponent.customPayload,
            "text": swipeButtonActionComponent.text,
            "actionUrl": swipeButtonActionComponent.actionUrl,
            "products": (swipeButtonActionComponent.products ?? []).compactMap { createSTRProductItemMap(product: $0) }
        ]
    case let productTagComponent as StoryProductTagComponent:
        return [
            "type": "producttag",
            "id": productTagComponent.id,
            "customPayload": productTagComponent.customPayload,
            "actionUrl": productTagComponent.actionUrl,
            "products": (productTagComponent.products ?? []).compactMap { createSTRProductItemMap(product: $0) }
        ]
    case let productCardComponent as StoryProductCardComponent:
        return [
            "type": "productcard",
            "id": productCardComponent.id,
            "customPayload": productCardComponent.customPayload,
            "text": productCardComponent.text,
            "actionUrl": productCardComponent.actionUrl,
            "products": (productCardComponent.products ?? []).compactMap { createSTRProductItemMap(product: $0) }
        ]
    case let productCatalogComponent as StoryProductCatalogComponent:
        return [
            "type": "productcatalog",
            "id": productCatalogComponent.id,
            "customPayload": productCatalogComponent.customPayload,
            "actionUrlList": productCatalogComponent.actionUrlList ?? [],
            "products": (productCatalogComponent.products ?? []).compactMap { createSTRProductItemMap(product: $0) }
        ]
    case let quizComponent as StoryQuizComponent:
        return [
            "type": "quiz",
            "id": quizComponent.id,
            "customPayload": quizComponent.customPayload,
            "title": quizComponent.title,
            "options": quizComponent.options,
            "rightAnswerIndex": quizComponent.rightAnswerIndex?.intValue,
            "selectedOptionIndex": quizComponent.selectedOptionIndex,
        ]
    case let pollComponent as StoryPollComponent:
        return [
            "type": "poll",
            "id": pollComponent.id,
            "customPayload": pollComponent.customPayload,
            "title": pollComponent.title,
            "options": pollComponent.options,
            "selectedOptionIndex": pollComponent.selectedOptionIndex,
        ]
    case let emojiComponent as StoryEmojiComponent:
        return [
            "type": "emoji",
            "id": emojiComponent.id,
            "customPayload": emojiComponent.customPayload,
            "emojiCodes": emojiComponent.emojiCodes,
            "selectedEmojiIndex": emojiComponent.selectedEmojiIndex,
        ]
    case let ratingComponent as StoryRatingComponent:
        return [
            "type": "rating",
            "id": ratingComponent.id,
            "customPayload": ratingComponent.customPayload,
            "emojiCode": ratingComponent.emojiCode,
            "rating": ratingComponent.rating,
        ]
    case let promoCodeComponent as StoryPromoCodeComponent:
        return [
            "type": "promocode",
            "id": promoCodeComponent.id,
            "customPayload": promoCodeComponent.customPayload,
            "text": promoCodeComponent.text
        ]
    case let commentComponent as StoryCommentComponent:
        return [
            "type": "comment",
            "id": commentComponent.id,
            "customPayload": commentComponent.customPayload,
            "text": commentComponent.text
        ]
    default:
        return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
        ]
        
    }
}
