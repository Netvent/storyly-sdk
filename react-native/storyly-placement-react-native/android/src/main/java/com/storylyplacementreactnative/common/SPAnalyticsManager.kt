package com.storylyplacementreactnative.common

import android.content.Context
import android.util.Log
import com.appsamurai.storyly.analytics.STRAnalytics
import com.appsamurai.storyly.analytics.config.STRAnalyticsConfig
import com.appsamurai.storyly.analytics.model.STRAnalyticProduct
import com.appsamurai.storyly.analytics.model.STRAnalyticProductEvent
import com.storylyplacementreactnative.common.data.util.decodeFromJson

object SPAnalyticsManager {

    fun initialize(context: Context, configJson: String) {
        val map = decodeFromJson(configJson) ?: run {
            Log.e("[SPAnalyticsManager]", "Failed to parse analytics config JSON")
            return
        }
        val config = decodeSTRAnalyticsConfig(map) ?: run {
            Log.e("[SPAnalyticsManager]", "A valid analytics config is required")
            return
        }
        STRAnalytics.initialize(context.applicationContext, config)
    }

    fun track(eventJson: String) {
        val map = decodeFromJson(eventJson) ?: return
        val event = decodeSTRAnalyticProductEvent(map["event"] as? String) ?: return
        val products = (map["products"] as? List<Map<String, Any?>>)
            ?.mapNotNull { decodeSTRAnalyticProduct(it) } ?: return
        STRAnalytics.track(event, products)
    }
}

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
