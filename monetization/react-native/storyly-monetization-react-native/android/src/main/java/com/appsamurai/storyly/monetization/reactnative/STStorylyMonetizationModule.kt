package com.appsamurai.storyly.monetization.reactnative

import android.content.Context
import android.os.Bundle
import android.os.Handler
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storyly.monetization.StorylyAdViewProvider
import com.appsamurai.storyly.reactnative.STStorylyView
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.uimanager.UIManagerModule

class STStorylyMonetizationModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  companion object {
      const val REACT_CLASS = "RNStorylyMonetization"
  }

  override fun getName(): String = REACT_CLASS

  @ReactMethod
  fun setAdViewProvider(reactViewId: Int, adMobAdUnitId: String) {
      Handler(reactContext.mainLooper).post {
          val uiManagerModule = reactContext.getNativeModule(UIManagerModule::class.java) ?: return@post
          val stStorylyView = uiManagerModule.resolveView(reactViewId) as? STStorylyView ?: return@post
          val storylyView = stStorylyView.getChildAt(0) as? StorylyView ?: return@post
          storylyView.storylyAdViewProvider = StorylyAdViewProvider(getActivityContext(), adMobAdUnitId)
      }
  }

  private fun getActivityContext(): Context {
      return reactApplicationContext.currentActivity ?: reactApplicationContext
  }
}
