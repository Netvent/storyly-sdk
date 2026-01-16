import Foundation
import StorylyCore
import StorylySwipeCard

// MARK: - SwipeCard Data Payload Encoding

func encodeSwipeCardDataPayload(_ data: SwipeCardDataPayload) -> [String: Any] {
    return [
        "type": STRWidgetType.swipeCard.description,
        "items": data.items.map { encodeSTRProductItem($0) }
    ]
}

func encodeSwipeCardPayload(_ payload: SwipeCardPayload?) -> [String: Any]? {
    guard let payload = payload else { return nil }
    
    return [
        "card": encodeSwipeCard(payload.card)
    ].compactMapValues { $0 }
}

// MARK: - SwipeCard Encoding

func encodeSwipeCard(_ card: SwipeCard?) -> [String: Any]? {
    guard let card = card else { return nil }
    
    return [
        "actionProducts": card.actionProducts?.map { encodeSTRProductItem($0) }
    ].compactMapValues { $0 }
}


