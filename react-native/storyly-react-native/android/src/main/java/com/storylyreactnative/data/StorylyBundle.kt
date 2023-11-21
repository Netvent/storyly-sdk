package com.storylyreactnative.data

import android.app.Activity
import android.content.Context
import android.content.res.Resources
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.util.DisplayMetrics
import android.util.TypedValue
import androidx.core.content.ContextCompat
import com.appsamurai.storyly.StoryGroupAnimation
import com.appsamurai.storyly.StoryGroupListOrientation
import com.appsamurai.storyly.StoryGroupSize
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.StorylyLayoutDirection
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storyly.config.StorylyConfig
import com.appsamurai.storyly.config.StorylyProductConfig
import com.appsamurai.storyly.config.StorylyShareConfig
import com.appsamurai.storyly.config.styling.bar.StorylyBarStyling
import com.appsamurai.storyly.config.styling.group.StorylyStoryGroupStyling
import com.appsamurai.storyly.config.styling.story.StorylyStoryStyling

internal data class STStorylyBundle (
    val storylyView: StorylyView,
)

internal fun createStorylyBundle(context: Activity, storylyBundle: Map<String, Any?>): STStorylyBundle? {
    println("STR:STStorylyManager:setPropStoryly:${storylyBundle}")
    val storylyInitJson = storylyBundle["storylyInit"] as? Map<String, Any?> ?: return null
    val storylyId = storylyInitJson["storylyId"] as? String ?: return null
    val storyGroupStylingJson = storylyBundle["storyGroupStyling"] as? Map<String, Any?> ?: return null
    val storyBarStylingJson = storylyBundle["storyBarStyling"] as? Map<String, Any?> ?: return null
    val storyStylingJson = storylyBundle["storyStyling"] as? Map<String, Any?> ?: return null
    val storyShareConfig = storylyBundle["storyShareConfig"] as? Map<String, Any?> ?: return null
    val storyProductConfig = storylyBundle["storyProductConfig"] as? Map<String, Any?> ?: return null

    var storylyConfigBuilder = StorylyConfig.Builder()
    storylyConfigBuilder = stStorylyInit(json = storylyInitJson, configBuilder = storylyConfigBuilder)
    storylyConfigBuilder = stStorylyGroupStyling(context = context, json = storyGroupStylingJson, configBuilder = storylyConfigBuilder)
    storylyConfigBuilder = stStoryBarStyling(json = storyBarStylingJson, configBuilder = storylyConfigBuilder)
    storylyConfigBuilder = stStoryStyling(context = context, json = storyStylingJson, configBuilder = storylyConfigBuilder)
    storylyConfigBuilder = stShareConfig(json = storyShareConfig, configBuilder = storylyConfigBuilder)
    storylyConfigBuilder = stProductConfig(json = storyProductConfig, configBuilder = storylyConfigBuilder)
    storylyConfigBuilder = storylyConfigBuilder.setLayoutDirection(getStorylyLayoutDirection(storylyBundle["storylyLayoutDirection"] as? String))

    return  STStorylyBundle(
        StorylyView(context).apply {
            storylyInit = StorylyInit(
                storylyId = storylyId,
                config = storylyConfigBuilder
                    .build()
            )
        },
    )
}

private fun stStorylyInit(
    json: Map<String, Any?>,
    configBuilder: StorylyConfig.Builder
): StorylyConfig.Builder {
    return configBuilder
        .setLabels(((json["storylySegments"] as? List<String>)?.toSet()))
        .setCustomParameter(json["customParameter"] as? String)
        .setTestMode(json["storylyIsTestMode"] as? Boolean ?: false)
        .setStorylyPayload(json["storylyPayload"] as? String)
        .setUserData(json["userProperty"] as? Map<String, String> ?: emptyMap())
}

private fun stStorylyGroupStyling(
    context: Context,
    json: Map<String, Any?>,
    configBuilder: StorylyConfig.Builder,
): StorylyConfig.Builder {
    var groupStylingBuilder = StorylyStoryGroupStyling.Builder()
    (json["iconBorderColorSeen"] as? List<Int>)?.let { groupStylingBuilder = groupStylingBuilder.setIconBorderColorSeen(it) }
    (json["iconBorderColorNotSeen"] as? List<Int>)?.let { groupStylingBuilder = groupStylingBuilder.setIconBorderColorNotSeen(it) }
    (json["iconBackgroundColor"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setIconBackgroundColor(it) }
    (json["pinIconColor"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setPinIconColor(it) }
    groupStylingBuilder = (json["iconHeight"] as? Int)?.let { groupStylingBuilder.setIconHeight(it) } ?: groupStylingBuilder.setIconHeight(
        dpToPixel(80)
    )
    groupStylingBuilder = (json["iconWidth"] as? Int)?.let { groupStylingBuilder.setIconWidth(it) } ?: groupStylingBuilder.setIconWidth(
        dpToPixel(80)
    )
    groupStylingBuilder = (json["iconCornerRadius"] as? Int)?.let { groupStylingBuilder.setIconCornerRadius(it) } ?: groupStylingBuilder.setIconCornerRadius(
        dpToPixel(40)
    )
    groupStylingBuilder = groupStylingBuilder.setIconBorderAnimation(getStoryGroupAnimation(json["iconBorderAnimation"] as? String))
    (json["titleSeenColor"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setTitleSeenColor(it) }
    (json["titleNotSeenColor"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setTitleNotSeenColor(it) }
    (json["titleLineCount"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setTitleLineCount(it) }
    (json["titleFont"] as? String)?.let { groupStylingBuilder = groupStylingBuilder.setTitleTypeface(
        getTypeface(context, it)
    ) }
    (json["titleTextSize"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setTitleTextSize(Pair(TypedValue.COMPLEX_UNIT_PX, it)) }
    (json["titleVisible"] as? Boolean)?.let { groupStylingBuilder = groupStylingBuilder.setTitleVisibility(it) }
    groupStylingBuilder = groupStylingBuilder.setSize(getStoryGroupSize(json["groupSize"] as? String))

    return configBuilder
        .setStoryGroupStyling(
            styling = groupStylingBuilder
                .build()
        )
}

private fun stStoryBarStyling(
    json: Map<String, Any?>,
    configBuilder: StorylyConfig.Builder
): StorylyConfig.Builder {
    return configBuilder
        .setBarStyling(
            StorylyBarStyling.Builder()
                .setOrientation(getStoryGroupListOrientation(json["orientation"] as? String))
                .setSection(json["sections"] as? Int ?: 1)
                .setHorizontalEdgePadding(json["horizontalEdgePadding"] as? Int ?: dpToPixel(4))
                .setVerticalEdgePadding(json["verticalEdgePadding"] as? Int ?: dpToPixel(4))
                .setHorizontalPaddingBetweenItems(json["horizontalPaddingBetweenItems"] as? Int ?: dpToPixel(8))
                .setVerticalPaddingBetweenItems(json["verticalPaddingBetweenItems"] as? Int ?: dpToPixel(8))
                .build()
        )
}

private fun stShareConfig(
    json: Map<String, Any?>,
    configBuilder: StorylyConfig.Builder
): StorylyConfig.Builder {
    var shareConfigBuilder = StorylyShareConfig.Builder()
    (json["storylyShareUrl"] as? String)?.let { shareConfigBuilder = shareConfigBuilder.setShareUrl(it) }
    (json["storylyFacebookAppID"] as? String)?.let { shareConfigBuilder = shareConfigBuilder.setFacebookAppID(it) }
    return configBuilder
        .setShareConfig(
            shareConfigBuilder
                .build()
        )
}

private fun stProductConfig(
    json: Map<String, Any?>,
    configBuilder: StorylyConfig.Builder
): StorylyConfig.Builder {
    var storyProductConfig = StorylyProductConfig.Builder()
    (json["isFallbackEnabled"] as? Boolean)?.let { storyProductConfig = storyProductConfig.setFallbackAvailability(it) }
    (json["isCartEnabled"] as? Boolean)?.let { storyProductConfig = storyProductConfig.setCartAvailability(it) }
    (json["productCountry"] as? String)?.let  { storyProductConfig = storyProductConfig.setProductFeedCountry(it) }
    (json["productLanguage"] as? String)?.let  { storyProductConfig = storyProductConfig.setProductFeedLanguage(it) }

    return configBuilder
        .setProductConfig(
            storyProductConfig
                .build()
        )
}

private fun stStoryStyling(
    context: Context,
    json: Map<String, Any?>,
    configBuilder: StorylyConfig.Builder
): StorylyConfig.Builder {
    var storyStylingBuilder = StorylyStoryStyling.Builder()
    (json["headerIconBorderColor"] as? List<Int>)?.let { storyStylingBuilder = storyStylingBuilder.setHeaderIconBorderColor(it) }
    (json["titleColor"] as? Int)?.let { storyStylingBuilder = storyStylingBuilder.setTitleColor(it) }
    (json["titleFont"] as? String)?.let { storyStylingBuilder = storyStylingBuilder.setTitleTypeface(
        getTypeface(context, it)
    ) }
    (json["interactiveFont"] as? String)?.let { storyStylingBuilder = storyStylingBuilder.setInteractiveTypeface(
        getTypeface(context, it)
    ) }
    (json["progressBarColor"] as? List<Int>)?.let { storyStylingBuilder = storyStylingBuilder.setProgressBarColor(it) }
    (json["isTitleVisible"] as? Boolean)?.let { storyStylingBuilder = storyStylingBuilder.setTitleVisibility(it) }
    (json["isHeaderIconVisible"] as? Boolean)?.let { storyStylingBuilder = storyStylingBuilder.setHeaderIconVisibility(it) }
    (json["isCloseButtonVisible"] as? Boolean)?.let { storyStylingBuilder = storyStylingBuilder.setCloseButtonVisibility(it) }
    storyStylingBuilder = storyStylingBuilder.setCloseButtonIcon(getDrawable(context, json["closeButtonIcon"] as? String))
    storyStylingBuilder = storyStylingBuilder.setShareButtonIcon(getDrawable(context, json["shareButtonIcon"] as? String))

    return configBuilder
        .setStoryStyling(
            storyStylingBuilder
                .build()
        )
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
