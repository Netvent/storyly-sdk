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
import com.appsamurai.storyly.*
import com.appsamurai.storyly.styling.*
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.annotations.ReactProp

class STStorylyManager : ViewGroupManager<STStorylyView>() {
    companion object {
        private const val REACT_CLASS = "STStoryly"

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
        private const val COMMAND_HYDRATE_PRODUCT_NAME = "hydrateProducts"
        private const val COMMAND_HYDRATE_PRODUCT_CODE = 7


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

        internal const val EVENT_STORYLY_ON_HYDRATION = "onStorylyProductHydration"
        internal const val EVENT_STORYLY_PRODUCT_EVENT = "onStorylyProductEvent"

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
            EVENT_STORYLY_PRODUCT_EVENT,
            EVENT_STORYLY_ON_HYDRATION
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
            COMMAND_OPEN_STORY_WITH_ID_NAME, COMMAND_OPEN_STORY_WITH_ID_CODE,
            COMMAND_HYDRATE_PRODUCT_NAME, COMMAND_HYDRATE_PRODUCT_CODE
        )
    }

    override fun receiveCommand(root: STStorylyView, commandId: Int, args: ReadableArray?) {
        when (commandId) {
            COMMAND_REFRESH_CODE -> root.storylyView?.refresh()
            COMMAND_OPEN_CODE -> root.storylyView?.show()
            COMMAND_CLOSE_CODE -> root.storylyView?.dismiss()
            COMMAND_OPEN_STORY_CODE -> {
                val payloadStr: String = args?.getString(0) ?: return
                root.storylyView?.openStory(Uri.parse(payloadStr))
            }
            COMMAND_SET_EXTERNAL_DATA_CODE -> {
                (args?.getArray(0)?.toArrayList() as List<Map<String, Any?>>).let {
                    root.storylyView?.setExternalData(it)
                }
            }
            COMMAND_HYDRATE_PRODUCT_CODE -> {
                (args?.getArray(0)?.toArrayList() as List<Map<String, Any?>>).let {
                    val productItems = it.map { createSTRProductItem(it) }
                    root.storylyView.hydrateProducts(productItems)
                }
            }
            COMMAND_OPEN_STORY_WITH_ID_CODE -> {
                val storyGroupId: String = args?.getString(0) ?: return
                val storyId: String? = if (args.size() > 1) args.getString(1) else null

                root.storylyView?.openStory(storyGroupId, storyId)
            }
        }
    }

    @ReactProp(name = "storyly")
    fun setPropStoryly(view: STStorylyView, storylyBundle: ReadableMap) {
        println("STR:STStorylyManager:setPropStoryly:${storylyBundle}")
        val storylyInitJson = storylyBundle.getMap("storylyInit") ?: return
        val storyGroupListStylingJson = storylyBundle.getMap("storyGroupListStyling") ?: return
        val storyGroupIconStylingJson = storylyBundle.getMap("storyGroupIconStyling") ?: return
        val storyGroupTextStylingJson = storylyBundle.getMap("storyGroupTextStyling") ?: return
        val storyHeaderStylingJson = storylyBundle.getMap("storyHeaderStyling") ?: return

        val storylyView = StorylyView(view.activity).apply {
            storylyInit = getStorylyInit(storylyInitJson)
            storylyShareUrl = storylyBundle.getString("storylyShareUrl")
            val stStoryGroupViewFactory = getStoryGroupViewFactory(view.context, storylyBundle.getMap("storyGroupViewFactory"))
            if (stStoryGroupViewFactory != null) {
                storyGroupViewFactory = stStoryGroupViewFactory.also { it?.onSendEvent = view::sendEvent }
            } else {
                setStoryGroupSize(getStoryGroupSize(storylyBundle.getString("storyGroupSize")))
                setStoryGroupIconStyling(getStoryGroupIconStyling(storyGroupIconStylingJson))
                setStoryGroupTextStyling(getStoryGroupTextStyling(view.context, storyGroupTextStylingJson))
                storylyBundle.getArray("storyGroupIconBorderColorSeen")?.let { setStoryGroupIconBorderColorSeen(convertColorArray(it)) }
                storylyBundle.getArray("storyGroupIconBorderColorNotSeen")?.let { setStoryGroupIconBorderColorNotSeen(convertColorArray(it)) }
                if (storylyBundle.hasKey("storyGroupIconBackgroundColor")) setStoryGroupIconBackgroundColor(storylyBundle.getInt("storyGroupIconBackgroundColor"))
                if (storylyBundle.hasKey("storyGroupPinIconColor")) setStoryGroupPinIconColor(storylyBundle.getInt("storyGroupPinIconColor"))
                setStoryGroupAnimation(getStoryGroupAnimation(storylyBundle.getString("storyGroupAnimation")))
            }

            setStoryGroupListStyling(getStoryGroupListStyling(storyGroupListStylingJson))
            setStorylyLayoutDirection(getStorylyLayoutDirection(storylyBundle.getString("storylyLayoutDirection")))
            setStoryHeaderStyling(getStoryHeaderStyling(view.context, storyHeaderStylingJson))
            if (storylyBundle.hasKey("storyItemTextColor")) setStoryItemTextColor(storylyBundle.getInt("storyItemTextColor"))
            storylyBundle.getArray("storyItemIconBorderColor")?.let { setStoryItemIconBorderColor(convertColorArray(it)) }
            storylyBundle.getArray("storyItemProgressBarColor")?.let { setStoryItemProgressBarColor(convertColorArray(it)) }
            setStoryItemTextTypeface(getTypeface(view.context, storylyBundle.getString("storyItemTextTypeface")))
            setStoryInteractiveTextTypeface(getTypeface(view.context, storylyBundle.getString("storyInteractiveTextTypeface")))
        }

        view.storylyView = storylyView
    }

    private fun getStorylyInit(storylyInit: ReadableMap): StorylyInit {
        val storylyId: String = storylyInit.getString("storylyId") ?: ""
        val segments = if (storylyInit.hasKey("storylySegments")) (storylyInit.getArray("storylySegments")?.toArrayList() as? ArrayList<String>)?.toSet() else null
        val customParameter = if (storylyInit.hasKey("customParameter")) storylyInit.getString("customParameter") else null
        val isTestMode = if (storylyInit.hasKey("storylyIsTestMode")) storylyInit.getBoolean("storylyIsTestMode") else false
        val storylyPayload = if (storylyInit.hasKey("storylyPayload")) storylyInit.getString("storylyPayload") else null
        val userProperty = if (storylyInit.hasKey("userProperty")) storylyInit.getMap("userProperty")?.toHashMap() as? Map<String, String> else null

        return StorylyInit(
            storylyId = storylyId,
            segmentation = StorylySegmentation(segments = segments),
            customParameter = customParameter,
            isTestMode = isTestMode,
            storylyPayload = storylyPayload
        ).apply {
            userProperty?.let { this.userData = it }
        }
    }

    private fun getStoryGroupSize(size: String?): StoryGroupSize {
        return when (size) {
            "small" -> StoryGroupSize.Small
            "custom" -> StoryGroupSize.Custom
            else -> StoryGroupSize.Large
        }
    }

    private fun getStoryGroupIconStyling(storyGroupIconStylingMap: ReadableMap): StoryGroupIconStyling {
        val height = if (storyGroupIconStylingMap.hasKey("height")) storyGroupIconStylingMap.getInt("height").toFloat() else dpToPixel(80)
        val width = if (storyGroupIconStylingMap.hasKey("width")) storyGroupIconStylingMap.getInt("width").toFloat() else dpToPixel(80)
        val cornerRadius = if (storyGroupIconStylingMap.hasKey("cornerRadius")) storyGroupIconStylingMap.getInt("cornerRadius").toFloat() else dpToPixel(40)

        return StoryGroupIconStyling(
            height = height,
            width = width,
            cornerRadius = cornerRadius
        )
    }

    private fun getStoryGroupViewFactory(context: Context, storyGroupViewFactoryMap: ReadableMap?): STStoryGroupViewFactory? {
        val map = storyGroupViewFactoryMap ?: return null
        val width = if (map.hasKey("width")) map.getInt("width") else return null
        val height = if (map.hasKey("height")) map.getInt("height") else return null
        if (width <= 0 || height <= 0) return null

        return STStoryGroupViewFactory(context, width, height)
    }

    private fun getStoryGroupListStyling(storyGroupListStylingMap: ReadableMap): StoryGroupListStyling {
        val orientation = when (if (storyGroupListStylingMap.hasKey("orientation")) storyGroupListStylingMap.getString("orientation") else null) {
            "horizontal" -> StoryGroupListOrientation.Horizontal
            "vertical" -> StoryGroupListOrientation.Vertical
            else -> StoryGroupListOrientation.Horizontal
        }
        val sections = if (storyGroupListStylingMap.hasKey("sections")) storyGroupListStylingMap.getInt("sections") else 1
        val horizontalEdgePadding = if (storyGroupListStylingMap.hasKey("horizontalEdgePadding")) storyGroupListStylingMap.getInt("horizontalEdgePadding").toFloat() else dpToPixel(4)
        val verticalEdgePadding = if (storyGroupListStylingMap.hasKey("verticalEdgePadding")) storyGroupListStylingMap.getInt("verticalEdgePadding").toFloat() else dpToPixel(4)
        val horizontalPaddingBetweenItems = if (storyGroupListStylingMap.hasKey("horizontalPaddingBetweenItems")) storyGroupListStylingMap.getInt("horizontalPaddingBetweenItems").toFloat() else dpToPixel(8)
        val verticalPaddingBetweenItems = if (storyGroupListStylingMap.hasKey("verticalPaddingBetweenItems")) storyGroupListStylingMap.getInt("verticalPaddingBetweenItems").toFloat() else dpToPixel(8)

        return StoryGroupListStyling(
            orientation = orientation,
            sections = sections,
            horizontalEdgePadding = horizontalEdgePadding,
            verticalEdgePadding = verticalEdgePadding,
            horizontalPaddingBetweenItems = horizontalPaddingBetweenItems,
            verticalPaddingBetweenItems = verticalPaddingBetweenItems,
        )
    }

    private fun getStoryGroupTextStyling(context: Context, storyGroupTextStylingMap: ReadableMap): StoryGroupTextStyling {
        val isVisible = if (storyGroupTextStylingMap.hasKey("isVisible")) storyGroupTextStylingMap.getBoolean("isVisible") else true
        val typefaceName = if (storyGroupTextStylingMap.hasKey("typeface")) storyGroupTextStylingMap.getString("typeface") else null
        val textSize = if (storyGroupTextStylingMap.hasKey("textSize")) storyGroupTextStylingMap.getInt("textSize") else null
        val lines = if (storyGroupTextStylingMap.hasKey("lines")) storyGroupTextStylingMap.getInt("lines") else null

        val colorSeen = Color.parseColor(if (storyGroupTextStylingMap.hasKey("colorSeen")) storyGroupTextStylingMap.getString("colorSeen") else "#FF000000")
        val colorNotSeen = Color.parseColor(if (storyGroupTextStylingMap.hasKey("colorNotSeen")) storyGroupTextStylingMap.getString("colorNotSeen") else "#FF000000")

        val customTypeface = typefaceName?.let {
            try {
                Typeface.createFromAsset(view.context.applicationContext.assets, it)
            } catch (_: Exception) {
                null
            }
        } ?: Typeface.DEFAULT

        return StoryGroupTextStyling(
            isVisible = isVisible,
            typeface = getTypeface(context, typefaceName),
            textSize = Pair(TypedValue.COMPLEX_UNIT_PX, textSize),
            minLines = null,
            maxLines = null,
            lines = lines,
            colorSeen = colorSeen,
            colorNotSeen = colorNotSeen
        )
    }

    private fun getStoryGroupAnimation(animation: String?): StoryGroupAnimation {
        return when (animation) {
            "border-rotation" -> StoryGroupAnimation.BorderRotation
            "disabled" -> StoryGroupAnimation.Disabled
            else -> StoryGroupAnimation.BorderRotation
        }
    }

    private fun getStorylyLayoutDirection(layoutDirection: String?): StorylyLayoutDirection {
        return when (layoutDirection) {
            "ltr" -> StorylyLayoutDirection.LTR
            "rtl" -> StorylyLayoutDirection.RTL
            else -> StorylyLayoutDirection.LTR
        }
    }

    private fun getStoryHeaderStyling(context: Context, storyHeaderStylingMap: ReadableMap): StoryHeaderStyling {
        val isTextVisible = if (storyHeaderStylingMap.hasKey("isTextVisible")) storyHeaderStylingMap.getBoolean("isTextVisible") else true
        val isIconVisible = if (storyHeaderStylingMap.hasKey("isIconVisible")) storyHeaderStylingMap.getBoolean("isIconVisible") else true
        val isCloseButtonVisible = if (storyHeaderStylingMap.hasKey("isCloseButtonVisible")) storyHeaderStylingMap.getBoolean("isCloseButtonVisible") else true

        val closeIcon = if (storyHeaderStylingMap.hasKey("closeIcon")) storyHeaderStylingMap.getString("closeIcon") else null
        val closeIconDrawable = closeIcon?.let { getDrawable(context.applicationContext, it) }

        val shareIcon = if (storyHeaderStylingMap.hasKey("shareIcon")) storyHeaderStylingMap.getString("shareIcon") else null
        val shareIconDrawable = shareIcon?.let { getDrawable(context.applicationContext, it) }

        return StoryHeaderStyling(
            isTextVisible = isTextVisible,
            isIconVisible = isIconVisible,
            isCloseButtonVisible = isCloseButtonVisible,
            closeButtonIcon = closeIconDrawable,
            shareButtonIcon = shareIconDrawable
        )
    }

    @ReactProp(name = PROP_STORY_GROUP_VIEW_FACTORY)
    fun setPropStoryGroupViewFactory(view: STStorylyView, storyGroupViewFactoryMap: ReadableMap?) {
        val map = storyGroupViewFactoryMap ?: return
        val width = if (map.hasKey("width")) map.getInt("width") else return
        val height = if (map.hasKey("height")) map.getInt("height") else return

        view.storylyView.storyGroupViewFactory = STStoryGroupViewFactory(view.context, width, height).also {
            it.onSendEvent = view::sendEvent
        }
    }

    @ReactProp(name = PROP_STORY_ITEM_TEXT_TYPEFACE)
    fun setPropStoryItemTextTypeface(view: STStorylyView, typeface: String) {
        val customTypeface = try {
            Typeface.createFromAsset(view.context.applicationContext.assets, typeface)
        } catch (_: Exception) {
            Typeface.DEFAULT
        }
        view.storylyView.setStoryItemTextTypeface(customTypeface)
    }

    @ReactProp(name = PROP_STORY_INTERACTIVE_TEXT_TYPEFACE)
    fun setPropStoryInteractiveTextTypeface(view: STStorylyView, typeface: String) {
        val customTypeface = try {
            Typeface.createFromAsset(view.context.applicationContext.assets, typeface)
        } catch (_: Exception) {
            Typeface.DEFAULT
        }
        view.storylyView.setStoryInteractiveTextTypeface(customTypeface)
    }

    @ReactProp(name = PROP_STORYLY_LAYOUT_DIRECTION)
    fun setPropStorylyLayoutDirection(view: STStorylyView, layoutDirection: String) {
        when (layoutDirection) {
            "ltr" -> view.storylyView.setStorylyLayoutDirection(StorylyLayoutDirection.LTR)
            "rtl" -> view.storylyView.setStorylyLayoutDirection(StorylyLayoutDirection.RTL)
            else -> view.storylyView.setStorylyLayoutDirection(StorylyLayoutDirection.LTR)
        }
    }

     private fun getTypeface(context: Context, fontName: String?): Typeface {
        fontName ?: return Typeface.DEFAULT
        return try {
            Typeface.createFromAsset(context.assets, fontName)
        } catch (_: Exception) {
            Typeface.DEFAULT
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
