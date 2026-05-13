//
//  STStorylyDataConverter.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 8.11.2022.
//
import Storyly


func createStoryGroupMap(_ storyGroup: StoryGroup?) -> [String: Any?]? {
    guard let storyGroup = storyGroup else { return nil }
    return createStoryGroupMap(storyGroup: storyGroup)
}
    
func createStoryGroupMap(storyGroup: StoryGroup) -> [String: Any?] {
    return [
        "id": storyGroup.uniqueId,
        "title": storyGroup.title,
        "iconUrl": storyGroup.iconUrl?.absoluteString,
        "index": storyGroup.index,
        "pinned": storyGroup.pinned,
        "seen": storyGroup.seen,
        "stories": storyGroup.stories.map { createStoryMap(story: $0) },
        "type": storyGroup.type.description,
        "name": storyGroup.name,
        "nudge": storyGroup.nudge,
        "style": createStoryGroupStyleMap(storyGroupStyle: storyGroup.style)
    ]
}

func createStoryGroupStyleMap(storyGroupStyle: StoryGroupStyle?) -> [String: Any?]? {
    guard let style = storyGroupStyle else { return nil }
    return [
        "borderUnseenColors": style.borderUnseenColors?.map { $0.toHexString() },
        "textUnseenColor": style.textUnseenColor?.toHexString(),
        "badge": createStoryGroupBadgeStyleMap(badge: style.badge)
    ]
}

func createStoryGroupBadgeStyleMap(badge: StoryGroupBadgeStyle?) -> [String: Any?]? {
    guard let badge = badge else { return nil }
    return [
        "backgroundColor": badge.backgroundColor?.toHexString(),
        "textColor": badge.textColor?.toHexString(),
        "endTime": badge.endTime,
        "template": badge.template,
        "text": badge.text,
    ]
}

func createStoryMap(_ story: Story?) -> [String: Any?]? {
    guard let story = story else { return nil }
    return createStoryMap(story: story)
}

func createStoryMap(story: Story) -> [String: Any?] {
    return [
        "id": story.uniqueId,
        "index": story.index,
        "title": story.title,
        "name": story.name,
        "seen": story.seen,
        "currentTime": story.currentTime,
        "previewUrl": story.previewUrl?.absoluteString,
        "actionUrl": story.actionUrl,
        "storyComponentList": story.storyComponentList?.map { createStoryComponentMap(storyComponent: $0)},
        "actionProducts": story.actionProducts?.map { product in createSTRProductItemMap(product: product) }
    ]
}

func createStoryComponentMap(_ storyComponent: StoryComponent?) -> [String: Any?]? {
    guard let storyComponent = storyComponent else { return nil }
    return createStoryComponentMap(storyComponent: storyComponent)
}

func createStoryComponentMap(storyComponent: StoryComponent) -> [String: Any?] {
    switch storyComponent {
        case let storyComponent as StoryButtonComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
            "text": storyComponent.text,
            "actionUrl": storyComponent.actionUrl,
            "products": storyComponent.products?.map { product in createSTRProductItemMap(product: product) }   
        ]
        case let storyComponent as StorySwipeComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
            "text": storyComponent.text,
            "actionUrl": storyComponent.actionUrl,
            "products": storyComponent.products?.map { product in createSTRProductItemMap(product: product) }
        ]
        case let storyComponent as StoryProductTagComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
            "actionUrl": storyComponent.actionUrl,
            "products": storyComponent.products?.map { product in createSTRProductItemMap(product: product) }
        ]
        case let storyComponent as StoryProductCardComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
            "text": storyComponent.text,
            "actionUrl": storyComponent.actionUrl,
            "products": storyComponent.products?.map { product in createSTRProductItemMap(product: product) }
        ]
        case let storyComponent as StoryProductCatalogComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
            "actionUrlList": storyComponent.actionUrlList,
            "products": storyComponent.products?.map { product in createSTRProductItemMap(product: product) }
        ]
        case let storyComponent as StoryQuizComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "title": storyComponent.title,
            "options": storyComponent.options,
            "rightAnswerIndex": storyComponent.rightAnswerIndex,
            "selectedOptionIndex": storyComponent.selectedOptionIndex,
            "customPayload": storyComponent.customPayload
        ]
        case let storyComponent as StoryImageQuizComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "title": storyComponent.title,
            "options": storyComponent.options,
            "rightAnswerIndex": storyComponent.rightAnswerIndex,
            "selectedOptionIndex": storyComponent.selectedOptionIndex,
            "customPayload": storyComponent.customPayload
        ]
        case let storyComponent as StoryPollComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "title": storyComponent.title,
            "options": storyComponent.options,
            "selectedOptionIndex": storyComponent.selectedOptionIndex,
            "customPayload": storyComponent.customPayload
        ]
        case let storyComponent as StoryEmojiComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "emojiCodes": storyComponent.emojiCodes,
            "selectedEmojiIndex": storyComponent.selectedEmojiIndex,
            "customPayload": storyComponent.customPayload
        ]
        case let storyComponent as StoryRatingComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "emojiCode": storyComponent.emojiCode,
            "rating": storyComponent.rating,
            "customPayload": storyComponent.customPayload
        ]
        case let storyComponent as StoryPromoCodeComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "text": storyComponent.text,
            "customPayload": storyComponent.customPayload
        ]
        case let storyComponent as StoryCommentComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "text": storyComponent.text,
            "customPayload": storyComponent.customPayload
        ]
        default: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload
        ]
    }
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
        "variants": product.variants?.compactMap { createSTRProductVariantMap(variant: $0) },
        "imageUrls": product.imageUrls.map { $0 },
        "wishlist": product.wishlist
    ]
}

internal func createSTRProductVariantMap(variant: STRProductVariant) -> [String: Any?] {
    return [
        "name": variant.name,
        "value": variant.value,
        "key": variant.key
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
        ctaText: productItem?["ctaText"] as? String,
        wishlist:productItem?["wishlist"] as? Bool ?? false
    )
}

internal func createSTRProductVariant(variants: [NSDictionary]) -> [STRProductVariant] {
    variants.compactMap { variant in
        STRProductVariant(
            name: variant["name"] as? String ?? "", 
            value: variant["value"] as? String ?? "",
            key: variant["key"] as? String ?? ""
        )
    }
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

internal func createSTRProductInformationMap(productInfo: STRProductInformation?) -> [String: Any?] {
    guard let productInfo = productInfo else { return [:] }
    return [
        "productId": productInfo.productId,
        "productGroupId": productInfo.productGroupId
    ]
}

internal func createSTRCartItem(cartItemMap: NSDictionary) -> STRCartItem {
    return STRCartItem(
        item: createSTRProductItem(productItem: cartItemMap["item"] as? NSDictionary),
        quantity: cartItemMap["quantity"] as? Int ?? 0,
        totalPrice: cartItemMap["totalPrice"] as? NSNumber,
        oldTotalPrice: cartItemMap["oldTotalPrice"] as? NSNumber
    )
}

internal func createSTRCart(cartMap: NSDictionary) -> STRCart {
    return STRCart(
        items: (cartMap["items"] as? [NSDictionary])?.map { createSTRCartItem(cartItemMap: $0) } ?? [],
        totalPrice: cartMap["totalPrice"] as? Float ?? 0.0,
        oldTotalPrice: cartMap["oldTotalPrice"] as? NSNumber,
        currency: cartMap["currency"] as? String ?? ""
    )
}
