package com.appsamurai.storyly.reactnative.verticalFeedBar

import com.appsamurai.storyly.reactnative.createSTRProductItemMap
import com.appsamurai.storyly.reactnative.toHexString
import com.appsamurai.storyly.verticalfeed.VerticalFeedGroup
import com.appsamurai.storyly.verticalfeed.VerticalFeedItem
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemCommentComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemComponentType
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemEmojiComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemPollComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemPromoCodeComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemQuizComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemRatingComponent
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap


internal fun createVerticalFeedGroup(verticalFeedGroup: VerticalFeedGroup): WritableMap {
    return Arguments.createMap().also { storyGroupMap ->
        storyGroupMap.putString("id", verticalFeedGroup.uniqueId)
        storyGroupMap.putString("title", verticalFeedGroup.title)
        storyGroupMap.putString("iconUrl", verticalFeedGroup.iconUrl)
        storyGroupMap.putBoolean("pinned", verticalFeedGroup.pinned)
        storyGroupMap.putInt("index", verticalFeedGroup.index)
        storyGroupMap.putBoolean("seen", verticalFeedGroup.seen)
        storyGroupMap.putArray("feedList", Arguments.createArray().also { storiesArray ->
            verticalFeedGroup.feedList.forEach { story -> storiesArray.pushMap(
                createVerticalFeedItem(story)
            ) }
        })
        storyGroupMap.putString("type", verticalFeedGroup.type.customName)
        storyGroupMap.putString("name", verticalFeedGroup.name)
        storyGroupMap.putBoolean("nudge", verticalFeedGroup.nudge)
        storyGroupMap.putMap("style", verticalFeedGroup.style?.let {
            Arguments.createMap().apply {
                putArray("borderUnseenColors", it.borderUnseenColors?.let { borderUnseenColors ->
                    Arguments.createArray().also { colorMap ->
                        borderUnseenColors.forEach { colorMap.pushString(it.toHexString()) }
                    }
                })
                putString("textUnseenColor", it.textUnseenColor?.toHexString())
                putMap("badge",  it.badge?.let { badge ->
                    Arguments.createMap().apply {
                        putString("backgroundColor", badge.backgroundColor?.toHexString())
                        putString("textColor", badge.textColor?.toHexString())
                        badge.endTime?.toInt()?.let { endTime -> putInt("endTime", endTime) }
                        putString("template", badge.template)
                        putString("text", badge.text)
                    }

                })
            }
        })
    }
}

internal fun createVerticalFeedItem(feedItem: VerticalFeedItem): WritableMap {
    return Arguments.createMap().also { storyMap ->
        storyMap.putString("id", feedItem.uniqueId)
        storyMap.putInt("index", feedItem.index)
        storyMap.putString("title", feedItem.title)
        storyMap.putString("name", feedItem.name)
        storyMap.putBoolean("seen", feedItem.seen)
        feedItem.currentTime?.toInt()?.let { storyMap.putInt("currentTime", it) }
        storyMap.putString("actionUrl", feedItem.actionUrl)
        storyMap.putString("previewUrl", feedItem.previewUrl)
        storyMap.putArray("verticalFeedItemComponentList", Arguments.createArray().also { componentArray ->
            feedItem.verticalFeedItemComponentList?.forEach { componentArray.pushMap(
                createVerticalFeedComponentMap(it)
            ) }
        })
        storyMap.putArray("actionProducts", feedItem.actionProducts?.let {
            Arguments.createArray().also { storiesArray ->
                it.forEach { item -> storiesArray.pushMap(createSTRProductItemMap(item)) }
            }
        })
    }
}

internal fun createVerticalFeedComponentMap(verticalFeedComponent: VerticalFeedItemComponent): WritableMap {
    return Arguments.createMap().also { storyComponentMap ->
        when (verticalFeedComponent.type) {
            VerticalFeedItemComponentType.Quiz -> {
                val quizComponent = verticalFeedComponent as VerticalFeedItemQuizComponent
                storyComponentMap.putString("type", "quiz")
                storyComponentMap.putString("id", quizComponent.id)
                storyComponentMap.putString("title", quizComponent.title)
                storyComponentMap.putArray("options", Arguments.createArray().also { optionsArray ->
                    quizComponent.options.forEach { option ->
                        optionsArray.pushString(option)
                    }
                })
                quizComponent.rightAnswerIndex?.let {
                    storyComponentMap.putInt("rightAnswerIndex", it)
                } ?: run {
                    storyComponentMap.putNull("rightAnswerIndex")
                }
                storyComponentMap.putInt("selectedOptionIndex", quizComponent.selectedOptionIndex)
                storyComponentMap.putString("customPayload", quizComponent.customPayload)
            }

            VerticalFeedItemComponentType.Poll -> {
                val pollComponent = verticalFeedComponent as VerticalFeedItemPollComponent
                storyComponentMap.putString("type", "poll")
                storyComponentMap.putString("id", pollComponent.id)
                storyComponentMap.putString("title", pollComponent.title)
                storyComponentMap.putArray("options", Arguments.createArray().also { optionsArray ->
                    pollComponent.options.forEach { option ->
                        optionsArray.pushString(option)
                    }
                })
                storyComponentMap.putInt("selectedOptionIndex", pollComponent.selectedOptionIndex)
                storyComponentMap.putString("customPayload", pollComponent.customPayload)
            }

            VerticalFeedItemComponentType.Emoji -> {
                val emojiComponent = verticalFeedComponent as VerticalFeedItemEmojiComponent
                storyComponentMap.putString("type", "emoji")
                storyComponentMap.putString("id", emojiComponent.id)
                storyComponentMap.putArray(
                    "emojiCodes",
                    Arguments.createArray().also { emojiCodesArray ->
                        emojiComponent.emojiCodes.forEach { emojiCode ->
                            emojiCodesArray.pushString(emojiCode)
                        }
                    })
                storyComponentMap.putInt("selectedEmojiIndex", emojiComponent.selectedEmojiIndex)
                storyComponentMap.putString("customPayload", emojiComponent.customPayload)

            }

            VerticalFeedItemComponentType.Rating -> {
                val ratingComponent = verticalFeedComponent as VerticalFeedItemRatingComponent
                storyComponentMap.putString("type", "rating")
                storyComponentMap.putString("id", ratingComponent.id)
                storyComponentMap.putString("emojiCode", ratingComponent.emojiCode)
                storyComponentMap.putInt("rating", ratingComponent.rating)
                storyComponentMap.putString("customPayload", ratingComponent.customPayload)
            }

            VerticalFeedItemComponentType.PromoCode -> {
                val promoCodeComponent = verticalFeedComponent as VerticalFeedItemPromoCodeComponent
                storyComponentMap.putString("type", "promocode")
                storyComponentMap.putString("id", promoCodeComponent.id)
                storyComponentMap.putString("text", promoCodeComponent.text)
            }

            VerticalFeedItemComponentType.Comment -> {
                val commentComponent = verticalFeedComponent as VerticalFeedItemCommentComponent
                storyComponentMap.putString("type", "comment")
                storyComponentMap.putString("id", commentComponent.id)
                storyComponentMap.putString("text", commentComponent.text)
            }

            else -> {
                storyComponentMap.putString("id", verticalFeedComponent.id)
                storyComponentMap.putString("type", verticalFeedComponent.type.name.lowercase())
            }
        }
    }
}