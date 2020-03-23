package com.appsamurai.storyly.storyly_flutter

import android.content.Context
import android.graphics.Color
import android.view.View
import com.appsamurai.storyly.Story
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.StorylyView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FlutterStorylyViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    internal lateinit var context: Context

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView = FlutterStorylyView(this.context, messenger, viewId, args as HashMap<String, Any>)
}

class FlutterStorylyView(
        private val context: Context,
        messenger: BinaryMessenger,
        viewId: Int,
        private val args: HashMap<String, Any>
) : PlatformView, StorylyListener {

    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.appsamurai.storyly/flutter_storyly_view_$viewId").apply {
        setMethodCallHandler { call, result ->
            when (call.method) {
                "refresh" -> storylyView.refresh()
                "show" -> storylyView.show()
                "dismiss" -> storylyView.dismiss()
            }
        }
    }

    companion object {
        private const val ARGS_STORYLY_ID = "storylyId"
        private const val ARGS_STORY_GROUP_ICON_BORDER_COLOR_SEEN = "storyGroupIconBorderColorSeen"
        private const val ARGS_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN = "storyGroupIconBorderColorNotSeen"
        private const val ARGS_STORY_GROUP_ICON_BACKGROUND_COLOR = "storyGroupIconBackgroundColor"
        private const val ARGS_STORY_GROUP_TEXT_COLOR = "storyGroupTextColor"
        private const val ARGS_STORY_GROUP_PIN_ICON_COLOR = "storyGroupPinIconColor"
        private const val ARGS_STORY_ITEM_ICON_BORDER_COLOR = "storyItemIconBorderColor"
        private const val ARGS_STORY_ITEM_TEXT_COLOR = "storyItemTextColor"
        private const val ARGS_STORY_ITEM_PROGRESS_BAR_COLOR = "storyItemProgressBarColor"
    }

    private val storylyView: StorylyView by lazy {
        StorylyView(context).apply {
            storylyId = args[ARGS_STORYLY_ID] as? String ?: throw Exception("StorylyId must be set.")

            (args[ARGS_STORY_GROUP_ICON_BORDER_COLOR_SEEN] as? List<String>)?.let { colors -> setStoryGroupIconBorderColorSeen(colors.map { color -> Color.parseColor(color) }.toTypedArray()) }
            (args[ARGS_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN] as? List<String>)?.let { colors -> setStoryGroupIconBorderColorNotSeen(colors.map { color -> Color.parseColor(color) }.toTypedArray()) }
            (args[ARGS_STORY_GROUP_ICON_BACKGROUND_COLOR] as? String)?.let { setStoryGroupIconBackgroundColor(Color.parseColor(it)) }
            (args[ARGS_STORY_GROUP_TEXT_COLOR] as? String)?.let { setStoryGroupTextColor(Color.parseColor(it)) }
            (args[ARGS_STORY_GROUP_PIN_ICON_COLOR] as? String)?.let { setStoryGroupPinIconColor(Color.parseColor(it)) }
            (args[ARGS_STORY_ITEM_ICON_BORDER_COLOR] as? List<String>)?.let { colors -> setStoryItemIconBorderColor(colors.map { color -> Color.parseColor(color) }.toTypedArray()) }
            (args[ARGS_STORY_ITEM_TEXT_COLOR] as? String)?.let { setStoryItemTextColor(Color.parseColor(it)) }
            (args[ARGS_STORY_ITEM_PROGRESS_BAR_COLOR] as? List<String>)?.let { colors -> setStoryItemProgressBarColor(colors.map { color -> Color.parseColor(color) }.toTypedArray()) }

            storylyListener = object : StorylyListener {
                override fun storylyActionClicked(storylyView: StorylyView, story: Story): Boolean {
                    methodChannel.invokeMethod("storylyActionClicked",
                            mapOf("index" to story.index, "title" to story.title, "media" to with(story.media) {
                                mapOf("type" to this.type.ordinal, "url" to this.url, "actionUrl" to this.actionUrl)
                            }))
                    return true
                }

                override fun storylyLoaded(storylyView: StorylyView, storyGroupList: List<StoryGroup>) {
                    methodChannel.invokeMethod("storylyLoaded", storyGroupList.map { storyGroup ->
                        mapOf("index" to storyGroup.index, "title" to storyGroup.title, "stories" to storyGroup.stories.map { story ->
                            mapOf("index" to story.index, "title" to story.title, "media" to with(story.media) {
                                mapOf("type" to this.type.ordinal, "url" to this.url, "actionUrl" to this.actionUrl)
                            })
                        })
                    })
                }

                override fun storylyLoadFailed(storylyView: StorylyView, errorMessage: String) {
                    methodChannel.invokeMethod("storylyLoadFailed", errorMessage)
                }

                override fun storylyStoryShown(storylyView: StorylyView) {
                    methodChannel.invokeMethod("storylyStoryShown", null)
                }

                override fun storylyStoryDismissed(storylyView: StorylyView) {
                    methodChannel.invokeMethod("storylyStoryDismissed", null)
                }
            }
        }
    }

    override fun getView(): View {
        return storylyView
    }

    override fun dispose() {}
}