package com.appsamurai.storyly.storyly_placement_flutter.common

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.appsamurai.storyly.core.data.model.STRDataPayload
import com.appsamurai.storyly.core.data.model.STRDataSource
import com.appsamurai.storyly.core.data.model.product.STRProductInformation
import com.appsamurai.storyly.core.listener.log.STRLog
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
                STRLog.error("[SPPlacementProviderWrapper] Failed to parse config JSON")
                return@post
            }

            setupProvider(parsedConfig)
        }
    }

    private fun setupProvider(config: Map<String, Any?>) {
        val token = config["token"] as? String ?: return


        val placementConfig = decodeSTRPlacementConfig(config, token)
        placementConfig.framework = "flutter"

        provider.apply {
          listener = object : STRDataProviderListener {
            override fun onLoad(data: STRDataPayload, dataSource: STRDataSource) {
              val eventJson = encodeToJson(mapOf(
                  "data" to encodeDataPayload(data),
                  "dataSource" to dataSource.value,
              ))
              sendEvent?.invoke(id, SPPlacementProviderEventType.ON_LOAD, eventJson ?: "")
            }

            override fun onLoadFail(errorMessage: String) {
              val eventJson = encodeToJson(mapOf(
                "errorMessage" to errorMessage,
              ))
              sendEvent?.invoke(id, SPPlacementProviderEventType.ON_LOAD_FAIL, eventJson ?: "")
            }
          }
          productListener = object : STRDataProviderProductListener {
            override fun onHydration(products: List<STRProductInformation>) {
              val eventJson = encodeToJson(mapOf(
                "products" to products.map { encodeSTRProductInformation(it) },
              ))
              sendEvent?.invoke(id, SPPlacementProviderEventType.ON_HYDRATION, eventJson ?: "")
            }
          }

          this.config = placementConfig
        }
    }

    fun hydrateProducts(raw: String) {
        Handler(context.mainLooper).post {
            val map = decodeFromJson(raw) ?: return@post
            val products = (map["products"] as? List<Map<String, Any?>>)?.mapNotNull {
                decodeSTRProductItem(it)
            } ?: return@post
            provider.hydrateProducts(products)
        }
    }

    fun hydrateWishlist(raw: String) {
        Handler(context.mainLooper).post {
            val map = decodeFromJson(raw) ?: return@post
            val products = (map["products"] as? List<Map<String, Any?>>)?.mapNotNull {
                decodeSTRProductInformation(it)
            } ?: return@post
            provider.hydrateWishlist(products)
        }
    }
}
