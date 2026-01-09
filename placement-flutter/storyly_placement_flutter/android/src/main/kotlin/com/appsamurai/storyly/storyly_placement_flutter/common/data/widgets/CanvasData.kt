package com.appsamurai.storyly.storyly_placement_flutter.common.data.widgets

import com.appsamurai.storyly.canvas.data.CanvasDataPayload
import com.appsamurai.storyly.canvas.data.model.CanvasItem
import com.appsamurai.storyly.canvas.data.model.CanvasPayload
import com.appsamurai.storyly.core.STRWidgetType
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.encodeSTRProductItem

fun encodeCanvasDataPayload(data: CanvasDataPayload): Map<String, Any?> {
    return mapOf(
        "type" to STRWidgetType.Canvas.raw,
        "items" to data.items.map { encodeCanvasItem(it) }
    )
}

fun encodeCanvasPayload(payload: CanvasPayload?): Map<String, Any?>? {
    payload ?: return null
    return mapOf(
        "item" to encodeCanvasItem(payload.item)
    )
}

fun encodeCanvasItem(item: CanvasItem?): Map<String, Any?>? {
    item ?: return null
    return mapOf(
        "actionUrl" to item.actionUrl,
        "actionProducts" to item.actionProducts?.map { encodeSTRProductItem(it) }
    )
}
