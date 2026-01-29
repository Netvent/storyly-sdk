package com.storylyplacementreactnative.common.data

import com.appsamurai.storyly.core.config.placement.STRLayoutDirection
import com.appsamurai.storyly.core.config.placement.STRNetworkConfig
import com.appsamurai.storyly.core.config.placement.STRPlacementConfig
import com.appsamurai.storyly.core.config.placement.STRProductConfig
import com.appsamurai.storyly.core.config.placement.STRShareConfig
import com.storylyplacementreactnative.common.data.product.decodeSTRProductItem


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
    decodeSTRProductConfig(config["productConfig"] as? Map<String, Any?>)?.let { productConfig ->
        builder.setProductConfig(productConfig)
    }
    decodeSTRShareConfig(config["shareConfig"] as? Map<String, Any?>)?.let { shareConfig ->
        builder.setShareConfig(shareConfig)
    }
    decodeSTRNetworkConfig(config["networkConfig"] as? Map<String, Any?>)?.let { networkConfig ->
        builder.setNetworkConfig(networkConfig)
    }
    return builder.build(token)
}

fun decodeSTRProductConfig(productConfig: Map<String, Any?>?): STRProductConfig? {
    productConfig ?: return null
    val builder = STRProductConfig.Builder()
    return builder.build()
}

fun decodeSTRShareConfig(shareConfig: Map<String, Any?>?): STRShareConfig? {
    shareConfig ?: return null
    val config = STRShareConfig.Builder()
    (shareConfig["facebookAppId"] as? String)?.let { config.setFacebookAppID(it) }
    (shareConfig["shareUrl"] as? String)?.let { config.setShareUrl(it) }
    (shareConfig["appLogoVisibility"] as? Boolean)?.let { config.setAppLogoVisibility(it) }
    return config.build()
}

fun decodeSTRNetworkConfig(networkConfig: Map<String, Any?>?): STRNetworkConfig? {
    networkConfig ?: return null
    val config = STRNetworkConfig.Builder()
    (networkConfig["cdnHost"] as? String)?.let { config.setCdnHost(it) }
    (networkConfig["productHost"] as? String)?.let { config.setProductHost(it) }
    (networkConfig["analyticHost"] as? String)?.let { config.setAnalyticHost(it) }
    (networkConfig["placementHost"] as? String)?.let { config.setPlacementHost(it) }
    return config.build()
}