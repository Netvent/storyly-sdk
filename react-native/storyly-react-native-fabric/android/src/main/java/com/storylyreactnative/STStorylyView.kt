package com.storylyreactnative

import android.annotation.SuppressLint
import android.content.Context
import android.view.Choreographer
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.appsamurai.storyly.*
import com.appsamurai.storyly.analytics.StorylyEvent
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartEventResult
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.LifecycleEventListener
import com.facebook.react.bridge.ReactContext
import com.facebook.react.uimanager.UIManagerHelper
import com.storylyreactnative.data.STEvent
import com.storylyreactnative.data.createSTRCartItemMap
import com.storylyreactnative.data.createSTRCartMap
import com.storylyreactnative.data.createStoryComponentMap
import com.storylyreactnative.data.createStoryGroupMap
import com.storylyreactnative.data.createStoryMap
import java.lang.ref.WeakReference
import java.util.UUID
import kotlin.properties.Delegates

@SuppressLint("ViewConstructor")
class STStorylyView(
    private val reactContext: ReactContext
): FrameLayout(reactContext) {

    private var cartUpdateSuccessFailCallbackMap: MutableMap<String, Pair<((STRCart?) -> Unit)?, ((STRCartEventResult) -> Unit)?>> = mutableMapOf()

    internal var storylyView: StorylyView? by Delegates.observable(null) { _, _, _ ->
        removeAllViews()
        val storylyView = storylyView ?: return@observable
        addView(storylyView, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))
        storylyView.storylyListener = object : StorylyListener {
            override fun storylyActionClicked(storylyView: StorylyView, story: Story) {
                dispatchEvent(STEvent.Type.ON_STORYLY_ACTION_CLICKED, createStoryMap(story))
            }

            override fun storylyLoaded(
                storylyView: StorylyView,
                storyGroupList: List<StoryGroup>,
                dataSource: StorylyDataSource
            ) {
                dispatchEvent(
                    STEvent.Type.ON_STORYLY_LOADED, mapOf(
                    "storyGroupList" to storyGroupList.map { storyGroup -> createStoryGroupMap(storyGroup) },
                    "dataSource" to dataSource.value,
                ))
            }

            override fun storylyLoadFailed(
                storylyView: StorylyView,
                errorMessage: String
            ) {
                dispatchEvent(STEvent.Type.ON_STORYLY_LOAD_FAILED, mapOf(
                    "errorMessage" to errorMessage,
                ))
            }

            override fun storylyEvent(
                storylyView: StorylyView,
                event: StorylyEvent,
                storyGroup: StoryGroup?,
                story: Story?,
                storyComponent: StoryComponent?,
            ) {
                dispatchEvent(STEvent.Type.ON_STORYLY_EVENT, mapOf(
                    "event" to event.name,
                    "storyGroup" to storyGroup?.let { createStoryGroupMap(it) },
                    "story" to  story?.let { createStoryMap(it) },
                    "storyComponent" to storyComponent?.let { createStoryComponentMap(it) },
                ))
            }

            override fun storylyStoryShown(storylyView: StorylyView) {
                dispatchEvent(STEvent.Type.ON_STORYLY_STORY_PRESENTED)
            }

            override fun storylyStoryShowFailed(storylyView: StorylyView, errorMessage: String) {
                dispatchEvent(STEvent.Type.ON_STORYLY_STORY_PRESENT_FAILED, mapOf(
                    "errorMessage" to errorMessage,
                ))
            }

            override fun storylyStoryDismissed(storylyView: StorylyView) {
                dispatchEvent(STEvent.Type.ON_STORYLY_STORY_DISMISSED)
            }

            override fun storylyUserInteracted(
                storylyView: StorylyView,
                storyGroup: StoryGroup,
                story: Story,
                storyComponent: StoryComponent
            ) {
                dispatchEvent(STEvent.Type.ON_STORYLY_USER_INTERACTED, mapOf(
                    "storyGroup" to createStoryGroupMap(storyGroup),
                    "story" to createStoryMap(story),
                    "storyComponent" to createStoryComponentMap(storyComponent),
                ))
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

                dispatchEvent(
                    STEvent.Type.ON_STORYLY_ON_CART_UPDATED,
                    mapOf(
                        "event" to event.name,
                        "cart" to createSTRCartMap(cart),
                        "change" to createSTRCartItemMap(change),
                        "responseId" to responseId,
                    )
                )
            }

            override fun storylyEvent(
                storylyView: StorylyView,
                event: StorylyEvent
            ) {
                dispatchEvent(STEvent.Type.ON_STORYLY_PRODUCT_EVENT, mapOf(
                    "event" to event.name,
                ))
            }

            override fun storylyHydration(
                storylyView: StorylyView,
                productIds: List<String>
            ) {
                dispatchEvent(STEvent.Type.ON_STORYLY_ON_HYDRATION, mapOf(
                        "productIds" to productIds
                ))
            }
        }
    }

    internal var storyGroupViewFactory: STStoryGroupViewFactory? by Delegates.observable(null) { _, _, _ ->
        storyGroupViewFactory?.apply {
            dispatchEvent = this@STStorylyView::dispatchEvent
        }
    }

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

        val innerStorylyView = storylyView.getChildAt(0) as? ViewGroup ?: return
        for (i in 0 until innerStorylyView.childCount) {
            innerStorylyView.getChildAt(i).requestLayout()
        }
    }

    private fun dispatchEvent(eventType: STEvent.Type, data: Map<String, Any?>? = null) {
        val surfaceId = UIManagerHelper.getSurfaceId(reactContext)
        val eventDispatcher = UIManagerHelper.getEventDispatcherForReactTag(reactContext, id)
        eventDispatcher?.dispatchEvent(STEvent(surfaceId, id, eventType, data))
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
