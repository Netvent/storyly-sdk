package com.appsamurai.storyly.reactnative

import android.annotation.SuppressLint
import android.content.Context
import android.view.MotionEvent
import android.view.View
import android.widget.FrameLayout
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.styling.StoryGroupView
import com.appsamurai.storyly.styling.StoryGroupViewFactory
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap


class RNStoryGroupViewFactory(
    private val context: Context,
    private val width: Int,
    private val height: Int,
): StoryGroupViewFactory() {
    private val customViewList = mutableListOf<RNStoryGroupView>()

    internal var onSendEvent: ((eventName: String, eventParameters: WritableMap?) -> Unit)? = null

    override fun createView(): StoryGroupView {
        val storyGroupView = RNStoryGroupView(context, width, height).also {
            it.onViewUpdate = this::onUpdateView
        }
        customViewList.add(storyGroupView)
        onSendEvent?.invoke(STStorylyManager.EVENT_ON_CREATE_CUSTOM_VIEW, null)
        return storyGroupView
    }

    internal fun attachCustomReactNativeView(child: View?, index: Int) {
        customViewList.getOrNull(index)?.holderView?.addView(child)
    }

    private fun onUpdateView(customView: RNStoryGroupView, storyGroup: StoryGroup?) {
        val index = customViewList.indexOf(customView)
        onSendEvent?.invoke(STStorylyManager.EVENT_ON_UPDATE_CUSTOM_VIEW, Arguments.createMap().apply {
            putInt("index", index)
            putMap("storyGroup", storyGroup?.let { createStoryGroupMap(it) })
        })
    }
}

@SuppressLint("ViewConstructor")
class RNStoryGroupView(context: Context, width: Int, height: Int): StoryGroupView(context) {
    internal var onViewUpdate: ((RNStoryGroupView, StoryGroup?) -> Unit)? = null

    internal val holderView = FrameLayout(context)

    init {
        layoutParams = LayoutParams(width, height)
        addView(holderView, LayoutParams(width, height))
    }

    override fun onInterceptTouchEvent(event: MotionEvent?): Boolean {  return true }

    override fun populateView(storyGroup: StoryGroup?) {
        onViewUpdate?.invoke(this, storyGroup)
    }
}
