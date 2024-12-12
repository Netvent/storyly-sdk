//
//  STStorylyDataConverter.swift
//  storyly-react-native
//
//  Created by Haldun Melih Fadillioglu on 8.11.2022.
//
import Storyly


func createVerticalFeedGroupMap(_ storyGroup: VerticalFeedGroup?) -> [String: Any?]? {
    guard let storyGroup = storyGroup else { return nil }
    return createVerticalFeedGroupMap(storyGroup: storyGroup)
}
    
func createVerticalFeedGroupMap(storyGroup: VerticalFeedGroup) -> [String: Any?] {
    return [
        "id": storyGroup.uniqueId,
        "title": storyGroup.title,
        "iconUrl": storyGroup.iconUrl?.absoluteString,
        "index": storyGroup.index,
        "pinned": storyGroup.pinned,
        "seen": storyGroup.seen,
        "stories": storyGroup.feedList.map { createVerticalFeedItemMap(story: $0) },
        "type": storyGroup.type.description,
        "name": storyGroup.name,
        "nudge": storyGroup.nudge,
        "style": createVerticalFeedGroupStyleMap(storyGroupStyle: storyGroup.style)
    ]
}

func createVerticalFeedGroupStyleMap(storyGroupStyle: VerticalFeedGroupStyle?) -> [String: Any?]? {
    guard let style = storyGroupStyle else { return nil }
    return [
        "borderUnseenColors": style.borderUnseenColors?.map { $0.toHexString() },
        "textUnseenColor": style.textUnseenColor?.toHexString(),
        "badge": createVerticalFeedGroupBadgeStyleMap(badge: style.badge)
    ]
}

func createVerticalFeedGroupBadgeStyleMap(badge: VerticalFeedGroupBadgeStyle?) -> [String: Any?]? {
    guard let badge = badge else { return nil }
    return [
        "backgroundColor": badge.backgroundColor?.toHexString(),
        "textColor": badge.textColor?.toHexString(),
        "endTime": badge.endTime,
        "template": badge.template,
        "text": badge.text,
    ]
}

func createVerticalFeedItemMap(_ story: VerticalFeedItem?) -> [String: Any?]? {
    guard let story = story else { return nil }
    return createVerticalFeedItemMap(story: story)
}

func createVerticalFeedItemMap(story: VerticalFeedItem) -> [String: Any?] {
    return [
        "id": story.uniqueId,
        "index": story.index,
        "title": story.title,
        "name": story.name,
        "seen": story.seen,
        "currentTime": story.currentTime,
        "previewUrl": story.previewUrl?.absoluteString,
        "actionUrl": story.actionUrl,
        "storyComponentList": story.verticalFeedItemComponentList?.map { createVerticalFeedItemComponentMap(storyComponent: $0)},
        "products": story.actionProducts?.map { product in createSTRProductItemMap(product: product) }
    ]
}

func createVerticalFeedItemComponentMap(_ storyComponent: VerticalFeedItemComponent?) -> [String: Any?]? {
    guard let storyComponent = storyComponent else { return nil }
    return createVerticalFeedItemComponentMap(storyComponent: storyComponent)
}

func createVerticalFeedItemComponentMap(storyComponent: VerticalFeedItemComponent) -> [String: Any?] {
    switch storyComponent {
        case let storyComponent as VerticalFeedButtonComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
            "text": storyComponent.text,
            "actionUrl": storyComponent.actionUrl,
            "products": storyComponent.products?.map { product in createSTRProductItemMap(product: product) }
        ]
        case let storyComponent as VerticalFeedSwipeComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
            "text": storyComponent.text,
            "actionUrl": storyComponent.actionUrl,
            "products": storyComponent.products?.map { product in createSTRProductItemMap(product: product) }
        ]
        case let storyComponent as VerticalFeedProductTagComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
            "actionUrl": storyComponent.actionUrl,
            "products": storyComponent.products?.map { product in createSTRProductItemMap(product: product) }
        ]
        case let storyComponent as VerticalFeedProductCardComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
            "text": storyComponent.text,
            "actionUrl": storyComponent.actionUrl,
            "products": storyComponent.products?.map { product in createSTRProductItemMap(product: product) }
        ]
        case let storyComponent as VerticalFeedProductCatalogComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
            "customPayload": storyComponent.customPayload,
            "actionUrlList": storyComponent.actionUrlList,
            "products": storyComponent.products?.map { product in createSTRProductItemMap(product: product) }
        ]
        case let verticalFeedComponent as VerticalFeedQuizComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:verticalFeedComponent.type).lowercased(),
            "id": verticalFeedComponent.id,
            "title": verticalFeedComponent.title,
            "options": verticalFeedComponent.options,
            "rightAnswerIndex": verticalFeedComponent.rightAnswerIndex,
            "selectedOptionIndex": verticalFeedComponent.selectedOptionIndex,
            "customPayload": verticalFeedComponent.customPayload
        ]
        case let verticalFeedComponent as VerticalFeedPollComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:verticalFeedComponent.type).lowercased(),
            "id": verticalFeedComponent.id,
            "title": verticalFeedComponent.title,
            "options": verticalFeedComponent.options,
            "selectedOptionIndex": verticalFeedComponent.selectedOptionIndex,
            "customPayload": verticalFeedComponent.customPayload
        ]
        case let verticalFeedComponent as VerticalFeedEmojiComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:storyComponent.type).lowercased(),
            "id": verticalFeedComponent.id,
            "emojiCodes": verticalFeedComponent.emojiCodes,
            "selectedEmojiIndex": verticalFeedComponent.selectedEmojiIndex,
            "customPayload": verticalFeedComponent.customPayload
        ]
        case let verticalFeedComponent as VerticalFeedRatingComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:storyComponent.type).lowercased(),
            "id": verticalFeedComponent.id,
            "emojiCode": verticalFeedComponent.emojiCode,
            "rating": verticalFeedComponent.rating,
            "customPayload": verticalFeedComponent.customPayload
        ]
        case let verticalFeedComponent as VerticalFeedPromoCodeComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:storyComponent.type).lowercased(),
            "id": verticalFeedComponent.id,
            "text": verticalFeedComponent.text
        ]
        case let verticalFeedComponent as VerticalFeedCommentComponent: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:storyComponent.type).lowercased(),
            "id": verticalFeedComponent.id,
            "text": verticalFeedComponent.text
        ]
        default: return [
            "type": VerticalFeedItemComponentTypeHelper.verticalFeedItemComponentName(componentType:storyComponent.type).lowercased(),
            "id": storyComponent.id,
        ]
    }
}

