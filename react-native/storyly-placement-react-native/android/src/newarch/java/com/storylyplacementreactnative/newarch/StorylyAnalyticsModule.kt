package com.storylyplacementreactnative.newarch

import android.util.Log
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule
import com.storylyplacementreactnative.NativeStorylyAnalyticsSpec
import com.storylyplacementreactnative.common.SPAnalyticsManager


@ReactModule(name = StorylyAnalyticsModule.NAME)
class StorylyAnalyticsModule(
    private val reactContext: ReactApplicationContext
) : NativeStorylyAnalyticsSpec(reactContext) {

    companion object {
        const val NAME = "StorylyAnalytics"
    }

    override fun getName(): String = NAME

    @ReactMethod
    override fun initialize(config: String) {
        Log.d("[StorylyAnalyticsModule]", "initialize")
        SPAnalyticsManager.initialize(reactContext.applicationContext, config)
    }

    @ReactMethod
    override fun track(event: String) {
        Log.d("[StorylyAnalyticsModule]", "track")
        SPAnalyticsManager.track(event)
    }
}
