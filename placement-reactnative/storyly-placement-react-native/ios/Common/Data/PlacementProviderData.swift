import Foundation
import StorylyCore
import StorylyPlacement
import StorylyBanner
import StorylyStoryBar
import StorylyVideoFeed
import StorylySwipeCard

// MARK: - STRDataPayload Encoding

func encodeDataPayload(_ data: STRDataPayload) -> [String: Any] {
    switch data {
    case let storyBarData as StoryBarDataPayload:
        return encodeStoryBarDataPayload(storyBarData)
    case let videoFeedData as VideoFeedDataPayload:
        return encodeVideoFeedDataPayload(videoFeedData)
    case let bannerData as BannerDataPayload:
        return encodeBannerDataPayload(bannerData)
    case let swipeCardData as SwipeCardDataPayload:
        return encodeSwipeCardDataPayload(swipeCardData)
    default:
        return [:]
    }
}

