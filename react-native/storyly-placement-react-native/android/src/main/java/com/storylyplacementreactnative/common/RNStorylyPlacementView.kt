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
import java.util.UUID


class RNStorylyPlacementView(context: Context) : FrameLayout(context) {

    companion object {
        private const val TAG = "RNStorylyPlacementView"
    }

    // MARK: - Properties

    private var providerId: String? = null

    // Callback maps for async cart/wishlist operations
    internal val cartUpdateCallbacks = mutableMapOf<String, Pair<((STRCart?) -> Unit)?, ((STRCartEventResult) -> Unit)?>>()
    internal val wishlistUpdateCallbacks = mutableMapOf<String, Pair<((STRProductItem?) -> Unit)?, ((STRWishlistEventResult) -> Unit)?>>()

    private var nativePlacementView: STRPlacementView? = null

    // Event dispatcher function (set by view manager)
    internal var dispatchEvent: ((RNPlacementEventType, String) -> Unit)? = null

    // Choreographer for layout updates
    private val choreographerFrameCallback: Choreographer.FrameCallback by lazy {
        Choreographer.FrameCallback {
            if (isAttachedToWindow && nativePlacementView?.isAttachedToWindow == true) {
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

    // MARK: - Configuration (JSON string input)

    fun configure(providerId: String) {
        this.providerId = providerId
        setupPlacementView()
    }

    private fun setupPlacementView() {
        val currentProviderId = providerId ?: return

        Log.d(TAG, "Setting up placement view with providerId: $currentProviderId")

        val providerWrapper = RNPlacementProviderManager.getProvider(currentProviderId)
        val dataProvider = providerWrapper?.provider ?: run {
            Log.e(TAG, "Provider not found for id: $currentProviderId")
            return
        }

        // Remove old view if exists
        nativePlacementView?.let { removeView(it) }

        // Create STRPlacementView
        nativePlacementView = STRPlacementView(context, dataProvider).apply {
            listener = createSTRListener()
            productListener = createSTRProductListener()
        }

        addView(nativePlacementView, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))
    }

    private fun manuallyLayout() {
        val view = nativePlacementView ?: return
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

    // MARK: - STRListener Implementation

    private fun createSTRListener(): STRListener {
        return object : STRListener {
            override fun onActionClicked(widget: STRWidgetController, url: String, payload: STRPayload) {
                Log.d(TAG, "onActionClicked: url=$url")
                val eventJson = RNPlacementDataConverter.encodeToJson(
                    mapOf(
                        "url" to url,
                        "widgetType" to widget.getType(),
                    )
                )
                dispatchEvent?.invoke(RNPlacementEventType.ON_PLACEMENT_ACTION_CLICKED, eventJson ?: "")
            }

            override fun onEvent(widget: STRWidgetController, payload: STREventPayload) {
                Log.d(TAG, "onEvent: widgetType=${widget.getType()}")
                val eventJson = RNPlacementDataConverter.encodeToJson(
                    mapOf(
                        "widgetType" to widget.getType(),
                    )
                )
                dispatchEvent?.invoke(RNPlacementEventType.ON_PLACEMENT_EVENT, eventJson ?: "")
            }

            override fun onFail(widget: STRWidgetController, payload: STRErrorPayload) {
                Log.e(TAG, "onFail: widgetType=${widget.getType()}")
                val eventJson = RNPlacementDataConverter.createFailEvent("Widget error")
                dispatchEvent?.invoke(RNPlacementEventType.ON_PLACEMENT_FAIL, eventJson ?: "")
            }

            override fun onWidgetReady(widget: STRWidgetController, ratio: Float) {
                Log.d(TAG, "onWidgetReady: ratio=$ratio")
                val eventJson = RNPlacementDataConverter.createWidgetReadyEvent(ratio)
                dispatchEvent?.invoke(RNPlacementEventType.ON_PLACEMENT_READY, eventJson ?: "")
            }
        }
    }

    // MARK: - STRProductListener Implementation

    private fun createSTRProductListener(): STRProductListener {
        return object : STRProductListener {
            override fun onProductEvent(widget: STRWidgetController, event: STREvent) {
                Log.d(TAG, "onProductEvent: ${event.getType()}")
                val eventJson = RNPlacementDataConverter.encodeToJson(
                    mapOf(
                        "event" to event.getType(),
                        "widgetType" to widget.getType(),
                    )
                )
                dispatchEvent?.invoke(RNPlacementEventType.ON_PLACEMENT_PRODUCT_EVENT, eventJson ?: "")
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

                val cartMap = RNPlacementDataConverter.createSTRCartMap(cart)
                val changeMap = RNPlacementDataConverter.createSTRCartItemMap(change)

                val eventJson = RNPlacementDataConverter.encodeToJson(
                    mapOf(
                        "event" to event.getType(),
                        "widgetType" to widget.getType(),
                        "cart" to cartMap,
                        "change" to changeMap,
                        "responseId" to responseId,
                    )
                )
                dispatchEvent?.invoke(RNPlacementEventType.ON_PLACEMENT_CART_UPDATE, eventJson ?: "")
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

                val itemMap = item?.let { RNPlacementDataConverter.createSTRProductItemMap(it) }

                val eventJson = RNPlacementDataConverter.encodeToJson(
                    mapOf(
                        "event" to event.getType(),
                        "widgetType" to widget.getType(),
                        "item" to itemMap,
                        "responseId" to responseId,
                    )
                )
                dispatchEvent?.invoke(RNPlacementEventType.ON_PLACEMENT_WISHLIST_UPDATE, eventJson ?: "")
            }
        }
    }

    // MARK: - Commands

    fun pauseStory() {
        Log.d(TAG, "pauseStory")
        // Note: STRPlacementView doesn't have pause/resume methods directly
        // These might need to be implemented based on specific widget types
    }

    fun resumeStory() {
        Log.d(TAG, "resumeStory")
        // Note: STRPlacementView doesn't have pause/resume methods directly
        // These might need to be implemented based on specific widget types
    }

    // MARK: - Cart/Wishlist Response (JSON string input)

    fun approveCartChange(responseId: String, cartJson: String?) {
        val callbacks = cartUpdateCallbacks[responseId] ?: return
        val cart = if (cartJson != null) {
            RNPlacementDataConverter.parseCart(cartJson)
        } else {
            null
        }
        callbacks.first?.invoke(cart)
        cartUpdateCallbacks.remove(responseId)
    }

    fun rejectCartChange(responseId: String, failMessage: String) {
        val callbacks = cartUpdateCallbacks[responseId] ?: return
        callbacks.second?.invoke(STRCartEventResult(failMessage))
        cartUpdateCallbacks.remove(responseId)
    }

    fun approveWishlistChange(responseId: String, itemJson: String?) {
        val callbacks = wishlistUpdateCallbacks[responseId] ?: return
        val item = if (itemJson != null) {
            val decoded = RNPlacementDataConverter.decodeFromJson(itemJson)
            decoded?.let { RNPlacementDataConverter.createSTRProductItem(it) }
        } else {
            null
        }
        callbacks.first?.invoke(item)
        wishlistUpdateCallbacks.remove(responseId)
    }

    fun rejectWishlistChange(responseId: String, failMessage: String) {
        val callbacks = wishlistUpdateCallbacks[responseId] ?: return
        callbacks.second?.invoke(STRWishlistEventResult(failMessage))
        wishlistUpdateCallbacks.remove(responseId)
    }
}


