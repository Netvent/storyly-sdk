package com.storylyplacementreactnative.newarch

import android.util.Log
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.storylyplacementreactnative.NativeStorylyPlacementProviderSpec
import com.storylyplacementreactnative.common.RNPlacementEventType
import com.storylyplacementreactnative.common.RNPlacementProviderManager


@ReactModule(name = StorylyPlacementProviderModule.NAME)
class StorylyPlacementProviderModule(
    private val reactContext: ReactApplicationContext
) : NativeStorylyPlacementProviderSpec(reactContext) {

    companion object {
        private const val TAG = "StorylyPlacementProviderModule"
        const val NAME = "StorylyPlacementProvider"
    }

    private var listenerCount = 0

    override fun getName(): String = NAME

    @ReactMethod
    override fun createProvider(providerId: String, config: String) {
        Log.d(TAG, "Creating provider: $providerId")
        val wrapper = RNPlacementProviderManager.createProvider(
            reactContext.applicationContext,
            providerId,
            config
        )
        wrapper.sendEvent = { eventType, jsonPayload ->
            if (listenerCount > 0) {
                sendEvent(eventType, jsonPayload)
            }
        }
    }

    @ReactMethod
    override fun destroyProvider(providerId: String) {
        Log.d(TAG, "Destroying provider: $providerId")
        RNPlacementProviderManager.destroyProvider(providerId)
    }

    @ReactMethod
    override fun updateConfig(providerId: String, config: String) {
        Log.d(TAG, "Updating config for provider: $providerId")
        RNPlacementProviderManager.getProvider(providerId)?.configure(config)
    }

    @ReactMethod
    override fun hydrateProducts(providerId: String, productsJson: String) {
        Log.d(TAG, "Hydrating products for provider: $providerId")
        RNPlacementProviderManager.getProvider(providerId)?.hydrateProducts(productsJson)
    }

    @ReactMethod
    override fun hydrateWishlist(providerId: String, productsJson: String) {
        Log.d(TAG, "Hydrating wishlist for provider: $providerId")
        RNPlacementProviderManager.getProvider(providerId)?.hydrateWishlist(productsJson)
    }

    @ReactMethod
    override fun updateCart(providerId: String, cartJson: String) {
        Log.d(TAG, "Updating cart for provider: $providerId")
        RNPlacementProviderManager.getProvider(providerId)?.updateCart(cartJson)
    }

    @ReactMethod
    override fun addListener(eventName: String) {
        listenerCount++
    }

    @ReactMethod
    override fun removeListeners(count: Double) {
        listenerCount -= count.toInt()
        if (listenerCount < 0) listenerCount = 0
    }

    private fun sendEvent(eventType: RNPlacementEventType, jsonPayload: String) {
        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventType.eventName, mapOf("raw" to jsonPayload))
    }
}


