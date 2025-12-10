package com.storylyplacementreactnative.common

import android.content.Context
import android.util.Log
import com.appsamurai.storyly.core.data.model.STRDataPayload
import com.appsamurai.storyly.core.data.model.STRDataSource
import com.appsamurai.storyly.core.data.model.product.STRProductInformation
import com.appsamurai.storyly.core.listener.provider.STRProviderListener
import com.appsamurai.storyly.core.listener.provider.STRProviderProductListener
import com.appsamurai.storyly.placement.data.provider.PlacementDataProvider


object RNPlacementProviderManager {

    private val providers = mutableMapOf<String, RNPlacementProviderWrapper>()
    private val lock = Any()

    fun createProvider(context: Context, id: String): RNPlacementProviderWrapper {
        synchronized(lock) {
            Log.d("[RNPlacementProviderManager]", "Create provider: $id")
            val wrapper = RNPlacementProviderWrapper(context, id)
            providers[id] = wrapper
            return wrapper
        }
    }

    fun getProvider(id: String): RNPlacementProviderWrapper? {
        synchronized(lock) {
            return providers[id]
        }
    }

    fun destroyProvider(id: String) {
        synchronized(lock) {
            Log.d("[RNPlacementProviderManager]", "Destroy provider: $id")
            providers.remove(id)
        }
    }
}

class RNPlacementProviderWrapper(
    private val context: Context,
    val id: String
) {

    var provider: PlacementDataProvider = PlacementDataProvider(context)

    internal var sendEvent: ((String, RNPlacementProviderEventType, String) -> Unit)? = null

    fun configure(configJson: String) {
        val parsedConfig = RNPlacementDataConverter.decodeFromJson(configJson)
        if (parsedConfig == null) {
            Log.e("[RNPlacementProviderWrapper]", "Failed to parse config JSON")
            return
        }

        setupProvider(parsedConfig)
    }

    private fun setupProvider(config: Map<String, Any?>) {
        val token = config["token"] as? String ?: return

        Log.d("[RNPlacementProviderWrapper]", "Configuring provider with token: $token")

        val placementConfig = RNPlacementDataConverter.createSTRPlacementConfig(config, token)

        provider.apply {
          listener = object : STRProviderListener {
            override fun onLoad(data: STRDataPayload, dataSource: STRDataSource) {
              val eventData = mapOf(
                "dataSource" to dataSource.value,
              )
              val eventJson = RNPlacementDataConverter.encodeToJson(eventData)
              Log.d("[RNPlacementProviderWrapper]", "STRProviderListener:onLoad: $eventJson")
              sendEvent?.invoke(id, RNPlacementProviderEventType.ON_LOAD, eventJson ?: "")
            }

            override fun onLoadFail(errorMessage: String) {
              val eventData = mapOf(
                "errorMessage" to errorMessage,
              )
              val eventJson = RNPlacementDataConverter.encodeToJson(eventData)
              Log.d("[RNPlacementProviderWrapper]", "STRProviderListener:onLoadFail: $eventJson")
              sendEvent?.invoke(id, RNPlacementProviderEventType.ON_LOAD_FAIL, eventJson ?: "")
            }
          }
          productListener = object : STRProviderProductListener {
            override fun onHydration(products: List<STRProductInformation>) {
              val productsMap = products.map { RNPlacementDataConverter.createSTRProductInformationMap(it) }
              val eventData = mapOf(
                "products" to productsMap,
              )
              val eventJson = RNPlacementDataConverter.encodeToJson(eventData)
              Log.d("[RNPlacementProviderWrapper]", "STRProviderProductListener:onHydration: $eventJson")
              sendEvent?.invoke(id, RNPlacementProviderEventType.ON_HYDRATION, eventJson ?: "")
            }
          }

          this.config = placementConfig
        }
    }

    fun hydrateProducts(productsJson: String) {
        Log.d("[RNPlacementProviderWrapper]", "hydrateProducts: $productsJson")
        val products = RNPlacementDataConverter.parseProductItems(productsJson)
        provider.hydrateProducts(products)
    }

    fun hydrateWishlist(productsJson: String) {
        Log.d("[RNPlacementProviderWrapper]", "hydrateWishlist: $productsJson")
        val products = RNPlacementDataConverter.parseProductItems(productsJson)
        provider.hydrateWishlist(products)
    }

    fun updateCart(cartJson: String) {
        Log.d("[RNPlacementProviderWrapper]", "updateCart: $cartJson")
        val cart = RNPlacementDataConverter.parseCart(cartJson)
        if (cart != null) {
            provider.updateCart(cart)
        }
    }
}
