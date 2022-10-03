package com.appsamurai.storyly.monetization.reactnative

import android.content.Context
import android.os.Bundle
import android.os.Handler
import androidx.core.os.bundleOf
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storyly.monetization.StorylyAdViewProvider
import com.appsamurai.storyly.reactnative.STStorylyView
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.UIManagerModule

class STStorylyMonetizationModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  companion object {
    const val REACT_CLASS = "RNStorylyMonetization"

    const val AD_MOB_AD_UNIT_ID = "adMobAdUnitId"
    const val AD_MOB_AD_EXTRAS = "adMobAdExtras"
  }

  override fun getName(): String = REACT_CLASS

  @ReactMethod
  fun setAdViewProvider(reactViewId: Int, adViewProviderMap: ReadableMap?) {
      Handler(reactContext.mainLooper).post {
          val uiManagerModule = reactContext.getNativeModule(UIManagerModule::class.java) ?: return@post
          val stStorylyView = uiManagerModule.resolveView(reactViewId) as? STStorylyView ?: return@post
          val storylyView = stStorylyView.getChildAt(0) as? StorylyView ?: return@post

          val map = adViewProviderMap ?: run {
            storylyView.storylyAdViewProvider = null
            return@post
          }
          val adMobAdUnitId = map.getString(AD_MOB_AD_UNIT_ID) ?: return@post
          val adMobAdExtras = map.getMap(AD_MOB_AD_EXTRAS)?.toHashMap()?.let {
            Bundle().apply {
              putAll(it.toBundle())
            }
          }
          storylyView.storylyAdViewProvider = StorylyAdViewProvider(getActivityContext(), adMobAdUnitId, adMobAdExtras)
      }
  }

  private fun Map<String, Any?>.toBundle(): Bundle = bundleOf(*this.toList().toTypedArray())

  private fun getActivityContext(): Context {
      return reactApplicationContext.currentActivity ?: reactApplicationContext
  }
}
