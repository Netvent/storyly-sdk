package com.appsamurai.storyly.moments.reactnative

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.appsamurai.storyly.moments.Config
import com.appsamurai.storyly.moments.StorylyMomentsManager
import com.appsamurai.storyly.moments.data.entity.MomentsStoryGroup
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class STStorylyMomentsModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  companion object {
    const val REACT_CLASS = "RNStorylyMoments"
  }

  private var storylyMomentsManager: StorylyMomentsManager? = null

  override fun getName(): String = REACT_CLASS

  @ReactMethod
  fun initialize(token: String, userPayload: String) {
    Handler(Looper.getMainLooper()).post {
      storylyMomentsManager = StorylyMomentsManager(
        context = getActivityContext(),
        config = Config(
          momentToken = token,
          userPayload = userPayload
        )
      )
//      storylyMomentsManager?.momentsListener = storylyMomentsListener
    }
  }

  @ReactMethod
  fun openUserStories() {
    Handler(Looper.getMainLooper()).post { storylyMomentsManager?.openMyStories() }
  }

  @ReactMethod
  fun openStoryCreator() {
    Handler(Looper.getMainLooper()).post { storylyMomentsManager?.createStory() }
  }

  private fun getActivityContext(): Context {
    return reactApplicationContext.currentActivity ?: reactApplicationContext
  }
}
