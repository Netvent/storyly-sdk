package com.appsamurai.storyly.reactnative

import com.appsamurai.storyly.*
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.appsamurai.storyly.data.managers.product.STRProductItem
import com.appsamurai.storyly.data.managers.product.STRProductVariant
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap


internal fun createStoryGroupMap(storyGroup: StoryGroup): WritableMap {
    return Arguments.createMap().also { storyGroupMap ->
        storyGroupMap.putString("id", storyGroup.uniqueId)
        storyGroupMap.putString("title", storyGroup.title)
        storyGroupMap.putString("iconUrl", storyGroup.iconUrl)
        storyGroupMap.putBoolean("pinned", storyGroup.pinned)
        storyGroupMap.putMap("thematicIconUrls", storyGroup.thematicIconUrls?.let { thematicIconUrls ->
            Arguments.createMap().also {
                thematicIconUrls.forEach { entry -> it.putString(entry.key, entry.value) }
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
                story.media.actionUrlList?.forEach { urlArray.pushString(it) }
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

internal fun createSTRProductItemMap(product: STRProductItem): WritableMap {
    return Arguments.createMap().also { productItemMap ->
        productItemMap.putString("productId", product.productId)
        productItemMap.putString("productGroupId", product.productGroupId)
        productItemMap.putString("title", product.title)
        productItemMap.putString("desc", product.desc)
        productItemMap.putDouble("price", product.price.toDouble())
        product.salesPrice?.let {
            productItemMap.putDouble("salesPrice", it.toDouble())
        } ?: run {
            productItemMap.putNull("salesPrice")
        }
        productItemMap.putString("currency", product.currency)
        productItemMap.putArray("imageUrls", Arguments.createArray().also { imageUrls ->
            product.imageUrls?.forEach { imageUrls.pushString(it) }
        })
        productItemMap.putArray("variants", Arguments.createArray().also { variantArray ->
            product.variants.forEach { variant -> variantArray.pushMap(createSTRProductVariantMap(variant)) }
        })
    }
}

internal fun createSTRCartMap(cart: STRCart): WritableMap {
    return Arguments.createMap().also { cartMap ->
        cartMap.putArray("items", Arguments.createArray().also { cartItemArray ->
            cart.items.forEach { cartItemArray.pushMap(createSTRCartItemMap(it)) }
        })
        cart.oldTotalPrice?.let {
            cartMap.putDouble("oldTotalPrice", it.toDouble())
        } ?: run {
            cartMap.putNull("oldTotalPrice")
        }
        cartMap.putDouble("totalPrice", cart.totalPrice.toDouble())

        cartMap.putString("currency", cart.currency)
    }
}

internal fun createSTRCartItemMap(cartItem: STRCartItem): WritableMap {
    return Arguments.createMap().also { cartItemMap ->
        cartItemMap.putMap("item", createSTRProductItemMap(cartItem.item))
        cartItem.oldTotalPrice?.let {
            cartItemMap.putDouble("oldTotalPrice", it.toDouble())
        } ?: run {
            cartItemMap.putNull("oldTotalPrice")
        }
        cartItem.totalPrice?.let {
            cartItemMap.putDouble("totalPrice", it.toDouble())
        } ?: run {
            cartItemMap.putNull("totalPrice")
        }
    }
}

internal fun createSTRProductVariantMap(variant: STRProductVariant): ReadableMap {
    return Arguments.createMap().also { productItemMap ->
        productItemMap.putString("name", variant.name)
        productItemMap.putString("value", variant.value)
    }
}

internal fun createSTRProductItem(product: Map<String, Any?>?): STRProductItem {
    return STRProductItem(
        productId = product?.get("productId") as? String ?: "",
        productGroupId = product?.get("productGroupId") as? String ?: "",
        title = product?.get("title") as? String ?: "",
        desc = product?.get("desc") as? String ?: "",
        price = (product?.get("price") as Double).toFloat(),
        salesPrice = (product["salesPrice"] as? Double)?.toFloat(),
        currency = product["currency"] as? String ?: "",
        imageUrls = product["imageUrls"] as? List<String>,
        url = product["url"] as? String ?: "",
        variants = createSTRProductVariant(product["variants"] as? List<Map<String, Any?>>)
    )
}

internal fun createSTRProductVariant(variants: List<Map<String, Any?>>?): List<STRProductVariant> {
    return variants?.map { variant ->
        STRProductVariant(
            name = variant["name"] as? String ?: "",
            value = variant["value"] as? String ?: ""
        )
    } ?: listOf()
}

internal fun createSTRCart(cart: Map<String, Any?>): STRCart {
    return STRCart(
        items = (cart["items"] as? List<Map<String, Any?>>)?.map { createSTRCartItem(it) } ?: listOf(),
        oldTotalPrice = (cart["oldTotalPrice"] as? Double)?.toFloat(),
        totalPrice = (cart["oldTotalPrice"] as Double).toFloat(),
        currency = cart["currency"] as String
    )
}

internal fun createSTRCartItem(cartItem: Map<String, Any?>): STRCartItem {
    return STRCartItem(
        item = createSTRProductItem(cartItem["item"] as? Map<String, Any?>),
        oldTotalPrice = (cartItem["oldTotalPrice"] as? Double)?.toFloat(),
        totalPrice = (cartItem["oldTotalPrice"] as Double).toFloat(),
        quantity = (cartItem["quantity"] as Double).toInt()
    )
}
