package com.appsamurai.storyly.reactnative

import com.appsamurai.storyly.*
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap


internal fun createStoryGroupMap(storyGroup: StoryGroup): WritableMap {
    return Arguments.createMap().also { storyGroupMap ->
        storyGroupMap.putString("groupTheme", storyGroup.groupTheme?.name)
        storyGroupMap.putString("id", storyGroup.uniqueId)
        storyGroupMap.putString("title", storyGroup.title)
        storyGroupMap.putString("iconUrl", storyGroup.iconUrl)
        storyGroupMap.putBoolean("pinned", storyGroup.pinned)
        storyGroupMap.putMap("thematicIconUrls",  storyGroup.thematicIconUrls?.let { thematicIconUrls ->
            Arguments.createMap().also {
                thematicIconUrls.forEach { entry ->  it.putString(entry.key, entry.value) }
            }
        })
        storyGroupMap.putString("coverUrl", storyGroup.coverUrl)
        storyGroupMap.putInt("index", storyGroup.index)
        storyGroupMap.putBoolean("seen", storyGroup.seen)
        storyGroupMap.putArray("stories", Arguments.createArray().also { storiesArray ->
            storyGroup.stories.forEach { story -> storiesArray.pushMap(createStoryMap(story)) }
        })
        storyGroupMap.putString("type", storyGroup.type.customName)
        storyGroupMap.putMap("momentsUser", storyGroup.momentsUser?.let { momentsUser ->
            Arguments.createMap().also {
                it.putString("id", momentsUser.userId)
                it.putString("avatarUrl", momentsUser.userId)
                it.putString("username", momentsUser.username)
            }
        })
    }
}

internal fun createStoryMap(story: Story): WritableMap {
    return Arguments.createMap().also { storyMap ->
        storyMap.putString("id", story.uniqueId)
        storyMap.putInt("index", story.index)
        storyMap.putString("title", story.title)
        storyMap.putString("name", story.name)
        storyMap.putBoolean("seen", story.seen)
        storyMap.putInt("currentTime", story.currentTime.toInt())
        storyMap.putMap("media", Arguments.createMap().also { storyMediaMap ->
            storyMediaMap.putInt("type", story.media.type.ordinal)
            storyMediaMap.putArray("storyComponentList", Arguments.createArray().also { componentArray ->
                story.media.storyComponentList?.forEach { componentArray.pushMap(createStoryComponentMap(it)) }
            })
            storyMediaMap.putString("actionUrl", story.media.actionUrl)
            storyMediaMap.putArray("actionUrlList", Arguments.createArray().also { urlArray ->
                story.media.actionUrlList?.forEach { urlArray.pushString(it)  }
            })
            storyMediaMap.putString("previewUrl", story.media.previewUrl)
        })
    }
}

internal fun createStoryComponentMap(storyComponent: StoryComponent): WritableMap {
    return Arguments.createMap().also { storyComponentMap ->
        when (storyComponent.type) {
            StoryComponentType.Quiz -> {
                val quizComponent = storyComponent as StoryQuizComponent
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
            StoryComponentType.Poll -> {
                val pollComponent = storyComponent as StoryPollComponent
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
            StoryComponentType.Emoji -> {
                val emojiComponent = storyComponent as StoryEmojiComponent
                storyComponentMap.putString("type", "emoji")
                storyComponentMap.putString("id", emojiComponent.id)
                storyComponentMap.putArray("emojiCodes", Arguments.createArray().also { emojiCodesArray ->
                    emojiComponent.emojiCodes.forEach { emojiCode ->
                        emojiCodesArray.pushString(emojiCode)
                    }
                })
                storyComponentMap.putInt("selectedEmojiIndex", emojiComponent.selectedEmojiIndex)
                storyComponentMap.putString("customPayload", emojiComponent.customPayload)

            }
            StoryComponentType.Rating -> {
                val ratingComponent = storyComponent as StoryRatingComponent
                storyComponentMap.putString("type", "rating")
                storyComponentMap.putString("id", ratingComponent.id)
                storyComponentMap.putString("emojiCode", ratingComponent.emojiCode)
                storyComponentMap.putInt("rating", ratingComponent.rating)
                storyComponentMap.putString("customPayload", ratingComponent.customPayload)
            }
            StoryComponentType.PromoCode -> {
                val promoCodeComponent = storyComponent as StoryPromoCodeComponent
                storyComponentMap.putString("type", "promocode")
                storyComponentMap.putString("id", promoCodeComponent.id)
                storyComponentMap.putString("text", promoCodeComponent.text)
            }
            StoryComponentType.Comment -> {
                val commentComponent = storyComponent as StoryCommentComponent
                storyComponentMap.putString("type", "comment")
                storyComponentMap.putString("id", commentComponent.id)
                storyComponentMap.putString("text", commentComponent.text)
            }
            else -> {
                storyComponentMap.putString("id", storyComponent.id)
                storyComponentMap.putString("type", storyComponent.type.name.lowercase())
            }
        }
    }
}
