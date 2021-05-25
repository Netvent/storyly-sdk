package com.appsamurai.storyly.reactnative

import android.graphics.Color
import android.net.Uri
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.StorylySegmentation
import com.appsamurai.storyly.StoryGroupSize
import com.appsamurai.storyly.styling.StoryGroupIconStyling
import com.appsamurai.storyly.styling.StoryGroupListStyling
import com.appsamurai.storyly.styling.StoryGroupTextStyling
import com.appsamurai.storyly.styling.StoryHeaderStyling
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.annotations.ReactProp

class STStorylyManager : ViewGroupManager<STStorylyView>() {
    companion object {
        private const val REACT_CLASS = "STStoryly"

        private const val PROP_STORYLY_INIT = "storylyInit"
        private const val PROP_STORYLY_ID = "storylyId"
        private const val PROP_STORYLY_SEGMENTS = "storylySegments"
        private const val PROP_CUSTOM_PARAMETER = "customParameter"
        private const val PROP_STORYLY_IS_TEST_MODE = "storylyIsTestMode"
        private const val PROP_STORY_GROUP_ICON_BORDER_COLOR_SEEN = "storyGroupIconBorderColorSeen"
        private const val PROP_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN = "storyGroupIconBorderColorNotSeen"
        private const val PROP_STORY_GROUP_ICON_BACKGROUND_COLOR = "storyGroupIconBackgroundColor"
        private const val PROP_STORY_GROUP_TEXT_COLOR = "storyGroupTextColor"
        private const val PROP_STORY_GROUP_PIN_ICON_COLOR = "storyGroupPinIconColor"
        private const val PROP_STORY_GROUP_ICON_FOREGROUND_COLORS = "storyGroupIconForegroundColors"
        private const val PROP_STORY_GROUP_SIZE = "storyGroupSize"
        private const val PROP_STORY_ITEM_ICON_BORDER_COLOR = "storyItemIconBorderColor"
        private const val PROP_STORY_ITEM_TEXT_COLOR = "storyItemTextColor"
        private const val PROP_STORY_ITEM_PROGRESS_BAR_COLOR = "storyItemProgressBarColor"
        private const val PROP_STORY_GROUP_ICON_STYLING = "storyGroupIconStyling"
        private const val PROP_STORY_GROUP_LIST_STYLING = "storyGroupListStyling"
        private const val PROP_STORY_GROUP_TEXT_STYLING = "storyGroupTextStyling"
        private const val PROP_STORY_HEADER_STYLING = "storyHeaderStyling"

        private const val COMMAND_REFRESH_NAME = "refresh"
        private const val COMMAND_REFRESH_CODE = 1
        private const val COMMAND_OPEN_NAME = "open"
        private const val COMMAND_OPEN_CODE = 2
        private const val COMMAND_CLOSE_NAME = "close"
        private const val COMMAND_CLOSE_CODE = 3
        private const val COMMAND_OPEN_STORY_NAME = "openStory"
        private const val COMMAND_OPEN_STORY_CODE = 4
        private const val COMMAND_SET_EXTERNAL_DATA_NAME = "setExternalData"
        private const val COMMAND_SET_EXTERNAL_DATA_CODE = 5
        private const val COMMAND_OPEN_STORY_V2_NAME = "openStoryWithId"
        private const val COMMAND_OPEN_STORY_V2_CODE = 6

        internal const val EVENT_STORYLY_LOADED = "onStorylyLoaded"
        internal const val EVENT_STORYLY_LOAD_FAILED = "onStorylyLoadFailed"
        internal const val EVENT_STORYLY_EVENT = "onStorylyEvent"
        internal const val EVENT_STORYLY_ACTION_CLICKED = "onStorylyActionClicked"
        internal const val EVENT_STORYLY_STORY_PRESENTED = "onStorylyStoryPresented"
        internal const val EVENT_STORYLY_STORY_DISMISSED = "onStorylyStoryDismissed"
        internal const val EVENT_STORYLY_USER_INTERACTED = "onStorylyUserInteracted"

    }

    override fun getName(): String = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): STStorylyView {
        return STStorylyView(reactContext)
    }

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
        val builder = MapBuilder.builder<String, Any>()
        arrayOf(EVENT_STORYLY_LOADED,
                EVENT_STORYLY_LOAD_FAILED,
                EVENT_STORYLY_EVENT,
                EVENT_STORYLY_ACTION_CLICKED,
                EVENT_STORYLY_STORY_PRESENTED,
                EVENT_STORYLY_STORY_DISMISSED,
                EVENT_STORYLY_USER_INTERACTED).forEach {
            builder.put(it, MapBuilder.of("registrationName", it))
        }
        return builder.build()
    }

    override fun getCommandsMap(): Map<String, Int> {
        return MapBuilder.of(
                COMMAND_REFRESH_NAME, COMMAND_REFRESH_CODE,
                COMMAND_OPEN_NAME, COMMAND_OPEN_CODE,
                COMMAND_CLOSE_NAME, COMMAND_CLOSE_CODE,
                COMMAND_OPEN_STORY_NAME, COMMAND_OPEN_STORY_CODE,
                COMMAND_SET_EXTERNAL_DATA_NAME, COMMAND_SET_EXTERNAL_DATA_CODE,
                COMMAND_OPEN_STORY_V2_NAME, COMMAND_OPEN_STORY_V2_CODE
        )
    }

    override fun receiveCommand(root: STStorylyView, commandId: Int, args: ReadableArray?) {
        when (commandId) {
            COMMAND_REFRESH_CODE -> root.storylyView.refresh()
            COMMAND_OPEN_CODE -> root.storylyView.show()
            COMMAND_CLOSE_CODE -> root.storylyView.dismiss()
            COMMAND_OPEN_STORY_CODE -> {
                val payloadStr: String = args?.getString(0) ?: return
                root.storylyView.openStory(Uri.parse(payloadStr))
            }
            COMMAND_SET_EXTERNAL_DATA_CODE -> {
                root.storylyView.setExternalData(args?.getArray(0)?.toArrayList() as? ArrayList<Map<String, Any>>)
            }
            COMMAND_OPEN_STORY_V2_CODE -> {
                val storyGroupId: Int = args?.getInt(0) ?: return
                val storyId: Int? = if (args.size() > 1) args.getInt(1) else null

                root.storylyView.openStory(storyGroupId, storyId)
            }
        }
    }

    @ReactProp(name = PROP_STORYLY_INIT)
    fun setPropStorylyInit(view: STStorylyView, storylyInit: ReadableMap) {
        val storylyId: String = storylyInit.getString(PROP_STORYLY_ID) ?: return
        val isTestMode = if (storylyInit.hasKey(PROP_STORYLY_IS_TEST_MODE)) storylyInit.getBoolean(PROP_STORYLY_IS_TEST_MODE) else false
        if (storylyInit.hasKey(PROP_STORYLY_SEGMENTS)) {
            storylyInit.getArray(PROP_STORYLY_SEGMENTS)?.let { storylySegments ->
                val segmentationParams = StorylySegmentation(segments = (storylySegments.toArrayList() as? ArrayList<String>)?.toSet())
                if (storylyInit.hasKey(PROP_CUSTOM_PARAMETER)) {
                    view.storylyView.storylyInit = StorylyInit(storylyId = storylyId, segmentation = segmentationParams, customParameter = storylyInit.getString(PROP_CUSTOM_PARAMETER), isTestMode = isTestMode)
                } else {
                    view.storylyView.storylyInit = StorylyInit(storylyId = storylyId, segmentation = segmentationParams, isTestMode = isTestMode)
                }
            } ?: run {
                if (storylyInit.hasKey(PROP_CUSTOM_PARAMETER)) {
                    view.storylyView.storylyInit = StorylyInit(storylyId = storylyId, customParameter = storylyInit.getString(PROP_CUSTOM_PARAMETER), isTestMode = isTestMode)
                } else {
                    view.storylyView.storylyInit = StorylyInit(storylyId = storylyId, isTestMode = isTestMode)
                }
            }
        } else {
            if (storylyInit.hasKey(PROP_CUSTOM_PARAMETER)) {
                view.storylyView.storylyInit = StorylyInit(storylyId = storylyId, customParameter = storylyInit.getString(PROP_CUSTOM_PARAMETER), isTestMode = isTestMode)
            } else {
                view.storylyView.storylyInit = StorylyInit(storylyId = storylyId, isTestMode = isTestMode)
            }
        }
    }

    @ReactProp(name = PROP_STORY_GROUP_ICON_BORDER_COLOR_SEEN)
    fun setPropStoryGroupIconBorderColorSeen(view: STStorylyView, colors: ReadableArray?) {
        colors?.let { view.storylyView.setStoryGroupIconBorderColorSeen(convertColorArray(colors)) }
    }

    @ReactProp(name = PROP_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN)
    fun setPropStoryGroupIconBorderColorNotSeen(view: STStorylyView, colors: ReadableArray?) {
        colors?.let { view.storylyView.setStoryGroupIconBorderColorNotSeen(convertColorArray(colors)) }
    }

    @ReactProp(name = PROP_STORY_GROUP_ICON_BACKGROUND_COLOR)
    fun setPropStoryGroupIconBackgroundColor(view: STStorylyView, color: String) {
        view.storylyView.setStoryGroupIconBackgroundColor(Color.parseColor(color))
    }

    @ReactProp(name = PROP_STORY_GROUP_TEXT_COLOR)
    fun setPropStoryGroupTextColor(view: STStorylyView, color: String) {
        view.storylyView.setStoryGroupTextColor(Color.parseColor(color))
    }

    @ReactProp(name = PROP_STORY_GROUP_PIN_ICON_COLOR)
    fun setPropStoryGroupPinIconColor(view: STStorylyView, color: String) {
        view.storylyView.setStoryGroupPinIconColor(Color.parseColor(color))
    }

    @ReactProp(name = PROP_STORY_GROUP_ICON_FOREGROUND_COLORS)
    fun setPropStoryGroupIconForegroundColors(view: STStorylyView, colors: ReadableArray?) {
        colors?.let { view.storylyView.setStoryGroupIconForegroundColor(convertColorArray(colors)) }
    }

    @ReactProp(name = PROP_STORY_GROUP_SIZE)
    fun setPropStoryGroupSize(view: STStorylyView, size: String) {
        when (size) {
            "small" -> view.storylyView.setStoryGroupSize(StoryGroupSize.Small)
            "xlarge" -> view.storylyView.setStoryGroupSize(StoryGroupSize.XLarge)
            "custom" -> view.storylyView.setStoryGroupSize(StoryGroupSize.Custom)
            else -> view.storylyView.setStoryGroupSize(StoryGroupSize.Large)
        }
    }

    @ReactProp(name = PROP_STORY_ITEM_ICON_BORDER_COLOR)
    fun setPropStoryItemIconBorderColor(view: STStorylyView, colors: ReadableArray?) {
        colors?.let { view.storylyView.setStoryItemIconBorderColor(convertColorArray(colors)) }
    }

    @ReactProp(name = PROP_STORY_ITEM_TEXT_COLOR)
    fun setPropStoryItemTextColor(view: STStorylyView, color: String) {
        view.storylyView.setStoryItemTextColor(Color.parseColor(color))
    }

    @ReactProp(name = PROP_STORY_ITEM_PROGRESS_BAR_COLOR)
    fun setPropStoryItemProgressBarColor(view: STStorylyView, colors: ReadableArray?) {
        colors?.let { view.storylyView.setStoryItemProgressBarColor(convertColorArray(colors)) }
    }

    @ReactProp(name = PROP_STORY_GROUP_ICON_STYLING)
    fun setPropStoryGroupIconStyling(view: STStorylyView, storyGroupIconStylingMap: ReadableMap) {
        if (storyGroupIconStylingMap.hasKey("height") &&
                storyGroupIconStylingMap.hasKey("width") &&
                storyGroupIconStylingMap.hasKey("cornerRadius")) {
            view.storylyView.setStoryGroupIconStyling(StoryGroupIconStyling(
                    storyGroupIconStylingMap.getInt("height").toFloat(),
                    storyGroupIconStylingMap.getInt("width").toFloat(),
                    storyGroupIconStylingMap.getDouble("cornerRadius").toFloat()))
        }
    }

    @ReactProp(name = PROP_STORY_GROUP_LIST_STYLING)
    fun setPropStoryGroupListStyling(view: STStorylyView, storyGroupListStylingMap: ReadableMap) {
        if (storyGroupListStylingMap.hasKey("edgePadding") &&
                storyGroupListStylingMap.hasKey("paddingBetweenItems")) {
            view.storylyView.setStoryGroupListStyling(StoryGroupListStyling(
                    storyGroupListStylingMap.getInt("edgePadding").toFloat(),
                    storyGroupListStylingMap.getInt("paddingBetweenItems").toFloat()))
        }
    }

    @ReactProp(name = PROP_STORY_GROUP_TEXT_STYLING)
    fun setPropStoryGroupTextStyling(view: STStorylyView, storyGroupTextStylingMap: ReadableMap) {
        if (storyGroupTextStylingMap.hasKey("isVisible")) {
            view.storylyView.setStoryGroupTextStyling(StoryGroupTextStyling(storyGroupTextStylingMap.getBoolean("isVisible")))
        }
    }

    @ReactProp(name = PROP_STORY_HEADER_STYLING)
    fun setPropStoryHeaderStyling(view: STStorylyView, storyHeaderStylingMap: ReadableMap) {
        if (storyHeaderStylingMap.hasKey("isTextVisible") &&
                storyHeaderStylingMap.hasKey("isIconVisible") &&
                storyHeaderStylingMap.hasKey("isCloseButtonVisible")) {
            view.storylyView.setStoryHeaderStyling(StoryHeaderStyling(
                    storyHeaderStylingMap.getBoolean("isTextVisible"),
                    storyHeaderStylingMap.getBoolean("isIconVisible"),
                    storyHeaderStylingMap.getBoolean("isCloseButtonVisible")))
        }
    }

    private fun convertColorArray(colors: ReadableArray): Array<Int> {
        val colorsNative = arrayListOf<Int>()
        for (i in 0 until colors.size()) {
            colorsNative.add(colors.getInt(i))
        }
        return colorsNative.toTypedArray()
    }
}
