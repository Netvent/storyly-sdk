package com.appsamurai.storyly.reactnative

import android.content.Context
import android.content.res.Resources
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.net.Uri
import android.util.DisplayMetrics
import android.util.TypedValue
import android.view.View
import androidx.core.content.ContextCompat
import com.appsamurai.storyly.*
import com.appsamurai.storyly.config.StorylyConfig
import com.appsamurai.storyly.config.StorylyProductConfig
import com.appsamurai.storyly.config.StorylyShareConfig
import com.appsamurai.storyly.config.styling.bar.StorylyBarStyling
import com.appsamurai.storyly.config.styling.group.StorylyStoryGroupStyling
import com.appsamurai.storyly.config.styling.story.StorylyStoryStyling
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
        private const val COMMAND_OPEN_STORY_WITH_ID_NAME = "openStoryWithId"
        private const val COMMAND_OPEN_STORY_WITH_ID_CODE = 5
        private const val COMMAND_HYDRATE_PRODUCT_NAME = "hydrateProducts"
        private const val COMMAND_HYDRATE_PRODUCT_CODE = 6
        private const val COMMAND_UPDATE_CART_NAME = "updateCart"
        private const val COMMAND_UPDATE_CART_CODE = 7
        private const val COMMAND_APPROVE_CART_CHANGE_NAME = "approveCartChange"
        private const val COMMAND_APPROVE_CART_CHANGE_CODE = 8
        private const val COMMAND_REJECT_CART_CHANGE_NAME = "rejectCartChange"
        private const val COMMAND_REJECT_CART_CHANGE_CODE = 9
        private const val COMMAND_RESUME_STORY_NAME = "resumeStory"
        private const val COMMAND_RESUME_STORY_CODE = 10
        private const val COMMAND_PAUSE_STORY_NAME = "pauseStory"
        private const val COMMAND_PAUSE_STORY_CODE = 11
        private const val COMMAND_CLOSE_STORY_NAME = "closeStory"
        private const val COMMAND_CLOSE_STORY_CODE = 12


        internal const val EVENT_STORYLY_LOADED = "onStorylyLoaded"
        internal const val EVENT_STORYLY_LOAD_FAILED = "onStorylyLoadFailed"
        internal const val EVENT_STORYLY_EVENT = "onStorylyEvent"
        internal const val EVENT_STORYLY_ACTION_CLICKED = "onStorylyActionClicked"
        internal const val EVENT_STORYLY_STORY_PRESENTED = "onStorylyStoryPresented"
        internal const val EVENT_STORYLY_STORY_PRESENT_FAILED = "onStorylyStoryPresentFailed"
        internal const val EVENT_STORYLY_STORY_DISMISSED = "onStorylyStoryDismissed"
        internal const val EVENT_STORYLY_USER_INTERACTED = "onStorylyUserInteracted"

        internal const val EVENT_STORYLY_ON_HYDRATION = "onStorylyProductHydration"
        internal const val EVENT_STORYLY_ON_CART_UPDATED = "onStorylyCartUpdated"
        internal const val EVENT_STORYLY_PRODUCT_EVENT = "onStorylyProductEvent"

        internal const val EVENT_ON_CREATE_CUSTOM_VIEW = "onCreateCustomView"
        internal const val EVENT_ON_UPDATE_CUSTOM_VIEW = "onUpdateCustomView"
    }

    override fun getName(): String = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): STStorylyView = STStorylyView(reactContext)

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
            EVENT_STORYLY_ON_HYDRATION,
            EVENT_STORYLY_ON_CART_UPDATED,
            EVENT_STORYLY_PRODUCT_EVENT
        ).forEach {
            builder.put(it, MapBuilder.of("registrationName", it))
        }
        return builder.build()
    }

    override fun getCommandsMap(): Map<String, Int> {
        return mapOf(
            COMMAND_REFRESH_NAME to COMMAND_REFRESH_CODE,
            COMMAND_OPEN_NAME to COMMAND_OPEN_CODE,
            COMMAND_CLOSE_NAME to COMMAND_CLOSE_CODE,
            COMMAND_OPEN_STORY_NAME to COMMAND_OPEN_STORY_CODE,
            COMMAND_OPEN_STORY_WITH_ID_NAME to COMMAND_OPEN_STORY_WITH_ID_CODE,
            COMMAND_HYDRATE_PRODUCT_NAME to COMMAND_HYDRATE_PRODUCT_CODE,
            COMMAND_UPDATE_CART_NAME to COMMAND_UPDATE_CART_CODE,
            COMMAND_APPROVE_CART_CHANGE_NAME to COMMAND_APPROVE_CART_CHANGE_CODE,
            COMMAND_REJECT_CART_CHANGE_NAME to COMMAND_REJECT_CART_CHANGE_CODE,
            COMMAND_RESUME_STORY_NAME to COMMAND_RESUME_STORY_CODE,
            COMMAND_PAUSE_STORY_NAME to COMMAND_PAUSE_STORY_CODE,
            COMMAND_CLOSE_STORY_NAME to COMMAND_CLOSE_STORY_CODE
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
            COMMAND_HYDRATE_PRODUCT_CODE -> {
                (args?.getArray(0)?.toArrayList() as? List<Map<String, Any?>>)?.let {
                    val productItems = it.map { createSTRProductItem(it) }
                    root.storylyView?.hydrateProducts(productItems)
                }
            }
            COMMAND_UPDATE_CART_CODE -> {
                (args?.getMap(0)?.toHashMap() as? Map<String, Any?>)?.let {
                    val cart = createSTRCart(it)
                    root.storylyView?.updateCart(cart)
                }
            }
            COMMAND_APPROVE_CART_CHANGE_CODE -> {
                val responseId: String = args?.getString(0) ?: return
                if (args.size() > 1) {
                    (args.getMap(1)?.toHashMap() as? Map<String, Any?>)?.let {
                         root.approveCartChange(responseId, createSTRCart(it))
                    } ?: run {
                        root.approveCartChange(responseId)
                    }
                } else {
                    root.approveCartChange(responseId)
                }
            }
            COMMAND_REJECT_CART_CHANGE_CODE -> {
                val responseId: String = args?.getString(0) ?: return
                val failMessage: String = if (args.size() > 1) args.getString(1) else ""
                root.rejectCartChange(responseId, failMessage)
            }
            COMMAND_OPEN_STORY_WITH_ID_CODE -> {
                val storyGroupId: String = args?.getString(0) ?: return
                val storyId: String? = if (args.size() > 1) args.getString(1) else null

                root.storylyView?.openStory(storyGroupId, storyId)
            }
            COMMAND_RESUME_STORY_CODE -> root.storylyView?.resumeStory()
            COMMAND_PAUSE_STORY_CODE -> root.storylyView?.pauseStory()
            COMMAND_CLOSE_STORY_CODE -> root.storylyView?.closeStory()
        }
    }

    @ReactProp(name = "storyly")
    fun setPropStoryly(view: STStorylyView, storylyBundle: ReadableMap) {
        println("STR:STStorylyManager:setPropStoryly:${storylyBundle}")
        val storylyInitJson = storylyBundle.getMap("storylyInit") ?: return
        val storylyId = storylyInitJson.getString("storylyId") ?: return
        val storyGroupStylingJson = storylyBundle.getMap("storyGroupStyling") ?: return
        val storyGroupViewFactoryJson = storylyBundle.getMap("storyGroupViewFactory") ?: return
        val storyBarStylingJson = storylyBundle.getMap("storyBarStyling") ?: return
        val storyStylingJson = storylyBundle.getMap("storyStyling") ?: return
        val storyShareConfig = storylyBundle.getMap("storyShareConfig") ?: return
        val storyProductConfig = storylyBundle.getMap("storyProductConfig") ?: return

        val storyGroupViewFactory = getStoryGroupViewFactory(view.context, storyGroupViewFactoryJson).also { it?.onSendEvent = view::sendEvent }
        var storylyConfigBuilder = StorylyConfig.Builder()
        storylyConfigBuilder = stStorylyInit(json = storylyInitJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stStorylyGroupStyling(context = view.context, json = storyGroupStylingJson, groupViewFactory = storyGroupViewFactory, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stStoryBarStyling(json = storyBarStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stStoryStyling(context = view.context, json = storyStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stShareConfig(json = storyShareConfig, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stProductConfig(json = storyProductConfig, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = storylyConfigBuilder.setLayoutDirection(getStorylyLayoutDirection(storylyBundle.getString("storylyLayoutDirection")))

        view.storylyView = StorylyView(view.activity).apply {
            storylyInit = StorylyInit(
                storylyId = storylyId,
                config = storylyConfigBuilder
                    .build()
            )
        }
        view.storyGroupViewFactory = storyGroupViewFactory
    }

    private fun stStorylyInit(
        json: ReadableMap,
        configBuilder: StorylyConfig.Builder
    ): StorylyConfig.Builder {
        return configBuilder
            .setLabels(if (json.hasKey("storylySegments")) (json.getArray("storylySegments")?.toArrayList() as? ArrayList<String>)?.toSet() else null)
            .setCustomParameter(if (json.hasKey("customParameter")) json.getString("customParameter") else null)
            .setTestMode(if (json.hasKey("storylyIsTestMode")) json.getBoolean("storylyIsTestMode") else false)
            .setStorylyPayload(if (json.hasKey("storylyPayload")) json.getString("storylyPayload") else null)
            .setUserData(if (json.hasKey("userProperty")) json.getMap("userProperty")?.toHashMap() as? Map<String, String> ?: emptyMap() else emptyMap())
    }

    private fun stStorylyGroupStyling(
        context: Context,
        json: ReadableMap,
        groupViewFactory: STStoryGroupViewFactory?,
        configBuilder: StorylyConfig.Builder,
    ): StorylyConfig.Builder {
        var groupStylingBuilder = StorylyStoryGroupStyling.Builder()
        json.getArray("iconBorderColorSeen")?.let { groupStylingBuilder = groupStylingBuilder.setIconBorderColorSeen(convertColorArray(it)) }
        json.getArray("iconBorderColorNotSeen")?.let { groupStylingBuilder = groupStylingBuilder.setIconBorderColorNotSeen(convertColorArray(it)) }
        if (json.hasKey("iconBackgroundColor")) groupStylingBuilder = groupStylingBuilder.setIconBackgroundColor(json.getInt("iconBackgroundColor"))
        if (json.hasKey("pinIconColor")) groupStylingBuilder = groupStylingBuilder.setPinIconColor(json.getInt("pinIconColor"))
        groupStylingBuilder = if (json.hasKey("iconHeight")) groupStylingBuilder.setIconHeight(json.getInt("iconHeight")) else groupStylingBuilder.setIconHeight(dpToPixel(80))
        groupStylingBuilder = if (json.hasKey("iconWidth")) groupStylingBuilder.setIconWidth(json.getInt("iconWidth")) else groupStylingBuilder.setIconWidth(dpToPixel(80))
        groupStylingBuilder = if (json.hasKey("iconCornerRadius")) groupStylingBuilder.setIconCornerRadius(json.getInt("iconCornerRadius")) else groupStylingBuilder.setIconCornerRadius(dpToPixel(40))
        groupStylingBuilder = groupStylingBuilder.setIconBorderAnimation(getStoryGroupAnimation(json.getString("iconBorderAnimation")))
        if (json.hasKey("titleSeenColor")) groupStylingBuilder = groupStylingBuilder.setTitleSeenColor(json.getInt("titleSeenColor"))
        if (json.hasKey("titleNotSeenColor")) groupStylingBuilder = groupStylingBuilder.setTitleNotSeenColor(json.getInt("titleNotSeenColor"))
        if (json.hasKey("titleLineCount")) groupStylingBuilder = groupStylingBuilder.setTitleLineCount(json.getInt("titleLineCount"))
        if (json.hasKey("titleFont")) groupStylingBuilder = groupStylingBuilder.setTitleTypeface(getTypeface(context, json.getString("titleFont")))
        if (json.hasKey("titleTextSize")) groupStylingBuilder = groupStylingBuilder.setTitleTextSize(Pair(TypedValue.COMPLEX_UNIT_PX, json.getInt("titleTextSize")))
        if (json.hasKey("titleVisible")) groupStylingBuilder = groupStylingBuilder.setTitleVisibility(json.getBoolean("titleVisible"))
        groupStylingBuilder = groupStylingBuilder.setSize(getStoryGroupSize(json.getString("groupSize")))
        groupStylingBuilder = groupStylingBuilder.setCustomGroupViewFactory(groupViewFactory)

        return configBuilder
            .setStoryGroupStyling(
                styling = groupStylingBuilder
                    .build()
            )
    }

    private fun stStoryBarStyling(
        json: ReadableMap,
        configBuilder: StorylyConfig.Builder
    ): StorylyConfig.Builder {
        return configBuilder
            .setBarStyling(
                StorylyBarStyling.Builder()
                    .setOrientation(getStoryGroupListOrientation(if (json.hasKey("orientation")) json.getString("orientation") else null))
                    .setSection(if (json.hasKey("sections")) json.getInt("sections") else 1)
                    .setHorizontalEdgePadding(if (json.hasKey("horizontalEdgePadding")) json.getInt("horizontalEdgePadding") else dpToPixel(4))
                    .setVerticalEdgePadding(if (json.hasKey("verticalEdgePadding")) json.getInt("verticalEdgePadding") else dpToPixel(4))
                    .setHorizontalPaddingBetweenItems(if (json.hasKey("horizontalPaddingBetweenItems")) json.getInt("horizontalPaddingBetweenItems") else dpToPixel(8))
                    .setVerticalPaddingBetweenItems(if (json.hasKey("verticalPaddingBetweenItems")) json.getInt("verticalPaddingBetweenItems") else dpToPixel(8))
                    .build()
            )
    }

    private fun stShareConfig(
        json: ReadableMap,
        configBuilder: StorylyConfig.Builder
    ): StorylyConfig.Builder {
        var shareConfigBuilder = StorylyShareConfig.Builder()
        json.getString("storylyShareUrl")?.let { shareConfigBuilder = shareConfigBuilder.setShareUrl(it) }
        json.getString("storylyFacebookAppID")?.let { shareConfigBuilder = shareConfigBuilder.setFacebookAppID(it) }
        return configBuilder
            .setShareConfig(
                shareConfigBuilder
                    .build()
            )
    }

    private fun stProductConfig(
        json: ReadableMap,
        configBuilder: StorylyConfig.Builder
    ): StorylyConfig.Builder {
        var storyProductConfig = StorylyProductConfig.Builder()
        if (json.hasKey("isFallbackEnabled")) storyProductConfig = storyProductConfig.setFallbackAvailability(json.getBoolean("isFallbackEnabled"))
        if (json.hasKey("isCartEnabled")) storyProductConfig = storyProductConfig.setCartAvailability(json.getBoolean("isCartEnabled"))

        return configBuilder
            .setProductConfig(
                storyProductConfig
                    .build()
            )
    }

    private fun stStoryStyling(
        context: Context,
        json: ReadableMap,
        configBuilder: StorylyConfig.Builder
    ): StorylyConfig.Builder {
        var storyStylingBuilder = StorylyStoryStyling.Builder()
        json.getArray("headerIconBorderColor")?.let { storyStylingBuilder = storyStylingBuilder.setHeaderIconBorderColor(convertColorArray(it)) }
        if (json.hasKey("titleColor")) storyStylingBuilder = storyStylingBuilder.setTitleColor(json.getInt("titleColor"))
        if (json.hasKey("titleFont")) storyStylingBuilder = storyStylingBuilder.setTitleTypeface(getTypeface(context, json.getString("titleFont")))
        if (json.hasKey("interactiveFont")) storyStylingBuilder = storyStylingBuilder.setInteractiveTypeface(getTypeface(context, json.getString("interactiveFont")))
        json.getArray("progressBarColor")?.let { storyStylingBuilder = storyStylingBuilder.setProgressBarColor(convertColorArray(it)) }
        if (json.hasKey("isTitleVisible")) storyStylingBuilder = storyStylingBuilder.setTitleVisibility(json.getBoolean("isTitleVisible"))
        if (json.hasKey("isHeaderIconVisible")) storyStylingBuilder = storyStylingBuilder.setHeaderIconVisibility(json.getBoolean("isHeaderIconVisible"))
        if (json.hasKey("isCloseButtonVisible")) storyStylingBuilder = storyStylingBuilder.setCloseButtonVisibility(json.getBoolean("isCloseButtonVisible"))
        storyStylingBuilder = storyStylingBuilder.setCloseButtonIcon(getDrawable(context, if (json.hasKey("closeButtonIcon")) json.getString("closeButtonIcon") else null))
        storyStylingBuilder = storyStylingBuilder.setShareButtonIcon(getDrawable(context, if (json.hasKey("shareButtonIcon")) json.getString("shareButtonIcon") else null))

        return configBuilder
            .setStoryStyling(
                storyStylingBuilder
                    .build()
            )
    }

    private fun getStoryGroupViewFactory(
        context: Context,
        json: ReadableMap,
    ): STStoryGroupViewFactory? {
        val width = if (json.hasKey("width")) json.getInt("width") else return null
        val height = if (json.hasKey("height")) json.getInt("height") else return null
        if (width <= 0 || height <= 0) return null
        return STStoryGroupViewFactory(context, width, height)
    }

    private fun getStoryGroupSize(size: String?): StoryGroupSize {
        return when (size) {
            "small" -> StoryGroupSize.Small
            "custom" -> StoryGroupSize.Custom
            else -> StoryGroupSize.Large
        }
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

    private fun getStoryGroupListOrientation(orientation: String?): StoryGroupListOrientation {
        return when (orientation) {
            "horizontal" -> StoryGroupListOrientation.Horizontal
            "vertical" -> StoryGroupListOrientation.Vertical
            else -> StoryGroupListOrientation.Horizontal
        }
    }

    private fun convertColorArray(colors: ReadableArray): List<Int> {
        val colorsNative = arrayListOf<Int>()
        for (i in 0 until colors.size()) colorsNative.add(colors.getInt(i))
        return colorsNative
    }

    private fun dpToPixel(dpValue: Int): Int {
        return (dpValue * (Resources.getSystem().displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)).toInt()
    }

    private fun getTypeface(context: Context, fontName: String?): Typeface {
        fontName ?: return Typeface.DEFAULT
        return try {
            Typeface.createFromAsset(context.assets, fontName)
        } catch (_: Exception) {
            Typeface.DEFAULT
        }
    }

    private fun getDrawable(
        context: Context,
        name: String?
    ): Drawable? {
        name ?: return null
        val id = context.resources.getIdentifier(name, "drawable", context.packageName)
        return ContextCompat.getDrawable(context, id)
    }
}
