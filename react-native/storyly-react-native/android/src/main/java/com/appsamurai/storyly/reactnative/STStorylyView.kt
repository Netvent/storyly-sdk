package com.appsamurai.storyly.reactnative

import android.content.Context
import android.view.Choreographer
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.appsamurai.storyly.Story
import com.appsamurai.storyly.StoryComponent
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StorylyDataSource
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.StorylyProductListener
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storyly.analytics.StorylyEvent
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartEventResult
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.appsamurai.storyly.data.managers.product.STRProductInformation
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.LifecycleEventListener
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.RCTEventEmitter
import java.lang.ref.WeakReference
import java.util.UUID
import kotlin.properties.Delegates

class STStorylyView(context: Context) : FrameLayout(context) {

    private var cartUpdateSuccessFailCallbackMap: MutableMap<String, Pair<((STRCart?) -> Unit)?, ((STRCartEventResult) -> Unit)?>> = mutableMapOf()

    internal var storylyView: StorylyView? by Delegates.observable(null) { _, _, _ ->
        removeAllViews()
        val storylyView = storylyView ?: return@observable
        addView(storylyView, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))
        storylyView.storylyListener = object : StorylyListener {
            override fun storylyActionClicked(storylyView: StorylyView, story: Story) {
                sendEvent(STStorylyManager.EVENT_STORYLY_ACTION_CLICKED, Arguments.createMap().also { eventMap ->
                    eventMap.putMap("story", createStoryMap(story))
                })
            }

            override fun storylyLoaded(
                storylyView: StorylyView,
                storyGroupList: List<StoryGroup>,
                dataSource: StorylyDataSource
            ) {
                sendEvent(STStorylyManager.EVENT_STORYLY_LOADED, Arguments.createMap().also { storyGroupListMap ->
                    storyGroupListMap.putArray("storyGroupList", Arguments.createArray().also { storyGroups ->
                        storyGroupList.forEach { storyGroup ->
                            storyGroups.pushMap(createStoryGroupMap(storyGroup))
                        }
                    })
                    storyGroupListMap.putString("dataSource", dataSource.value)
                })
            }

            override fun storylyLoadFailed(
                storylyView: StorylyView,
                errorMessage: String
            ) {
                sendEvent(STStorylyManager.EVENT_STORYLY_LOAD_FAILED, Arguments.createMap().also { eventMap ->
                    eventMap.putString("errorMessage", errorMessage)
                })
            }

            override fun storylyEvent(
                storylyView: StorylyView,
                event: StorylyEvent,
                storyGroup: StoryGroup?,
                story: Story?, storyComponent: StoryComponent?
            ) {
                sendEvent(STStorylyManager.EVENT_STORYLY_EVENT, Arguments.createMap().also { eventMap ->
                    eventMap.putString("event", event.name)
                    storyGroup?.let { eventMap.putMap("storyGroup", createStoryGroupMap(it)) }
                    story?.let { eventMap.putMap("story", createStoryMap(it)) }
                    storyComponent?.let { eventMap.putMap("storyComponent", createStoryComponentMap(it)) }
                })
            }

            override fun storylyStoryShown(storylyView: StorylyView) {
                sendEvent(STStorylyManager.EVENT_STORYLY_STORY_PRESENTED, null)
            }

            override fun storylyStoryShowFailed(storylyView: StorylyView, errorMessage: String) {
                sendEvent(STStorylyManager.EVENT_STORYLY_STORY_PRESENT_FAILED, Arguments.createMap().also { eventMap ->
                    eventMap.putString("errorMessage", errorMessage)
                })
                sendEvent(STStorylyManager.EVENT_STORYLY_STORY_PRESENTED, null)
            }

            override fun storylyStoryDismissed(storylyView: StorylyView) {
                sendEvent(STStorylyManager.EVENT_STORYLY_STORY_DISMISSED, null)
            }

            override fun storylyUserInteracted(
                storylyView: StorylyView,
                storyGroup: StoryGroup,
                story: Story,
                storyComponent: StoryComponent
            ) {
                sendEvent(STStorylyManager.EVENT_STORYLY_USER_INTERACTED, Arguments.createMap().apply {
                    putMap("storyGroup", createStoryGroupMap(storyGroup))
                    putMap("story", createStoryMap(story))
                    putMap("storyComponent", createStoryComponentMap(storyComponent))
                })
            }
        }

        storylyView.storylyProductListener = object : StorylyProductListener {
            override fun storylyUpdateCartEvent(
                storylyView: StorylyView,
                event: StorylyEvent,
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
                    STStorylyManager.EVENT_STORYLY_ON_CART_UPDATED,
                    eventParameters
                )
            }

            override fun storylyEvent(
                storylyView: StorylyView,
                event: StorylyEvent
            ) {
                sendEvent(
                    STStorylyManager.EVENT_STORYLY_PRODUCT_EVENT,
                    Arguments.createMap().apply {
                        putString("event", event.name)
                    }
                )
            }

            override fun storylyHydration(
                storylyView: StorylyView,
                products: List<STRProductInformation>
            ) {
                sendEvent(STStorylyManager.EVENT_STORYLY_ON_HYDRATION, Arguments.createMap().also { productInformationMap ->
                    productInformationMap.putArray("products", Arguments.createArray().also { productMap ->
                        products.forEach { productInfo ->
                            productMap.pushMap(createSTRProductInformationMap(productInfo))
                        }
                    })
                })
            }
        }
    }

    internal var storyGroupViewFactory: STStoryGroupViewFactory? = null

    internal val activity: Context
        get() = ((context as? ReactContext)?.currentActivity ?: context)

    private val choreographerFrameCallback: Choreographer.FrameCallback by lazy {
        Choreographer.FrameCallback {
            if (isAttachedToWindow && storylyView?.isAttachedToWindow == true) {
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
                storylyView?.activity = WeakReference(activity)
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

    internal fun onAttachCustomReactNativeView(child: View?, index: Int) {
        val storyGroupViewFactory = storyGroupViewFactory ?: return
        storyGroupViewFactory.attachCustomReactNativeView(child, index)
    }

    private fun manuallyLayout() {
        val storylyView = storylyView ?: return
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