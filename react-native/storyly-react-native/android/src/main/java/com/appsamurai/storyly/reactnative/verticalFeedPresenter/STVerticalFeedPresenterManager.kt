package com.appsamurai.storyly.reactnative.verticalFeedPresenter

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Resources
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.util.DisplayMetrics
import android.util.TypedValue
import androidx.core.content.ContextCompat
import com.appsamurai.storyly.StorylyLayoutDirection
import com.appsamurai.storyly.config.StorylyProductConfig
import com.appsamurai.storyly.config.StorylyShareConfig
import com.appsamurai.storyly.reactnative.createSTRCart
import com.appsamurai.storyly.reactnative.createSTRProductItem
import com.appsamurai.storyly.verticalfeed.StorylyVerticalFeedGroupOrder
import com.appsamurai.storyly.verticalfeed.StorylyVerticalFeedInit
import com.appsamurai.storyly.verticalfeed.StorylyVerticalFeedPresenterView
import com.appsamurai.storyly.verticalfeed.config.StorylyVerticalFeedConfig
import com.appsamurai.storyly.verticalfeed.config.bar.StorylyVerticalFeedBarStyling
import com.appsamurai.storyly.verticalfeed.config.customization.StorylyVerticalFeedCustomization
import com.appsamurai.storyly.verticalfeed.config.group.StorylyVerticalFeedGroupStyling
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.annotations.ReactProp

class STVerticalFeedPresenterManager : ViewGroupManager<STVerticalFeedPresenterView>() {
    companion object {
        private const val REACT_CLASS = "STVerticalFeedPresenter"

        private const val COMMAND_REFRESH_NAME = "refresh"
        private const val COMMAND_REFRESH_CODE = 1
        private const val COMMAND_HYDRATE_PRODUCT_NAME = "hydrateProducts"
        private const val COMMAND_HYDRATE_PRODUCT_CODE = 6
        private const val COMMAND_UPDATE_CART_NAME = "updateCart"
        private const val COMMAND_UPDATE_CART_CODE = 7
        private const val COMMAND_APPROVE_CART_CHANGE_NAME = "approveCartChange"
        private const val COMMAND_APPROVE_CART_CHANGE_CODE = 8
        private const val COMMAND_REJECT_CART_CHANGE_NAME = "rejectCartChange"
        private const val COMMAND_REJECT_CART_CHANGE_CODE = 9
        private const val COMMAND_PLAY_NAME = "play"
        private const val COMMAND_PLAY_CODE = 10
        private const val COMMAND_PAUSE_NAME = "pause"
        private const val COMMAND_PAUSE_CODE = 11
        private const val COMMAND_APPROVE_WISHLIST_CHANGE_NAME = "approveWishlistChange"
        private const val COMMAND_APPROVE_WISHLIST_CHANGE_CODE = 13
        private const val COMMAND_REJECT_WISHLIST_CHANGE_NAME = "rejectWishlistChange"
        private const val COMMAND_REJECT_WISHLIST_CHANGE_CODE = 14
        private const val COMMAND_HYDRATE_WISHLIST_NAME = "hydrateWishlist"
        private const val COMMAND_HYDRATE_WISHLIST_CODE = 15

        internal const val EVENT_STORYLY_LOADED = "onStorylyLoaded"
        internal const val EVENT_STORYLY_LOAD_FAILED = "onStorylyLoadFailed"
        internal const val EVENT_STORYLY_EVENT = "onStorylyEvent"
        internal const val EVENT_STORYLY_ACTION_CLICKED = "onStorylyActionClicked"
        internal const val EVENT_STORYLY_VERTICAL_FEED_PRESENTED = "onStorylyStoryPresented"
        internal const val EVENT_STORYLY_VERTICAL_FEED_PRESENT_FAILED = "onStorylyStoryPresentFailed"
        internal const val EVENT_STORYLY_VERTICAL_FEED_DISMISSED = "onStorylyStoryDismissed"
        internal const val EVENT_STORYLY_USER_INTERACTED = "onStorylyUserInteracted"

        internal const val EVENT_STORYLY_ON_HYDRATION = "onStorylyProductHydration"
        internal const val EVENT_STORYLY_ON_CART_UPDATED = "onStorylyCartUpdated"
        internal const val EVENT_STORYLY_ON_WISHLIST_UPDATED = "onStorylyWishlistUpdated"
        internal const val EVENT_STORYLY_PRODUCT_EVENT = "onStorylyProductEvent"

        internal const val EVENT_ON_CREATE_CUSTOM_VIEW = "onCreateCustomView"
        internal const val EVENT_ON_UPDATE_CUSTOM_VIEW = "onUpdateCustomView"
    }

    override fun getName(): String = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): STVerticalFeedPresenterView = STVerticalFeedPresenterView(reactContext)

    override fun removeViewAt(parent: STVerticalFeedPresenterView, index: Int) {}

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
        val builder = MapBuilder.builder<String, Any>()
        arrayOf(
            EVENT_STORYLY_LOADED,
            EVENT_STORYLY_LOAD_FAILED,
            EVENT_STORYLY_EVENT,
            EVENT_STORYLY_ACTION_CLICKED,
            EVENT_STORYLY_VERTICAL_FEED_PRESENTED,
            EVENT_STORYLY_VERTICAL_FEED_PRESENT_FAILED,
            EVENT_STORYLY_VERTICAL_FEED_DISMISSED,
            EVENT_STORYLY_USER_INTERACTED,
            EVENT_ON_CREATE_CUSTOM_VIEW,
            EVENT_ON_UPDATE_CUSTOM_VIEW,
            EVENT_STORYLY_ON_HYDRATION,
            EVENT_STORYLY_ON_CART_UPDATED,
            EVENT_STORYLY_ON_WISHLIST_UPDATED,
            EVENT_STORYLY_PRODUCT_EVENT
        ).forEach {
            builder.put(it, MapBuilder.of("registrationName", it))
        }
        return builder.build()
    }

    override fun getCommandsMap(): Map<String, Int> {
        return mapOf(
            COMMAND_REFRESH_NAME to COMMAND_REFRESH_CODE,
            COMMAND_HYDRATE_PRODUCT_NAME to COMMAND_HYDRATE_PRODUCT_CODE,
            COMMAND_HYDRATE_WISHLIST_NAME to COMMAND_HYDRATE_WISHLIST_CODE,
            COMMAND_UPDATE_CART_NAME to COMMAND_UPDATE_CART_CODE,
            COMMAND_APPROVE_CART_CHANGE_NAME to COMMAND_APPROVE_CART_CHANGE_CODE,
            COMMAND_REJECT_CART_CHANGE_NAME to COMMAND_REJECT_CART_CHANGE_CODE,
            COMMAND_PLAY_NAME to COMMAND_PLAY_CODE,
            COMMAND_PAUSE_NAME to COMMAND_PAUSE_CODE,
            COMMAND_APPROVE_WISHLIST_CHANGE_NAME to COMMAND_APPROVE_WISHLIST_CHANGE_CODE,
            COMMAND_REJECT_WISHLIST_CHANGE_NAME to COMMAND_REJECT_WISHLIST_CHANGE_CODE,
        )
    }

    override fun receiveCommand(root: STVerticalFeedPresenterView, commandId: Int, args: ReadableArray?) {
        when (commandId) {
            COMMAND_REFRESH_CODE -> root.verticalFeedView?.refresh()

            COMMAND_HYDRATE_PRODUCT_CODE -> {
                (args?.getArray(0)?.toArrayList() as? List<Map<String, Any?>>)?.let {
                    val productItems = it.map { createSTRProductItem(it) }
                    root.verticalFeedView?.hydrateProducts(productItems)
                }
            }

            COMMAND_HYDRATE_WISHLIST_CODE -> {
                (args?.getArray(0)?.toArrayList() as? List<Map<String, Any?>>)?.let {
                    val productItems = it.map { createSTRProductItem(it) }
                    root.verticalFeedView?.hydrateWishlist(productItems)
                }
            }    

            COMMAND_UPDATE_CART_CODE -> {
                (args?.getMap(0)?.toHashMap() as? Map<String, Any?>)?.let {
                    val cart = createSTRCart(it)
                    root.verticalFeedView?.updateCart(cart)
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

            COMMAND_APPROVE_WISHLIST_CHANGE_CODE -> {
                val responseId: String = args?.getString(0) ?: return
                if (args.size() > 1) {
                    (args.getMap(1)?.toHashMap() as? Map<String, Any?>)?.let {
                        root.approveWishlistChange(responseId, createSTRProductItem(it))
                    } ?: run {
                        root.approveWishlistChange(responseId)
                    }
                } else {
                    root.approveWishlistChange(responseId)
                }
            }

            COMMAND_REJECT_WISHLIST_CHANGE_CODE -> {
                val responseId: String = args?.getString(0) ?: return
                val failMessage: String = if (args.size() > 1) args.getString(1) else ""
                root.rejectWishlistChange(responseId, failMessage)
            }

            COMMAND_PLAY_CODE -> root.verticalFeedView?.play()
            COMMAND_PAUSE_CODE -> root.verticalFeedView?.pause()
        }
    }

    @ReactProp(name = "storyly")
    fun setPropStoryly(view: STVerticalFeedPresenterView, storylyBundle: ReadableMap) {
        println("STR:STVerticalFeedManager:setPropStoryly:${storylyBundle}")
        val storylyInitJson = storylyBundle.getMap("storylyInit") ?: return
        val storylyId = storylyInitJson.getString("storylyId") ?: return
        val storyGroupStylingJson = storylyBundle.getMap("verticalFeedGroupStyling") ?: return
        val storyBarStylingJson = storylyBundle.getMap("verticalFeedBarStyling") ?: return
        val storyStylingJson = storylyBundle.getMap("verticalFeedCustomization") ?: return
        val storyShareConfig = storylyBundle.getMap("verticalFeedItemShareConfig") ?: return
        val storyProductConfig = storylyBundle.getMap("verticalFeedItemProductConfig") ?: return

        var storylyConfigBuilder = StorylyVerticalFeedConfig.Builder()
        storylyConfigBuilder = stVerticalFeedInit(json = storylyInitJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stVerticalFeedGroupStyling(context = view.context, json = storyGroupStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stVerticalFeedItemBarStyling(json = storyBarStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stVerticalFeedCustomization(context = view.context, json = storyStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stShareConfig(json = storyShareConfig, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stProductConfig(json = storyProductConfig, configBuilder = storylyConfigBuilder)
        
        val storylyConfig = storylyConfigBuilder.build()
        stFrameworkSet(storylyConfig)

        view.verticalFeedView = StorylyVerticalFeedPresenterView(view.activity).apply {
            storylyVerticalFeedInit = StorylyVerticalFeedInit(
                storylyId = storylyId,
                config = storylyConfig
            )
        }
    }

    @SuppressLint("RestrictedApi")
    private fun stFrameworkSet(config: StorylyVerticalFeedConfig) {
        config.setFramework("rn")
    }

    private fun stVerticalFeedInit(
        json: ReadableMap,
        configBuilder: StorylyVerticalFeedConfig.Builder
    ): StorylyVerticalFeedConfig.Builder {
        return configBuilder
            .setLabels(if (json.hasKey("storylySegments")) (json.getArray("storylySegments")?.toArrayList() as? ArrayList<String>)?.toSet() else null)
            .setCustomParameter(if (json.hasKey("customParameter")) json.getString("customParameter") else null)
            .setTestMode(if (json.hasKey("storylyIsTestMode")) json.getBoolean("storylyIsTestMode") else false)
            .setUserData(if (json.hasKey("userProperty")) json.getMap("userProperty")?.toHashMap() as? Map<String, String> ?: emptyMap() else emptyMap())
            .setLayoutDirection(getStorylyLayoutDirection(json.getString("storylyLayoutDirection")))
            .setLocale(if (json.hasKey("storylyLocale")) json.getString("storylyLocale") else null)
    }

    private fun stVerticalFeedGroupStyling(
        context: Context,
        json: ReadableMap,
        configBuilder: StorylyVerticalFeedConfig.Builder,
    ): StorylyVerticalFeedConfig.Builder {
        var groupStylingBuilder = StorylyVerticalFeedGroupStyling.Builder()
        if (json.hasKey("iconBackgroundColor")) groupStylingBuilder = groupStylingBuilder.setIconBackgroundColor(json.getInt("iconBackgroundColor"))
        if (json.hasKey("iconHeight")) groupStylingBuilder = groupStylingBuilder.setIconHeight(json.getInt("iconHeight"))
        if (json.hasKey("iconCornerRadius")) groupStylingBuilder = groupStylingBuilder.setIconCornerRadius(json.getInt("iconCornerRadius"))
        if (json.hasKey("titleTextSize")) groupStylingBuilder = groupStylingBuilder.setTitleTextSize(Pair(TypedValue.COMPLEX_UNIT_PX, json.getInt("titleTextSize")))
        if (json.hasKey("titleVisible")) groupStylingBuilder = groupStylingBuilder.setTitleVisibility(json.getBoolean("titleVisible"))
        if (json.hasKey("textTypeface")) groupStylingBuilder = groupStylingBuilder.setTypeface(getTypeface(context, json.getString("textTypeface")))
        if (json.hasKey("textColor")) groupStylingBuilder = groupStylingBuilder.setTextColor(json.getInt("textColor"))
        if (json.hasKey("typeIndicatorVisible")) groupStylingBuilder = groupStylingBuilder.setTypeIndicatorVisibility(json.getBoolean("typeIndicatorVisible"))
        if (json.hasKey("groupOrder")) groupStylingBuilder = groupStylingBuilder.setGroupOrder(getStorylyGroupOrder(json.getString("groupOrder")))
        if (json.hasKey("minLikeCountToShowIcon")) groupStylingBuilder = groupStylingBuilder.setMinLikeCountToShowIcon(json.getInt("minLikeCountToShowIcon"))
        if (json.hasKey("minImpressionCountToShowIcon")) groupStylingBuilder = groupStylingBuilder.setMinImpressionCountToShowIcon(json.getInt("minImpressionCountToShowIcon"))

        getDrawable(context, if (json.hasKey("impressionIcon")) json.getString("impressionIcon") else null)?.let {
            groupStylingBuilder = groupStylingBuilder.setImpressionIcon(it)
        }
        getDrawable(context, if (json.hasKey("likeIcon")) json.getString("likeIcon") else null)?.let {
            groupStylingBuilder = groupStylingBuilder.setLikeIcon(it)
        }

        return configBuilder
            .setVerticalFeedGroupStyling(
                styling = groupStylingBuilder
                    .build()
            )
    }

    private fun stVerticalFeedItemBarStyling(
        json: ReadableMap,
        configBuilder: StorylyVerticalFeedConfig.Builder
    ): StorylyVerticalFeedConfig.Builder {
        return configBuilder
            .setVerticalFeedBarStyling(
                StorylyVerticalFeedBarStyling.Builder()
                    .setSection(if (json.hasKey("sections")) json.getInt("sections") else 2)
                    .setHorizontalEdgePadding(if (json.hasKey("horizontalEdgePadding")) json.getInt("horizontalEdgePadding") else dpToPixel(4))
                    .setVerticalEdgePadding(if (json.hasKey("verticalEdgePadding")) json.getInt("verticalEdgePadding") else dpToPixel(4))
                    .setHorizontalPaddingBetweenItems(if (json.hasKey("horizontalPaddingBetweenItems")) json.getInt("horizontalPaddingBetweenItems") else dpToPixel(8))
                    .setVerticalPaddingBetweenItems(if (json.hasKey("verticalPaddingBetweenItems")) json.getInt("verticalPaddingBetweenItems") else dpToPixel(8))
                    .build()
            )
    }

    private fun stShareConfig(
        json: ReadableMap,
        configBuilder: StorylyVerticalFeedConfig.Builder
    ): StorylyVerticalFeedConfig.Builder {
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
        configBuilder: StorylyVerticalFeedConfig.Builder
    ): StorylyVerticalFeedConfig.Builder {
        var storyProductConfig = StorylyProductConfig.Builder()
        if (json.hasKey("isFallbackEnabled")) storyProductConfig = storyProductConfig.setFallbackAvailability(json.getBoolean("isFallbackEnabled"))
        if (json.hasKey("isCartEnabled")) storyProductConfig = storyProductConfig.setCartAvailability(json.getBoolean("isCartEnabled"))
        (json.getMap("productFeed")?.toHashMap() as? Map<String, List<Map<String, Any?>>?>)?.let { productFeed ->
            val feed = productFeed.mapValues { entry ->
                entry.value?.let { productList ->
                    productList.map { createSTRProductItem(it) }
                } ?: emptyList()
            }
            storyProductConfig = storyProductConfig.setProductFeed(feed)
        }
        return configBuilder
            .setProductConfig(
                storyProductConfig
                    .build()
            )
    }

    private fun stVerticalFeedCustomization(
        context: Context,
        json: ReadableMap,
        configBuilder: StorylyVerticalFeedConfig.Builder
    ): StorylyVerticalFeedConfig.Builder {
        var storyStylingBuilder = StorylyVerticalFeedCustomization.Builder()
        if (json.hasKey("titleFont")) storyStylingBuilder = storyStylingBuilder.setTitleTypeface(getTypeface(context, json.getString("titleFont")))
        if (json.hasKey("interactiveFont")) storyStylingBuilder = storyStylingBuilder.setInteractiveTypeface(getTypeface(context, json.getString("interactiveFont")))
        json.getArray("progressBarColor")?.let { storyStylingBuilder = storyStylingBuilder.setProgressBarColor(convertColorArray(it)) }
        if (json.hasKey("isTitleVisible")) storyStylingBuilder = storyStylingBuilder.setTitleVisibility(json.getBoolean("isTitleVisible"))
        if (json.hasKey("isProgressBarVisible")) storyStylingBuilder = storyStylingBuilder.setTitleVisibility(json.getBoolean("isProgressBarVisible"))
        if (json.hasKey("isCloseButtonVisible")) storyStylingBuilder = storyStylingBuilder.setCloseButtonVisibility(json.getBoolean("isCloseButtonVisible"))
        if (json.hasKey("isLikeButtonVisible")) storyStylingBuilder = storyStylingBuilder.setLikeButtonVisibility(json.getBoolean("isLikeButtonVisible"))
        if (json.hasKey("isShareButtonVisible")) storyStylingBuilder = storyStylingBuilder.setShareButtonVisibility(json.getBoolean("isShareButtonVisible"))

        storyStylingBuilder = storyStylingBuilder.setCloseButtonIcon(getDrawable(context, if (json.hasKey("closeButtonIcon")) json.getString("closeButtonIcon") else null))
        storyStylingBuilder = storyStylingBuilder.setShareButtonIcon(getDrawable(context, if (json.hasKey("shareButtonIcon")) json.getString("shareButtonIcon") else null))
        storyStylingBuilder = storyStylingBuilder.setShareButtonIcon(getDrawable(context, if (json.hasKey("likeButtonIcon")) json.getString("likeButtonIcon") else null))

        return configBuilder
            .setVerticalFeedStyling(
                storyStylingBuilder
                    .build()
            )
    }

    private fun getStorylyLayoutDirection(layoutDirection: String?): StorylyLayoutDirection {
        return when (layoutDirection) {
            "ltr" -> StorylyLayoutDirection.LTR
            "rtl" -> StorylyLayoutDirection.RTL
            else -> StorylyLayoutDirection.LTR
        }
    }

    private fun getStorylyGroupOrder(groupOrder: String?): StorylyVerticalFeedGroupOrder {
        return when (groupOrder) {
            "bySeenState" -> StorylyVerticalFeedGroupOrder.BySeenState
            else -> StorylyVerticalFeedGroupOrder.Static
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
