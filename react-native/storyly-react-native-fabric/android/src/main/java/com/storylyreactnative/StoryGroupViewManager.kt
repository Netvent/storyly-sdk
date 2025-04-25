package com.storylyreactnative

import android.content.Context
import android.util.Log
import android.widget.FrameLayout
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.StorylyGroupViewManagerDelegate
import com.facebook.react.viewmanagers.StorylyGroupViewManagerInterface
import com.facebook.react.views.view.ReactViewGroup

@ReactModule(name = StorylyGroupViewManager.NAME)
class StorylyGroupViewManager : ViewGroupManager<STStorylyGroupView>(),
    StorylyGroupViewManagerInterface<STStorylyGroupView> {

    private val _delegate: ViewManagerDelegate<STStorylyGroupView> by lazy {
        StorylyGroupViewManagerDelegate(this)
    }

    override fun getDelegate(): ViewManagerDelegate<STStorylyGroupView> = _delegate

    override fun getName(): String = NAME

    public override fun createViewInstance(context: ThemedReactContext): STStorylyGroupView {
        return STStorylyGroupView(context)
    }

    companion object {
        const val NAME = "StorylyGroupView"
    }
}


class STStorylyGroupView(context: Context) : ReactViewGroup(context)
