package com.storylyplacementreactnative.common.data

import com.appsamurai.storyly.banner.data.BannerDataPayload
import com.appsamurai.storyly.core.data.model.STRDataPayload
import com.appsamurai.storyly.swipecard.data.SwipeCardDataPayload
import com.appsamurai.storyly.videofeed.data.VideoFeedDataPayload
import com.storylyplacementreactnative.common.data.widgets.encodeBannerDataPayload
import com.storylyplacementreactnative.common.data.widgets.encodeSwipeCardDataPayload
import com.storylyplacementreactnative.common.data.widgets.encodeVideoFeedDataPayload


fun encodeDataPayload(dataPayload: STRDataPayload): Map<String, Any?> {
    return when (dataPayload) {
       is StoryBarDataPayload -> encodeStoryBarDataPayload(dataPayload)
        is VideoFeedDataPayload -> encodeVideoFeedDataPayload(dataPayload)
        is BannerDataPayload -> encodeBannerDataPayload(dataPayload)
        is SwipeCardDataPayload -> encodeSwipeCardDataPayload(dataPayload)
        else -> { mapOf() }
    }
}

