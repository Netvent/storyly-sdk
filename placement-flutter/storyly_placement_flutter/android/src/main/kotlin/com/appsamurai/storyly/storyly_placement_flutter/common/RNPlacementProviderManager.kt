package com.appsamurai.storyly.storyly_placement_flutter.common

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.appsamurai.storyly.core.data.model.STRDataPayload
import com.appsamurai.storyly.core.data.model.STRDataSource
import com.appsamurai.storyly.core.data.model.product.STRProductInformation
import com.appsamurai.storyly.core.listener.provider.STRProviderListener
import com.appsamurai.storyly.core.listener.provider.STRProviderProductListener
import com.appsamurai.storyly.placement.data.provider.PlacementDataProvider
import com.appsamurai.storyly.storyly_placement_flutter.common.data.decodeSTRPlacementConfig
import com.appsamurai.storyly.storyly_placement_flutter.common.data.encodeDataPayload
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.decodeSTRCart
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.decodeSTRProductItem
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.encodeSTRProductInformation
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.encodeSTRProductItem
import com.appsamurai.storyly.storyly_placement_flutter.common.data.util.decodeFromJson
import com.appsamurai.storyly.storyly_placement_flutter.common.data.util.encodeToJson


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
    val provider: PlacementDataProvider by lazy { PlacementDataProvider(context) }

    internal var sendEvent: ((String, RNPlacementProviderEventType, String) -> Unit)? = null

    fun configure(configJson: String) {
        Handler(Looper.getMainLooper()).post {
            val parsedConfig = decodeFromJson(configJson) ?: run {
                Log.e("[RNPlacementProviderWrapper]", "Failed to parse config JSON")
                return@post
            }

            setupProvider(parsedConfig)
        }
    }

    private fun setupProvider(config: Map<String, Any?>) {
        val token = config["token"] as? String ?: return

        Log.d("[RNPlacementProviderWrapper]", "Configuring provider with token: $token")

        val placementConfig = decodeSTRPlacementConfig(config, token)

        provider.apply {
          listener = object : STRProviderListener {
            override fun onLoad(data: STRDataPayload, dataSource: STRDataSource) {
              val eventJson = encodeToJson(mapOf(
                  "data" to encodeDataPayload(data),
                  "dataSource" to dataSource.value,
              ))
              Log.d("[RNPlacementProviderWrapper]", "STRProviderListener:onLoad: $eventJson")
              sendEvent?.invoke(id, RNPlacementProviderEventType.ON_LOAD, eventJson ?: "")
            }

            override fun onLoadFail(errorMessage: String) {
              val eventJson = encodeToJson(mapOf(
                "errorMessage" to errorMessage,
              ))
              Log.d("[RNPlacementProviderWrapper]", "STRProviderListener:onLoadFail: $eventJson")
              sendEvent?.invoke(id, RNPlacementProviderEventType.ON_LOAD_FAIL, eventJson ?: "")
            }
          }
          productListener = object : STRProviderProductListener {
            override fun onHydration(products: List<STRProductInformation>) {
              val eventJson = encodeToJson(mapOf(
                "products" to products.map { encodeSTRProductInformation(it) },
              ))
              Log.d("[RNPlacementProviderWrapper]", "STRProviderProductListener:onHydration: $eventJson")
              sendEvent?.invoke(id, RNPlacementProviderEventType.ON_HYDRATION, eventJson ?: "")
            }
          }

          this.config = placementConfig
        }
    }

    fun hydrateProducts(raw: String) {
        Handler(context.mainLooper).post {
            val map = decodeFromJson(raw) ?: return@post
            Log.d("[RNPlacementProviderWrapper]", "hydrateProducts: $raw")
            val products = (map["products"] as? List<Map<String, Any?>>)?.mapNotNull {
                decodeSTRProductItem(it)
            } ?: return@post
            provider.hydrateProducts(products)
        }
    }

    fun hydrateWishlist(raw: String) {
        Handler(context.mainLooper).post {
            val map = decodeFromJson(raw) ?: return@post
            Log.d("[RNPlacementProviderWrapper]", "hydrateWishlist: $raw")
            val products = (map["products"] as? List<Map<String, Any?>>)?.mapNotNull {
                decodeSTRProductItem(it)
            } ?: return@post
            provider.hydrateWishlist(products)
        }
    }

    fun updateCart(raw: String) {
        Handler(context.mainLooper).post {
            val map = decodeFromJson(raw) ?: return@post
            Log.d("[RNPlacementProviderWrapper]", "hydrateWishlist: $raw")
            val cart = (map["cart"] as? Map<String, Any?>)?.let {
                decodeSTRCart(it)
            } ?: return@post
            provider.updateCart(cart)
        }

    }
}
