package com.appsamurai.storyly.storyly_placement_flutter.common.data.widgets

import com.appsamurai.storyly.core.STRWidgetType
import com.appsamurai.storyly.storybar.data.StoryBarDataPayload
import com.appsamurai.storyly.storybar.data.model.StoryBarPayload
import com.appsamurai.storyly.storybar.ui.model.Story
import com.appsamurai.storyly.storybar.ui.model.StoryBarComponent
import com.appsamurai.storyly.storybar.ui.model.StoryButtonComponent
import com.appsamurai.storyly.storybar.ui.model.StoryCommentComponent
import com.appsamurai.storyly.storybar.ui.model.StoryEmojiComponent
import com.appsamurai.storyly.storybar.ui.model.StoryGroup
import com.appsamurai.storyly.storybar.ui.model.StoryGroupBadgeStyle
import com.appsamurai.storyly.storybar.ui.model.StoryGroupStyle
import com.appsamurai.storyly.storybar.ui.model.StoryImageQuizComponent
import com.appsamurai.storyly.storybar.ui.model.StoryPollComponent
import com.appsamurai.storyly.storybar.ui.model.StoryProductCardComponent
import com.appsamurai.storyly.storybar.ui.model.StoryProductCatalogComponent
import com.appsamurai.storyly.storybar.ui.model.StoryProductTagComponent
import com.appsamurai.storyly.storybar.ui.model.StoryPromoCodeComponent
import com.appsamurai.storyly.storybar.ui.model.StoryQuizComponent
import com.appsamurai.storyly.storybar.ui.model.StoryRatingComponent
import com.appsamurai.storyly.storybar.ui.model.StorySwipeComponent
import com.appsamurai.storyly.storyly_placement_flutter.common.data.product.encodeSTRProductItem
import com.appsamurai.storyly.storyly_placement_flutter.common.data.util.toHexString


fun encodeStoryBarDataPayload(data: StoryBarDataPayload): Map<String, Any?> {
    return mapOf(
        "type" to STRWidgetType.StoryBar.raw,
        "items" to data.items.map { encodeStoryGroupItem(it) }
    )
}

fun encodeStoryBarPayload(payload: StoryBarPayload?): Map<String, Any?>? {
    payload ?: return null
    return mapOf(
        "component" to encodeStoryBarComponent(payload.component),
        "group" to encodeStoryGroupItem(payload.group),
        "story" to encodeStory(payload.story),
    )
}

fun encodeStoryGroupItem(group: StoryGroup?): Map<String, Any?>? {
    group ?: return null
    return mapOf(
        "id" to group.uniqueId,
        "title" to group.title,
        "name" to group.name,
        "index" to group.index,
        "seen" to group.seen,
        "iconUrl" to group.iconUrl,
        "pinned" to group.pinned,
        "type" to group.type.customName,
        "nudge" to group.nudge,
        "iconVideoUrl" to group.iconVideoUrl,
        "iconVideoThumbnailUrl" to group.iconVideoThumbnailUrl,
        "style" to encodeStoryGroupStyle(group.style),
        "stories" to group.stories.map { story -> encodeStory(story) }
    )
}

fun encodeStoryGroupStyle(style: StoryGroupStyle?): Map<String, Any?>? {
    style ?: return null
    return mapOf(
        "badge" to encodeStoryGroupBadgeStyle(style.badge),
        "borderUnseenColors" to style.borderUnseenColors?.map { it.toHexString() },
        "textUnseenColor" to style.textUnseenColor?.toHexString(),
    )
}

fun encodeStoryGroupBadgeStyle(badgeStyle: StoryGroupBadgeStyle?): Map<String, Any?>? {
    badgeStyle ?: return null
    return mapOf(
        "text" to badgeStyle.text,
        "textColor" to badgeStyle.textColor?.toHexString(),
        "backgroundColor" to badgeStyle.backgroundColor?.toHexString(),
        "endTime" to badgeStyle.endTime,
        "template" to badgeStyle.template,
    )
}

fun encodeStory(story: Story?): Map<String, Any?>? {
    story ?: return null
    return mapOf(
        "id" to story.uniqueId,
        "title" to story.title,
        "name" to story.name,
        "index" to story.index,
        "seen" to story.seen,
        "previewUrl" to story.previewUrl,
        "actionUrl" to story.actionUrl,
        "actionProducts" to story.actionProducts?.map { encodeSTRProductItem(it) },
        "currentTime" to story.currentTime,
        "storyComponentList" to story.storyComponentList?.map { encodeStoryBarComponent(it) }
    )
}

fun encodeStoryBarComponent(component: StoryBarComponent?): Map<String, Any?>? {
    component ?: return null
    val base = mapOf(
        "id" to component.id,
        "type" to component.type.get(),
        "customPayload" to component.customPayload,
    )
    
    val additional = when(component) {
        is StoryQuizComponent -> mapOf(
            "title" to component.title,
            "options" to component.options,
            "rightAnswerIndex" to component.rightAnswerIndex,
            "selectedOptionIndex" to component.selectedOptionIndex,
        )
        is StoryImageQuizComponent -> mapOf(
            "title" to component.title,
            "options" to component.options,
            "rightAnswerIndex" to component.rightAnswerIndex,
            "selectedOptionIndex" to component.selectedOptionIndex,
        )
        is StoryPollComponent -> mapOf(
            "title" to component.title,
            "options" to component.options,
            "selectedOptionIndex" to component.selectedOptionIndex,
        )
        is StoryEmojiComponent -> mapOf(
            "emojiCodes" to component.emojiCodes,
            "selectedEmojiIndex" to component.selectedEmojiIndex,
        )
        is StoryRatingComponent -> mapOf(
            "emojiCode" to component.emojiCode,
            "rating" to component.rating,
        )
        is StoryPromoCodeComponent -> mapOf(
            "text" to component.text,
        )
        is StoryCommentComponent -> mapOf(
            "text" to component.text,
        )
        is StorySwipeComponent -> mapOf(
            "text" to component.text,
            "actionUrl" to component.actionUrl,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        is StoryButtonComponent -> mapOf(
            "text" to component.text,
            "actionUrl" to component.actionUrl,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        is StoryProductTagComponent -> mapOf(
            "actionUrl" to component.actionUrl,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        is StoryProductCardComponent -> mapOf(
            "text" to component.text,
            "actionUrl" to component.actionUrl,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        is StoryProductCatalogComponent -> mapOf(
            "actionUrlList" to component.actionUrlList,
            "products" to component.products?.map { encodeSTRProductItem(it) },
        )
        else -> emptyMap()
    }
    
    return base + additional
}