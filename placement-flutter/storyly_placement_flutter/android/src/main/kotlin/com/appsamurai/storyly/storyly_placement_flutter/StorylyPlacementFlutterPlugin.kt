package com.appsamurai.storyly.storyly_placement_flutter

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.appsamurai.storyly.storyly_placement_flutter.common.SPPlacementProviderManager
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import com.appsamurai.storyly.storyly_placement_flutter.common.data.util.decodeFromJson

/** StorylyPlacementFlutterPlugin */
class StorylyPlacementFlutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    private var placementFlutterViewFactory: StorylyPlacementFlutterViewFactory? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "storyly_placement_flutter")
        channel.setMethodCallHandler(this)


        placementFlutterViewFactory = StorylyPlacementFlutterViewFactory(flutterPluginBinding.binaryMessenger).also { factory ->
            flutterPluginBinding.platformViewRegistry.registerViewFactory(
                "storyly_placement_flutter_view",
                factory,
            )
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "createProvider" -> {
                val providerId = call.arguments as? String
                if (providerId != null) {
                    SPPlacementProviderManager.createProvider(applicationContext, providerId).apply {
                        this.sendEvent = { id, event, eventData ->
                            Handler(Looper.getMainLooper()).post {
                                val payload = mapOf(
                                    "providerId" to id,
                                    "raw" to eventData
                                )
                                channel.invokeMethod(event.eventName, payload)
                            }
                        }
                    }
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "providerId is required", null)
                }
            }
            "destroyProvider" -> {
                val providerId = call.arguments as? String
                if (providerId != null) {
                    SPPlacementProviderManager.destroyProvider(providerId)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "providerId is required", null)
                }
            }
            "updateConfig" -> {
                val args = call.arguments as? Map<String, Any>
                val providerId = args?.get("providerId") as? String ?: return
                val config = args["config"] as? String

                val provider = SPPlacementProviderManager.getProvider(providerId) ?: return
                
                if (config != null) {
                    provider.configure(config)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "providerId and config are required", null)
                }
            }
            "hydrateProducts" -> {
                val args = call.arguments as? Map<String, Any>
                val providerId = args?.get("providerId") as? String ?: return
                val products = args["products"] as? String

                val provider = SPPlacementProviderManager.getProvider(providerId) ?: return
                
                if (products != null) {
                    provider.hydrateProducts(products)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "providerId and products are required", null)
                }
            }
            "hydrateWishlist" -> {
                val args = call.arguments as? Map<String, Any>
                val providerId = args?.get("providerId") as? String ?: return
                val products = args["products"] as? String

                val provider = SPPlacementProviderManager.getProvider(providerId) ?: return
                
                if (products != null) {
                    provider.hydrateWishlist(products)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "providerId and products are required", null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
