package com.appsamurai.storylytwiliosample

import com.appsamurai.storyly.Story
import com.appsamurai.storyly.StoryButtonComponent
import com.appsamurai.storyly.StoryCommentComponent
import com.appsamurai.storyly.StoryComponent
import com.appsamurai.storyly.StoryEmojiComponent
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StoryGroupBadgeStyle
import com.appsamurai.storyly.StoryGroupStyle
import com.appsamurai.storyly.StoryImageQuizComponent
import com.appsamurai.storyly.StoryPollComponent
import com.appsamurai.storyly.StoryProductCardComponent
import com.appsamurai.storyly.StoryProductCatalogComponent
import com.appsamurai.storyly.StoryProductTagComponent
import com.appsamurai.storyly.StoryPromoCodeComponent
import com.appsamurai.storyly.StoryQuizComponent
import com.appsamurai.storyly.StoryRatingComponent
import com.appsamurai.storyly.StorySwipeComponent
import com.appsamurai.storyly.analytics.StorylyEvent
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.appsamurai.storyly.data.managers.product.STRProductItem
import com.appsamurai.storyly.data.managers.product.STRProductVariant

/**
 * Builds a Segment `track` properties map from the objects that Storyly hands
 * back in the [com.appsamurai.storyly.StorylyListener] /
 * [com.appsamurai.storyly.StorylyProductListener] callbacks.
 *
 * Segment's Track spec: https://www.twilio.com/docs/segment/connections/spec/track
 * The story group, story, and interactive component each become a nested
 * sub-map, and repeated objects (products, variants, colors) become nested
 * lists. The result is a plain [Map] that [SegmentManager] converts to a
 * JsonObject before sending. Optional values are only written when present.
 *
 * Goal: full coverage of the public properties Storyly exposes.
 */
object SegmentEventMapper {

    // region Entry points

    /**
     * Assembles story & interactive context into a nested properties map.
     *
     * Shape:
     * ```
     * {
     *   "event": "StoryQuizAnswered",
     *   "event_raw_value": 20,
     *   "story_group": { ..., "style": { "badge": { ... } } },
     *   "story":       { ..., "action_products": [ { ..., "variants": [ ... ] } ] },
     *   "component":   { ..., "products": [ ... ] }
     * }
     * ```
     */
    fun properties(
        event: StorylyEvent?,
        storyGroup: StoryGroup?,
        story: Story?,
        storyComponent: StoryComponent?
    ): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>()
        event?.let { map.putAll(eventProperties(it)) }
        storyGroup?.let { map["story_group"] = storyGroupMap(it) }
        story?.let { map["story"] = storyMap(it) }
        storyComponent?.let { map["component"] = componentMap(it) }
        return map
    }

    /** Assembles a cart-related product event (from `storylyUpdateCartEvent`). */
    fun cartProperties(event: StorylyEvent, cart: STRCart?, change: STRCartItem?): Map<String, Any?> {
        val map = eventProperties(event).toMutableMap()
        cart?.let { map["cart"] = cartMap(it) }
        change?.let { map["change"] = cartItemMap(it) }
        return map
    }

    /** Assembles a wishlist-related product event (from `storylyUpdateWishlistEvent`). */
    fun wishlistProperties(event: StorylyEvent, item: STRProductItem?): Map<String, Any?> {
        val map = eventProperties(event).toMutableMap()
        item?.let { map["product"] = productMap(it) }
        return map
    }

    // endregion

    // region Story group

    private fun storyGroupMap(storyGroup: StoryGroup): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>(
            "id" to storyGroup.uniqueId,
            "title" to storyGroup.title,
            "index" to storyGroup.index,
            "seen" to storyGroup.seen,
            "pinned" to storyGroup.pinned,
            "nudge" to storyGroup.nudge,
            "type" to storyGroup.type.customName,
            "story_count" to storyGroup.stories.size
        )
        storyGroup.name?.let { map["name"] = it }
        storyGroup.iconUrl?.let { map["icon_url"] = it }
        storyGroup.iconVideoUrl?.let { map["icon_video_url"] = it }
        storyGroup.iconVideoThumbnailUrl?.let { map["icon_video_thumbnail_url"] = it }
        styleMap(storyGroup.style)?.let { map["style"] = it }
        return map
    }

    private fun styleMap(style: StoryGroupStyle?): Map<String, Any?>? {
        if (style == null) return null
        val map = mutableMapOf<String, Any?>()
        style.borderUnseenColors?.let { colors -> map["border_unseen_colors"] = colors.map { hexString(it) } }
        style.textUnseenColor?.let { map["text_unseen_color"] = hexString(it) }
        badgeMap(style.badge)?.let { map["badge"] = it }
        return map.ifEmpty { null }
    }

    private fun badgeMap(badge: StoryGroupBadgeStyle?): Map<String, Any?>? {
        if (badge == null) return null
        val map = mutableMapOf<String, Any?>()
        badge.text?.let { map["text"] = it }
        badge.textColor?.let { map["text_color"] = hexString(it) }
        badge.backgroundColor?.let { map["background_color"] = hexString(it) }
        badge.endTime?.let { map["end_time"] = it }
        badge.template?.let { map["template"] = it }
        return map.ifEmpty { null }
    }

    // endregion

    // region Story

    private fun storyMap(story: Story): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>(
            "id" to story.uniqueId,
            "title" to story.title,
            "index" to story.index,
            "seen" to story.seen
        )
        story.currentTime?.let { map["current_time"] = it }
        story.name?.let { map["name"] = it }
        story.actionUrl?.let { map["action_url"] = it }
        story.previewUrl?.let { map["preview_url"] = it }
        story.storyComponentList?.let { map["component_count"] = it.size }
        productMaps(story.actionProducts)?.let { map["action_products"] = it }
        return map
    }

    // endregion

    // region Interactive components

    /**
     * Builds the base component fields, then casts to each concrete type and
     * merges in its type-specific fields (including attached products).
     */
    private fun componentMap(component: StoryComponent): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>(
            "id" to component.id,
            "type" to component.type.name
        )
        component.customPayload?.let { map["custom_payload"] = it }

        when (component) {
            is StoryQuizComponent -> {
                map["title"] = component.title
                map["options"] = component.options
                map["selected_index"] = component.selectedOptionIndex
                component.rightAnswerIndex?.let { map["right_answer_index"] = it }
            }
            is StoryImageQuizComponent -> {
                component.title?.let { map["title"] = it }
                map["selected_index"] = component.selectedOptionIndex
                component.options?.let { map["options"] = it }
                component.rightAnswerIndex?.let { map["right_answer_index"] = it }
            }
            is StoryPollComponent -> {
                map["title"] = component.title
                map["options"] = component.options
                map["selected_index"] = component.selectedOptionIndex
            }
            is StoryEmojiComponent -> {
                map["emoji_codes"] = component.emojiCodes
                map["selected_index"] = component.selectedEmojiIndex
            }
            is StoryRatingComponent -> {
                map["emoji_code"] = component.emojiCode
                map["rating"] = component.rating
            }
            is StoryPromoCodeComponent -> {
                map["promo_code"] = component.text
            }
            is StoryCommentComponent -> {
                map["comment_text"] = component.text
            }
            is StorySwipeComponent -> {
                map["text"] = component.text
                component.actionUrl?.let { map["action_url"] = it }
                productMaps(component.products)?.let { map["products"] = it }
            }
            is StoryButtonComponent -> {
                map["text"] = component.text
                component.actionUrl?.let { map["action_url"] = it }
                productMaps(component.products)?.let { map["products"] = it }
            }
            is StoryProductCardComponent -> {
                component.text?.let { map["text"] = it }
                component.actionUrl?.let { map["action_url"] = it }
                productMaps(component.products)?.let { map["products"] = it }
            }
            is StoryProductTagComponent -> {
                component.actionUrl?.let { map["action_url"] = it }
                productMaps(component.products)?.let { map["products"] = it }
            }
            is StoryProductCatalogComponent -> {
                component.actionUrlList?.let { urls -> map["action_urls"] = urls.filterNotNull() }
                productMaps(component.products)?.let { map["products"] = it }
            }
        }
        return map
    }

    // endregion

    // region Products & cart

    private fun productMaps(products: List<STRProductItem>?): List<Map<String, Any?>>? {
        if (products.isNullOrEmpty()) return null
        return products.map { productMap(it) }
    }

    private fun productMap(product: STRProductItem): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>(
            "id" to product.productId,
            "group_id" to product.productGroupId,
            "title" to product.title,
            "url" to product.url,
            "price" to product.price,
            "currency" to product.currency,
            "wishlist" to (product.wishlist ?: false)
        )
        product.desc?.let { map["description"] = it }
        product.salesPrice?.let { map["sales_price"] = it }
        product.lowestPrice?.let { map["lowest_price"] = it }
        product.imageUrls?.let { map["image_urls"] = it }
        product.ctaText?.let { map["cta_text"] = it }
        variantMaps(product.variants)?.let { map["variants"] = it }
        return map
    }

    private fun variantMaps(variants: List<STRProductVariant>?): List<Map<String, Any?>>? {
        if (variants.isNullOrEmpty()) return null
        return variants.map { mapOf("name" to it.name, "value" to it.value, "key" to it.key) }
    }

    private fun cartMap(cart: STRCart): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>(
            "total_price" to cart.totalPrice,
            "currency" to cart.currency,
            "item_count" to cart.items.size,
            "items" to cart.items.map { cartItemMap(it) }
        )
        cart.oldTotalPrice?.let { map["old_total_price"] = it }
        return map
    }

    private fun cartItemMap(cartItem: STRCartItem): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>(
            "quantity" to cartItem.quantity,
            "product" to productMap(cartItem.item)
        )
        cartItem.totalPrice?.let { map["total_price"] = it }
        cartItem.oldTotalPrice?.let { map["old_total_price"] = it }
        return map
    }

    // endregion

    // region Helpers

    private fun eventProperties(event: StorylyEvent): Map<String, Any?> =
        mapOf("event" to event.name, "event_raw_value" to event.ordinal)

    /** Converts an Android ColorInt into an `#AARRGGBB` hex string. */
    private fun hexString(color: Int): String = String.format("#%08X", color)

    // endregion
}
