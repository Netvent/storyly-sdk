package com.storylyplacementreactnative.common.data

import com.appsamurai.storyly.core.config.placement.STRLayoutDirection
import com.appsamurai.storyly.core.config.placement.STRPlacementConfig
import com.appsamurai.storyly.core.config.placement.STRProductConfig


fun decodeSTRPlacementConfig(config: Map<String, Any?>, token: String): STRPlacementConfig {
    val builder = STRPlacementConfig.Builder()

    (config["testMode"] as? Boolean)?.let { builder.setTestMode(it) }
    (config["locale"] as? String)?.let { builder.setLocale(it) }
    (config["layoutDirection"] as? String)?.let { layoutDir ->
        builder.setLayoutDirection(
            if (layoutDir == "rtl") STRLayoutDirection.RTL else STRLayoutDirection.LTR
        )
    }
    (config["customParameter"] as? String)?.let { builder.setCustomParameter(it) }
    (config["labels"] as? List<*>)?.filterIsInstance<String>()?.let { labels ->
        builder.setLabels(labels.toSet())
    }
    (config["userProperties"] as? Map<String, String>)?.let { userProps ->
        builder.setUserProperties(userProps)
    }
    (config["productConfig"] as? Map<String, Any?>)?.let { productConfig ->
        builder.setProductConfig(decodeSTRProductConfig(productConfig))
    }
    return builder.build(token)
}

fun decodeSTRProductConfig(productConfig: Map<*, *>?): STRProductConfig {
    val builder = STRProductConfig.Builder()

    if (productConfig != null) {
        (productConfig["isCartEnabled"] as? Boolean)?.let { builder.setCartAvailability(it) }
        (productConfig["isFallbackEnabled"] as? Boolean)?.let { builder.setFallbackAvailability(it) }
    }

    return builder.build()
}