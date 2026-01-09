package com.appsamurai.storyly.storyly_placement_flutter

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import com.appsamurai.storyly.storyly_placement_flutter.common.SPStorylyPlacementView

class StorylyPlacementFlutterViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return StorylyPlacementFlutterView(context, viewId, messenger)
    }
}

class StorylyPlacementFlutterView(
    context: Context,
    id: Int,
    messenger: BinaryMessenger
) : PlatformView, MethodChannel.MethodCallHandler {

    private val placementView: SPStorylyPlacementView = SPStorylyPlacementView(context)
    private val methodChannel: MethodChannel = MethodChannel(messenger, "storyly_placement_flutter/view_$id")

    init {
        methodChannel.setMethodCallHandler(this)

        setupCallbacks()
    }

    private fun setupCallbacks() {
        placementView.dispatchEvent = { event, eventData ->
            Handler(Looper.getMainLooper()).post {
                methodChannel.invokeMethod(event.eventName, eventData)
            }
        }
    }

    override fun getView(): View {
        return placementView
    }

    override fun dispose() {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "configure" -> {
                val providerId = call.argument<String?>("providerId") ?: return
                placementView.configure(providerId)
            }
            "callWidget" -> {
                val viewId = call.argument<String>("viewId")
                val method = call.argument<String>("method")
                val raw = call.argument<String>("raw")
                
                if (viewId != null && method != null) {
                    placementView.callWidget(viewId, method, raw)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "viewId, method and params are required", null)
                }
            }
            "approveCartChange" -> {
                val responseId = call.argument<String>("responseId")
                val raw = call.argument<String>("raw")
                
                if (responseId != null) {
                    placementView.approveCartChange(responseId, raw)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "responseId and cart are required", null)
                }
            }
            "rejectCartChange" -> {
                val responseId = call.argument<String>("responseId")
                val raw = call.argument<String>("raw")
                
                if (responseId != null) {
                    placementView.rejectCartChange(responseId, raw)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "responseId and failMessage are required", null)
                }
            }
            "approveWishlistChange" -> {
                val responseId = call.argument<String>("responseId")
                val raw = call.argument<String>("raw")
                
                if (responseId != null) {
                    placementView.approveWishlistChange(responseId, raw)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "responseId and item are required", null)
                }
            }
            "rejectWishlistChange" -> {
                val responseId = call.argument<String>("responseId")
                val raw = call.argument<String>("raw")
                
                if (responseId != null) {
                    placementView.rejectWishlistChange(responseId, raw)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "responseId and failMessage are required", null)
                }
            }
            else -> result.notImplemented()
        }
    }
}
