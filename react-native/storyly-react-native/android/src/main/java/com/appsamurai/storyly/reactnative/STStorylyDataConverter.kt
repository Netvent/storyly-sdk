package com.appsamurai.storyly.reactnative

import com.appsamurai.storyly.*
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.appsamurai.storyly.data.managers.product.STRProductItem
import com.appsamurai.storyly.data.managers.product.STRProductVariant
import com.appsamurai.storyly.data.managers.product.STRProductInformation
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap


internal fun createStoryGroupMap(storyGroup: StoryGroup): WritableMap {
    return Arguments.createMap().also { storyGroupMap ->
        storyGroupMap.putString("id", storyGroup.uniqueId)
        storyGroupMap.putString("title", storyGroup.title)
        storyGroupMap.putString("iconUrl", storyGroup.iconUrl)
        storyGroupMap.putBoolean("pinned", storyGroup.pinned)
        storyGroupMap.putInt("index", storyGroup.index)
        storyGroupMap.putBoolean("seen", storyGroup.seen)
        storyGroupMap.putArray("stories", Arguments.createArray().also { storiesArray ->
            storyGroup.stories.forEach { story -> storiesArray.pushMap(createStoryMap(story)) }
        })
        storyGroupMap.putString("type", storyGroup.type.customName)
        storyGroupMap.putString("name", storyGroup.name)
        storyGroupMap.putBoolean("nudge", storyGroup.nudge)
        storyGroupMap.putMap("style", storyGroup.style?.let {
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

internal fun createStoryMap(story: Story): WritableMap {
    return Arguments.createMap().also { storyMap ->
        storyMap.putString("id", story.uniqueId)
        storyMap.putInt("index", story.index)
        storyMap.putString("title", story.title)
        storyMap.putString("name", story.name)
        storyMap.putBoolean("seen", story.seen)
        story.currentTime?.toInt()?.let { storyMap.putInt("currentTime", it) }
        storyMap.putString("actionUrl", story.actionUrl)
        storyMap.putString("previewUrl", story.previewUrl)
        storyMap.putArray("storyComponentList", Arguments.createArray().also { componentArray ->
            story.storyComponentList?.forEach { componentArray.pushMap(createStoryComponentMap(it)) }
        })
        storyMap.putArray("actionProducts", story.actionProducts?.let {
            Arguments.createArray().also { storiesArray ->
                it.forEach { item -> storiesArray.pushMap(createSTRProductItemMap(item)) }
            }
        })
    }
}

internal fun createStoryComponentMap(storyComponent: StoryComponent): WritableMap {
    return Arguments.createMap().also { storyComponentMap ->
        when (storyComponent.type) {
            StoryComponentType.ButtonAction -> {
                val buttonComponent = storyComponent as StoryButtonComponent
                storyComponentMap.putString("type", "buttonaction")
                storyComponentMap.putString("text", buttonComponent.text)
                storyComponentMap.putString("id", buttonComponent.id)
                storyComponentMap.putString("actionUrl", buttonComponent.actionUrl)
                storyComponentMap.putArray("products", Arguments.createArray().also { productsArray ->
                    buttonComponent.products?.forEach { product ->
                        productsArray.pushMap(createSTRProductItemMap(product))
                    }
                })
            }

            StoryComponentType.SwipeAction -> {
                val swipeComponent = storyComponent as StorySwipeComponent
                storyComponentMap.putString("type", "swipeaction")
                storyComponentMap.putString("id", swipeComponent.id)
                storyComponentMap.putString("text", swipeComponent.text)
                storyComponentMap.putString("actionUrl", swipeComponent.actionUrl)
                storyComponentMap.putArray("products", Arguments.createArray().also { productsArray ->
                    swipeComponent.products?.forEach { product ->
                        productsArray.pushMap(createSTRProductItemMap(product))
                    }
                })
            }

            StoryComponentType.ProductTag -> {
                val ptagComponent = storyComponent as StoryProductTagComponent
                storyComponentMap.putString("type", "producttag")
                storyComponentMap.putString("id", ptagComponent.id)
                storyComponentMap.putString("actionUrl", ptagComponent.actionUrl)
                storyComponentMap.putArray("products", Arguments.createArray().also { productsArray ->
                    ptagComponent.products?.forEach { product ->
                        productsArray.pushMap(createSTRProductItemMap(product))
                    }
                })
            }

            StoryComponentType.ProductCard -> {
                val pcardComponent = storyComponent as StoryProductCardComponent
                storyComponentMap.putString("type", "productcard")
                storyComponentMap.putString("text", pcardComponent.text)
                storyComponentMap.putString("id", pcardComponent.id)
                storyComponentMap.putString("actionUrl", pcardComponent.actionUrl)
                storyComponentMap.putArray("products", Arguments.createArray().also { productsArray ->
                    pcardComponent.products?.forEach { product ->
                        productsArray.pushMap(createSTRProductItemMap(product))
                    }
                })
            }

            StoryComponentType.ProductCatalog -> {
                val catalogComponent = storyComponent as StoryProductCatalogComponent
                storyComponentMap.putString("type", "productcatalog")
                storyComponentMap.putString("id", catalogComponent.id)
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
                storyComponentMap.putString("customPayload", promoCodeComponent.customPayload)
            }

            StoryComponentType.Comment -> {
                val commentComponent = storyComponent as StoryCommentComponent
                storyComponentMap.putString("type", "comment")
                storyComponentMap.putString("id", commentComponent.id)
                storyComponentMap.putString("text", commentComponent.text)
                storyComponentMap.putString("customPayload", commentComponent.customPayload)
            }

            else -> {
                storyComponentMap.putString("id", storyComponent.id)
                storyComponentMap.putString("type", storyComponent.type.name.lowercase())
                storyComponentMap.putString("customPayload", storyComponent.customPayload)
            }
        }
    }
}

internal fun createSTRProductItemMap(product: STRProductItem?): WritableMap {
    return product?.let {
        Arguments.createMap().also { productItemMap ->
            productItemMap.putString("productId", product.productId)
            productItemMap.putString("productGroupId", product.productGroupId)
            productItemMap.putString("title", product.title)
            productItemMap.putString("url", product.url)
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
                product.variants.forEach { variant ->
                    variantArray.pushMap(
                        createSTRProductVariantMap(variant)
                    )
                }
            })
        }
    } ?: Arguments.createMap()
}

internal fun createSTRProductVariantMap(variant: STRProductVariant): WritableMap {
    return Arguments.createMap().also { productItemMap ->
        productItemMap.putString("name", variant.name)
        productItemMap.putString("value", variant.value)
        productItemMap.putString("key", variant.key)
    }
}

internal fun createSTRProductItem(product: Map<String, Any?>?): STRProductItem {
    return STRProductItem(
        productId = product?.get("productId") as? String ?: "",
        productGroupId = product?.get("productGroupId") as? String ?: "",
        title = product?.get("title") as? String ?: "",
        url = product?.get("url") as? String ?: "",
        desc = product?.get("desc") as? String ?: "",
        price = (product?.get("price") as? Double)?.toFloat() ?: 0f,
        salesPrice = (product?.get("salesPrice") as? Double)?.toFloat(),
        currency = product?.get("currency") as? String ?: "",
        imageUrls = product?.get("imageUrls") as? List<String>,
        variants = createSTRProductVariant(product?.get("variants") as? List<Map<String, Any?>>),
        ctaText = product?.get("ctaText") as? String,
    )
}

internal fun createSTRProductVariant(variants: List<Map<String, Any?>>?): List<STRProductVariant> {
    return variants?.map { variant ->
        STRProductVariant(
            name = variant["name"] as? String ?: "",
            value = variant["value"] as? String ?: "",
            key = variant["key"] as? String ?: ""
        )
    } ?: listOf()
}

internal fun createSTRCartMap(cart: STRCart?): WritableMap? {
    return cart?.let {
        Arguments.createMap().also { cartMap ->
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
}

internal fun createSTRCartItemMap(cartItem: STRCartItem?): WritableMap {
    return cartItem?.let {
        Arguments.createMap().also { cartItemMap ->
            cartItemMap.putMap("item", createSTRProductItemMap(cartItem.item))
            cartItemMap.putInt("quantity", cartItem.quantity)
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
    } ?: Arguments.createMap()
}

internal fun createSTRProductInformationMap(productInfo: STRProductInformation): WritableMap {
    return Arguments.createMap().also { productInformationMap ->
        productInformationMap.putString("productId", productInfo.productId)
        productInformationMap.putString("productGroupId", productInfo.productGroupId)
    }
}

internal fun createSTRCart(cart: Map<String, Any?>): STRCart {
    return STRCart(
        items = (cart["items"] as? List<Map<String, Any?>>)?.map { createSTRCartItem(it) }
            ?: listOf(),
        oldTotalPrice = (cart["oldTotalPrice"] as? Double)?.toFloat(),
        totalPrice = (cart["totalPrice"] as Double).toFloat(),
        currency = cart["currency"] as String
    )
}

internal fun createSTRCartItem(cartItem: Map<String, Any?>): STRCartItem {
    return STRCartItem(
        item = createSTRProductItem(cartItem["item"] as? Map<String, Any?>),
        oldTotalPrice = (cartItem["oldTotalPrice"] as? Double)?.toFloat(),
        totalPrice = (cartItem["totalPrice"] as Double).toFloat(),
        quantity = (cartItem["quantity"] as Double).toInt()
    )
}


internal fun Int.toHexString(): String {
    return String.format("#%08X", this)
}
