package com.storylyreactnative

import android.annotation.SuppressLint
import android.content.Context
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.FrameLayout.LayoutParams
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.config.styling.group.StoryGroupView
import com.appsamurai.storyly.config.styling.group.StoryGroupViewFactory
import com.storylyreactnative.data.STEvent
import com.storylyreactnative.data.createStoryGroupMap


class STStoryGroupViewFactory(
    private val context: Context,
    private val width: Int,
    private val height: Int,
): StoryGroupViewFactory() {
    private val customViewList = mutableListOf<STStoryGroupView>()

    internal var dispatchEvent: ((eventName: STEvent.Type, eventParameters: Map<String, Any>?) -> Unit)? = null

    override fun createView(): StoryGroupView {
        val storyGroupView = STStoryGroupView(context, width, height).also {
            it.onViewUpdate = this::onUpdateView
        }
        customViewList.add(storyGroupView)
        dispatchEvent?.invoke(STEvent.Type.ON_CREATE_CUSTOM_VIEW, null)
        return storyGroupView
    }

    internal fun attachCustomReactNativeView(child: View?, index: Int) {
        customViewList.getOrNull(index)?.holderView?.addView(child, LayoutParams(width, height))
    }

    private fun onUpdateView(customView: STStoryGroupView, storyGroup: StoryGroup?) {
        val index = customViewList.indexOf(customView).takeIf { it != -1 } ?: returns
        dispatchEvent?.invoke(
            STEvent.Type.ON_UPDATE_CUSTOM_VIEW, mapOf(
                "index" to index,
                "storyGroup" to storyGroup?.let { createStoryGroupMap(it) },
            ) as Map<String, Any>?)
    }
}

@SuppressLint("ViewConstructor")
class STStoryGroupView(context: Context, width: Int, height: Int): StoryGroupView(context) {
    internal var onViewUpdate: ((STStoryGroupView, StoryGroup?) -> Unit)? = null

    internal val holderView = FrameLayout(context)

    init {
        addView(holderView, LayoutParams(width, height))
    }

    override fun onInterceptTouchEvent(event: MotionEvent?): Boolean {  return true }

    override fun populateView(storyGroup: StoryGroup?) {
        onViewUpdate?.invoke(this, storyGroup)
    }
}
