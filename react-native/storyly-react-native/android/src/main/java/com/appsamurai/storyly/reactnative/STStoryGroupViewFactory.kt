package com.appsamurai.storyly.reactnative

import android.annotation.SuppressLint
import android.content.Context
import android.view.MotionEvent
import android.view.View
import android.widget.FrameLayout
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.config.styling.group.StoryGroupView
import com.appsamurai.storyly.config.styling.group.StoryGroupViewFactory
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap


class STStoryGroupViewFactory(
    private val context: Context,
    private val width: Int,
    private val height: Int,
): StoryGroupViewFactory() {
    private val customViewList = mutableListOf<STStoryGroupView>()

    internal var onSendEvent: ((eventName: String, eventParameters: WritableMap?) -> Unit)? = null

    override fun createView(): StoryGroupView {
        val storyGroupView = STStoryGroupView(context, width, height).also { it.onViewUpdate = this::onUpdateView }
        customViewList.add(storyGroupView)
        onSendEvent?.invoke(STStorylyManager.EVENT_ON_CREATE_CUSTOM_VIEW, null)
        return storyGroupView
    }

    internal fun attachCustomReactNativeView(child: View?, index: Int) {
        customViewList.getOrNull(index)?.holderView?.addView(child)
    }

    private fun onUpdateView(customView: STStoryGroupView, storyGroup: StoryGroup?) {
        val index = customViewList.indexOf(customView)
        onSendEvent?.invoke(STStorylyManager.EVENT_ON_UPDATE_CUSTOM_VIEW, Arguments.createMap().apply {
            putInt("index", index)
            putMap("storyGroup", storyGroup?.let { createStoryGroupMap(it) })
        })
    }
}

@SuppressLint("ViewConstructor")
class STStoryGroupView(context: Context, width: Int, height: Int): StoryGroupView(context) {
    internal var onViewUpdate: ((STStoryGroupView, StoryGroup?) -> Unit)? = null

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
