package com.storylyplacementreactnative

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.StorylyPlacementReactNativeViewManagerInterface
import com.facebook.react.viewmanagers.StorylyPlacementReactNativeViewManagerDelegate

@ReactModule(name = StorylyPlacementReactNativeViewManager.NAME)
class StorylyPlacementReactNativeViewManager : SimpleViewManager<StorylyPlacementReactNativeView>(),
  StorylyPlacementReactNativeViewManagerInterface<StorylyPlacementReactNativeView> {
  private val mDelegate: ViewManagerDelegate<StorylyPlacementReactNativeView>

  init {
    mDelegate = StorylyPlacementReactNativeViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<StorylyPlacementReactNativeView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): StorylyPlacementReactNativeView {
    return StorylyPlacementReactNativeView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: StorylyPlacementReactNativeView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "StorylyPlacementReactNativeView"
  }
}
