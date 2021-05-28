package com.appsamurai.storyly.storyly_flutter

import android.content.Context
import android.graphics.Color
import android.net.Uri
import android.view.View
import com.appsamurai.storyly.*
import com.appsamurai.storyly.analytics.StorylyEvent
import com.appsamurai.storyly.styling.StoryGroupIconStyling
import com.appsamurai.storyly.styling.StoryGroupListStyling
import com.appsamurai.storyly.styling.StoryGroupTextStyling
import com.appsamurai.storyly.styling.StoryHeaderStyling
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.*
import kotlin.collections.HashMap

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
        setMethodCallHandler { call, _ ->
            val callArguments = call.arguments as? Map<String, *>
            when (call.method) {
                "refresh" -> storylyView.refresh()
                "show" -> storylyView.show()
                "dismiss" -> storylyView.dismiss()
                "openStory" -> storylyView.openStory(callArguments?.get("storyGroupId") as? Int
                        ?: 0,
                        callArguments?.getOrElse("storyId", { null }) as? Int)
                "openStoryUri" -> storylyView.openStory(Uri.parse(callArguments?.get("uri") as? String))
            }
        }
    }

    companion object {
        private const val ARGS_STORYLY_ID = "storylyId"
        private const val ARGS_STORYLY_SEGMENTS = "storylySegments"
        private const val ARGS_STORYLY_CUSTOM_PARAMETERS = "storylyCustomParameters"
        private const val ARGS_STORYLY_IS_TEST_MODE = "storylyIsTestMode"

        private const val ARGS_STORYLY_BACKGROUND_COLOR = "storylyBackgroundColor"

        private const val ARGS_STORY_GROUP_SIZE = "storyGroupSize"
        private const val ARGS_STORY_GROUP_ICON_STYLING = "storyGroupIconStyling"
        private const val ARGS_STORY_GROUP_LIST_STYLING = "storyGroupListStyling"
        private const val ARGS_STORY_GROUP_TEXT_STYLING = "storyGroupTextStyling"
        private const val ARGS_STORY_HEADER_STYLING = "storyHeaderStyling"

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
            val storylyId = args[ARGS_STORYLY_ID] as? String
                    ?: throw Exception("StorylyId must be set.")
            val segments = args[ARGS_STORYLY_SEGMENTS] as? List<String>
            val customParameters = args[ARGS_STORYLY_CUSTOM_PARAMETERS] as? String
            val isTestMode = args[ARGS_STORYLY_IS_TEST_MODE] as? Boolean ?: false
            storylyInit = StorylyInit(storylyId, StorylySegmentation(segments = segments?.toSet()), customParameter = customParameters, isTestMode = isTestMode)
            (args[ARGS_STORY_GROUP_SIZE] as? String)?.let {
                setStoryGroupSize(when (it) {
                    "small" -> StoryGroupSize.Small
                    "xlarge" -> StoryGroupSize.XLarge
                    "custom" -> StoryGroupSize.Custom
                    else -> StoryGroupSize.Large
                })
            }
            (args[ARGS_STORYLY_BACKGROUND_COLOR] as? String)?.let { setBackgroundColor(Color.parseColor(it)) }
            (args[ARGS_STORY_GROUP_ICON_BORDER_COLOR_SEEN] as? List<String>)?.let { colors -> setStoryGroupIconBorderColorSeen(colors.map { color -> Color.parseColor(color) }.toTypedArray()) }
            (args[ARGS_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN] as? List<String>)?.let { colors -> setStoryGroupIconBorderColorNotSeen(colors.map { color -> Color.parseColor(color) }.toTypedArray()) }
            (args[ARGS_STORY_GROUP_ICON_BACKGROUND_COLOR] as? String)?.let { setStoryGroupIconBackgroundColor(Color.parseColor(it)) }
            (args[ARGS_STORY_GROUP_TEXT_COLOR] as? String)?.let { setStoryGroupTextColor(Color.parseColor(it)) }
            (args[ARGS_STORY_GROUP_PIN_ICON_COLOR] as? String)?.let { setStoryGroupPinIconColor(Color.parseColor(it)) }
            (args[ARGS_STORY_ITEM_ICON_BORDER_COLOR] as? List<String>)?.let { colors -> setStoryItemIconBorderColor(colors.map { color -> Color.parseColor(color) }.toTypedArray()) }
            (args[ARGS_STORY_ITEM_TEXT_COLOR] as? String)?.let { setStoryItemTextColor(Color.parseColor(it)) }
            (args[ARGS_STORY_ITEM_PROGRESS_BAR_COLOR] as? List<String>)?.let { colors -> setStoryItemProgressBarColor(colors.map { color -> Color.parseColor(color) }.toTypedArray()) }

            (args[ARGS_STORY_GROUP_ICON_STYLING] as? Map<String, *>)?.let {
                val width = it["width"] as? Int ?: return@let
                val height = it["height"] as? Int ?: return@let
                val cornerRadius = it["cornerRadius"] as? Int ?: return@let
                setStoryGroupIconStyling(StoryGroupIconStyling(height.toFloat(), width.toFloat(), cornerRadius.toFloat()))
            }

            (args[ARGS_STORY_GROUP_LIST_STYLING] as? Map<String, *>)?.let {
                val edgePadding = it["edgePadding"] as? Int ?: return@let
                val paddingBetweenItems = it["paddingBetweenItems"] as? Int ?: return@let
                setStoryGroupListStyling(StoryGroupListStyling(edgePadding.toFloat(), paddingBetweenItems.toFloat()))
            }

            (args[ARGS_STORY_GROUP_TEXT_STYLING] as? Map<String, *>)?.let {
                val isVisible = it["isVisible"] as? Boolean ?: return@let
                setStoryGroupTextStyling(StoryGroupTextStyling(isVisible))
            }

            (args[ARGS_STORY_HEADER_STYLING] as? Map<String, *>)?.let {
                val isTextVisible = it["isTextVisible"] as? Boolean ?: return@let
                val isIconVisible = it["isIconVisible"] as? Boolean ?: return@let
                val isCloseButtonVisible = it["isCloseButtonVisible"] as? Boolean ?: return@let
                setStoryHeaderStyling(StoryHeaderStyling(isTextVisible, isIconVisible, isCloseButtonVisible))
            }

            storylyListener = object : StorylyListener {
                override fun storylyActionClicked(storylyView: StorylyView, story: Story) {
                    methodChannel.invokeMethod("storylyActionClicked",
                            createStoryMap(story))
                }

                override fun storylyLoaded(storylyView: StorylyView, storyGroupList: List<StoryGroup>) {
                    methodChannel.invokeMethod("storylyLoaded",
                            storyGroupList.map { storyGroup -> createStoryGroupMap(storyGroup) })
                }

                override fun storylyLoadFailed(storylyView: StorylyView, errorMessage: String) {
                    methodChannel.invokeMethod("storylyLoadFailed", errorMessage)
                }

                override fun storylyEvent(storylyView: StorylyView, event: StorylyEvent, storyGroup: StoryGroup?, story: Story?, storyComponent: StoryComponent?) {
                    methodChannel.invokeMethod("storylyEvent",
                            mapOf("event" to event.name,
                                    "storyGroup" to storyGroup?.let { createStoryGroupMap(storyGroup) },
                                    "story" to story?.let { createStoryMap(story) },
                                    "storyComponent" to storyComponent?.let { createStoryComponentMap(storyComponent) }))
                }

                override fun storylyStoryShown(storylyView: StorylyView) {
                    methodChannel.invokeMethod("storylyStoryShown", null)
                }

                override fun storylyStoryDismissed(storylyView: StorylyView) {
                    methodChannel.invokeMethod("storylyStoryDismissed", null)
                }

                override fun storylyUserInteracted(storylyView: StorylyView,
                                                   storyGroup: StoryGroup,
                                                   story: Story,
                                                   storyComponent: StoryComponent) {
                    methodChannel.invokeMethod("storylyUserInteracted",
                            mapOf("storyGroup" to createStoryGroupMap(storyGroup),
                                    "story" to createStoryMap(story),
                                    "storyComponent" to createStoryComponentMap(storyComponent)))
                }
            }
        }
    }

    override fun getView(): View {
        return storylyView
    }

    override fun dispose() {}

    private fun createStoryGroupMap(storyGroup: StoryGroup): Map<String, *> {
        return mapOf("id" to storyGroup.id,
                "title" to storyGroup.title,
                "index" to storyGroup.index,
                "seen" to storyGroup.seen,
                "iconUrl" to storyGroup.iconUrl,
                "stories" to storyGroup.stories.map { story -> createStoryMap(story) }
        )
    }

    private fun createStoryMap(story: Story): Map<String, *> {
        return mapOf("id" to story.id,
                "title" to story.title,
                "index" to story.index,
                "seen" to story.seen,
                "media" to with(story.media) {
                    mapOf("type" to this.type.ordinal,
                            "actionUrl" to this.actionUrl)
                }
        )
    }

    private fun createStoryComponentMap(storyComponent: StoryComponent): Map<String, *> {
        when (storyComponent) {
            is StoryQuizComponent -> {
                return mapOf("type" to storyComponent.type.name.toLowerCase(Locale.ENGLISH),
                        "title" to storyComponent.title,
                        "options" to storyComponent.options,
                        "rightAnswerIndex" to storyComponent.rightAnswerIndex,
                        "selectedOptionIndex" to storyComponent.selectedOptionIndex,
                        "customPayload" to storyComponent.customPayload)
            }
            is StoryPollComponent -> {
                return mapOf("type" to storyComponent.type.name.toLowerCase(Locale.ENGLISH),
                        "title" to storyComponent.title,
                        "options" to storyComponent.options,
                        "selectedOptionIndex" to storyComponent.selectedOptionIndex,
                        "customPayload" to storyComponent.customPayload)
            }
            is StoryEmojiComponent -> {
                return mapOf("type" to storyComponent.type.name.toLowerCase(Locale.ENGLISH),
                        "emojiCodes" to storyComponent.emojiCodes,
                        "selectedEmojiIndex" to storyComponent.selectedEmojiIndex,
                        "customPayload" to storyComponent.customPayload)
            }
            is StoryRatingComponent -> {
                return mapOf("type" to storyComponent.type.name.toLowerCase(Locale.ENGLISH),
                        "emojiCode" to storyComponent.emojiCode,
                        "rating" to storyComponent.rating,
                        "customPayload" to storyComponent.customPayload)
            }
        }
        return mapOf("type" to storyComponent.type.name.toLowerCase(Locale.ENGLISH))
    }
}