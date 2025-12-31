package com.appsamurai.storyly.storyly_placement_flutter.common.data.widgets

import com.appsamurai.storyly.banner.data.BannerButtonComponent
import com.appsamurai.storyly.banner.data.BannerComponent
import com.appsamurai.storyly.banner.data.BannerDataPayload
import com.appsamurai.storyly.banner.data.BannerSlide
import com.appsamurai.storyly.banner.data.model.BannerPayload
import com.appsamurai.storyly.core.STRWidgetType
import com.appsamurai.storyly.core.data.model.product.STRProductItem
import com.appsamurai.storyly.storybar.data.model.StoryBarPayload
import com.appsamurai.storyly.storybar.ui.model.StoryButtonComponent
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.encodeSTRProductItem

fun encodeBannerDataPayload(data: BannerDataPayload): Map<String, Any?> {
    return mapOf(
        "type" to STRWidgetType.Banner.raw,
        "items" to data.items.map { encodeBannerSlide(it) }
    )
}


fun encodeBannerPayload(payload: BannerPayload?): Map<String, Any?>? {
    payload ?: return null
    return mapOf(
        "component" to encodeBannerComponent(payload.component),
        "item" to encodeBannerSlide(payload.item),
    )
}


fun encodeBannerSlide(slide: BannerSlide?): Map<String, Any?>? {
    slide ?: return null
    return mapOf(
        "id" to slide.uniqueId,
        "name" to slide.name,
        "index" to slide.index,
        "actionUrl" to slide.actionUrl,
        "componentList" to slide.componentList?.map { encodeBannerComponent(it) },
        "actionProducts" to slide.actionProducts?.map { encodeSTRProductItem(it) },
        "currentTime" to slide.currentTime
    )
}


fun encodeBannerComponent(component: BannerComponent?): Map<String, Any?>? {
    component ?: return null
    val base = mapOf(
        "id" to component.id,
        "type" to component.type.name.lowercase(),
        "customPayload" to component.customPayload
    )
    val additional = when (component) {
        is BannerButtonComponent -> mapOf(
            "text" to component.text,
            "actionUrl" to component.actionUrl,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        else -> emptyMap()
    }
    return base + additional
}
