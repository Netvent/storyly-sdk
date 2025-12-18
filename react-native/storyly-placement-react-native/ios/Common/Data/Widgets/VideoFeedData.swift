import Foundation
import StorylyCore
import StorylyVideoFeed

// MARK: - VideoFeed Data Payload Encoding

func encodeVideoFeedDataPayload(_ data: VideoFeedDataPayload) -> [String: Any] {
    return [
        "type": STRWidgetType.videoFeed.description,
        "items": data.items.map { encodeVideoFeedGroup($0) }.compactMap { $0 }
    ]
}

func encodeVideoFeedPayload(_ payload: VideoFeedPayload?) -> [String: Any]? {
    guard let payload = payload else { return nil }
    
    return [
        "component": encodeVideoFeedComponent(payload.component),
        "group": encodeVideoFeedGroup(payload.group),
        "feedItem": encodeVideoFeedItem(payload.feedItem)
    ].compactMapValues { $0 }
}

// MARK: - VideoFeed Group Encoding

func encodeVideoFeedGroup(_ group: VideoFeedGroup?) -> [String: Any]? {
    guard let group = group else { return nil }
    
    return ([
        "id": group.uniqueId,
        "title": group.title,
        "name": group.name,
        "iconUrl": group.iconUrl?.absoluteString,
        "index": group.index,
        "seen": group.seen,
        "type": group.type.description,
        "pinned": group.pinned,
        "nudge": group.nudge,
        "iconVideoUrl": group.iconVideoUrl?.absoluteString,
        "iconVideoThumbnailUrl": group.iconVideoThumbnailUrl?.absoluteString,
        "feedList": group.feedList.map { encodeVideoFeedItem($0) }.compactMap { $0 }
    ] as [String: Any?]).compactMapValues { $0 }
}

// MARK: - VideoFeed Item Encoding

func encodeVideoFeedItem(_ item: VideoFeedItem?) -> [String: Any]? {
    guard let item = item else { return nil }
    
    return ([
        "id": item.uniqueId,
        "title": item.title,
        "name": item.name,
        "index": item.index,
        "seen": item.seen,
        "previewUrl": item.previewUrl?.absoluteString,
        "actionUrl": item.actionUrl,
        "actionProducts": item.actionProducts?.map { encodeSTRProductItem($0) },
        "currentTime": item.currentTime,
        "feedItemComponentList": item.videoFeedItemComponentList
    ] as [String: Any?]).compactMapValues { $0 }
}

// MARK: - VideoFeed Component Encoding

func encodeVideoFeedComponent(_ component: VideoFeedComponent?) -> [String: Any]? {
    guard let component = component else { return nil }
    
    var result: [String: Any] = [
        "id": component.id,
        "type": component.type.get(),
        "customPayload": component.customPayload as Any
    ]
    
    // Add component-specific fields
    switch component {
    case let quiz as VideoFeedQuizComponent:
        result["title"] = quiz.title
        result["options"] = quiz.options
        result["rightAnswerIndex"] = quiz.rightAnswerIndex
        result["selectedOptionIndex"] = quiz.selectedOptionIndex
        
    case let imageQuiz as VideoFeedImageQuizComponent:
        result["title"] = imageQuiz.title
        result["options"] = imageQuiz.options
        result["rightAnswerIndex"] = imageQuiz.rightAnswerIndex
        result["selectedOptionIndex"] = imageQuiz.selectedOptionIndex
        
    case let poll as VideoFeedPollComponent:
        result["title"] = poll.title
        result["options"] = poll.options
        result["selectedOptionIndex"] = poll.selectedOptionIndex
        
    case let emoji as VideoFeedEmojiComponent:
        result["emojiCodes"] = emoji.emojiCodes
        result["selectedEmojiIndex"] = emoji.selectedEmojiIndex
        
    case let rating as VideoFeedRatingComponent:
        result["emojiCode"] = rating.emojiCode
        result["rating"] = rating.rating
        
    case let promoCode as VideoFeedPromoCodeComponent:
        result["text"] = promoCode.text
        
    case let comment as VideoFeedCommentComponent:
        result["text"] = comment.text
        
    case let swipe as VideoFeedSwipeComponent:
        result["text"] = swipe.text
        result["actionUrl"] = swipe.actionUrl
        result["products"] = swipe.products?.map { encodeSTRProductItem($0) }
        
    case let button as VideoFeedButtonComponent:
        result["text"] = button.text
        result["actionUrl"] = button.actionUrl
        result["products"] = button.products?.map { encodeSTRProductItem($0) }
        
    case let productTag as VideoFeedProductTagComponent:
        result["actionUrl"] = productTag.actionUrl
        result["products"] = productTag.products?.map { encodeSTRProductItem($0) }
        
    case let productCard as VideoFeedProductCardComponent:
        result["text"] = productCard.text
        result["actionUrl"] = productCard.actionUrl
        result["products"] = productCard.products?.map { encodeSTRProductItem($0) }
        
    case let productCatalog as VideoFeedProductCatalogComponent:
        result["actionUrlList"] = productCatalog.actionUrlList
        result["products"] = productCatalog.products?.map { encodeSTRProductItem($0) }
    default:
        break
    }
    
    return result.compactMapValues { $0 }
}


