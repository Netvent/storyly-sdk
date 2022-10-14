package com.appsamurai.storyly.storyly_monetization_flutter

import android.content.Context
import android.os.Bundle
import android.os.Handler
import androidx.core.os.bundleOf
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storyly.monetization.StorylyAdViewProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class StorylyMonetizationFlutter(private val messenger: BinaryMessenger,  private val flutterEngine: FlutterEngine? = null) {

    companion object {
        const val STORYLY_VIEW_ID = "viewId"
        const val AD_VIEW_PROVIDER = "adViewProvider"
        const val AD_MOB_AD_UNIT_ID = "adMobAdUnitId"
        const val AD_MOB_AD_EXTRAS = "adMobAdExtras"
    }

    internal var context: Context? = null

    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.appsamurai.storyly.storyly_monetization_flutter/storyly_monetization_flutter").apply {
        setMethodCallHandler { call, _ ->
            val callArguments = call.arguments as? Map<String, Any?>
            when (call.method) {
                "setAdViewProvider" -> {
                    val args = callArguments ?: return@setMethodCallHandler
                    val viewId = args[STORYLY_VIEW_ID] as? Int ?: return@setMethodCallHandler
                    val adViewProviderMap = callArguments[AD_VIEW_PROVIDER] as? Map<String, *> ?: return@setMethodCallHandler
                    setAdViewProvider(viewId, adViewProviderMap)
                }
                else -> {}
            }
        }
    }

    private fun setAdViewProvider(viewId: Int, adViewProviderMap: Map<String, *>?) {
        val context = context ?: return
        val engine = flutterEngine ?: return
        Handler(context.mainLooper).post {
            val view = engine.platformViewsController.getPlatformViewById(viewId)
            val storylyView = view as? StorylyView ?: return@post

            val map = adViewProviderMap ?: run {
                storylyView.storylyAdViewProvider = null
                return@post
            }
            val adMobAdUnitId = map[AD_MOB_AD_UNIT_ID] as? String ?: return@post
            val adMobAdExtras = (map[AD_MOB_AD_EXTRAS] as? Map<String, *>)?.let {
                Bundle().apply {
                    putAll(it.toBundle())
                }
            }
            storylyView.storylyAdViewProvider = StorylyAdViewProvider(context, adMobAdUnitId, adMobAdExtras)
        }
    }

    private fun Map<String, Any?>.toBundle(): Bundle = bundleOf(*this.toList().toTypedArray())
}