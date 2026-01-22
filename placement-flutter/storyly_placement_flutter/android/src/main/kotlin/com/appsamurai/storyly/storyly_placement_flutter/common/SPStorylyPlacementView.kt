package com.appsamurai.storyly.storyly_placement_flutter.common

import android.content.Context
import android.os.Handler
import android.util.Log
import com.appsamurai.storyly.core.STRWidgetType
import com.appsamurai.storyly.core.analytics.error.STRErrorPayload
import com.appsamurai.storyly.core.analytics.event.STREvent
import com.appsamurai.storyly.core.analytics.product.STRProductEvent
import com.appsamurai.storyly.core.analytics.event.STREventPayload
import com.appsamurai.storyly.core.data.model.STRPayload
import com.appsamurai.storyly.core.data.model.product.STRCartItem
import com.appsamurai.storyly.core.data.model.product.STRProductItem
import com.appsamurai.storyly.core.data.model.product.STRWishlistEventResult
import com.appsamurai.storyly.core.ui.STRWidgetController
import com.appsamurai.storyly.coreinternal.util.getActivity
import com.appsamurai.storyly.placement.data.provider.STRPlacementDataProvider
import com.appsamurai.storyly.placement.ui.STRListener
import com.appsamurai.storyly.placement.ui.STRPlacementView
import com.appsamurai.storyly.placement.ui.STRProductListener
import com.appsamurai.storyly.storybar.ui.STRStoryBarController
import com.appsamurai.storyly.storybar.ui.model.PlayMode
import com.appsamurai.storyly.storyly_placement_flutter.common.data.encodeSTRErrorPayload
import com.appsamurai.storyly.storyly_placement_flutter.common.data.encodeSTREventPayload
import com.appsamurai.storyly.storyly_placement_flutter.common.data.encodeSTRPayload
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.decodeSTRProductItem
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.encodeSTRCartItem
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.encodeSTRProductItem
import com.appsamurai.storyly.storyly_placement_flutter.common.data.util.decodeFromJson
import com.appsamurai.storyly.storyly_placement_flutter.common.data.util.encodeToJson
import com.appsamurai.storyly.videofeed.ui.STRVideoFeedController
import com.appsamurai.storyly.videofeed.ui.STRVideoFeedPresenterController
import com.appsamurai.storyly.videofeed.ui.model.VFPlayMode
import io.flutter.embedding.android.FlutterView
import java.lang.ref.WeakReference
import java.util.UUID


class SPStorylyPlacementView(context: Context) : FlutterView(context) {

    private var providerId: String? = null

    // Callback maps for async cart/wishlist operations
    private val cartUpdateCallbacks = mutableMapOf<String, Pair<(() -> Unit)?, ((String) -> Unit)?>>()
    private val wishlistUpdateCallbacks = mutableMapOf<String, Pair<(() -> Unit)?, ((String) -> Unit)?>>()

    private var widgetMap = mutableMapOf<String, WeakReference<STRWidgetController>>()

    private var placementView: STRPlacementView? = null

    internal var dispatchEvent: ((SPPlacementEventType, String?) -> Unit)? = null

    fun configure(providerId: String) {
        Handler(context.mainLooper).post {
            if (providerId == this@SPStorylyPlacementView.providerId) {
                Log.d("[SPStorylyPlacement]", "Already configured with providerId: $providerId")
                return@post
            }
            Log.d("[SPStorylyPlacement]", "Configuring with providerId: $providerId")
            this@SPStorylyPlacementView.providerId = providerId
            setupPlacementView()
        }
    }

    fun callWidget(id: String, method: String, raw: String?) {
        Handler(context.mainLooper).post {
            Log.d("[SPStorylyPlacement]", "callWidget: ${id}-${method}-${raw}")
            val widget = widgetMap[id]?.get() ?: return@post
            val params = decodeFromJson(raw)
            when (widget.getType()) {
                STRWidgetType.StoryBar -> handleStoryBarMethod(widget, method, params)
                STRWidgetType.VideoFeed -> handleVideoFeedMethod(widget, method, params)
                STRWidgetType.VideoFeedPresenter -> handleVideoFeedPresenterMethod(widget, method, params)
                STRWidgetType.Banner -> return@post
                STRWidgetType.SwipeCard -> return@post
                STRWidgetType.Canvas -> return@post
                STRWidgetType.None -> return@post
            }
        }
    }

    fun approveCartChange(responseId: String, raw: String?) {
        Handler(context.mainLooper).post {
            val callbacks = cartUpdateCallbacks[responseId] ?: return@post
            callbacks.first?.invoke()
            cartUpdateCallbacks.remove(responseId)
        }
    }

    fun rejectCartChange(responseId: String, raw: String?) {
        Handler(context.mainLooper).post {
            val callbacks = cartUpdateCallbacks[responseId] ?: return@post
            val failMessage = raw?.let {
                val map = decodeFromJson(it)
                map?.get("failMessage") as? String
            } ?: ""
            callbacks.second?.invoke(failMessage)
            cartUpdateCallbacks.remove(responseId)
        }
    }

    fun approveWishlistChange(responseId: String) {
        Handler(context.mainLooper).post {
            val callbacks = wishlistUpdateCallbacks[responseId] ?: return@post
            callbacks.first?.invoke()
            wishlistUpdateCallbacks.remove(responseId)
        }
    }

    fun rejectWishlistChange(responseId: String, raw: String?) {
        Handler(context.mainLooper).post {
            val callbacks = wishlistUpdateCallbacks[responseId] ?: return@post
            val failMessage = raw?.let {
                val map = decodeFromJson(it)
                map?.get("failMessage") as? String
            } ?: ""
            callbacks.second?.invoke(failMessage)
            wishlistUpdateCallbacks.remove(responseId)
        }
    }

    private fun setupPlacementView() {
        val currentProviderId = providerId ?: return

        Log.d("[SPStorylyPlacement]", "Setting up placement view with providerId: $currentProviderId")

        val providerWrapper = SPPlacementProviderManager.getProvider(currentProviderId)
        val dataProvider = providerWrapper?.provider ?: run {
            Log.e("[SPStorylyPlacement]", "Provider not found for id: $currentProviderId")
            return
        }
        placementView?.let { removeView(it) }

        placementView = createPlacementView(dataProvider)
        addView(placementView, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))
    }

    private fun createPlacementView(dataProvider: STRPlacementDataProvider): STRPlacementView {
        return STRPlacementView(context.getActivity() ?: context, dataProvider).apply {
            listener = object : STRListener {
                override fun onActionClicked(widget: STRWidgetController, url: String, payload: STRPayload) {
                    Log.d("[SPStorylyPlacement]", "onActionClicked: url=$url")
                    val eventJson = encodeToJson(mapOf(
                        "widget" to encodeWidgetController(widget),
                        "url" to url,
                        "payload" to encodeSTRPayload(payload)
                    ))
                    dispatchEvent?.invoke(SPPlacementEventType.ON_ACTION_CLICKED, eventJson)
                }

                override fun onEvent(widget: STRWidgetController, payload: STREventPayload) {
                    Log.d("[SPStorylyPlacement]", "onEvent: widgetType=${widget.getType()}, payload=${payload.baseEvent.getType()}")
                    val eventJson = encodeToJson(mapOf(
                        "widget" to encodeWidgetController(widget),
                        "payload" to encodeSTREventPayload(payload)
                    ))
                    println("AAAA: ${eventJson}")
                    dispatchEvent?.invoke(SPPlacementEventType.ON_EVENT, eventJson)
                }

                override fun onFail(widget: STRWidgetController, payload: STRErrorPayload) {
                    Log.w("[SPStorylyPlacement]", "onFail: widget=${widget.getType()}, payload=${payload.baseError.getType()}")
                    val eventJson = encodeToJson(mapOf(
                        "widget" to encodeWidgetController(widget),
                        "payload" to encodeSTRErrorPayload(payload)
                    ))
                    dispatchEvent?.invoke(SPPlacementEventType.ON_FAIL, eventJson)
                }

                override fun onWidgetReady(widget: STRWidgetController, ratio: Float) {
                    Log.d("[SPStorylyPlacement]", "onWidgetReady: ratio=$ratio")
                    val eventJson = encodeToJson(mapOf(
                        "widget" to encodeWidgetController(widget),
                        "ratio" to ratio,
                    ))
                    dispatchEvent?.invoke(SPPlacementEventType.ON_WIDGET_READY, eventJson)
                }
            }
            productListener = object : STRProductListener {
                override fun onProductEvent(widget: STRWidgetController, event: STRProductEvent) {
                    Log.d("[SPStorylyPlacement]", "onProductEvent: ${event.getType()}")
                    val eventJson = encodeToJson(mapOf(
                        "widget" to encodeWidgetController(widget),
                        "event" to event.getType(),
                    ))
                    dispatchEvent?.invoke(SPPlacementEventType.ON_PRODUCT_EVENT, eventJson)
                }

                override fun onUpdateCart(
                    widget: STRWidgetController,
                    item: STRCartItem?,
                    onSuccess: (() -> Unit)?,
                    onFail: ((String) -> Unit)?,
                ) {
                    Log.d("[SPStorylyPlacement]", "onUpdateCart")
                    val responseId = UUID.randomUUID().toString()
                    cartUpdateCallbacks[responseId] = Pair(onSuccess, onFail)
                    val eventJson = encodeToJson(
                        mapOf(
                            "widget" to encodeWidgetController(widget),
                            "item" to encodeSTRCartItem(item),
                            "responseId" to responseId,
                        )
                    )
                    dispatchEvent?.invoke(SPPlacementEventType.ON_UPDATE_CART, eventJson)
                }

                override fun onUpdateWishlist(
                    widget: STRWidgetController,
                    event: STRProductEvent,
                    item: STRProductItem?,
                    onSuccess: (() -> Unit)?,
                    onFail: ((String) -> Unit)?,
                ) {
                    Log.d("[SPStorylyPlacement]", "onUpdateWishlist: ${event.getType()}")
                    val responseId = UUID.randomUUID().toString()
                    wishlistUpdateCallbacks[responseId] = Pair(onSuccess, onFail)

                    val eventJson = encodeToJson(
                        mapOf(
                            "widget" to encodeWidgetController(widget),
                            "event" to event.getType(),
                            "item" to item?.let { encodeSTRProductItem(it) },
                            "responseId" to responseId,
                        )
                    )
                    dispatchEvent?.invoke(SPPlacementEventType.ON_UPDATE_WISHLIST, eventJson)
                }
            }
        }
    }

    private fun handleStoryBarMethod(widget: STRWidgetController, method: String, params: Map<String, Any?>?) {
        val controller = widget as? STRStoryBarController ?: return
        when (method) {
            "pause" -> {
                controller.pause()
            }
            "resume" -> {
                controller.resume()
            }
            "close" -> {
                controller.close()
            }
            "open" -> {
                params ?: return
                val uri = (params["uri"] as? String) ?: return
                controller.open(uri)
            }
            "openWithId" -> {
                params ?: return
                val storyGroupId = (params["storyGroupId"] as? String) ?: return
                val storyId = params["storyId"] as? String
                val playMode = (params["playMode"] as? String).let {
                    when (it) {
                        "storygroup" -> PlayMode.StoryGroup
                        "story" -> PlayMode.Story
                        else -> PlayMode.Default
                    }
                }
                controller.open(storyGroupId, storyId, playMode)
            }
            else -> return
        }
    }

    private fun handleVideoFeedMethod(widget: STRWidgetController, method: String, params: Map<String, Any?>?) {
        val controller = widget as? STRVideoFeedController ?: return
        when (method) {
            "pause" -> {
                controller.pause()
            }
            "resume" -> {
                controller.resume()
            }
            "close" -> {
                controller.close()
            }
            "open" -> {
                params ?: return
                val uri = (params["uri"] as? String) ?: return
                controller.open(uri)
            }
            "openWithId" -> {
                params ?: return
                val groupId = (params["groupId"] as? String) ?: return
                val itemId = params["itemId"] as? String
                val playMode = (params["playMode"] as? String).let {
                    when (it) {
                        "feedgroup" -> VFPlayMode.FeedGroup
                        "feed" -> VFPlayMode.Feed
                        else -> VFPlayMode.Default
                    }
                }
                controller.open(groupId, itemId, playMode)
            }
            else -> return
        }
    }

    private fun handleVideoFeedPresenterMethod(widget: STRWidgetController, method: String, params: Map<String, Any?>?) {
        val controller = widget as? STRVideoFeedPresenterController ?: return
        when (method) {
            "pause" -> {
                controller.pause()
            }
            "play" -> {
                controller.play()
            }
            "open" -> {
                params ?: return
                val groupId = (params["groupId"] as? String) ?: return
                controller.open(groupId)
            }
            else -> return
        }
    }

    private fun encodeWidgetController(controller: STRWidgetController): Map<String, String> {
        return mapOf(
            "type" to controller.getType().raw,
            "viewId" to updateWidgetMapKey(controller)
        )
    }

    private fun updateWidgetMapKey(controller: STRWidgetController): String {
        widgetMap.entries.removeIf { it.value.get() == null }
        widgetMap.entries.firstOrNull { it.value.get() == controller }?.let { entry ->
            return entry.key
        }

        val newKey = UUID.randomUUID().toString()
        widgetMap[newKey] = WeakReference(controller)
        return newKey
    }
}


