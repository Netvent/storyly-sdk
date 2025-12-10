package com.storylyplacementreactnative.common

import android.content.Context
import android.util.Log
import android.view.Choreographer
import android.view.ViewGroup
import android.widget.FrameLayout
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
import com.appsamurai.storyly.placement.ui.STRListener
import com.appsamurai.storyly.placement.ui.STRPlacementView
import com.appsamurai.storyly.placement.ui.STRProductListener
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
import java.util.UUID


class RNStorylyPlacementView(context: Context) : FrameLayout(context) {

    private var providerId: String? = null

    // Callback maps for async cart/wishlist operations
    internal val cartUpdateCallbacks = mutableMapOf<String, Pair<((STRCart?) -> Unit)?, ((STRCartEventResult) -> Unit)?>>()
    internal val wishlistUpdateCallbacks = mutableMapOf<String, Pair<((STRProductItem?) -> Unit)?, ((STRWishlistEventResult) -> Unit)?>>()

    private var placementView: STRPlacementView? = null

    internal var dispatchEvent: ((RNPlacementEventType, String?) -> Unit)? = null

    private val choreographerFrameCallback: Choreographer.FrameCallback by lazy {
        Choreographer.FrameCallback {
            if (isAttachedToWindow && placementView?.isAttachedToWindow == true) {
                manuallyLayout()
                viewTreeObserver.dispatchOnGlobalLayout()
                Choreographer.getInstance().postFrameCallback(choreographerFrameCallback)
            }
        }
    }

    init {
        setBackgroundColor(android.graphics.Color.TRANSPARENT)
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
        this.providerId = providerId
        setupPlacementView()
    }

    private fun setupPlacementView() {
        val currentProviderId = providerId ?: return

        Log.d("[RNStorylyPlacementView]", "Setting up placement view with providerId: $currentProviderId")

        val providerWrapper = RNPlacementProviderManager.getProvider(currentProviderId)
        val dataProvider = providerWrapper?.provider ?: run {
            Log.e("[RNStorylyPlacementView]", "Provider not found for id: $currentProviderId")
            return
        }

        // Remove old view if exists
        placementView?.let { removeView(it) }

        // Create STRPlacementView
        placementView = STRPlacementView(context, dataProvider).apply {
            listener = createSTRListener()
            productListener = createSTRProductListener()
        }

        addView(placementView, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))
    }

    private fun manuallyLayout() {
        val view = placementView ?: return
        view.measure(
            MeasureSpec.makeMeasureSpec(measuredWidth, MeasureSpec.EXACTLY),
            MeasureSpec.makeMeasureSpec(measuredHeight, MeasureSpec.EXACTLY)
        )
        view.layout(0, 0, view.measuredWidth, view.measuredHeight)

        (view as? ViewGroup)?.let { viewGroup ->
            for (i in 0 until viewGroup.childCount) {
                viewGroup.getChildAt(i).requestLayout()
            }
        }
    }

    private fun createSTRListener(): STRListener {
        return object : STRListener {
            override fun onActionClicked(widget: STRWidgetController, url: String, payload: STRPayload) {
                Log.d("[RNStorylyPlacementView]", "onActionClicked: url=$url")
                val eventJson = encodeToJson(mapOf(
                    "widget" to widget.getType().raw,
                    "url" to url,
                    "payload" to encodeSTRPayload(payload)
                ))
                dispatchEvent?.invoke(RNPlacementEventType.ON_ACTION_CLICKED, eventJson)
            }

            override fun onEvent(widget: STRWidgetController, payload: STREventPayload) {
                Log.d("[RNStorylyPlacementView]", "onEvent: widgetType=${widget.getType()}")
                val eventJson = encodeToJson(mapOf(
                    "widget" to widget.getType().raw,
                    "payload" to encodeSTREventPayload(payload)
                ))
                dispatchEvent?.invoke(RNPlacementEventType.ON_EVENT, eventJson)
            }

            override fun onFail(widget: STRWidgetController, payload: STRErrorPayload) {
                Log.e("[RNStorylyPlacementView]", "onFail: widget=${widget.getType()}")
                val eventJson = encodeToJson(mapOf(
                    "widget" to widget.getType(),
                    "payload" to encodeSTRErrorPayload(payload)
                ))
                dispatchEvent?.invoke(RNPlacementEventType.ON_FAIL, eventJson)
            }

            override fun onWidgetReady(widget: STRWidgetController, ratio: Float) {
                Log.d("[RNStorylyPlacementView]", "onWidgetReady: ratio=$ratio")
                val eventJson = encodeToJson(mapOf(
                    "widget" to widget.getType(),
                    "ratio" to ratio,
                ))
                dispatchEvent?.invoke(RNPlacementEventType.ON_WIDGET_READY, eventJson)
            }
        }
    }

    private fun createSTRProductListener(): STRProductListener {
        return object : STRProductListener {
            override fun onProductEvent(widget: STRWidgetController, event: STREvent) {
                Log.d("[RNStorylyPlacementView]", "onProductEvent: ${event.getType()}")
                val eventJson = encodeToJson(mapOf(
                    "widget" to widget.getType(),
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
                val responseId = UUID.randomUUID().toString()
                cartUpdateCallbacks[responseId] = Pair(onSuccess, onFail)
                val eventJson = encodeToJson(
                    mapOf(
                        "event" to event.getType(),
                        "widget" to widget.getType(),
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
                val responseId = UUID.randomUUID().toString()
                wishlistUpdateCallbacks[responseId] = Pair(onSuccess, onFail)

                val eventJson = encodeToJson(
                    mapOf(
                        "event" to event.getType(),
                        "widget" to widget.getType(),
                        "item" to item?.let { encodeSTRProductItem(it) },
                        "responseId" to responseId,
                    )
                )
                dispatchEvent?.invoke(RNPlacementEventType.ON_WISHLIST_UPDATE, eventJson)
            }
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
}


