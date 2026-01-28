package com.appsamurai.storyly.storyly_placement_flutter.common

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.appsamurai.storyly.core.data.model.STRDataPayload
import com.appsamurai.storyly.core.data.model.STRDataSource
import com.appsamurai.storyly.core.data.model.product.STRProductInformation
import com.appsamurai.storyly.core.listener.provider.STRDataProviderListener
import com.appsamurai.storyly.core.listener.provider.STRDataProviderProductListener
import com.appsamurai.storyly.placement.data.provider.STRPlacementDataProvider
import com.appsamurai.storyly.storyly_placement_flutter.common.data.decodeSTRPlacementConfig
import com.appsamurai.storyly.storyly_placement_flutter.common.data.encodeDataPayload
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.decodeSTRProductItem
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.decodeSTRProductInformation
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.encodeSTRProductInformation
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.encodeSTRProductItem
import com.appsamurai.storyly.storyly_placement_flutter.common.data.util.decodeFromJson
import com.appsamurai.storyly.storyly_placement_flutter.common.data.util.encodeToJson


object SPPlacementProviderManager {

    private val providers = mutableMapOf<String, SPPlacementProviderWrapper>()
    private val lock = Any()

    fun createProvider(context: Context, id: String): SPPlacementProviderWrapper {
        synchronized(lock) {
            Log.d("[SPPlacementProviderManager]", "Create provider: $id")
            val wrapper = SPPlacementProviderWrapper(context, id)
            providers[id] = wrapper
            return wrapper
        }
    }

    fun getProvider(id: String): SPPlacementProviderWrapper? {
        synchronized(lock) {
            return providers[id]
        }
    }

    fun destroyProvider(id: String) {
        synchronized(lock) {
            Log.d("[SPPlacementProviderManager]", "Destroy provider: $id")
            providers.remove(id)
        }
    }
}

class SPPlacementProviderWrapper(
    private val context: Context,
    val id: String
) {
    val provider: STRPlacementDataProvider by lazy { STRPlacementDataProvider(context) }

    internal var sendEvent: ((String, SPPlacementProviderEventType, String) -> Unit)? = null

    fun configure(configJson: String) {
        Handler(Looper.getMainLooper()).post {
            val parsedConfig = decodeFromJson(configJson) ?: run {
                Log.e("[SPPlacementProviderWrapper]", "Failed to parse config JSON")
                return@post
            }

            setupProvider(parsedConfig)
        }
    }

    private fun setupProvider(config: Map<String, Any?>) {
        val token = config["token"] as? String ?: return

        Log.d("[SPPlacementProviderWrapper]", "Configuring provider with token: $token")

        val placementConfig = decodeSTRPlacementConfig(config, token)
        placementConfig.framework = "flutter"

        provider.apply {
          listener = object : STRDataProviderListener {
            override fun onLoad(data: STRDataPayload, dataSource: STRDataSource) {
              val eventJson = encodeToJson(mapOf(
                  "data" to encodeDataPayload(data),
                  "dataSource" to dataSource.value,
              ))
              Log.d("[SPPlacementProviderWrapper]", "STRDataProviderListener:onLoad: $eventJson")
              sendEvent?.invoke(id, SPPlacementProviderEventType.ON_LOAD, eventJson ?: "")
            }

            override fun onLoadFail(errorMessage: String) {
              val eventJson = encodeToJson(mapOf(
                "errorMessage" to errorMessage,
              ))
              Log.d("[SPPlacementProviderWrapper]", "STRDataProviderListener:onLoadFail: $eventJson")
              sendEvent?.invoke(id, SPPlacementProviderEventType.ON_LOAD_FAIL, eventJson ?: "")
            }
          }
          productListener = object : STRDataProviderProductListener {
            override fun onHydration(products: List<STRProductInformation>) {
              val eventJson = encodeToJson(mapOf(
                "products" to products.map { encodeSTRProductInformation(it) },
              ))
              Log.d("[SPPlacementProviderWrapper]", "STRDataProviderProductListener:onHydration: $eventJson")
              sendEvent?.invoke(id, SPPlacementProviderEventType.ON_HYDRATION, eventJson ?: "")
            }
          }

          this.config = placementConfig
        }
    }

    fun hydrateProducts(raw: String) {
        Handler(context.mainLooper).post {
            val map = decodeFromJson(raw) ?: return@post
            Log.d("[SPPlacementProviderWrapper]", "hydrateProducts: $raw")
            val products = (map["products"] as? List<Map<String, Any?>>)?.mapNotNull {
                decodeSTRProductItem(it)
            } ?: return@post
            provider.hydrateProducts(products)
        }
    }

    fun hydrateWishlist(raw: String) {
        Handler(context.mainLooper).post {
            val map = decodeFromJson(raw) ?: return@post
            Log.d("[SPPlacementProviderWrapper]", "hydrateWishlist: $raw")
            val products = (map["products"] as? List<Map<String, Any?>>)?.mapNotNull {
                decodeSTRProductInformation(it)
            } ?: return@post
            provider.hydrateWishlist(products)
        }
    }
}
