package com.appsamurai.storyly.reactnative

import android.content.Context
import android.widget.FrameLayout
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager

class STStorylyCustomViewManager : ViewGroupManager<STStorylyCustomView>() {
    companion object {
        private const val REACT_CLASS = "STStorylyCustomView"
    }

    override fun getName(): String = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): STStorylyCustomView {
        return STStorylyCustomView(reactContext)
    }
}

class STStorylyCustomView(context: Context) : FrameLayout(context)