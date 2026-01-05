package com.storylyplacementreactnative.common.data.widgets

import com.appsamurai.storyly.core.STRWidgetType
import com.appsamurai.storyly.videofeed.data.VideoFeedDataPayload
import com.appsamurai.storyly.videofeed.data.model.VideoFeedPayload
import com.appsamurai.storyly.videofeed.ui.model.*
import com.storylyplacementreactnative.common.data.product.encodeSTRProductItem

fun encodeVideoFeedDataPayload(data: VideoFeedDataPayload): Map<String, Any?> {
    return mapOf(
        "type" to STRWidgetType.VideoFeed.raw,
        "items" to data.items.map { encodeVideoFeedGroup(it) }
    )
}

fun encodeVideoFeedPayload(payload: VideoFeedPayload?): Map<String, Any?>? {
    payload ?: return null
    return mapOf(
        "component" to encodeVideoFeedComponent(payload.component),
        "group" to encodeVideoFeedGroup(payload.group),
        "feedItem" to encodeVideoFeedItem(payload.feedItem),
    )
}

fun encodeVideoFeedGroup(group: VideoFeedGroup?): Map<String, Any?>? {
    group ?: return null
    return mapOf(
        "id" to group.uniqueId,
        "title" to group.title,
        "name" to group.name,
        "iconUrl" to group.iconUrl,
        "index" to group.index,
        "seen" to group.seen,
        "type" to group.type.customName,
        "pinned" to group.pinned,
        "nudge" to group.nudge,
        "iconVideoUrl" to group.iconVideoUrl,
        "iconVideoThumbnailUrl" to group.iconVideoThumbnailUrl,
        "feedList" to group.feedList.map { encodeVideoFeedItem(it) }
    )
}

private fun encodeVideoFeedItem(item: VideoFeedItem?): Map<String, Any?>? {
    item ?: return null
    return mapOf(
        "id" to item.uniqueId,
        "title" to item.title,
        "name" to item.name,
        "index" to item.index,
        "seen" to item.seen,
        "previewUrl" to item.previewUrl,
        "actionUrl" to item.actionUrl,
        "actionProducts" to item.actionProducts?.map { encodeSTRProductItem(it) },
        "currentTime" to item.currentTime,
        "feedItemComponentList" to item.feedItemComponentList
    )
}


fun encodeVideoFeedComponent(component: VideoFeedComponent?): Map<String, Any?>? {
    component ?: return null
    val base = mapOf(
        "id" to component.id,
        "type" to component.type.get(),
        "customPayload" to component.customPayload,
    )

    val additional = when(component) {
        is VideoFeedQuizComponent -> mapOf(
            "title" to component.title,
            "options" to component.options,
            "rightAnswerIndex" to component.rightAnswerIndex,
            "selectedOptionIndex" to component.selectedOptionIndex,
        )
        is VideoFeedImageQuizComponent -> mapOf(
            "title" to component.title,
            "options" to component.options,
            "rightAnswerIndex" to component.rightAnswerIndex,
            "selectedOptionIndex" to component.selectedOptionIndex,
        )
        is VideoFeedPollComponent -> mapOf(
            "title" to component.title,
            "options" to component.options,
            "selectedOptionIndex" to component.selectedOptionIndex,
        )
        is VideoFeedEmojiComponent -> mapOf(
            "emojiCodes" to component.emojiCodes,
            "selectedEmojiIndex" to component.selectedEmojiIndex,
        )
        is VideoFeedRatingComponent -> mapOf(
            "emojiCode" to component.emojiCode,
            "rating" to component.rating,
        )
        is VideoFeedPromoCodeComponent -> mapOf(
            "text" to component.text,
        )
        is VideoFeedCommentComponent -> mapOf(
            "text" to component.text,
        )
        is VideoFeedSwipeComponent -> mapOf(
            "text" to component.text,
            "actionUrl" to component.actionUrl,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        is VideoFeedButtonComponent -> mapOf(
            "text" to component.text,
            "actionUrl" to component.actionUrl,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        is VideoFeedProductTagComponent -> mapOf(
            "actionUrl" to component.actionUrl,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        is VideoFeedProductCardComponent -> mapOf(
            "text" to component.text,
            "actionUrl" to component.actionUrl,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        is VideoFeedProductCatalogComponent -> mapOf(
            "actionUrlList" to component.actionUrlList,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        else -> emptyMap()
    }

    return base + additional
}