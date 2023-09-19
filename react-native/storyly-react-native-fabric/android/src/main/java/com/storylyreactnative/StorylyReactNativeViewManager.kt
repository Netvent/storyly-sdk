package com.storylyreactnative

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.StorylyReactNativeViewManagerInterface
import com.facebook.react.viewmanagers.StorylyReactNativeViewManagerDelegate
import com.facebook.soloader.SoLoader

@ReactModule(name = StorylyReactNativeViewManager.NAME)
class StorylyReactNativeViewManager : SimpleViewManager<StorylyReactNativeView>(),
  StorylyReactNativeViewManagerInterface<StorylyReactNativeView> {
  private val mDelegate: ViewManagerDelegate<StorylyReactNativeView>

  init {
    mDelegate = StorylyReactNativeViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<StorylyReactNativeView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): StorylyReactNativeView {
    return StorylyReactNativeView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: StorylyReactNativeView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "StorylyReactNativeView"

    init {
      if (BuildConfig.CODEGEN_MODULE_REGISTRATION != null) {
        SoLoader.loadLibrary(BuildConfig.CODEGEN_MODULE_REGISTRATION)
      }
    }
  }
}
