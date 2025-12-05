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

    private const val TAG = "RNPlacementProviderManager"

    private val providers = mutableMapOf<String, RNPlacementProviderWrapper>()
    private val lock = Any()

    fun createProvider(context: Context, id: String, configJson: String): RNPlacementProviderWrapper {
        synchronized(lock) {
            val wrapper = RNPlacementProviderWrapper(context, id)
            wrapper.configure(configJson)
            providers[id] = wrapper

            Log.d(TAG, "Created provider: $id")
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
            providers.remove(id)
            Log.d(TAG, "Destroyed provider: $id")
        }
    }

    fun destroyAllProviders() {
        synchronized(lock) {
            providers.clear()
            Log.d(TAG, "Destroyed all providers")
        }
    }
}

// MARK: - Provider Wrapper

class RNPlacementProviderWrapper(
    private val context: Context,
    val id: String
) {

    companion object {
        private const val TAG = "RNPlacementProviderWrapper"
    }

    var provider: PlacementDataProvider? = null
        private set

    internal var sendEvent: ((RNPlacementEventType, String) -> Unit)? = null

    fun configure(configJson: String) {
        val parsedConfig = RNPlacementDataConverter.decodeFromJson(configJson)
        if (parsedConfig == null) {
            Log.e(TAG, "Failed to parse config JSON")
            return
        }

        setupProvider(parsedConfig)
    }

    private fun setupProvider(config: Map<String, Any?>) {
        val placementInit = config["placementInit"] as? Map<*, *> ?: return
        val token = placementInit["token"] as? String ?: return

        Log.d(TAG, "Configuring provider with token: $token")

        val placementConfig = RNPlacementDataConverter.createSTRPlacementConfig(config, token)

        provider = PlacementDataProvider(context).apply {
            this@RNPlacementProviderWrapper.provider = this

            listener = createProviderListener()
            productListener = createProductListener()

            this.config = placementConfig
        }
    }

    private fun createProviderListener(): STRProviderListener {
        return object : STRProviderListener {
            override fun onLoad(data: STRDataPayload, dataSource: STRDataSource) {
                val eventData = mapOf(
                    "dataSource" to dataSource.value,
                    "providerId" to id,
                )
                val eventJson = RNPlacementDataConverter.encodeToJson(eventData)
                sendEvent?.invoke(RNPlacementEventType.ON_PROVIDER_LOAD, eventJson ?: "")
            }

            override fun onLoadFail(errorMessage: String) {
                val eventData = mapOf(
                    "errorMessage" to errorMessage,
                    "providerId" to id,
                )
                val eventJson = RNPlacementDataConverter.encodeToJson(eventData)
                sendEvent?.invoke(RNPlacementEventType.ON_PROVIDER_LOAD_FAIL, eventJson ?: "")
            }
        }
    }

    private fun createProductListener(): STRProviderProductListener {
        return object : STRProviderProductListener {
            override fun onHydration(products: List<STRProductInformation>) {
                val productsMap = products.map { RNPlacementDataConverter.createSTRProductInformationMap(it) }
                val eventData = mapOf(
                    "products" to productsMap,
                    "providerId" to id,
                )
                val eventJson = RNPlacementDataConverter.encodeToJson(eventData)
                sendEvent?.invoke(RNPlacementEventType.ON_PROVIDER_HYDRATION, eventJson ?: "")
            }
        }
    }

    fun hydrateProducts(productsJson: String) {
        Log.d(TAG, "hydrateProducts: $productsJson")
        val products = RNPlacementDataConverter.parseProductItems(productsJson)
        provider?.hydrateProducts(products)
    }

    fun hydrateWishlist(productsJson: String) {
        Log.d(TAG, "hydrateWishlist: $productsJson")
        val products = RNPlacementDataConverter.parseProductItems(productsJson)
        provider?.hydrateWishlist(products)
    }

    fun updateCart(cartJson: String) {
        Log.d(TAG, "updateCart: $cartJson")
        val cart = RNPlacementDataConverter.parseCart(cartJson)
        if (cart != null) {
            provider?.updateCart(cart)
        }
    }
}
