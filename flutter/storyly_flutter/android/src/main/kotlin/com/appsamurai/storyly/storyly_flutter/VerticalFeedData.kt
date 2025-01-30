package com.appsamurai.storyly.storyly_flutter

import android.content.Context
import android.graphics.Color
import android.util.TypedValue
import com.appsamurai.storyly.StorylyLayoutDirection
import com.appsamurai.storyly.config.StorylyProductConfig
import com.appsamurai.storyly.config.StorylyShareConfig
import com.appsamurai.storyly.verticalfeed.StorylyVerticalFeedGroupOrder
import com.appsamurai.storyly.verticalfeed.StorylyVerticalFeedInit
import com.appsamurai.storyly.verticalfeed.VerticalFeedGroup
import com.appsamurai.storyly.verticalfeed.VerticalFeedItem
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemButtonComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemCommentComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemEmojiComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemPollComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemProductCardComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemProductCatalogComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemProductTagComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemPromoCodeComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemQuizComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemRatingComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemSwipeComponent
import com.appsamurai.storyly.verticalfeed.config.StorylyVerticalFeedConfig
import com.appsamurai.storyly.verticalfeed.config.bar.StorylyVerticalFeedBarStyling
import com.appsamurai.storyly.verticalfeed.config.customization.StorylyVerticalFeedCustomization
import com.appsamurai.storyly.verticalfeed.config.group.StorylyVerticalFeedGroupStyling
import java.util.Locale


internal class VerticalFeedInitMapper(
    private val context: Context,
) {

    fun getStorylyInit(
        json: HashMap<String, Any>
    ): StorylyVerticalFeedInit? {
        val storylyInitJson = json["storylyInit"] as? Map<String, *> ?: return null
        val storylyId = storylyInitJson["storylyId"] as? String ?: return null
        val storyGroupStylingJson = json["verticalFeedGroupStyling"] as? Map<String, *> ?: return null
        val storyBarStylingJson = json["verticalFeedBarStyling"] as? Map<String, *> ?: return null
        val storyStylingJson = json["verticalFeedCustomization"] as? Map<String, *> ?: return null
        val storyShareConfigJson = json["verticalFeedItemShareConfig"] as? Map<String, *> ?: return null
        val storyProductConfigJson = json["verticalFeedItemProductConfig"] as? Map<String, *> ?: return null

        var storylyConfigBuilder = StorylyVerticalFeedConfig.Builder()
        storylyConfigBuilder = stStorylyInit(json = storylyInitJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stStorylyGroupStyling(context = context, json = storyGroupStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stStoryBarStyling(json = storyBarStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stStoryStyling(context = context, json = storyStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stShareConfig(json = storyShareConfigJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stProductConfig(json = storyProductConfigJson, configBuilder = storylyConfigBuilder)


        return StorylyVerticalFeedInit(
            storylyId = storylyId,
            config = storylyConfigBuilder
                .build()
        )
    }

    private fun stStorylyInit(
        json: Map<String, *>,
        configBuilder: StorylyVerticalFeedConfig.Builder
    ): StorylyVerticalFeedConfig.Builder {
        return configBuilder
            .setLabels((json["storylySegments"] as? List<String>)?.toSet())
            .setCustomParameter(json["customParameter"] as? String)
            .setTestMode(json["storylyIsTestMode"] as? Boolean ?: false)
            .setUserData(json["userProperty"] as? Map<String, String> ?: emptyMap())
            .setLayoutDirection(getStorylyLayoutDirection(json["storylyLayoutDirection"] as? String))
            .setLocale(json["storylyLocale"] as? String)
    }

    private fun stStorylyGroupStyling(
        context: Context,
        json: Map<String, *>,
        configBuilder: StorylyVerticalFeedConfig.Builder,
    ): StorylyVerticalFeedConfig.Builder {
        var groupStylingBuilder = StorylyVerticalFeedGroupStyling.Builder()
        (json["iconBackgroundColor"] as? String)?.let { groupStylingBuilder = groupStylingBuilder.setIconBackgroundColor(
            Color.parseColor(it)) }
        (json["iconCornerRadius"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setIconCornerRadius(it) }
        (json["iconHeight"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setIconHeight(it) }
        (json["textColor"] as? String)?.let { groupStylingBuilder = groupStylingBuilder.setTextColor(
            Color.parseColor(it)) }
        groupStylingBuilder.setTypeface(getTypeface(context, json["titleFont"] as? String))
        (json["titleTextSize"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setTitleTextSize(Pair(
            TypedValue.COMPLEX_UNIT_PX, it)) }
        groupStylingBuilder = groupStylingBuilder.setTitleVisibility(json["titleVisible"] as? Boolean ?: true)
        getVerticalFeedGroupOrder(json["groupOrder"] as? String)?.let { groupStylingBuilder = groupStylingBuilder.setGroupOrder(it) }
        (json["typeIndicatorVisible"] as? Boolean)?.let { groupStylingBuilder = groupStylingBuilder.setTypeIndicatorVisibility(it) }
        (json["minLikeCountToShowIcon"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setMinLikeCountToShowIcon(it) }
        (json["minImpressionCountToShowIcon"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setMinImpressionCountToShowIcon(it) }
        getDrawable(context, json["impressionIcon"] as? String)?.let { groupStylingBuilder = groupStylingBuilder.setImpressionIcon(it) }
        getDrawable(context, json["likeIcon"] as? String)?.let { groupStylingBuilder = groupStylingBuilder.setLikeIcon(it) }

        return configBuilder
            .setVerticalFeedGroupStyling(
                styling = groupStylingBuilder
                    .build()
            )
    }

    private fun stStoryBarStyling(
        json: Map<String, *>,
        configBuilder: StorylyVerticalFeedConfig.Builder
    ): StorylyVerticalFeedConfig.Builder {
        var barStyling = StorylyVerticalFeedBarStyling.Builder()
        (json["sections"] as? Int)?.let { barStyling = barStyling.setSection(it) }
        (json["horizontalEdgePadding"] as? Int)?.let { barStyling = barStyling.setHorizontalEdgePadding(it) }
        (json["verticalEdgePadding"] as? Int)?.let { barStyling = barStyling.setVerticalEdgePadding(it) }
        (json["horizontalPaddingBetweenItems"] as? Int)?.let { barStyling = barStyling.setHorizontalPaddingBetweenItems(it) }
        (json["verticalPaddingBetweenItems"] as? Int)?.let { barStyling = barStyling.setVerticalPaddingBetweenItems(it) }
        return configBuilder
            .setVerticalFeedBarStyling(
                barStyling.build()
            )
    }

    private fun stStoryStyling(
        context: Context,
        json: Map<String, *>,
        configBuilder: StorylyVerticalFeedConfig.Builder
    ): StorylyVerticalFeedConfig.Builder {
        var customization = StorylyVerticalFeedCustomization.Builder()
        getTypefaceOrNull(context, json["titleFont"] as? String)?.let { customization.setTitleTypeface(it) }
        getTypefaceOrNull(context, json["interactiveFont"] as? String)?.let { customization.setInteractiveTypeface(it) }
        (json["progressBarColor"] as? List<String>?)?.let { customization = customization.setProgressBarColor(it.map { hexColor -> Color.parseColor(hexColor) }) }
        (json["isTitleVisible"] as? Boolean)?.let { customization = customization.setTitleVisibility(it) }
        (json["isLikeButtonVisible"] as? Boolean)?.let { customization = customization.setLikeButtonVisibility(it) }
        (json["isCloseButtonVisible"] as? Boolean)?.let { customization = customization.setCloseButtonVisibility(it) }
        getDrawable(context, json["closeButtonIcon"] as? String)?.let { customization = customization.setCloseButtonIcon(it) }
        getDrawable(context, json["likeButtonIcon"] as? String)?.let { customization = customization.setLikeButtonIcon(it) }
        getDrawable(context, json["shareButtonIcon"] as? String)?.let { customization = customization.setShareButtonIcon(it) }

        return configBuilder
            .setVerticalFeedStyling(
                customization
                    .build()
            )
    }

    private fun stShareConfig(
        json: Map<String, *>,
        configBuilder: StorylyVerticalFeedConfig.Builder
    ): StorylyVerticalFeedConfig.Builder {
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
        json: Map<String, *>,
        configBuilder: StorylyVerticalFeedConfig.Builder
    ): StorylyVerticalFeedConfig.Builder {
        var productConfigBuilder = StorylyProductConfig.Builder()
        (json["isFallbackEnabled"] as? Boolean)?.let { productConfigBuilder = productConfigBuilder.setFallbackAvailability(it) }
        (json["isCartEnabled"] as? Boolean)?.let { productConfigBuilder = productConfigBuilder.setCartAvailability(it) }
        (json["productFeed"] as? HashMap<String, ArrayList<HashMap<String, Any?>>?>)?.let { productFeed ->
            val feed = productFeed.mapValues { entry ->
                entry.value?.let { productList ->
                    productList.map { createSTRProductItem(it) }
                } ?: emptyList()
            }
            productConfigBuilder = productConfigBuilder.setProductFeed(feed)
        }

        return configBuilder
            .setProductConfig(
                productConfigBuilder
                    .build()
            )
    }

    private fun getVerticalFeedGroupOrder(order: String?): StorylyVerticalFeedGroupOrder? {
        return when (order) {
            "static" -> StorylyVerticalFeedGroupOrder.Static
            "bySeenState" -> StorylyVerticalFeedGroupOrder.BySeenState
            else -> null
        }
    }

    private fun getStorylyLayoutDirection(layoutDirection: String?): StorylyLayoutDirection {
        return when (layoutDirection) {
            "ltr" -> StorylyLayoutDirection.LTR
            "rtl" -> StorylyLayoutDirection.RTL
            else -> StorylyLayoutDirection.LTR
        }
    }
}

internal fun createStoryGroupMap(storyGroup: VerticalFeedGroup): Map<String, *> {
    return mapOf(
        "id" to storyGroup.uniqueId,
        "title" to storyGroup.title,
        "index" to storyGroup.index,
        "seen" to storyGroup.seen,
        "iconUrl" to storyGroup.iconUrl,
        "feedList" to storyGroup.feedList.map { story -> createStoryMap(story) },
        "pinned" to storyGroup.pinned,
        "type" to storyGroup.type.ordinal,
        "name" to storyGroup.name,
        "nudge" to storyGroup.nudge
    )
}

internal fun createStoryMap(story: VerticalFeedItem): Map<String, *> {
    return mapOf(
        "id" to story.uniqueId,
        "title" to story.title,
        "name" to story.name,
        "index" to story.index,
        "seen" to story.seen,
        "currentTime" to story.currentTime,
        "previewUrl" to story.previewUrl,
        "actionUrl" to story.actionUrl,
        "verticalFeedItemComponentList" to story.verticalFeedItemComponentList?.map { component -> createStoryComponentMap(component) },
        "actionProducts" to (story.actionProducts ?: listOf()).map { product -> createSTRProductItemMap(product) }
    )
}

internal fun createStoryComponentMap(storyComponent: VerticalFeedItemComponent): Map<String, *> {
    when (storyComponent) {
        is VerticalFeedItemButtonComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "text" to storyComponent.text,
                "actionUrl" to storyComponent.actionUrl,
                "products" to (storyComponent.products ?: listOf()).map { product -> createSTRProductItemMap(product) }
            )
        }

        is VerticalFeedItemSwipeComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "text" to storyComponent.text,
                "actionUrl" to storyComponent.actionUrl,
                "products" to (storyComponent.products ?: listOf()).map { product -> createSTRProductItemMap(product) }
            )
        }

        is VerticalFeedItemProductTagComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "actionUrl" to storyComponent.actionUrl,
                "products" to (storyComponent.products ?: listOf()).map { product -> createSTRProductItemMap(product) }
            )
        }

        is VerticalFeedItemProductCardComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "text" to storyComponent.text,
                "actionUrl" to storyComponent.actionUrl,
                "products" to (storyComponent.products ?: listOf()).map { product -> createSTRProductItemMap(product) }
            )
        }

        is VerticalFeedItemProductCatalogComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "actionUrlList" to (storyComponent.actionUrlList ?: listOf()),
                "products" to (storyComponent.products ?: listOf()).map { product -> createSTRProductItemMap(product) }
            )
        }

        is VerticalFeedItemQuizComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "title" to storyComponent.title,
                "options" to storyComponent.options,
                "rightAnswerIndex" to storyComponent.rightAnswerIndex,
                "selectedOptionIndex" to storyComponent.selectedOptionIndex,
            )
        }

        is VerticalFeedItemPollComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "title" to storyComponent.title,
                "options" to storyComponent.options,
                "selectedOptionIndex" to storyComponent.selectedOptionIndex,
            )
        }

        is VerticalFeedItemEmojiComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "emojiCodes" to storyComponent.emojiCodes,
                "selectedEmojiIndex" to storyComponent.selectedEmojiIndex,
            )
        }

        is VerticalFeedItemRatingComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "emojiCode" to storyComponent.emojiCode,
                "rating" to storyComponent.rating,
            )
        }

        is VerticalFeedItemPromoCodeComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "text" to storyComponent.text
            )
        }

        is VerticalFeedItemCommentComponent -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
                "text" to storyComponent.text
            )
        }

        else -> {
            return mapOf(
                "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                "id" to storyComponent.id,
                "customPayload" to storyComponent.customPayload,
            )
        }
    }
}
