package com.appsamurai.storyly.reactnative

import android.content.Context
import android.widget.FrameLayout
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager

class STStorylyGroupViewManager : ViewGroupManager<STStorylyGroupView>() {
    companion object {
        private const val REACT_CLASS = "STStorylyGroupView"
    }

    override fun getName(): String = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): STStorylyGroupView {
        return STStorylyGroupView(reactContext)
    }
}

class STStorylyGroupView(context: Context) : FrameLayout(context)