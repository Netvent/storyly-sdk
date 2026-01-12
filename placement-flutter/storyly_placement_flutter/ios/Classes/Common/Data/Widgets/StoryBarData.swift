import Foundation
import StorylyCore
import StorylyPlacement
import StorylyStoryBar

// MARK: - StoryBar Data Payload Encoding

func encodeStoryBarDataPayload(_ data: StoryBarDataPayload) -> [String: Any] {
    return [
        "type": STRWidgetType.storyBar.description,
        "items": data.items.compactMap { encodeStoryGroupItem($0) }
    ]
}

func encodeStoryBarPayload(_ payload: StoryBarPayload?) -> [String: Any]? {
    guard let payload = payload else { return nil }
    
    return [
        "component": encodeStoryBarComponent(payload.component),
        "group": encodeStoryGroupItem(payload.group),
        "story": encodeStory(payload.story)
    ].compactMapValues { $0 }
}

// MARK: - Story Group Encoding

func encodeStoryGroupItem(_ group: StoryGroup?) -> [String: Any]? {
    guard let group = group else { return nil }
    
    return ([
        "id": group.uniqueId,
        "title": group.title,
        "name": group.name,
        "index": group.index,
        "seen": group.seen,
        "iconUrl": group.iconUrl?.absoluteString,
        "iconVideoUrl": group.iconVideoUrl?.absoluteString,
        "iconVideoThumbnailUrl": group.iconVideoThumbnailUrl?.absoluteString,
        "pinned": group.pinned,
        "type": group.type.description,
        "style": encodeStoryGroupStyle(group.style),
        "nudge": group.nudge,
        "stories": group.stories.compactMap { encodeStory($0) }
    ] as [String: Any?]).compactMapValues { $0 }
}

func encodeStoryGroupStyle(_ style: StoryGroupStyle?) -> [String: Any]? {
    guard let style = style else { return nil }
    
    return ([
        "badge": encodeStoryGroupBadgeStyle(style.badge),
        "borderUnseenColors": style.borderUnseenColors?.map { $0.toHexString() },
        "textUnseenColor": style.textUnseenColor?.toHexString()
    ] as [String: Any?]).compactMapValues { $0 }
}

func encodeStoryGroupBadgeStyle(_ badgeStyle: StoryGroupBadgeStyle?) -> [String: Any]? {
    guard let badgeStyle = badgeStyle else { return nil }
    
    return ([
        "text": badgeStyle.text,
        "textColor": badgeStyle.textColor?.toHexString(),
        "backgroundColor": badgeStyle.backgroundColor?.toHexString(),
        "endTime": badgeStyle.endTime,
        "template": badgeStyle.template
    ] as [String: Any?]).compactMapValues { $0 }
}

// MARK: - Story Encoding

func encodeStory(_ story: Story?) -> [String: Any]? {
    guard let story = story else { return nil }
    
    return ([
        "id": story.uniqueId,
        "title": story.title,
        "name": story.name,
        "index": story.index,
        "seen": story.seen,
        "previewUrl": story.previewUrl?.absoluteString,
        "actionUrl": story.actionUrl,
        "actionProducts": story.actionProducts?.map { encodeSTRProductItem($0) },
        "currentTime": story.currentTime,
        "storyComponentList": story.storyComponentList?.compactMap { encodeStoryBarComponent($0) }
    ] as [String: Any?]).compactMapValues { $0 }
}

// MARK: - Story Bar Component Encoding

func encodeStoryBarComponent(_ component: StoryBarComponent?) -> [String: Any]? {
    guard let component = component else { return nil }
    
    var result: [String: Any] = [
        "id": component.id,
        "type": component.type.get(),
        "customPayload": component.customPayload as Any
    ]
    
    // Add component-specific fields
    switch component {
    case let quiz as StoryQuizComponent:
        result["title"] = quiz.title
        result["options"] = quiz.options
        result["rightAnswerIndex"] = quiz.rightAnswerIndex
        result["selectedOptionIndex"] = quiz.selectedOptionIndex
        
    case let imageQuiz as StoryImageQuizComponent:
        result["title"] = imageQuiz.title
        result["options"] = imageQuiz.options
        result["rightAnswerIndex"] = imageQuiz.rightAnswerIndex
        result["selectedOptionIndex"] = imageQuiz.selectedOptionIndex
        
    case let poll as StoryPollComponent:
        result["title"] = poll.title
        result["options"] = poll.options
        result["selectedOptionIndex"] = poll.selectedOptionIndex
        
    case let emoji as StoryEmojiComponent:
        result["emojiCodes"] = emoji.emojiCodes
        result["selectedEmojiIndex"] = emoji.selectedEmojiIndex
        
    case let rating as StoryRatingComponent:
        result["emojiCode"] = rating.emojiCode
        result["rating"] = rating.rating
        
    case let promoCode as StoryPromoCodeComponent:
        result["text"] = promoCode.text
        
    case let comment as StoryCommentComponent:
        result["text"] = comment.text
        
    case let swipe as StorySwipeComponent:
        result["text"] = swipe.text
        result["actionUrl"] = swipe.actionUrl
        result["products"] = swipe.products?.map { encodeSTRProductItem($0) }
        
    case let button as StoryButtonComponent:
        result["text"] = button.text
        result["actionUrl"] = button.actionUrl
        result["products"] = button.products?.map { encodeSTRProductItem($0) }
        
    case let productTag as StoryProductTagComponent:
        result["actionUrl"] = productTag.actionUrl
        result["products"] = productTag.products?.map { encodeSTRProductItem($0) }
        
    case let productCard as StoryProductCardComponent:
        result["text"] = productCard.text
        result["actionUrl"] = productCard.actionUrl
        result["products"] = productCard.products?.map { encodeSTRProductItem($0) }
        
    case let productCatalog as StoryProductCatalogComponent:
        result["actionUrlList"] = productCatalog.actionUrlList
        result["products"] = productCatalog.products?.map { encodeSTRProductItem($0) }
        
    default:
        break
    }
    
    return result.compactMapValues { $0 }
}


