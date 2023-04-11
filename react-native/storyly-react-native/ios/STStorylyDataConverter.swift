//
//  STStorylyViewHelper.swift
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
    let storyGroupMap: [String : Any?] = [
        "id": storyGroup.uniqueId,
        "title": storyGroup.title,
        "iconUrl": storyGroup.iconUrl?.absoluteString,
        "thematicIconUrls": storyGroup.thematicIconUrls?.mapValues { $0.absoluteString },
        "coverUrl": storyGroup.coverUrl?.absoluteString,
        "index": storyGroup.index,
        "pinned": storyGroup.pinned,
        "seen": storyGroup.seen,
        "stories": storyGroup.stories.map { createStoryMap(story: $0) },
        "type": storyGroup.type.description,
        "momentsUser": (storyGroup.momentsUser != nil) ? [
            "id": storyGroup.momentsUser?.userId,
            "avatarUrl": storyGroup.momentsUser?.avatarURL,
            "username": storyGroup.momentsUser?.username,
        ] : nil
    ]
    return storyGroupMap
}

func createStoryMap(_ story: Story?) -> [String: Any?]? {
    guard let story = story else { return nil }
    return createStoryMap(story: story)
}

func createStoryMap(story: Story) -> [String: Any?] {
    let storyMap: [String : Any?] = [
        "id": story.uniqueId,
        "index": story.index,
        "title": story.title,
        "name": story.name,
        "seen": story.seen,
        "currentTime": story.currentTime,
        "media": [
            "type": story.media.type.rawValue,
            "storyComponentList": story.media.storyComponentList?.map { createStoryComponentMap(storyComponent: $0) },
            "actionUrl": story.media.actionUrl,
            "previewUrl": story.media.previewUrl?.absoluteString,
            "actionUrlList": story.media.actionUrlList
        ] as [String: Any?]
    ]
    return storyMap
}

func createStoryComponentMap(_ storyComponent: StoryComponent?) -> [String: Any?]? {
    guard let storyComponent = storyComponent else { return nil }
    return createStoryComponentMap(storyComponent: storyComponent)
}

func createStoryComponentMap(storyComponent: StoryComponent) -> [String: Any?] {
    switch storyComponent {
        case let storyComponent as StoryQuizComponent: return [
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
            "text": storyComponent.text
        ]
        case let storyComponent as StoryCommentComponent: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "text": storyComponent.text
        ]
        default: return [
            "type": StoryComponentTypeHelper.storyComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
        ]
    }
}
  
func createSTRProductItemMap(product: STRProductItem?) -> [String: Any?] {
    guard let product = product else { return [:] }

    let productMap: [String : Any?] = [
        "productId": product.productId,
        "productGroupId": product.productGroupId,
        "title": product.title,
        "url": product.url,
        "desc": product.desc,
        "price": product.price,
        "salesPrice": product.salesPrice, 
        "currency": product.currency,
        "variants": product.variants?.compactMap { createSTRProductVariantMap(variant: $0) },
        "imageUrls": product.imageUrls.map { $0 }
    ]
    return productMap
}

internal func createSTRProductVariantMap(variant: STRProductVariant) -> [String: Any?] {
    let productVariantMap: [String : Any?] = [
        "name": variant.name,
        "value": variant.value
    ]
    return productVariantMap
}

internal func createSTRProductItem(productItem: NSDictionary) -> STRProductItem {
    return STRProductItem(
        productId: productItem["productId"] as? String ?? "",
        productGroupId: productItem["productGroupId"] as? String ?? "",
        title:productItem["title"] as? String ?? "",
        url: productItem["url"] as? String ?? "",
        description: productItem["desc"] as? String,
        price: Float((productItem["price"] as? Double) ?? 0.0),
        salesPrice: (productItem["salesPrice"] as? NSNumber),
        currency: productItem["currency"] as? String ?? "",
        imageUrls:productItem["imageUrls"] as? [String],
        variants:  createSTRProductVariant(variants: productItem["variants"] as? [NSDictionary] ?? [])
    )
}
 
internal func createSTRProductVariant(variants: [NSDictionary]) -> [STRProductVariant] {
    variants.compactMap { variant in
        STRProductVariant(name: variant["name"] as? String ?? "", value: variant["value"] as? String ?? "")
    }
}
