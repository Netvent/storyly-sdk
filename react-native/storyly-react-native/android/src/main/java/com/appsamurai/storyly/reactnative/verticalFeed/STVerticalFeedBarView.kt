package com.appsamurai.storyly.reactnative.verticalFeed

import android.content.Context
import android.view.Choreographer
import android.widget.FrameLayout
import com.appsamurai.storyly.StorylyDataSource
import com.appsamurai.storyly.analytics.VerticalFeedEvent
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartEventResult
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.appsamurai.storyly.data.managers.product.STRProductInformation
import com.appsamurai.storyly.reactnative.createSTRCartItemMap
import com.appsamurai.storyly.reactnative.createSTRCartMap
import com.appsamurai.storyly.reactnative.createSTRProductInformationMap
import com.appsamurai.storyly.verticalfeed.StorylyVerticalFeedBarView
import com.appsamurai.storyly.verticalfeed.VerticalFeedGroup
import com.appsamurai.storyly.verticalfeed.VerticalFeedItem
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemComponent
import com.appsamurai.storyly.verticalfeed.core.STRVerticalFeedView
import com.appsamurai.storyly.verticalfeed.listener.StorylyVerticalFeedListener
import com.appsamurai.storyly.verticalfeed.listener.StorylyVerticalFeedProductListener
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.LifecycleEventListener
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.RCTEventEmitter
import java.lang.ref.WeakReference
import java.util.UUID
import kotlin.properties.Delegates

class STVerticalFeedBarView(context: Context) : FrameLayout(context) {

    private var cartUpdateSuccessFailCallbackMap: MutableMap<String, Pair<((STRCart?) -> Unit)?, ((STRCartEventResult) -> Unit)?>> = mutableMapOf()

    internal var verticalFeedBarView: StorylyVerticalFeedBarView? by Delegates.observable(null) { _, _, _ ->
        removeAllViews()
        val verticalFeedBarView = verticalFeedBarView ?: return@observable
        addView(verticalFeedBarView, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))
        verticalFeedBarView.storylyVerticalFeedListener = object : StorylyVerticalFeedListener {
            override fun verticalFeedActionClicked(view: STRVerticalFeedView, feedItem: VerticalFeedItem) {
                sendEvent(STVerticalFeedManager.EVENT_STORYLY_ACTION_CLICKED, Arguments.createMap().also { eventMap ->
                    eventMap.putMap("feedItem", createVerticalFeedItem(feedItem))
                })
            }

            override fun verticalFeedLoaded(
                view: STRVerticalFeedView,
                feedGroupList: List<VerticalFeedGroup>,
                dataSource: StorylyDataSource
            ) {
                sendEvent(STVerticalFeedManager.EVENT_STORYLY_LOADED, Arguments.createMap().also { storyGroupListMap ->
                    storyGroupListMap.putArray("feedGroupList", Arguments.createArray().also { storyGroups ->
                        feedGroupList.forEach { group ->
                            storyGroups.pushMap(createVerticalFeedGroup(group))
                        }
                    })
                    storyGroupListMap.putString("dataSource", dataSource.value)
                })
            }

            override fun verticalFeedLoadFailed(
                view: STRVerticalFeedView,
                errorMessage: String
            ) {
                sendEvent(STVerticalFeedManager.EVENT_STORYLY_LOAD_FAILED, Arguments.createMap().also { eventMap ->
                    eventMap.putString("errorMessage", errorMessage)
                })
            }

            override fun verticalFeedEvent(
                view: STRVerticalFeedView,
                event: VerticalFeedEvent,
                feedGroup: VerticalFeedGroup?,
                feedItem: VerticalFeedItem?,
                feedItemComponent: VerticalFeedItemComponent?
            ) {
                sendEvent(STVerticalFeedManager.EVENT_STORYLY_EVENT, Arguments.createMap().also { eventMap ->
                    eventMap.putString("event", event.name)
                    feedGroup?.let { eventMap.putMap("feedGroup", createVerticalFeedGroup(it)) }
                    feedItem?.let { eventMap.putMap("feedItem", createVerticalFeedItem(it)) }
                    feedItemComponent?.let { eventMap.putMap("feedItemComponent", createVerticalFeedComponentMap(it)) }
                })
            }

            override fun verticalFeedShown(view: STRVerticalFeedView) {
                sendEvent(STVerticalFeedManager.EVENT_STORYLY_VERTICAL_FEED_PRESENTED, null)
            }

            override fun verticalFeedShowFailed(view: STRVerticalFeedView, errorMessage: String) {
                sendEvent(STVerticalFeedManager.EVENT_STORYLY_VERTICAL_FEED_PRESENT_FAILED, Arguments.createMap().also { eventMap ->
                    eventMap.putString("errorMessage", errorMessage)
                })
                sendEvent(STVerticalFeedManager.EVENT_STORYLY_VERTICAL_FEED_PRESENTED, null)
            }

            override fun verticalFeedDismissed(view: STRVerticalFeedView) {
                sendEvent(STVerticalFeedManager.EVENT_STORYLY_VERTICAL_FEED_DISMISSED, null)
            }

            override fun verticalFeedUserInteracted(
                view: STRVerticalFeedView,
                feedGroup: VerticalFeedGroup,
                feedItem: VerticalFeedItem,
                feedItemComponent: VerticalFeedItemComponent
            ) {
                sendEvent(STVerticalFeedManager.EVENT_STORYLY_USER_INTERACTED, Arguments.createMap().apply {
                    putMap("feedGroup", createVerticalFeedGroup(feedGroup))
                    putMap("feedItem", createVerticalFeedItem(feedItem))
                    putMap("feedItemComponent", createVerticalFeedComponentMap(feedItemComponent))
                })
            }
        }

        verticalFeedBarView.storylyVerticalFeedProductListener = object : StorylyVerticalFeedProductListener {
            override fun verticalFeedUpdateCartEvent(
                view: STRVerticalFeedView,
                event: VerticalFeedEvent,
                cart: STRCart?,
                change: STRCartItem?,
                onSuccess: ((STRCart?) -> Unit)?,
                onFail: ((STRCartEventResult) -> Unit)?
            ) {
                val responseId = UUID.randomUUID().toString()
                cartUpdateSuccessFailCallbackMap[responseId] = Pair(onSuccess, onFail)

                val eventParameters = Arguments.createMap().apply {
                    putString("event", event.name)
                    putMap("cart", createSTRCartMap(cart))
                    putMap("change", createSTRCartItemMap(change))
                    putString("responseId", responseId)
                }

                sendEvent(
                    STVerticalFeedManager.EVENT_STORYLY_ON_CART_UPDATED,
                    eventParameters
                )
            }

            override fun verticalFeedEvent(
                view: STRVerticalFeedView,
                event: VerticalFeedEvent
            ) {
                sendEvent(
                    STVerticalFeedManager.EVENT_STORYLY_PRODUCT_EVENT,
                    Arguments.createMap().apply {
                        putString("event", event.name)
                    }
                )
            }

            override fun verticalFeedHydration(
                view: STRVerticalFeedView,
                products: List<STRProductInformation>
            ) {
                sendEvent(STVerticalFeedManager.EVENT_STORYLY_ON_HYDRATION, Arguments.createMap().also { productInformationMap ->
                    productInformationMap.putArray("products", Arguments.createArray().also { productMap ->
                        products.forEach { productInfo ->
                            productMap.pushMap(createSTRProductInformationMap(productInfo))
                        }
                    })
                })
            }
        }
    }

    internal val activity: Context
        get() = ((context as? ReactContext)?.currentActivity ?: context)

    private val choreographerFrameCallback: Choreographer.FrameCallback by lazy {
        Choreographer.FrameCallback {
            if (isAttachedToWindow && verticalFeedBarView?.isAttachedToWindow == true) {
                manuallyLayout()
                viewTreeObserver.dispatchOnGlobalLayout()
                Choreographer.getInstance().postFrameCallback(choreographerFrameCallback)
            }
        }
    }

    init {
        (context as? ReactContext)?.addLifecycleEventListener(object : LifecycleEventListener {
            override fun onHostResume() {
                val activity = (context as? ReactContext)?.currentActivity ?: return
                verticalFeedBarView?.activity = WeakReference(activity)
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

    private fun manuallyLayout() {
        val storylyView = verticalFeedBarView ?: return
        storylyView.measure(
            MeasureSpec.makeMeasureSpec(measuredWidth, MeasureSpec.EXACTLY),
            MeasureSpec.makeMeasureSpec(measuredHeight, MeasureSpec.EXACTLY)
        )
        storylyView.layout(0, 0, storylyView.measuredWidth, storylyView.measuredHeight)
    }

    internal fun sendEvent(eventName: String, eventParameters: WritableMap?) {
        (context as? ReactContext)?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, eventName, eventParameters)
    }

    internal fun approveCartChange(responseId: String, cart: STRCart? = null) {
        cartUpdateSuccessFailCallbackMap[responseId]?.first?.invoke(cart)
        cartUpdateSuccessFailCallbackMap.remove(responseId)
    }

    internal fun rejectCartChange(responseId: String, failMessage: String) {
        cartUpdateSuccessFailCallbackMap[responseId]?.second?.invoke(STRCartEventResult(failMessage))
        cartUpdateSuccessFailCallbackMap.remove(responseId)
    }
}