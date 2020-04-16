package com.appsamurai.storyly.reactnative

import android.content.Context
import android.view.Choreographer
import android.widget.FrameLayout
import com.appsamurai.storyly.Story
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.StorylyView
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
                manuallyLayout()
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

            override fun storylyStoryShown(storylyView: StorylyView) {
                sendEvent(STStorylyManager.EVENT_STORYLY_STORY_PRESENTED, null)
            }

            override fun storylyStoryDismissed(storylyView: StorylyView) {
                sendEvent(STStorylyManager.EVENT_STORYLY_STORY_DISMISSED, null)
            }
        }

        Choreographer.getInstance().postFrameCallback {
            manuallyLayout()
            viewTreeObserver.dispatchOnGlobalLayout()
        }
    }

    private fun manuallyLayout() {
        storylyView.measure(MeasureSpec.makeMeasureSpec(measuredWidth, MeasureSpec.EXACTLY), MeasureSpec.makeMeasureSpec(measuredHeight, MeasureSpec.EXACTLY))
        storylyView.layout(0, 0, storylyView.measuredWidth, storylyView.measuredHeight)
    }

    private fun sendEvent(eventName: String, eventParameters: WritableMap?) {
        (context as? ReactContext)?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, eventName, eventParameters)
    }

    private fun createStoryGroupMap(storyGroup: StoryGroup): WritableMap {
        return Arguments.createMap().also { storyGroupMap ->
            storyGroupMap.putInt("index", storyGroup.index)
            storyGroupMap.putString("title", storyGroup.title)
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
            storyMap.putMap("media", Arguments.createMap().also { storyMediaMap ->
                storyMediaMap.putInt("type", story.media.type.ordinal)
                storyMediaMap.putString("url", story.media.url)
                storyMediaMap.putString("actionUrl", story.media.actionUrl)
            })
        }
    }
}
