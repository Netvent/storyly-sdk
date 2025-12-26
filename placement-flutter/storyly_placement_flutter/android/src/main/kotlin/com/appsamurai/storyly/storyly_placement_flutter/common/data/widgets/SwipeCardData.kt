package com.appsamurai.storyly.storyly_placement_flutter.common.data.widgets

import com.appsamurai.storyly.core.STRWidgetType
import com.appsamurai.storyly.swipecard.data.SwipeCardDataPayload
import com.appsamurai.storyly.swipecard.data.model.SwipeCardPayload
import com.appsamurai.storyly.swipecard.ui.model.SwipeCard
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.encodeSTRProductItem

fun encodeSwipeCardDataPayload(data: SwipeCardDataPayload): Map<String, Any?> {
    return mapOf(
        "type" to STRWidgetType.SwipeCard.raw,
        "items" to data.items.map { encodeSTRProductItem(it) }
    )
}

fun encodeSwipeCardPayload(payload: SwipeCardPayload?): Map<String, Any?>? {
    payload ?: return null
    return mapOf(
        "card" to encodeSwipeCard(payload.card),
    )
}

fun encodeSwipeCard(card: SwipeCard?): Map<String, Any?>? {
    card ?: return null
    return mapOf(
        "actionProducts" to card.actionProducts?.map { encodeSTRProductItem(it) }
    )
}