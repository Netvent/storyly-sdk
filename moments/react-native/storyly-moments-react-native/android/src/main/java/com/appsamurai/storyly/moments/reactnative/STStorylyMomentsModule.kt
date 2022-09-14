package com.appsamurai.storyly.moments.reactnative

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.appsamurai.storyly.moments.Config
import com.appsamurai.storyly.moments.StorylyMomentsManager
import com.appsamurai.storyly.moments.data.entity.MomentsUserPayload
import com.facebook.react.bridge.*

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

  @ReactMethod
  fun encryptUserPayload(
    secretKey: String,
    initializationVector: String,
    id: String,
    username: String,
    avatarUrl: String,
    followings: ReadableArray,
    creatorTags: ReadableArray?,
    consumerTags: ReadableArray?,
    expirationTime: Int,
    promise: Promise,
  ) {
    promise.resolve(
      MomentsUserPayload(
        id = id,
        username = username,
        avatarUrl = avatarUrl,
        followings = convertReadableArray(followings),
        creatorTags = if (creatorTags != null) convertReadableArray(creatorTags) else null,
        consumerTags = if (consumerTags != null) convertReadableArray(consumerTags) else null,
        expirationTime = expirationTime
      ).encryptUserPayload(
        secretKey = secretKey,
        initializationVector = initializationVector
      )
    )
  }

  private fun convertReadableArray(stringArray: ReadableArray): List<String> {
    val stringList = mutableListOf<String?>()
    for (i in 0 until stringArray.size()) stringList.add(stringArray.getString(i))
    return stringList.filterNotNull()
  }

  private fun getActivityContext(): Context {
    return reactApplicationContext.currentActivity ?: reactApplicationContext
  }
}
