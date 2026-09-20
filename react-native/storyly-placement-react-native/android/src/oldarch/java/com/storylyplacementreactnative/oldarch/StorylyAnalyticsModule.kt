package com.storylyplacementreactnative.oldarch

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule
import com.storylyplacementreactnative.common.SPAnalyticsManager


@ReactModule(name = StorylyAnalyticsModule.NAME)
class StorylyAnalyticsModule(
    private val reactContext: ReactApplicationContext
) : ReactContextBaseJavaModule(reactContext) {
    companion object {
        const val NAME = "StorylyAnalytics"
    }

    override fun getName(): String = NAME

    @ReactMethod
    fun initialize(config: String) {
        SPAnalyticsManager.initialize(reactContext.applicationContext, config)
    }

    @ReactMethod
    fun track(event: String) {
        SPAnalyticsManager.track(event)
    }
}
