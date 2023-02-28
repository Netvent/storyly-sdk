package com.appsamurai.storyly.moments.reactnative

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.appsamurai.storyly.moments.Config
import com.appsamurai.storyly.moments.MomentsListener
import com.appsamurai.storyly.moments.StorylyMomentsManager
import com.appsamurai.storyly.moments.analytics.StorylyMomentsEvent
import com.appsamurai.storyly.moments.data.entity.MomentsStory
import com.appsamurai.storyly.moments.data.entity.MomentsStoryGroup
import com.appsamurai.storyly.moments.data.entity.MomentsUserPayload
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule

class STStorylyMomentsModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  companion object {
    const val REACT_CLASS = "RNStorylyMoments"

    internal const val EVENT_STORYLY_MOMENTS_EVENT = "storylyMomentsEvent"
    internal const val EVENT_STORYLY_MOMENTS_OPEN_STORY_CREATE = "onOpenCreateStory"
    internal const val EVENT_STORYLY_MOMENTS_OPEN_MY_STORY = "onOpenMyStory"
    internal const val EVENT_STORYLY_MOMENTS_USER_STORIES_LOADED = "onUserStoriesLoaded"
    internal const val EVENT_STORYLY_MOMENTS_USER_STORIES_LOAD_FAILED = "onUserStoriesLoadFailed"
    internal const val EVENT_STORYLY_MOMENTS_USER_ACTION_CLICKED = "onUserActionClicked"
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
      ).apply {
        momentsListener = object : MomentsListener {
          override fun storylyMomentsEvent(
            event: StorylyMomentsEvent,
            momentsStoryGroup: MomentsStoryGroup?,
            stories: List<MomentsStory>?
          ) {
            sendEvent(
              EVENT_STORYLY_MOMENTS_EVENT,
              Arguments.createMap().also { eventMap ->
                eventMap.putString("eventName", event.name)
                eventMap.putMap("storyGroup", momentsStoryGroup?.let { createMomentsStoryGroup(it) })
                eventMap.putArray("stories", stories?.let { Arguments.createArray().also { array ->
                  it.forEach { story -> array.pushMap(createStoryMap(story)) }
                }})
              })
          }

          override fun onOpenCreateStory(isDirectMediaUpload: Boolean) {
            sendEvent(
              EVENT_STORYLY_MOMENTS_OPEN_STORY_CREATE,
              Arguments.createMap().also { eventMap ->
                eventMap.putBoolean("isDirectMediaUploaded", isDirectMediaUpload)
              })
          }

          override fun onOpenMyStory() {
            sendEvent(EVENT_STORYLY_MOMENTS_OPEN_MY_STORY, Arguments.createMap())
          }

          override fun onUserStoriesLoaded(momentsStoryGroup: MomentsStoryGroup?) {
            sendEvent(EVENT_STORYLY_MOMENTS_USER_STORIES_LOADED, Arguments.createMap().also { eventMap ->
              eventMap.putMap("storyGroup", momentsStoryGroup?.let { createMomentsStoryGroup(it) })
            })
          }

          override fun onUserStoriesLoadFailed(errorMessage: String) {
            sendEvent(EVENT_STORYLY_MOMENTS_USER_STORIES_LOAD_FAILED, Arguments.createMap().also { eventMap ->
              eventMap.putString("errorMessage", errorMessage)
            })
          }

          override fun onUserActionClicked(story: MomentsStory) {
            sendEvent(
              EVENT_STORYLY_MOMENTS_USER_ACTION_CLICKED,
              Arguments.createMap().also { eventMap ->
                eventMap.putMap("story", createStoryMap(story))
              })
          }
        }
      }
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
        followings = convertReadableArray(followings) ?: emptyList(),
        creatorTags = convertReadableArray(creatorTags),
        consumerTags = convertReadableArray(consumerTags),
        expirationTime = expirationTime
      ).encryptUserPayload(
        secretKey = secretKey,
        initializationVector = initializationVector
      )
    )
  }

  private fun convertReadableArray(stringArray: ReadableArray?): List<String>? {
    stringArray ?: return null
    if (stringArray.size() <= 0) return null
    val stringList = mutableListOf<String?>()
    for (i in 0 until stringArray.size()) stringList.add(stringArray.getString(i))
    return stringList.filterNotNull().toList()
  }

  private fun getActivityContext(): Context {
    return reactApplicationContext.currentActivity ?: reactApplicationContext
  }

  private fun sendEvent(eventName: String, eventParameters: WritableMap?) {
    (reactApplicationContext as ReactContext)
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
      .emit(eventName, eventParameters)
  }

  private fun createMomentsStoryGroup(storyGroup: MomentsStoryGroup): ReadableMap? {
    return Arguments.createMap().apply {
      putString("id", storyGroup.id)
      putString("iconUrl", storyGroup.iconUrl)
      putBoolean("seen", storyGroup.seen)
      putArray("stories",  Arguments.createArray().also { array ->
        storyGroup.stories.forEach { story -> array.pushMap(createStoryMap(story)) }
      })
    }
  }

  private fun createStoryMap(story: MomentsStory): ReadableMap? {
    return Arguments.createMap().apply {
      putString("id", story.id)
      putString("title", story.title)
      putBoolean("seen", story.seen)
      putInt("type", story.media.type.ordinal)
      putString("url", story.media.actionUrl)
    }
  }
}
