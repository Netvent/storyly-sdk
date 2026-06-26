package com.appsamurai.storyly.storyly_placement_flutter.common.data.analytics

import com.appsamurai.storyly.analytics.config.STRAnalyticsConfig
import com.appsamurai.storyly.analytics.model.STRAnalyticProduct
import com.appsamurai.storyly.analytics.model.STRAnalyticProductEvent

internal fun decodeSTRAnalyticsConfig(config: Map<String, Any?>): STRAnalyticsConfig? {
    val token = config["token"] as? String ?: return null
    val builder = STRAnalyticsConfig.Builder()
    (config["userId"] as? String)?.let { builder.setUserId(it) }
    return builder.build(token)
}

internal fun decodeSTRAnalyticProductEvent(event: String?): STRAnalyticProductEvent? {
    event ?: return null
    return STRAnalyticProductEvent.entries.firstOrNull { it.name == event }
}

internal fun decodeSTRAnalyticProduct(product: Map<String, Any?>?): STRAnalyticProduct? {
    product ?: return null
    val productId = product["productId"] as? String ?: return null
    val productGroupId = product["productGroupId"] as? String ?: return null
    val title = product["title"] as? String ?: return null
    val price = (product["price"] as? Number)?.toFloat() ?: return null
    return STRAnalyticProduct(
        productId = productId,
        productGroupId = productGroupId,
        title = title,
        desc = product["desc"] as? String,
        price = price,
        salesPrice = (product["salesPrice"] as? Number)?.toFloat(),
        quantity = (product["quantity"] as? Number)?.toInt() ?: 1,
    )
}
