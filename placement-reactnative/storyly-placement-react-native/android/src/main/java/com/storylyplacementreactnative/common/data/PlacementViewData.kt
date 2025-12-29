package com.storylyplacementreactnative.common.data

import com.appsamurai.storyly.banner.analytics.event.BannerEventPayload
import com.appsamurai.storyly.banner.data.model.BannerPayload
import com.appsamurai.storyly.core.analytics.error.STRErrorPayload
import com.appsamurai.storyly.core.analytics.event.STREventPayload
import com.appsamurai.storyly.core.data.model.STRPayload
import com.appsamurai.storyly.storybar.analytics.event.StoryBarEventPayload
import com.appsamurai.storyly.storybar.data.model.StoryBarPayload
import com.appsamurai.storyly.swipecard.analytics.event.SwipeCardEventPayload
import com.appsamurai.storyly.swipecard.data.model.SwipeCardPayload
import com.appsamurai.storyly.videofeed.analytics.event.VideoFeedEventPayload
import com.appsamurai.storyly.videofeed.data.model.VideoFeedPayload
import com.storylyplacementreactnative.common.data.widgets.encodeBannerPayload
import com.storylyplacementreactnative.common.data.widgets.encodeStoryBarPayload
import com.storylyplacementreactnative.common.data.widgets.encodeSwipeCardPayload
import com.storylyplacementreactnative.common.data.widgets.encodeVideoFeedPayload


fun encodeSTRPayload(payload: STRPayload): Map<String, Any?> {
    return when (payload) {
        is StoryBarPayload -> encodeStoryBarPayload(payload)
        is VideoFeedPayload -> encodeVideoFeedPayload(payload)
        is BannerPayload -> encodeBannerPayload(payload)
        is SwipeCardPayload -> encodeSwipeCardPayload(payload)
        else -> null
    } ?: emptyMap()
}

fun encodeSTREventPayload(payload: STREventPayload): Map<String, Any?> {
    val baseMap = mapOf(
        "event" to payload.baseEvent.getType()
    )
    val addition = when (payload) {
        is StoryBarEventPayload -> encodeStoryBarPayload(payload.payload)
        is VideoFeedEventPayload -> encodeVideoFeedPayload(payload.payload)
        is BannerEventPayload -> encodeBannerPayload(payload.payload)
        is SwipeCardEventPayload -> encodeSwipeCardPayload(payload.payload)
        else -> null
    } ?: emptyMap()
    return baseMap + addition
}

fun encodeSTRErrorPayload(payload: STRErrorPayload): Map<String, Any?> {
    return mapOf(
        "event" to payload.baseError.getType(),
        "message" to payload.message,
    )
}