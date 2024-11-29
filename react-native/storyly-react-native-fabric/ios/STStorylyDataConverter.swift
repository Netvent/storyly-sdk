//
//  STStorylyDataConverter.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 8.11.2022.
//
import Storyly

func decodePayload(raw: String) -> [String: Any?]? {
    guard let data = raw.data(using: .utf8),
          let map = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any?] else {
        return nil
    }
    return map
}

func encodeEvent(json: [String: Any?]?) -> String? {
    guard let json = json,
          let rawMap = try? JSONSerialization.data(withJSONObject: json, options: []),
          let rawMapString = String(data: rawMap, encoding: .utf8) else { return nil }
    return rawMapString
}
    
func createStoryGroupMap(storyGroup: StoryGroup?) -> [String: Any?]? {
    guard let storyGroup = storyGroup else { return nil }
    return [
        "id": storyGroup.uniqueId,
        "title": storyGroup.title,
        "iconUrl": storyGroup.iconUrl?.absoluteString,
        "pinned": storyGroup.pinned,
        "index": storyGroup.index,
        "seen": storyGroup.seen,
        "stories": storyGroup.stories.map { createStoryMap(story: $0) },
        "type": storyGroup.type.description,
        "name": storyGroup.name,
        "nudge": storyGroup.nudge,
        "style": createStoryGroupStyleMap(style: storyGroup.style)
    ]
}

func createStoryGroupStyleMap(style: StoryGroupStyle?) -> [String: Any?]? {
    guard let style = style else { return nil }
    return [
        "borderUnseenColors": style.borderUnseenColors?.map { $0.toHexString() },
        "textUnseenColor": style.textUnseenColor?.toHexString(),
        "badge": createStoryGroupStyleBadgeMap(badge: style.badge)
    ]
}

func createStoryGroupStyleBadgeMap(badge: StoryGroupBadgeStyle?) -> [String: Any?]? {
    guard let badge = badge else { return nil }
    return [
        "backgroundColor": badge.backgroundColor?.toHexString(),
        "textColor": badge.textColor?.toHexString(),
        "endTime": badge.endTime,
        "template": badge.template,
        "text": badge.text
    ]
}

func createStoryMap(story: Story?) -> [String: Any?]? {
    guard let story = story else { return nil }
    return [
        "id": story.uniqueId,
        "index": story.index,
        "title": story.title,
        "name": story.name,
        "seen": story.seen,
        "currentTime": story.currentTime,
        "products": story.actionProducts?.map { createSTRProductItemMap(product: $0) },
        "actionUrl": story.actionUrl,
        "previewUrl": story.previewUrl?.absoluteString,
        "storyComponentList": story.storyComponentList?.map { createStoryComponentMap(storyComponent: $0) },
        "actionProducts": story.actionProducts?.map { createSTRProductItemMap(product: $0) }
    ]
}

func createStoryComponentMap(storyComponent: StoryComponent?) -> [String: Any?]? {
    guard let storyComponent = storyComponent else { return nil }

    switch storyComponent.type {
    case .ButtonAction:
        guard let buttonComponent = storyComponent as? StoryButtonComponent else { return nil }
        return [
            "type": "buttonaction",
            "id": buttonComponent.id,
            "customPayload": buttonComponent.customPayload,
            "text": buttonComponent.text,
            "actionUrl": buttonComponent.actionUrl,
            "products": buttonComponent.products?.map { createSTRProductItemMap(product: $0) }
        ]
    case .SwipeAction:
        guard let swipeComponent = storyComponent as? StorySwipeComponent else { return nil }
        return [
            "type": "swipeaction",
            "id": swipeComponent.id,
            "customPayload": swipeComponent.customPayload,
            "text": swipeComponent.text,
            "actionUrl": swipeComponent.actionUrl,
            "products": swipeComponent.products?.map { createSTRProductItemMap(product: $0) }
        ]
    case .ProductTag:
        guard let ptagComponent = storyComponent as? StoryProductTagComponent else { return nil }
        return [
            "type": "producttag",
            "id": ptagComponent.id,
            "customPayload": ptagComponent.customPayload,
            "actionUrl": ptagComponent.actionUrl,
            "products": ptagComponent.products?.map { createSTRProductItemMap(product: $0) }
        ]
    case .ProductCard:
        guard let pcardComponent = storyComponent as? StoryProductCardComponent  else { return nil }
        return [
            "type": "productcard",
            "id": pcardComponent.id,
            "customPayload": pcardComponent.customPayload,
            "text": pcardComponent.text,
            "actionUrl": pcardComponent.actionUrl,
            "products": pcardComponent.products?.map { createSTRProductItemMap(product: $0) }
        ]
    case .ProductCatalog:
        guard let catalogComponent = storyComponent as? StoryProductCatalogComponent  else { return nil }
        return [
            "type": "productcatalog",
            "id": catalogComponent.id,
            "customPayload": catalogComponent.customPayload,
            "actionUrlList": catalogComponent.actionUrlList?.compactMap { $0 },
            "products": catalogComponent.products?.map { createSTRProductItemMap(product: $0) }
        ]
    case .Quiz:
        guard let quizComponent = storyComponent as? StoryQuizComponent  else { return nil }
        return [
            "type": "quiz",
            "id": quizComponent.id,
            "customPayload": quizComponent.customPayload,
            "title": quizComponent.title,
            "options": quizComponent.options,
            "rightAnswerIndex": quizComponent.rightAnswerIndex,
            "selectedOptionIndex": quizComponent.selectedOptionIndex
        ]
    case .Poll:
        guard let pollComponent = storyComponent as? StoryPollComponent  else { return nil }
        return [
            "type": "poll",
            "id": pollComponent.id,
            "customPayload": pollComponent.customPayload,
            "title": pollComponent.title,
            "options": pollComponent.options,
            "selectedOptionIndex": pollComponent.selectedOptionIndex
        ]
    case .Emoji:
        guard let emojiComponent = storyComponent as? StoryEmojiComponent  else { return nil }
        return [
            "type": "emoji",
            "id": emojiComponent.id,
            "customPayload": emojiComponent.customPayload,
            "emojiCodes": emojiComponent.emojiCodes,
            "selectedEmojiIndex": emojiComponent.selectedEmojiIndex
        ]
    case .Rating:
        guard let ratingComponent = storyComponent as? StoryRatingComponent  else { return nil }
        return [
            "type": "rating",
            "id": ratingComponent.id,
            "customPayload": ratingComponent.customPayload,
            "emojiCode": ratingComponent.emojiCode,
            "rating": ratingComponent.rating
        ]
    case .PromoCode:
        guard let promoCodeComponent = storyComponent as? StoryPromoCodeComponent  else { return nil }
        return [
            "type": "promocode",
            "id": promoCodeComponent.id,
            "customPayload": promoCodeComponent.customPayload,
            "text": promoCodeComponent.text
        ]
    case .Comment:
        guard let commentComponent = storyComponent as? StoryCommentComponent else { return nil }
        return [
            "type": "comment",
            "id": commentComponent.id,
            "customPayload": commentComponent.customPayload,
            "text": commentComponent.text
        ]
    default:
        return [
            "id": storyComponent.id,
            "type": storyComponent.type.stringValue.lowercased(),
            "customPayload": storyComponent.customPayload
        ]
    }
}

internal func createSTRProductInformationMap(productInfo: STRProductInformation) -> [String: Any?] {
    return [
        "productId": productInfo.productId,
        "productGroupId": productInfo.productGroupId
    ]
}

func createSTRProductItemMap(product: STRProductItem?) -> [String: Any?] {
    guard let product = product else { return [:] }
    return [
        "productId": product.productId,
        "productGroupId": product.productGroupId,
        "title": product.title,
        "url": product.url,
        "desc": product.desc,
        "price": product.price,
        "salesPrice": product.salesPrice,
        "currency": product.currency,
        "imageUrls": product.imageUrls,
        "variants": product.variants?.map { createSTRProductVariantMap(variant: $0) },
        "ctaText": product.ctaText
    ]
}

func createSTRProductVariantMap(variant: STRProductVariant) -> [String: Any?] {
    return [
        "name": variant.name,
        "value": variant.value,
        "key": variant.key
    ]
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

internal func createSTRProductItem(productItem: NSDictionary?) -> STRProductItem {
    return STRProductItem(
        productId: productItem?["productId"] as? String ?? "",
        productGroupId: productItem?["productGroupId"] as? String ?? "",
        title: productItem?["title"] as? String ?? "",
        url: productItem?["url"] as? String ?? "",
        description: productItem?["desc"] as? String,
        price: Float((productItem?["price"] as? Double) ?? 0.0),
        salesPrice: (productItem?["salesPrice"] as? NSNumber),
        currency: productItem?["currency"] as? String ?? "",
        imageUrls: productItem?["imageUrls"] as? [String],
        variants:  createSTRProductVariant(variants: productItem?["variants"] as? [NSDictionary] ?? []),
        ctaText: productItem?["ctaText"] as? String
    )
}

internal func createSTRProductVariant(variants: [NSDictionary]) -> [STRProductVariant] {
    variants.compactMap { variant in
        STRProductVariant(
            name: variant["name"] as? String ?? "",
            value: variant["value"] as? String ?? "",
            key: variant["key"] as? String ?? "")
    }
}


internal func createSTRCart(cartMap: NSDictionary?) -> STRCart? {
    guard let cartMap = cartMap else { return nil }
    return STRCart(
        items: (cartMap["items"] as? [NSDictionary])?.map { createSTRCartItem(cartItemMap: $0) } ?? [],
        totalPrice: cartMap["totalPrice"] as? Float ?? 0.0,
        oldTotalPrice: cartMap["oldTotalPrice"] as? NSNumber,
        currency: cartMap["currency"] as? String ?? ""
    )
}

internal func createSTRCartItem(cartItemMap: NSDictionary) -> STRCartItem {
    return STRCartItem(
        item: createSTRProductItem(productItem: cartItemMap["item"] as? NSDictionary),
        quantity: cartItemMap["quantity"] as? Int ?? 0,
        totalPrice: cartItemMap["totalPrice"] as? NSNumber,
        oldTotalPrice: cartItemMap["oldTotalPrice"] as? NSNumber
    )
}
