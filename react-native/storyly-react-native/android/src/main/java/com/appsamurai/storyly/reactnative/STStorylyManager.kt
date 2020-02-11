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
        private const val PROP_STORYLY_GROUP_ICON_BORDER_COLOR_SEEN = "storyGroupIconBorderColorSeen"
        private const val PROP_STORYLY_GROUP_ICON_BORDER_COLOR_NOT_SEEN = "storyGroupIconBorderColorNotSeen"
        private const val PROP_STORYLY_GROUP_ICON_BACKGROUND_COLOR = "storyGroupIconBackgroundColor"
        private const val PROP_STORYLY_GROUP_TEXT_COLOR = "storyGroupTextColor"
        private const val PROP_STORYLY_GROUP_PIN_ICON_COLOR = "storyGroupPinIconColor"
        private const val PROP_STORYLY_ITEM_ICON_BORDER_COLOR = "storyItemIconBorderColor"
        private const val PROP_STORYLY_ITEM_TEXT_COLOR = "storyItemTextColor"
        private const val PROP_STORYLY_ITEM_PROGRESS_BAR_COLOR = "storylyItemProgressBarColor"

        private const val COMMAND_REFRESH_NAME = "refresh"
        private const val COMMAND_REFRESH_CODE = 1

        internal const val EVENT_STORYLY_LOADED = "onStorylyLoaded"
        internal const val EVENT_STORYLY_LOAD_FAILED = "onStorylyLoadFailed"
        internal const val EVENT_STORYLY_ACTION_CLICKED = "onStorylyActionClicked"
    }

    override fun getName(): String = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): STStorylyView {
        return STStorylyView(reactContext)
    }

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
        val builder = MapBuilder.builder<String, Any>()
        arrayOf(EVENT_STORYLY_LOADED, EVENT_STORYLY_LOAD_FAILED, EVENT_STORYLY_ACTION_CLICKED).forEach {
            builder.put(it, MapBuilder.of("registrationName", it))
        }
        return builder.build()
    }

    override fun getCommandsMap(): Map<String, Int> {
        return MapBuilder.of(COMMAND_REFRESH_NAME, COMMAND_REFRESH_CODE)
    }

    override fun receiveCommand(root: STStorylyView, commandId: Int, args: ReadableArray?) {
        when (commandId) {
            COMMAND_REFRESH_CODE -> root.storylyView.refresh()
        }
    }

    @ReactProp(name = PROP_STORYLY_ID)
    fun setPropStorylyId(view: STStorylyView, storylyId: String) {
        view.storylyView.storylyId = storylyId
    }

    @ReactProp(name = PROP_STORYLY_GROUP_ICON_BORDER_COLOR_SEEN)
    fun setPropStorylyGroupIconBorderColorSeen(view: STStorylyView, colors: ReadableArray?) {
        colors?.let { view.storylyView.setStoryGroupIconBorderColorSeen(convertColorArray(colors)) }
    }

    @ReactProp(name = PROP_STORYLY_GROUP_ICON_BORDER_COLOR_NOT_SEEN)
    fun setPropStorylyGroupIconBorderColorNotSeen(view: STStorylyView, colors: ReadableArray?) {
        colors?.let { view.storylyView.setStoryGroupIconBorderColorNotSeen(convertColorArray(colors)) }
    }

    @ReactProp(name = PROP_STORYLY_GROUP_ICON_BACKGROUND_COLOR)
    fun setPropStorylyGroupIconBackgroundColor(view: STStorylyView, color: String) {
        view.storylyView.setStoryGroupIconBackgroundColor(Color.parseColor(color))
    }

    @ReactProp(name = PROP_STORYLY_GROUP_TEXT_COLOR)
    fun setPropStorylyGroupTextColor(view: STStorylyView, color: String) {
        view.storylyView.setStoryGroupTextColor(Color.parseColor(color))
    }

    @ReactProp(name = PROP_STORYLY_GROUP_PIN_ICON_COLOR)
    fun setPropStorylyGroupPinIconColor(view: STStorylyView, color: String) {
        view.storylyView.setStoryGroupPinIconColor(Color.parseColor(color))
    }

    @ReactProp(name = PROP_STORYLY_ITEM_ICON_BORDER_COLOR)
    fun setPropStorylyItemIconBorderColor(view: STStorylyView, colors: ReadableArray?) {
        colors?.let { view.storylyView.setStoryItemIconBorderColor(convertColorArray(colors)) }
    }

    @ReactProp(name = PROP_STORYLY_ITEM_TEXT_COLOR)
    fun setPropStorylyItemTextColor(view: STStorylyView, color: String) {
        view.storylyView.setStoryItemTextColor(Color.parseColor(color))
    }

    @ReactProp(name = PROP_STORYLY_ITEM_PROGRESS_BAR_COLOR)
    fun setPropStorylyItemProgressBarColor(view: STStorylyView, colors: ReadableArray?) {
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
