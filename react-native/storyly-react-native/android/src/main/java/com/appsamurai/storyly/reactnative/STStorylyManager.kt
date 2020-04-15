package com.appsamurai.storyly.reactnative

import android.graphics.Color
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.annotations.ReactProp

class STStorylyManager : ViewGroupManager<STStorylyView>() {
    companion object {
        private const val REACT_CLASS = "STStoryly"

        private const val PROP_STORYLY_ID = "storylyId"
        private const val PROP_STORY_GROUP_ICON_BORDER_COLOR_SEEN = "storyGroupIconBorderColorSeen"
        private const val PROP_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN = "storyGroupIconBorderColorNotSeen"
        private const val PROP_STORY_GROUP_ICON_BACKGROUND_COLOR = "storyGroupIconBackgroundColor"
        private const val PROP_STORY_GROUP_TEXT_COLOR = "storyGroupTextColor"
        private const val PROP_STORY_GROUP_PIN_ICON_COLOR = "storyGroupPinIconColor"
        private const val PROP_STORY_ITEM_ICON_BORDER_COLOR = "storyItemIconBorderColor"
        private const val PROP_STORY_ITEM_TEXT_COLOR = "storyItemTextColor"
        private const val PROP_STORY_ITEM_PROGRESS_BAR_COLOR = "storyItemProgressBarColor"

        private const val COMMAND_REFRESH_NAME = "refresh"
        private const val COMMAND_REFRESH_CODE = 1
        private const val COMMAND_OPEN_NAME = "open"
        private const val COMMAND_OPEN_CODE = 2
        private const val COMMAND_CLOSE_NAME = "close"
        private const val COMMAND_CLOSE_CODE = 3

        internal const val EVENT_STORYLY_LOADED = "onStorylyLoaded"
        internal const val EVENT_STORYLY_LOAD_FAILED = "onStorylyLoadFailed"
        internal const val EVENT_STORYLY_ACTION_CLICKED = "onStorylyActionClicked"
        internal const val EVENT_STORYLY_STORY_PRESENTED = "onStorylyStoryPresented"
        internal const val EVENT_STORYLY_STORY_DISMISSED = "onStorylyStoryDismissed"
    }

    override fun getName(): String = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): STStorylyView {
        return STStorylyView(reactContext)
    }

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
        val builder = MapBuilder.builder<String, Any>()
        arrayOf(EVENT_STORYLY_LOADED,
                EVENT_STORYLY_LOAD_FAILED,
                EVENT_STORYLY_ACTION_CLICKED,
                EVENT_STORYLY_STORY_PRESENTED,
                EVENT_STORYLY_STORY_DISMISSED).forEach {
            builder.put(it, MapBuilder.of("registrationName", it))
        }
        return builder.build()
    }

    override fun getCommandsMap(): Map<String, Int> {
        return MapBuilder.of(
                COMMAND_REFRESH_NAME, COMMAND_REFRESH_CODE,
                COMMAND_OPEN_NAME, COMMAND_OPEN_CODE,
                COMMAND_CLOSE_NAME, COMMAND_CLOSE_CODE
        )
    }

    override fun receiveCommand(root: STStorylyView, commandId: Int, args: ReadableArray?) {
        when (commandId) {
            COMMAND_REFRESH_CODE -> root.storylyView.refresh()
            COMMAND_OPEN_CODE -> root.storylyView.show()
            COMMAND_CLOSE_CODE -> root.storylyView.dismiss()
        }
    }

    @ReactProp(name = PROP_STORYLY_ID)
    fun setPropStorylyId(view: STStorylyView, storylyId: String) {
        view.storylyView.storylyId = storylyId
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

    private fun convertColorArray(colors: ReadableArray): Array<Int> {
        val colorsNative = arrayListOf<Int>()
        for (i in 0 until colors.size()) {
            colorsNative.add(colors.getInt(i))
        }
        return colorsNative.toTypedArray()
    }
}
