package com.storylyplacementreactnative.common

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.Choreographer
import android.widget.FrameLayout
import com.appsamurai.storyly.core.STRWidgetType
import com.appsamurai.storyly.core.analytics.error.STRErrorPayload
import com.appsamurai.storyly.core.analytics.event.STREvent
import com.appsamurai.storyly.core.analytics.event.STREventPayload
import com.appsamurai.storyly.core.data.model.STRPayload
import com.appsamurai.storyly.core.data.model.product.STRCart
import com.appsamurai.storyly.core.data.model.product.STRCartEventResult
import com.appsamurai.storyly.core.data.model.product.STRCartItem
import com.appsamurai.storyly.core.data.model.product.STRProductItem
import com.appsamurai.storyly.core.data.model.product.STRWishlistEventResult
import com.appsamurai.storyly.core.ui.STRWidgetController
import com.appsamurai.storyly.placement.data.provider.PlacementDataProvider
import com.appsamurai.storyly.placement.ui.STRListener
import com.appsamurai.storyly.placement.ui.STRPlacementView
import com.appsamurai.storyly.placement.ui.STRProductListener
import com.appsamurai.storyly.storybar.ui.STRStoryBarController
import com.appsamurai.storyly.storybar.ui.model.PlayMode
import com.appsamurai.storyly.videofeed.ui.STRVideoFeedController
import com.appsamurai.storyly.videofeed.ui.STRVideoFeedPresenterController
import com.appsamurai.storyly.videofeed.ui.model.VFPlayMode
import com.facebook.react.bridge.LifecycleEventListener
import com.facebook.react.bridge.ReactContext
import com.storylyplacementreactnative.common.data.encodeSTRErrorPayload
import com.storylyplacementreactnative.common.data.encodeSTREventPayload
import com.storylyplacementreactnative.common.data.encodeSTRPayload
import com.storylyplacementreactnative.common.data.product.decodeSTRCart
import com.storylyplacementreactnative.common.data.product.decodeSTRProductItem
import com.storylyplacementreactnative.common.data.product.encodeSTRCart
import com.storylyplacementreactnative.common.data.product.encodeSTRCartItem
import com.storylyplacementreactnative.common.data.product.encodeSTRProductItem
import com.storylyplacementreactnative.common.data.util.decodeFromJson
import com.storylyplacementreactnative.common.data.util.encodeToJson
import java.lang.ref.WeakReference
import java.util.UUID


class RNStorylyPlacementView(context: Context) : FrameLayout(context) {

    private var providerId: String? = null

    // Callback maps for async cart/wishlist operations
    internal val cartUpdateCallbacks = mutableMapOf<String, Pair<((STRCart?) -> Unit)?, ((STRCartEventResult) -> Unit)?>>()
    internal val wishlistUpdateCallbacks = mutableMapOf<String, Pair<((STRProductItem?) -> Unit)?, ((STRWishlistEventResult) -> Unit)?>>()

    private var widgetMap = mutableMapOf<String, WeakReference<STRWidgetController>>()

    private var placementView: STRPlacementView? = null

    internal var dispatchEvent: ((RNPlacementEventType, String?) -> Unit)? = null

    private val choreographerFrameCallback: Choreographer.FrameCallback by lazy {
        Choreographer.FrameCallback {
            if (isAttachedToWindow) {
                manuallyLayout()
                viewTreeObserver.dispatchOnGlobalLayout()
                Choreographer.getInstance().postFrameCallback(choreographerFrameCallback)
            }
        }
    }

    internal val activity: Context
        get() = ((context as? ReactContext)?.currentActivity ?: context)

    init {
        (context as? ReactContext)?.addLifecycleEventListener(object : LifecycleEventListener {
            override fun onHostResume() {
                setupPlacementView()
            }

            override fun onHostPause() {}

            override fun onHostDestroy() {}
        })
    }
    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        Choreographer.getInstance().postFrameCallback(choreographerFrameCallback)
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        Choreographer.getInstance().removeFrameCallback(choreographerFrameCallback)
    }

    fun configure(providerId: String) {
        Handler(Looper.getMainLooper()).post {
            if (providerId == this@RNStorylyPlacementView.providerId) {
                Log.d("[RNStorylyPlacement]", "Already configured with providerId: $providerId")
                return@post
            }
            Log.d("[RNStorylyPlacement]", "Configuring with providerId: $providerId")
            this@RNStorylyPlacementView.providerId = providerId
            setupPlacementView()
        }
    }

    private fun setupPlacementView() {
        val currentProviderId = providerId ?: return

        Log.d("[RNStorylyPlacement]", "Setting up placement view with providerId: $currentProviderId")

        val providerWrapper = RNPlacementProviderManager.getProvider(currentProviderId)
        val dataProvider = providerWrapper?.provider ?: run {
            Log.e("[RNStorylyPlacement]", "Provider not found for id: $currentProviderId")
            return
        }
        placementView?.let { removeView(it) }

        placementView = createPlacementView(dataProvider)
        addView(placementView, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))
        manuallyLayout()
    }

    private fun manuallyLayout() {
        placementView?.let { view ->
            view.measure(
                MeasureSpec.makeMeasureSpec(MeasureSpec.getSize(measuredWidth), MeasureSpec.EXACTLY),
                MeasureSpec.makeMeasureSpec(MeasureSpec.getSize(measuredHeight), MeasureSpec.EXACTLY)
            )
            view.layout(0, 0, view.measuredWidth, view.measuredHeight)
        }
    }

    private fun createPlacementView(dataProvider: PlacementDataProvider): STRPlacementView {
        return STRPlacementView(activity, dataProvider).apply {
            listener = object : STRListener {
                override fun onActionClicked(widget: STRWidgetController, url: String, payload: STRPayload) {
                    Log.d("[RNStorylyPlacement]", "onActionClicked: url=$url")
                    val eventJson = encodeToJson(mapOf(
                        "widget" to encodeWidgetController(widget),
                        "url" to url,
                        "payload" to encodeSTRPayload(payload)
                    ))
                    dispatchEvent?.invoke(RNPlacementEventType.ON_ACTION_CLICKED, eventJson)
                }

                override fun onEvent(widget: STRWidgetController, payload: STREventPayload) {
                    Log.d("[RNStorylyPlacement]", "onEvent: widgetType=${widget.getType()}, payload=${payload.baseEvent.getType()}")
                    val eventJson = encodeToJson(mapOf(
                        "widget" to encodeWidgetController(widget),
                        "payload" to encodeSTREventPayload(payload)
                    ))
                    println("AAAA: ${eventJson}")
                    dispatchEvent?.invoke(RNPlacementEventType.ON_EVENT, eventJson)
                }

                override fun onFail(widget: STRWidgetController, payload: STRErrorPayload) {
                    Log.w("[RNStorylyPlacement]", "onFail: widget=${widget.getType()}, payload=${payload.baseError.getType()}")
                    val eventJson = encodeToJson(mapOf(
                        "widget" to encodeWidgetController(widget),
                        "payload" to encodeSTRErrorPayload(payload)
                    ))
                    dispatchEvent?.invoke(RNPlacementEventType.ON_FAIL, eventJson)
                }

                override fun onWidgetReady(widget: STRWidgetController, ratio: Float) {
                    Log.d("[RNStorylyPlacement]", "onWidgetReady: ratio=$ratio")
                    val eventJson = encodeToJson(mapOf(
                        "widget" to encodeWidgetController(widget),
                        "ratio" to ratio,
                    ))
                    dispatchEvent?.invoke(RNPlacementEventType.ON_WIDGET_READY, eventJson)
                }
            }
            productListener = object : STRProductListener {
                override fun onProductEvent(widget: STRWidgetController, event: STREvent) {
                    Log.d("[RNStorylyPlacement]", "onProductEvent: ${event.getType()}")
                    val eventJson = encodeToJson(mapOf(
                        "widget" to encodeWidgetController(widget),
                        "event" to event.getType(),
                    ))
                    dispatchEvent?.invoke(RNPlacementEventType.ON_PRODUCT_EVENT, eventJson)
                }

                override fun onUpdateCart(
                    widget: STRWidgetController,
                    event: STREvent,
                    cart: STRCart?,
                    change: STRCartItem?,
                    onSuccess: ((STRCart?) -> Unit)?,
                    onFail: ((STRCartEventResult) -> Unit)?,
                ) {
                    Log.d("[RNStorylyPlacement]", "onUpdateProduct: ${event.getType()}")
                    val responseId = UUID.randomUUID().toString()
                    cartUpdateCallbacks[responseId] = Pair(onSuccess, onFail)
                    val eventJson = encodeToJson(
                        mapOf(
                            "widget" to encodeWidgetController(widget),
                            "event" to event.getType(),
                            "cart" to encodeSTRCart(cart),
                            "change" to encodeSTRCartItem(change),
                            "responseId" to responseId,
                        )
                    )
                    dispatchEvent?.invoke(RNPlacementEventType.ON_CART_UPDATE, eventJson)
                }

                override fun onUpdateWishlist(
                    widget: STRWidgetController,
                    item: STRProductItem?,
                    event: STREvent,
                    onSuccess: ((STRProductItem?) -> Unit)?,
                    onFail: ((STRWishlistEventResult) -> Unit)?,
                ) {
                    Log.d("[RNStorylyPlacement]", "onUpdateWishlist: ${event.getType()}")
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
                    dispatchEvent?.invoke(RNPlacementEventType.ON_WISHLIST_UPDATE, eventJson)
                }
            }
        }
    }

    fun callWidget(id: String, method: String, raw: String?) {
        Log.d("[RNStorylyPlacement]", "callWidget: ${id}-${method}-${raw}")
        val widget = widgetMap[id]?.get() ?: return
        val params = decodeFromJson(raw)
        when (widget.getType()) {
            STRWidgetType.StoryBar -> handleStoryBarMethod(widget, method, params)
            STRWidgetType.VideoFeed -> handleVideoFeedMethod(widget, method, params)
            STRWidgetType.VideoFeedPresenter -> handleVideoFeedPresenterMethod(widget, method, params)
            STRWidgetType.Banner -> return
            STRWidgetType.SwipeCard -> return
            STRWidgetType.None -> return
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


    fun approveCartChange(responseId: String, raw: String?) {
        val callbacks = cartUpdateCallbacks[responseId] ?: return
        val cart = raw?.let {
            val map = decodeFromJson(it)
            decodeSTRCart(map?.get("cart") as? Map<String, Any?>)
        }
        callbacks.first?.invoke(cart)
        cartUpdateCallbacks.remove(responseId)
    }

    fun rejectCartChange(responseId: String, raw: String?) {
        val callbacks = cartUpdateCallbacks[responseId] ?: return
        val failMessage = raw?.let {
            val map = decodeFromJson(it)
            map?.get("failMessage") as? String
        } ?: ""
        callbacks.second?.invoke(STRCartEventResult(failMessage))
        cartUpdateCallbacks.remove(responseId)
    }

    fun approveWishlistChange(responseId: String, raw: String?) {
        val callbacks = wishlistUpdateCallbacks[responseId] ?: return
        val item = raw?.let {
            val map = decodeFromJson(it)
            (map?.get("item") as? Map<String, Any?>)?.let { item ->
                decodeSTRProductItem(item)
            }
        }
        callbacks.first?.invoke(item)
        wishlistUpdateCallbacks.remove(responseId)
    }

    fun rejectWishlistChange(responseId: String, raw: String?) {
        val callbacks = wishlistUpdateCallbacks[responseId] ?: return
        val failMessage = raw?.let {
            val map = decodeFromJson(it)
            map?.get("failMessage") as? String
        } ?: ""
        callbacks.second?.invoke(STRWishlistEventResult(failMessage))
        wishlistUpdateCallbacks.remove(responseId)
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


