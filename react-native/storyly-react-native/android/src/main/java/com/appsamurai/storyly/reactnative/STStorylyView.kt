package com.appsamurai.storyly.reactnative

import android.content.Context
import android.view.Choreographer
import android.view.ViewGroup
import android.widget.FrameLayout
import com.appsamurai.storyly.*
import com.appsamurai.storyly.analytics.StorylyEvent
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.RCTEventEmitter


class STStorylyView(context: Context) : FrameLayout(context) {
    internal var storylyView: StorylyView = StorylyView(context)

    init {
        addView(storylyView, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))
        storylyView.storylyListener = object : StorylyListener {
            override fun storylyActionClicked(storylyView: StorylyView, story: Story): Boolean {
                sendEvent(STStorylyManager.EVENT_STORYLY_ACTION_CLICKED, createStoryMap(story))
                return true
            }

            override fun storylyLoaded(storylyView: StorylyView, storyGroupList: List<StoryGroup>) {
                sendEvent(STStorylyManager.EVENT_STORYLY_LOADED, Arguments.createMap().also { storyGroupListMap ->
                    storyGroupListMap.putArray("storyGroupList", Arguments.createArray().also { storyGroups ->
                        storyGroupList.forEach { storyGroup ->
                            storyGroups.pushMap(createStoryGroupMap(storyGroup))
                        }
                    })
                })
            }

            override fun storylyLoadFailed(storylyView: StorylyView, errorMessage: String) {
                sendEvent(STStorylyManager.EVENT_STORYLY_LOAD_FAILED, Arguments.createMap().also { eventMap ->
                    eventMap.putString("errorMessage", errorMessage)
                })
            }

            override fun storylyEvent(storylyView: StorylyView, event: StorylyEvent, storyGroup: StoryGroup?, story: Story?, storyComponent: StoryComponent?) {
                sendEvent(STStorylyManager.EVENT_STORYLY_EVENT, Arguments.createMap().also { eventMap ->
                    eventMap.putString("event", event.name)
                    storyGroup?.let { eventMap.putMap("storyGroup", createStoryGroupMap(it)) }
                    story?.let { eventMap.putMap("story", createStoryMap(it)) }
                    storyComponent?.let { eventMap.putMap("storyComponent", createStoryComponentMap(it)) }
                })
            }

            override fun storylyStoryShown(storylyView: StorylyView) {
                sendEvent(STStorylyManager.EVENT_STORYLY_STORY_PRESENTED, null)
            }

            override fun storylyStoryDismissed(storylyView: StorylyView) {
                sendEvent(STStorylyManager.EVENT_STORYLY_STORY_DISMISSED, null)
            }

            override fun storylyUserInteracted(storylyView: StorylyView, storyGroup: StoryGroup, story: Story, storyComponent: StoryComponent) {
                sendEvent(STStorylyManager.EVENT_STORYLY_USER_INTERACTED, Arguments.createMap().also { eventMap ->
                    eventMap.putMap("storyGroup", createStoryGroupMap(storyGroup))
                    eventMap.putMap("story", createStoryMap(story))
                    eventMap.putMap("storyComponent", createStoryComponentMap(storyComponent))
                })
            }
        }

        Choreographer.getInstance().postFrameCallback(object : Choreographer.FrameCallback {
            override fun doFrame(frameTimeNanos: Long) {
                manuallyLayout()
                viewTreeObserver.dispatchOnGlobalLayout()
                Choreographer.getInstance().postFrameCallback(this)
            }
        })
    }

    private fun manuallyLayout() {
        storylyView.measure(
            MeasureSpec.makeMeasureSpec(measuredWidth, MeasureSpec.EXACTLY),
            MeasureSpec.makeMeasureSpec(measuredHeight, MeasureSpec.EXACTLY)
        )
        storylyView.layout(0, 0, storylyView.measuredWidth, storylyView.measuredHeight)

        val innerStorylyView = storylyView.getChildAt(0) as? ViewGroup ?: return;
        for (i in 0 until innerStorylyView.childCount) {
            innerStorylyView.getChildAt(i).requestLayout()
        }
    }

    private fun sendEvent(eventName: String, eventParameters: WritableMap?) {
        (context as? ReactContext)?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, eventName, eventParameters)
    }

    private fun createStoryGroupMap(storyGroup: StoryGroup): WritableMap {
        return Arguments.createMap().also { storyGroupMap ->
            storyGroupMap.putInt("index", storyGroup.index)
            storyGroupMap.putString("title", storyGroup.title)
            storyGroupMap.putBoolean("seen", storyGroup.seen)
            storyGroupMap.putArray("stories", Arguments.createArray().also { storiesArray ->
                storyGroup.stories.forEach { story ->
                    storiesArray.pushMap(createStoryMap(story))
                }
            })
        }
    }

    private fun createStoryMap(story: Story): WritableMap {
        return Arguments.createMap().also { storyMap ->
            storyMap.putInt("index", story.index)
            storyMap.putString("title", story.title)
            storyMap.putBoolean("seen", story.seen)
            storyMap.putMap("media", Arguments.createMap().also { storyMediaMap ->
                storyMediaMap.putInt("type", story.media.type.ordinal)
                storyMediaMap.putString("url", story.media.url)
                storyMediaMap.putString("actionUrl", story.media.actionUrl)
            })
        }
    }

    private fun createStoryComponentMap(storyComponent: StoryComponent): WritableMap {
        return Arguments.createMap().also { storyComponentMap ->
            when (storyComponent.type) {
                StoryComponentType.Quiz -> {
                    val quizComponent = storyComponent as StoryQuizComponent
                    storyComponentMap.putString("type", quizComponent.type.name)
                    storyComponentMap.putString("title", quizComponent.title)
                    storyComponentMap.putArray("options", Arguments.createArray().also { optionsArray ->
                        quizComponent.options.forEach { option ->
                            optionsArray.pushString(option)
                        }
                    })
                    quizComponent.rightAnswerIndex?.let {
                        storyComponentMap.putInt("rightAnswerIndex", it)
                    } ?: run {
                        storyComponentMap.putNull("rightAnswerIndex")
                    }
                    storyComponentMap.putInt("selectedOptionIndex", quizComponent.selectedOptionIndex)
                    storyComponentMap.putString("customPayload", quizComponent.customPayload)
                }
                StoryComponentType.Poll -> {
                    val pollComponent = storyComponent as StoryPollComponent
                    storyComponentMap.putString("type", pollComponent.type.name)
                    storyComponentMap.putString("title", pollComponent.title)
                    storyComponentMap.putArray("options", Arguments.createArray().also { optionsArray ->
                        pollComponent.options.forEach { option ->
                            optionsArray.pushString(option)
                        }
                    })
                    storyComponentMap.putInt("selectedOptionIndex", pollComponent.selectedOptionIndex)
                    storyComponentMap.putString("customPayload", pollComponent.customPayload)
                }
                StoryComponentType.Emoji -> {
                    val emojiComponent = storyComponent as StoryEmojiComponent
                    storyComponentMap.putString("type", emojiComponent.type.name)
                    storyComponentMap.putArray("emojiCodes", Arguments.createArray().also { emojiCodesArray ->
                        emojiComponent.emojiCodes.forEach { emojiCode ->
                            emojiCodesArray.pushString(emojiCode)
                        }
                    })
                    storyComponentMap.putInt("selectedEmojiIndex", emojiComponent.selectedEmojiIndex)
                    storyComponentMap.putString("customPayload", emojiComponent.customPayload)

                }
                StoryComponentType.Rating -> {
                    val ratingComponent = storyComponent as StoryRatingComponent
                    storyComponentMap.putString("type", ratingComponent.type.name)
                    storyComponentMap.putString("emojiCode", ratingComponent.emojiCode)
                    storyComponentMap.putInt("rating", ratingComponent.rating)
                    storyComponentMap.putString("customPayload", ratingComponent.customPayload)
                }
            }
        }
    }
}
