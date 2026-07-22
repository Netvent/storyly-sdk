//
//  SegmentEventMapper.swift
//  StorylyTwilioIntegrationSample
//
//  Builds a Segment `track` properties dictionary from the objects that
//  Storyly hands back in the `storylyEvent` delegate callback.
//
//  Segment's Track spec: https://www.twilio.com/docs/segment/connections/spec/track
//  Properties are a free-form dictionary describing the action. Here we keep the
//  natural shape of the Storyly objects: the story group, story, and interactive
//  component each become a nested sub-dictionary, and repeated objects (products,
//  variants, colors) become nested arrays. Everything stays JSON-serializable.
//
//  Goal: full coverage of the public instance properties Storyly exposes.
//  Optional values are only written when present, so the map stays clean.
//

import Foundation
import UIKit
import Storyly

enum SegmentEventMapper {

    // MARK: - Entry point

    /// Assembles all available context from the `storylyEvent` callback into a
    /// nested properties dictionary.
    ///
    /// The `event` parameter is optional and defaults to `nil` so existing call
    /// sites that only pass the story context keep compiling. Pass it to include
    /// the event name/index in the properties as well.
    ///
    /// Shape:
    /// ```
    /// {
    ///   "event": "StoryQuizAnswered",
    ///   "event_raw_value": 20,
    ///   "story_group": { ..., "style": { "badge": { ... } } },
    ///   "story":       { ..., "action_products": [ { ..., "variants": [ ... ] } ] },
    ///   "component":   { ..., "products": [ ... ] }
    /// }
    /// ```
    static func properties(event: StorylyEvent? = nil,
                           storyGroup: StoryGroup?,
                           story: Story?,
                           storyComponent: StoryComponent?) -> [String: Any] {
        var props: [String: Any] = [:]

        if let event = event { props.merge(eventProperties(event)) { _, new in new } }
        if let storyGroup = storyGroup { props["story_group"] = storyGroupMap(storyGroup) }
        if let story = story { props["story"] = storyMap(story) }
        if let storyComponent = storyComponent { props["component"] = componentMap(storyComponent) }

        return props
    }

    /// Assembles a cart-related product event (from `storylyUpdateCartEvent`)
    /// into a nested properties dictionary.
    ///
    /// - Parameters:
    ///   - event: The cart event (e.g. StoryProductCartAdded, StoryProductAdded).
    ///   - cart: The current cart snapshot, if available.
    ///   - change: The single cart item being added/updated/removed, if available.
    static func cartProperties(event: StorylyEvent,
                               cart: STRCart?,
                               change: STRCartItem?) -> [String: Any] {
        var props = eventProperties(event)
        if let cart = cart { props["cart"] = cartMap(cart) }
        if let change = change { props["change"] = cartItemMap(change) }
        return props
    }

    /// Assembles a wishlist-related product event (from
    /// `storylyUpdateWishlistEvent`) into a nested properties dictionary.
    ///
    /// - Parameters:
    ///   - event: The wishlist event (e.g. StoryWishlistAdded, StoryWishlistRemoved).
    ///   - item: The product being added to / removed from the wishlist, if available.
    static func wishlistProperties(event: StorylyEvent,
                                   item: STRProductItem?) -> [String: Any] {
        var props = eventProperties(event)
        if let item = item { props["product"] = productMap(item) }
        return props
    }

    // MARK: - Story group

    private static func storyGroupMap(_ storyGroup: StoryGroup) -> [String: Any] {
        var map: [String: Any] = [
            "id": storyGroup.uniqueId,
            "title": storyGroup.title,
            "index": storyGroup.index,
            "seen": storyGroup.seen,
            "pinned": storyGroup.pinned,
            "nudge": storyGroup.nudge,
            "type": storyGroup.type.description,
            "story_count": storyGroup.stories.count
        ]

        if let name = storyGroup.name { map["name"] = name }
        if let url = storyGroup.iconUrl?.absoluteString { map["icon_url"] = url }
        if let url = storyGroup.iconVideoUrl?.absoluteString { map["icon_video_url"] = url }
        if let url = storyGroup.iconVideoThumbnailUrl?.absoluteString { map["icon_video_thumbnail_url"] = url }
        if let style = styleMap(storyGroup.style) { map["style"] = style }

        return map
    }

    private static func styleMap(_ style: StoryGroupStyle?) -> [String: Any]? {
        guard let style = style else { return nil }

        var map: [String: Any] = [:]
        if let colors = style.borderUnseenColors { map["border_unseen_colors"] = colors.map(hexString(from:)) }
        if let color = style.textUnseenColor { map["text_unseen_color"] = hexString(from: color) }
        if let badge = badgeMap(style.badge) { map["badge"] = badge }

        return map.isEmpty ? nil : map
    }

    private static func badgeMap(_ badge: StoryGroupBadgeStyle?) -> [String: Any]? {
        guard let badge = badge else { return nil }

        var map: [String: Any] = [:]
        if let text = badge.text { map["text"] = text }
        if let color = badge.textColor { map["text_color"] = hexString(from: color) }
        if let color = badge.backgroundColor { map["background_color"] = hexString(from: color) }
        if let endTime = badge.endTime { map["end_time"] = endTime.doubleValue }
        if let template = badge.template { map["template"] = template }

        return map.isEmpty ? nil : map
    }

    // MARK: - Story

    private static func storyMap(_ story: Story) -> [String: Any] {
        var map: [String: Any] = [
            "id": story.uniqueId,
            "title": story.title,
            "index": story.index,
            "seen": story.seen,
            "current_time": story.currentTime
        ]

        if let name = story.name { map["name"] = name }
        if let actionUrl = story.actionUrl { map["action_url"] = actionUrl }
        if let previewUrl = story.previewUrl?.absoluteString { map["preview_url"] = previewUrl }
        if let components = story.storyComponentList { map["component_count"] = components.count }
        if let products = productMaps(story.actionProducts) { map["action_products"] = products }

        return map
    }

    // MARK: - Interactive components

    /// Builds the base component fields, then casts to each concrete type and
    /// merges in its type-specific fields (including attached products).
    private static func componentMap(_ component: StoryComponent) -> [String: Any] {
        var map: [String: Any] = [
            "id": component.id,
            "type": component.type.stringValue
        ]
        if let payload = component.customPayload { map["custom_payload"] = payload }

        switch component {
        case let quiz as StoryQuizComponent:
            map["title"] = quiz.title
            map["options"] = quiz.options
            map["selected_index"] = quiz.selectedOptionIndex
            if let right = quiz.rightAnswerIndex { map["right_answer_index"] = right.intValue }

        case let quiz as StoryImageQuizComponent:
            map["title"] = quiz.title
            map["selected_index"] = quiz.selectedOptionIndex
            if let options = quiz.options { map["options"] = options }
            if let right = quiz.rightAnswerIndex { map["right_answer_index"] = right.intValue }

        case let poll as StoryPollComponent:
            map["title"] = poll.title
            map["options"] = poll.options
            map["selected_index"] = poll.selectedOptionIndex

        case let emoji as StoryEmojiComponent:
            map["emoji_codes"] = emoji.emojiCodes
            map["selected_index"] = emoji.selectedEmojiIndex

        case let rating as StoryRatingComponent:
            map["emoji_code"] = rating.emojiCode
            map["rating"] = rating.rating

        case let promo as StoryPromoCodeComponent:
            map["promo_code"] = promo.text

        case let comment as StoryCommentComponent:
            map["comment_text"] = comment.text

        case let swipe as StorySwipeComponent:
            map["text"] = swipe.text
            if let url = swipe.actionUrl { map["action_url"] = url }
            if let products = productMaps(swipe.products) { map["products"] = products }

        case let button as StoryButtonComponent:
            map["text"] = button.text
            if let url = button.actionUrl { map["action_url"] = url }
            if let products = productMaps(button.products) { map["products"] = products }

        case let productCard as StoryProductCardComponent:
            map["text"] = productCard.text
            if let url = productCard.actionUrl { map["action_url"] = url }
            if let products = productMaps(productCard.products) { map["products"] = products }

        case let productTag as StoryProductTagComponent:
            if let url = productTag.actionUrl { map["action_url"] = url }
            if let products = productMaps(productTag.products) { map["products"] = products }

        case let catalog as StoryProductCatalogComponent:
            if let urls = catalog.actionUrlList { map["action_urls"] = urls }
            if let products = productMaps(catalog.products) { map["products"] = products }

        default:
            break
        }

        return map
    }

    // MARK: - Products

    private static func productMaps(_ products: [STRProductItem]?) -> [[String: Any]]? {
        guard let products = products, !products.isEmpty else { return nil }
        return products.map(productMap(_:))
    }

    private static func productMap(_ product: STRProductItem) -> [String: Any] {
        var map: [String: Any] = [
            "id": product.productId,
            "group_id": product.productGroupId,
            "title": product.title,
            "url": product.url,
            "price": product.price,
            "currency": product.currency,
            "wishlist": product.wishlist
        ]

        if let desc = product.desc { map["description"] = desc }
        if let salesPrice = product.salesPrice { map["sales_price"] = salesPrice.floatValue }
        if let lowestPrice = product.lowestPrice { map["lowest_price"] = lowestPrice.floatValue }
        if let imageUrls = product.imageUrls { map["image_urls"] = imageUrls }
        if let ctaText = product.ctaText { map["cta_text"] = ctaText }
        if let variants = variantMaps(product.variants) { map["variants"] = variants }

        return map
    }

    private static func variantMaps(_ variants: [STRProductVariant]?) -> [[String: Any]]? {
        guard let variants = variants, !variants.isEmpty else { return nil }
        return variants.map { variant in
            ["name": variant.name, "value": variant.value, "key": variant.key]
        }
    }

    // MARK: - Cart

    private static func cartMap(_ cart: STRCart) -> [String: Any] {
        var map: [String: Any] = [
            "total_price": cart.totalPrice,
            "currency": cart.currency,
            "item_count": cart.items.count,
            "items": cart.items.map(cartItemMap(_:))
        ]
        if let oldTotalPrice = cart.oldTotalPrice { map["old_total_price"] = oldTotalPrice.floatValue }
        return map
    }

    private static func cartItemMap(_ cartItem: STRCartItem) -> [String: Any] {
        var map: [String: Any] = [
            "quantity": cartItem.quantity,
            "product": productMap(cartItem.item)
        ]
        if let totalPrice = cartItem.totalPrice { map["total_price"] = totalPrice.floatValue }
        if let oldTotalPrice = cartItem.oldTotalPrice { map["old_total_price"] = oldTotalPrice.floatValue }
        return map
    }

    // MARK: - Helpers

    private static func eventProperties(_ event: StorylyEvent) -> [String: Any] {
        ["event": event.stringValue, "event_raw_value": event.rawValue]
    }

    /// Converts a `UIColor` into a `#RRGGBBAA` hex string so colors survive
    /// JSON serialization.
    private static func hexString(from color: UIColor) -> String {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        _ = color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let clamp: (CGFloat) -> Int = { Int((max(0, min(1, $0)) * 255).rounded()) }
        return String(format: "#%02X%02X%02X%02X", clamp(red), clamp(green), clamp(blue), clamp(alpha))
    }
}
