package com.appsamurai.storyly.reactnative.verticalFeedBar

import com.appsamurai.storyly.StoryButtonComponent
import com.appsamurai.storyly.StoryCommentComponent
import com.appsamurai.storyly.StoryComponent
import com.appsamurai.storyly.StoryComponentType
import com.appsamurai.storyly.StoryEmojiComponent
import com.appsamurai.storyly.StoryPollComponent
import com.appsamurai.storyly.StoryProductCardComponent
import com.appsamurai.storyly.StoryProductCatalogComponent
import com.appsamurai.storyly.StoryProductTagComponent
import com.appsamurai.storyly.StoryPromoCodeComponent
import com.appsamurai.storyly.StoryQuizComponent
import com.appsamurai.storyly.StoryRatingComponent
import com.appsamurai.storyly.StorySwipeComponent
import com.appsamurai.storyly.reactnative.createSTRProductItemMap
import com.appsamurai.storyly.reactnative.toHexString
import com.appsamurai.storyly.verticalfeed.VerticalFeedGroup
import com.appsamurai.storyly.verticalfeed.VerticalFeedItem
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemButtonComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemCommentComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemComponentType
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemEmojiComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemPollComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemProductCardComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemProductCatalogComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemProductTagComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemPromoCodeComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemQuizComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemRatingComponent
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemSwipeComponent
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
            VerticalFeedItemComponentType.ButtonAction -> {
                val buttonComponent = verticalFeedComponent as VerticalFeedItemButtonComponent
                storyComponentMap.putString("type", "buttonaction")
                storyComponentMap.putString("text", buttonComponent.text)
                storyComponentMap.putString("id", buttonComponent.id)
                storyComponentMap.putString("actionUrl", buttonComponent.actionUrl)
                storyComponentMap.putString("customPayload", buttonComponent.customPayload)
                storyComponentMap.putArray("products", Arguments.createArray().also { productsArray ->
                    buttonComponent.products?.forEach { product ->
                        productsArray.pushMap(createSTRProductItemMap(product))
                    }
                })
            }

            VerticalFeedItemComponentType.SwipeAction -> {
                val swipeComponent = verticalFeedComponent as VerticalFeedItemSwipeComponent
                storyComponentMap.putString("type", "swipeaction")
                storyComponentMap.putString("id", swipeComponent.id)
                storyComponentMap.putString("text", swipeComponent.text)
                storyComponentMap.putString("actionUrl", swipeComponent.actionUrl)
                storyComponentMap.putString("customPayload", swipeComponent.customPayload)
                storyComponentMap.putArray("products", Arguments.createArray().also { productsArray ->
                    swipeComponent.products?.forEach { product ->
                        productsArray.pushMap(createSTRProductItemMap(product))
                    }
                })
            }

            VerticalFeedItemComponentType.ProductTag -> {
                val ptagComponent = verticalFeedComponent as VerticalFeedItemProductTagComponent
                storyComponentMap.putString("type", "producttag")
                storyComponentMap.putString("id", ptagComponent.id)
                storyComponentMap.putString("actionUrl", ptagComponent.actionUrl)
                storyComponentMap.putString("customPayload", ptagComponent.customPayload)
                storyComponentMap.putArray("products", Arguments.createArray().also { productsArray ->
                    ptagComponent.products?.forEach { product ->
                        productsArray.pushMap(createSTRProductItemMap(product))
                    }
                })
            }

            VerticalFeedItemComponentType.ProductCard -> {
                val pcardComponent = verticalFeedComponent as VerticalFeedItemProductCardComponent
                storyComponentMap.putString("type", "productcard")
                storyComponentMap.putString("id", pcardComponent.id)
                storyComponentMap.putString("text", pcardComponent.text)
                storyComponentMap.putString("actionUrl", pcardComponent.actionUrl)
                storyComponentMap.putString("customPayload", pcardComponent.customPayload)
                storyComponentMap.putArray("products", Arguments.createArray().also { productsArray ->
                    pcardComponent.products?.forEach { product ->
                        productsArray.pushMap(createSTRProductItemMap(product))
                    }
                })
            }

            VerticalFeedItemComponentType.ProductCatalog -> {
                val catalogComponent = verticalFeedComponent as VerticalFeedItemProductCatalogComponent
                storyComponentMap.putString("type", "productcatalog")
                storyComponentMap.putString("id", catalogComponent.id)
                storyComponentMap.putString("customPayload", catalogComponent.customPayload)
                storyComponentMap.putArray("actionUrlList", Arguments.createArray().also { actionUrlArray ->
                    catalogComponent.actionUrlList?.forEach { actionUrl ->
                        actionUrlArray.pushString(actionUrl)
                    }
                })
                storyComponentMap.putArray("products", Arguments.createArray().also { productsArray ->
                    catalogComponent.products?.forEach { product ->
                        productsArray.pushMap(createSTRProductItemMap(product))
                    }
                })
            }

            VerticalFeedItemComponentType.Quiz -> {
                val quizComponent = verticalFeedComponent as VerticalFeedItemQuizComponent
                storyComponentMap.putString("type", "quiz")
                storyComponentMap.putString("id", quizComponent.id)
                storyComponentMap.putString("title", quizComponent.title)
                storyComponentMap.putString("customPayload", quizComponent.customPayload)
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
                storyComponentMap.putString("customPayload", promoCodeComponent.customPayload)
            }

            VerticalFeedItemComponentType.Comment -> {
                val commentComponent = verticalFeedComponent as VerticalFeedItemCommentComponent
                storyComponentMap.putString("type", "comment")
                storyComponentMap.putString("id", commentComponent.id)
                storyComponentMap.putString("text", commentComponent.text)
                storyComponentMap.putString("customPayload", commentComponent.customPayload)
            }

            else -> {
                storyComponentMap.putString("id", verticalFeedComponent.id)
                storyComponentMap.putString("type", verticalFeedComponent.type.name.lowercase())
                storyComponentMap.putString("customPayload", verticalFeedComponent.customPayload)
            }
        }
    }
}