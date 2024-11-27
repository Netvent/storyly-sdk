package com.storylyreactnative.data

import com.appsamurai.storyly.*
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.appsamurai.storyly.data.managers.product.STRProductItem
import com.appsamurai.storyly.data.managers.product.STRProductVariant
import com.appsamurai.storyly.data.managers.product.STRProductInformation

internal fun createStoryGroupMap(storyGroup: StoryGroup): Map<String, Any?> {
    return mapOf(
        "id" to storyGroup.uniqueId,
        "title" to storyGroup.title,
        "iconUrl" to storyGroup.iconUrl,
        "pinned" to storyGroup.pinned,
        "thematicIconUrls" to  (storyGroup.thematicIconUrls ?: emptyMap()),
        "coverUrl" to storyGroup.coverUrl,
        "index" to storyGroup.index,
        "seen" to storyGroup.seen,
        "stories" to storyGroup.stories.map { story -> createStoryMap(story) },
        "type" to storyGroup.type.customName,
        "momentsUser" to storyGroup.momentsUser?.let { momentsUser ->
            mapOf(
                "id" to momentsUser.userId,
                "avatarUrl" to momentsUser.userId,
                "username" to momentsUser.username,
            )
        },
        "nudge" to storyGroup.nudge
    )
}

internal fun createStoryMap(story: Story): Map<String, Any?> {
    return mapOf(
        "id" to story.uniqueId,
        "index" to story.index,
        "title" to story.title,
        "name" to story.name,
        "seen" to story.seen,
        "currentTime" to story.currentTime.toInt(),
//        "products" to story.products?.map { product -> createSTRProductItemMap(product) },
        "media" to mapOf(
            "type" to story.media.type.ordinal,
            "storyComponentList" to story.media.storyComponentList?.map { createStoryComponentMap(it) },
            "actionUrl" to story.media.actionUrl,
            "actionUrlList" to story.media.actionUrlList,
            "previewUrl" to story.media.previewUrl,
        )
    )
}

internal fun createStoryComponentMap(storyComponent: StoryComponent): Map<String, Any?> {
    return when (storyComponent.type) {
        StoryComponentType.Quiz -> {
            val quizComponent = storyComponent as StoryQuizComponent
            mapOf(
                "type" to "quiz",
                "id" to quizComponent.id,
                "title" to quizComponent.title,
                "options" to quizComponent.options,
                "rightAnswerIndex" to quizComponent.rightAnswerIndex,
                "selectedOptionIndex" to quizComponent.selectedOptionIndex,
                "customPayload" to quizComponent.customPayload,
            )
        }
        StoryComponentType.Poll -> {
            val pollComponent = storyComponent as StoryPollComponent
            mapOf(
                "type" to "poll",
                "id" to pollComponent.id,
                "title" to pollComponent.title,
                "options" to pollComponent.options,
                "selectedOptionIndex" to pollComponent.selectedOptionIndex,
                "customPayload" to pollComponent.customPayload,
            )
        }
        StoryComponentType.Emoji -> {
            val emojiComponent = storyComponent as StoryEmojiComponent
            mapOf(
                "type" to "emoji",
                "id" to emojiComponent.id,
                "emojiCodes" to emojiComponent.emojiCodes,
                "selectedEmojiIndex" to emojiComponent.selectedEmojiIndex,
                "customPayload" to emojiComponent.customPayload,
            )
        }
        StoryComponentType.Rating -> {
            val ratingComponent = storyComponent as StoryRatingComponent
            mapOf(
                "type" to "rating",
                "id" to ratingComponent.id,
                "emojiCode" to ratingComponent.emojiCode,
                "rating" to ratingComponent.rating,
                "customPayload" to ratingComponent.customPayload,
            )
        }
        StoryComponentType.PromoCode -> {
            val promoCodeComponent = storyComponent as StoryPromoCodeComponent
            mapOf(
                "type" to "promocode",
                "id" to promoCodeComponent.id,
                "text" to promoCodeComponent.text,
            )
        }
        StoryComponentType.Comment -> {
            val commentComponent = storyComponent as StoryCommentComponent
            mapOf(
                "type" to "comment",
                "id" to commentComponent.id,
                "text" to commentComponent.text,
            )
        }
        else -> {
            mapOf(
                "id" to storyComponent.id,
                "type" to storyComponent.type.name.lowercase(),
            )
        }
    }
}

internal fun createSTRProductItemMap(product: STRProductItem?): Map<String, Any?> {
    return product?.let {
        mapOf(
            "productId" to product.productId,
            "productGroupId" to product.productGroupId,
            "title" to product.title,
            "url" to product.url,
            "desc" to product.desc,
            "price" to product.price.toDouble(),
            "salesPrice" to product.salesPrice?.toDouble(),
            "currency" to product.currency,
            "imageUrls" to product.imageUrls,
            "variants" to product.variants.map { variant -> createSTRProductVariantMap(variant) },
        )
    } ?: emptyMap()
}

internal fun createSTRProductVariantMap(variant: STRProductVariant): Map<String, Any?> {
    return mapOf(
        "name" to variant.name,
        "value" to variant.value,
//        "key" to variant.key,
    )
}

internal fun createSTRProductInformationMap(productInfo: STRProductInformation): Map<String, Any?> {
    return mapOf(
        "productId" to productInfo.productId,
        "productGroupId" to productInfo.productGroupId,
    )
}

internal fun createSTRProductItem(product: Map<String, Any?>?): STRProductItem {
    return STRProductItem(
        productId = product?.get("productId") as? String ?: "",
        productGroupId = product?.get("productGroupId") as? String ?: "",
        title = product?.get("title") as? String ?: "",
        url = product?.get("url") as? String ?: "",
        desc = product?.get("desc") as? String ?: "",
        price = (product?.get("price") as Double).toFloat(),
        salesPrice = (product["salesPrice"] as? Double)?.toFloat(),
        currency = product["currency"] as? String ?: "",
        imageUrls = product["imageUrls"] as? List<String>,
        variants = createSTRProductVariant(product["variants"] as? List<Map<String, Any?>>),
        ctaText = product["ctaText"] as? String,
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

internal fun createSTRCartMap(cart: STRCart?): Map<String, Any?>? {
    return cart?.let {
        mapOf(
            "items" to cart.items.map { createSTRCartItemMap(it) },
            "oldTotalPrice" to cart.oldTotalPrice?.toDouble(),
            "totalPrice" to cart.totalPrice.toDouble(),
            "currency" to cart.currency,
        )
    }
}

internal fun createSTRCartItemMap(cartItem: STRCartItem?): Map<String, Any?> {
    return cartItem?.let {
        mapOf(
            "item" to createSTRProductItemMap(cartItem.item),
            "quantity" to cartItem.quantity,
            "oldTotalPrice" to cartItem.oldTotalPrice?.toDouble(),
            "totalPrice" to cartItem.totalPrice?.toDouble(),
        )
    } ?: emptyMap()
}

internal fun createSTRCart(cart: Map<String, Any?>): STRCart {
    return STRCart(
        items = (cart["items"] as? List<Map<String, Any?>>)?.map { createSTRCartItem(it) } ?: listOf(),
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
