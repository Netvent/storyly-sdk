import Foundation
import StorylyPlacement
import StorylyCore
import StorylyBanner
import StorylyStoryBar
import StorylyVideoFeed
import StorylySwipeCard
import StorylyCanvas


// MARK: - STRPayload Encoding

func encodeSTRPayload(_ payload: STRPayload) -> [String: Any] {
    switch payload {
    case let storyBarPayload as StoryBarPayload:
        return encodeStoryBarPayload(storyBarPayload) ?? [:]
    case let videoFeedPayload as VideoFeedPayload:
        return encodeVideoFeedPayload(videoFeedPayload) ?? [:]
    case let bannerPayload as BannerPayload:
        return encodeBannerPayload(bannerPayload) ?? [:]
    case let swipeCardPayload as SwipeCardPayload:
        return encodeSwipeCardPayload(swipeCardPayload) ?? [:]
    case let canvasPayload as CanvasPayload:
        return encodeCanvasPayload(canvasPayload) ?? [:]
    default:
        return [:]
    }
}

// MARK: - STREventPayload Encoding

func encodeSTREventPayload(_ payload: STREventPayload) -> [String: Any] {
    let baseMap: [String: Any] = [
        "event": payload.baseEvent.getType()
    ]
    
    var addition: [String: Any] = [:]
    switch payload {
    case let storyBarEvent as StoryBarEventPayload:
        addition = encodeStoryBarPayload(storyBarEvent.payload) ?? [:]
    case let videoFeedEvent as VideoFeedEventPayload:
        addition = encodeVideoFeedPayload(videoFeedEvent.payload) ?? [:]
    case let bannerEvent as BannerEventPayload:
        addition = encodeBannerPayload(bannerEvent.payload) ?? [:]
    case let swipeCardEvent as SwipeCardEventPayload:
        addition = encodeSwipeCardPayload(swipeCardEvent.payload) ?? [:]
    case let canvasEvent as CanvasEventPayload:
        addition = encodeCanvasPayload(canvasEvent.payload) ?? [:]
    default:
        break
    }
    
    return baseMap.merging(addition) { (_, new) in new }
}

// MARK: - STRErrorPayload Encoding

func encodeSTRErrorPayload(_ payload: STRErrorPayload) -> [String: Any] {
    return [
        "event": payload.baseError.getType(),
        "message": payload.message
    ]
}

// MARK: - Widget Controller Encoding

func encodeWidgetController(_ controller: STRWidgetController, widgetMap: inout [String: WeakReference<STRWidgetController>]) -> [String: String] {
    return [
        "type": controller.getType().description,
        "viewId": updateWidgetMapKey(controller, widgetMap: &widgetMap)
    ]
}

func updateWidgetMapKey(_ controller: STRWidgetController, widgetMap: inout [String: WeakReference<STRWidgetController>]) -> String {
    widgetMap = widgetMap.filter { $0.value.value != nil }
    
    if let existingKey = widgetMap.first(where: { $0.value.value === controller })?.key {
        return existingKey
    }
    
    let newKey = UUID().uuidString
    widgetMap[newKey] = WeakReference(value: controller)
    return newKey
}

// MARK: - WeakReference Helper

class WeakReference<T: AnyObject> {
    weak var value: T?
    
    init(value: T) {
        self.value = value
    }
}

