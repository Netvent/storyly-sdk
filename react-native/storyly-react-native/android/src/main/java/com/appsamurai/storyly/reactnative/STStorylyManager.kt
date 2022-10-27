package com.appsamurai.storyly.reactnative

import android.content.Context
import android.content.res.Resources
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.net.Uri
import android.util.DisplayMetrics
import android.util.TypedValue
import android.view.View
import androidx.core.content.ContextCompat
import com.appsamurai.storyly.StoryGroupSize
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.StorylyLayoutDirection
import com.appsamurai.storyly.StorylySegmentation
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
import kotlin.math.roundToInt

class STStorylyManager : ViewGroupManager<STStorylyView>() {
    companion object {
        private const val REACT_CLASS = "STStoryly"

        private const val PROP_STORYLY_INIT = "storylyInit"
        private const val PROP_STORYLY_ID = "storylyId"
        private const val PROP_STORYLY_SEGMENTS = "storylySegments"
        private const val PROP_STORYLY_USER_PROPERTY = "userProperty"
        private const val PROP_STORYLY_SHARE_URL = "storylyShareUrl"
        private const val PROP_CUSTOM_PARAMETER = "customParameter"
        private const val PROP_STORYLY_PAYLOAD = "storylyPayload"
        private const val PROP_STORYLY_IS_TEST_MODE = "storylyIsTestMode"
        private const val PROP_STORY_GROUP_ICON_BORDER_COLOR_SEEN = "storyGroupIconBorderColorSeen"
        private const val PROP_STORY_GROUP_ICON_BORDER_COLOR_NOT_SEEN = "storyGroupIconBorderColorNotSeen"
        private const val PROP_STORY_GROUP_ICON_BACKGROUND_COLOR = "storyGroupIconBackgroundColor"
        private const val PROP_STORY_GROUP_PIN_ICON_COLOR = "storyGroupPinIconColor"
        private const val PROP_STORY_GROUP_SIZE = "storyGroupSize"
        private const val PROP_STORY_ITEM_ICON_BORDER_COLOR = "storyItemIconBorderColor"
        private const val PROP_STORY_ITEM_TEXT_COLOR = "storyItemTextColor"
        private const val PROP_STORY_ITEM_PROGRESS_BAR_COLOR = "storyItemProgressBarColor"
        private const val PROP_STORY_ITEM_TEXT_TYPEFACE = "storyItemTextTypeface"
        private const val PROP_STORY_INTERACTIVE_TEXT_TYPEFACE = "storyInteractiveTextTypeface"
        private const val PROP_STORY_GROUP_ICON_STYLING = "storyGroupIconStyling"
        private const val PROP_STORY_GROUP_LIST_STYLING = "storyGroupListStyling"
        private const val PROP_STORY_GROUP_TEXT_STYLING = "storyGroupTextStyling"
        private const val PROP_STORY_HEADER_STYLING = "storyHeaderStyling"
        private const val PROP_STORY_GROUP_VIEW_FACTORY = "storyGroupViewFactory"
        private const val PROP_STORYLY_LAYOUT_DIRECTION = "storylyLayoutDirection"

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
        private const val COMMAND_OPEN_STORY_WITH_ID_NAME = "openStoryWithId"
        private const val COMMAND_OPEN_STORY_WITH_ID_CODE = 6

        internal const val EVENT_STORYLY_LOADED = "onStorylyLoaded"
        internal const val EVENT_STORYLY_LOAD_FAILED = "onStorylyLoadFailed"
        internal const val EVENT_STORYLY_EVENT = "onStorylyEvent"
        internal const val EVENT_STORYLY_ACTION_CLICKED = "onStorylyActionClicked"
        internal const val EVENT_STORYLY_STORY_PRESENTED = "onStorylyStoryPresented"
        internal const val EVENT_STORYLY_STORY_PRESENT_FAILED = "onStorylyStoryPresentFailed"
        internal const val EVENT_STORYLY_STORY_DISMISSED = "onStorylyStoryDismissed"
        internal const val EVENT_STORYLY_USER_INTERACTED = "onStorylyUserInteracted"

        internal const val EVENT_ON_CREATE_CUSTOM_VIEW = "onCreateCustomView"
        internal const val EVENT_ON_UPDATE_CUSTOM_VIEW = "onUpdateCustomView"
    }

    override fun getName(): String = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): STStorylyView {
        return STStorylyView(reactContext)
    }

    override fun addView(parent: STStorylyView?, child: View?, index: Int) {
        parent?.onAttachCustomReactNativeView(child, index)
    }

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
        val builder = MapBuilder.builder<String, Any>()
        arrayOf(
            EVENT_STORYLY_LOADED,
            EVENT_STORYLY_LOAD_FAILED,
            EVENT_STORYLY_EVENT,
            EVENT_STORYLY_ACTION_CLICKED,
            EVENT_STORYLY_STORY_PRESENTED,
            EVENT_STORYLY_STORY_PRESENT_FAILED,
            EVENT_STORYLY_STORY_DISMISSED,
            EVENT_STORYLY_USER_INTERACTED,
            EVENT_ON_CREATE_CUSTOM_VIEW,
            EVENT_ON_UPDATE_CUSTOM_VIEW,
        ).forEach {
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
            COMMAND_OPEN_STORY_WITH_ID_NAME, COMMAND_OPEN_STORY_WITH_ID_CODE
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
                (args?.getArray(0)?.toArrayList() as List<Map<String, Any?>>).let {
                    root.storylyView.setExternalData(it)
                }
            }
            COMMAND_OPEN_STORY_WITH_ID_CODE -> {
                val storyGroupId: String = args?.getString(0) ?: return
                val storyId: String? = if (args.size() > 1) args.getString(1) else null

                root.storylyView.openStory(storyGroupId, storyId)
            }
        }
    }

    @ReactProp(name = PROP_STORYLY_INIT)
    fun setPropStorylyInit(view: STStorylyView, storylyInit: ReadableMap) {
        val storylyId: String = storylyInit.getString(PROP_STORYLY_ID) ?: return
        val isTestMode = if (storylyInit.hasKey(PROP_STORYLY_IS_TEST_MODE)) storylyInit.getBoolean(PROP_STORYLY_IS_TEST_MODE) else false
        val segments = if (storylyInit.hasKey(PROP_STORYLY_SEGMENTS)) (storylyInit.getArray(PROP_STORYLY_SEGMENTS)?.toArrayList() as? ArrayList<String>)?.toSet() else null
        val customParameter = if (storylyInit.hasKey(PROP_CUSTOM_PARAMETER)) storylyInit.getString(PROP_CUSTOM_PARAMETER) else null
        val storylyPayload = if (storylyInit.hasKey(PROP_STORYLY_PAYLOAD)) storylyInit.getString(PROP_STORYLY_PAYLOAD) else null
        val userProperty = if (storylyInit.hasKey(PROP_STORYLY_USER_PROPERTY)) storylyInit.getMap(PROP_STORYLY_USER_PROPERTY)?.toHashMap() as? Map<String, String> else null

        view.storylyView.storylyInit = StorylyInit(
            storylyId = storylyId,
            segmentation = StorylySegmentation(segments = segments),
            customParameter = customParameter,
            isTestMode = isTestMode,
            storylyPayload = storylyPayload
        ).apply {
            userProperty?.let { this.userData = it }
        }
    }

    @ReactProp(name = PROP_STORYLY_SHARE_URL)
    fun setPropStorylyShareUrl(view: STStorylyView, storylyShareUrl: String?) {
        view.storylyView.storylyShareUrl = storylyShareUrl
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

    @ReactProp(name = PROP_STORY_GROUP_PIN_ICON_COLOR)
    fun setPropStoryGroupPinIconColor(view: STStorylyView, color: String) {
        view.storylyView.setStoryGroupPinIconColor(Color.parseColor(color))
    }

    @ReactProp(name = PROP_STORY_GROUP_SIZE)
    fun setPropStoryGroupSize(view: STStorylyView, size: String) {
        when (size) {
            "small" -> view.storylyView.setStoryGroupSize(StoryGroupSize.Small)
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
        val height = if (storyGroupIconStylingMap.hasKey("height")) storyGroupIconStylingMap.getInt("height").toFloat() else dpToPixel(80)
        val width = if (storyGroupIconStylingMap.hasKey("width")) storyGroupIconStylingMap.getInt("width").toFloat() else dpToPixel(80)
        val cornerRadius = if (storyGroupIconStylingMap.hasKey("cornerRadius")) storyGroupIconStylingMap.getInt("cornerRadius").toFloat() else dpToPixel(40)

        view.storylyView.setStoryGroupIconStyling(
            StoryGroupIconStyling(
                height = height,
                width = width,
                cornerRadius = cornerRadius
            )
        )
    }

    @ReactProp(name = PROP_STORY_GROUP_LIST_STYLING)
    fun setPropStoryGroupListStyling(view: STStorylyView, storyGroupListStylingMap: ReadableMap) {
        val edgePadding = if (storyGroupListStylingMap.hasKey("edgePadding")) storyGroupListStylingMap.getInt("edgePadding").toFloat() else dpToPixel(4)
        val paddingBetweenItems = if (storyGroupListStylingMap.hasKey("paddingBetweenItems")) storyGroupListStylingMap.getInt("paddingBetweenItems").toFloat() else dpToPixel(4)

        view.storylyView.setStoryGroupListStyling(
            StoryGroupListStyling(
                edgePadding = edgePadding,
                paddingBetweenItems = paddingBetweenItems
            )
        )
    }

    @ReactProp(name = PROP_STORY_GROUP_TEXT_STYLING)
    fun setPropStoryGroupTextStyling(view: STStorylyView, storyGroupTextStylingMap: ReadableMap) {
        val isVisible = if (storyGroupTextStylingMap.hasKey("isVisible")) storyGroupTextStylingMap.getBoolean("isVisible") else true
        val typefaceName = if (storyGroupTextStylingMap.hasKey("typeface")) storyGroupTextStylingMap.getString("typeface") else null
        val textSize = if (storyGroupTextStylingMap.hasKey("textSize")) storyGroupTextStylingMap.getInt("textSize") else null
        val lines = if (storyGroupTextStylingMap.hasKey("lines")) storyGroupTextStylingMap.getInt("lines") else null

        val colorSeen = Color.parseColor(if (storyGroupTextStylingMap.hasKey("colorSeen")) storyGroupTextStylingMap.getString("colorSeen") else "#FF000000")
        val colorNotSeen = Color.parseColor(if (storyGroupTextStylingMap.hasKey("colorNotSeen")) storyGroupTextStylingMap.getString("colorNotSeen") else "#FF000000")

        val customTypeface = typefaceName?.let { try { Typeface.createFromAsset(view.context.applicationContext.assets, it) } catch(_: Exception) { null } } ?: Typeface.DEFAULT

        view.storylyView.setStoryGroupTextStyling(
            StoryGroupTextStyling(
                isVisible = isVisible,
                typeface = customTypeface,
                textSize = Pair(TypedValue.COMPLEX_UNIT_PX, textSize),
                minLines = null,
                maxLines = null,
                lines = lines,
                colorSeen = colorSeen,
                colorNotSeen = colorNotSeen
            )
        )
    }

    @ReactProp(name = PROP_STORY_HEADER_STYLING)
    fun setPropStoryHeaderStyling(view: STStorylyView, storyHeaderStylingMap: ReadableMap) {
        val isTextVisible = if (storyHeaderStylingMap.hasKey("isTextVisible")) storyHeaderStylingMap.getBoolean("isTextVisible") else true
        val isIconVisible = if (storyHeaderStylingMap.hasKey("isIconVisible")) storyHeaderStylingMap.getBoolean("isIconVisible") else true
        val isCloseButtonVisible = if (storyHeaderStylingMap.hasKey("isCloseButtonVisible")) storyHeaderStylingMap.getBoolean("isCloseButtonVisible") else true

        val closeIcon = if (storyHeaderStylingMap.hasKey("closeIcon")) storyHeaderStylingMap.getString("closeIcon") else null
        val closeIconDrawable = closeIcon?.let { getDrawable(view.context.applicationContext, it) }

        val shareIcon = if (storyHeaderStylingMap.hasKey("shareIcon")) storyHeaderStylingMap.getString("shareIcon") else null
        val shareIconDrawable = shareIcon?.let { getDrawable(view.context.applicationContext, it) }

        view.storylyView.setStoryHeaderStyling(
            StoryHeaderStyling(
                isTextVisible = isTextVisible,
                isIconVisible = isIconVisible,
                isCloseButtonVisible = isCloseButtonVisible,
                closeButtonIcon = closeIconDrawable,
                shareButtonIcon = shareIconDrawable
            )
        )
    }

    @ReactProp(name = PROP_STORY_GROUP_VIEW_FACTORY)
    fun setPropStoryGroupViewFactory(view: STStorylyView, storyGroupViewFactoryMap: ReadableMap?) {
        val map = storyGroupViewFactoryMap ?: return
        val width = if (map.hasKey("width")) map.getInt("width") else return
        val height = if (map.hasKey("height")) map.getInt("height") else return

        view.storylyView.storyGroupViewFactory = RNStoryGroupViewFactory(view.context, dpToPixel(width).roundToInt(), dpToPixel(height).roundToInt()).also {
            it.onSendEvent = view::sendEvent
        }
    }

    @ReactProp(name = PROP_STORY_ITEM_TEXT_TYPEFACE)
    fun setPropStoryItemTextTypeface(view: STStorylyView, typeface: String) {
        val customTypeface = try { Typeface.createFromAsset(view.context.applicationContext.assets, typeface) } catch(_: Exception) { Typeface.DEFAULT }
        view.storylyView.setStoryItemTextTypeface(customTypeface)
    }

    @ReactProp(name = PROP_STORY_INTERACTIVE_TEXT_TYPEFACE)
    fun setPropStoryInteractiveTextTypeface(view: STStorylyView, typeface: String) {
        val customTypeface = try { Typeface.createFromAsset(view.context.applicationContext.assets, typeface) } catch(_: Exception) { Typeface.DEFAULT }
        view.storylyView.setStoryInteractiveTextTypeface(customTypeface)
    }

    @ReactProp(name = PROP_STORYLY_LAYOUT_DIRECTION)
    fun setPropStorylyLayoutDirection(view: STStorylyView, layoutDirection: String) {
        when (layoutDirection) {
            "ltr" ->  view.storylyView.setStorylyLayoutDirection(StorylyLayoutDirection.LTR)
            "rtl" -> view.storylyView.setStorylyLayoutDirection(StorylyLayoutDirection.RTL)
            else -> view.storylyView.setStorylyLayoutDirection(StorylyLayoutDirection.LTR)
        }
    }

    private fun convertColorArray(colors: ReadableArray): Array<Int> {
        val colorsNative = arrayListOf<Int>()
        for (i in 0 until colors.size()) {
            colorsNative.add(colors.getInt(i))
        }
        return colorsNative.toTypedArray()
    }

    private fun dpToPixel(dpValue: Int): Float {
        return dpValue * (Resources.getSystem().displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)
    }

    private fun getDrawable(context: Context, name: String): Drawable? {
        val id = context.resources.getIdentifier(name, "drawable", context.packageName)
        return ContextCompat.getDrawable(context, id)
    }
}
