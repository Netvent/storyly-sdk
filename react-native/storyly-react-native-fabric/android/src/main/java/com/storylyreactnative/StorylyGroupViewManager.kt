package com.storylyreactnative

import android.content.Context
import android.widget.FrameLayout
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.StorylyGroupViewManagerDelegate
import com.facebook.react.viewmanagers.StorylyGroupViewManagerInterface
import com.facebook.soloader.SoLoader

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

        init {
            if (BuildConfig.CODEGEN_MODULE_REGISTRATION != null) {
                SoLoader.loadLibrary(BuildConfig.CODEGEN_MODULE_REGISTRATION)
            }
        }
    }
}


class STStorylyGroupView(context: Context) : FrameLayout(context)
