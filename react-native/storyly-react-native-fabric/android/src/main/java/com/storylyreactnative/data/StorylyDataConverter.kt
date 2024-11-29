package com.storylyreactnative.data

import com.appsamurai.storyly.Story
import com.appsamurai.storyly.StoryButtonComponent
import com.appsamurai.storyly.StoryCommentComponent
import com.appsamurai.storyly.StoryComponent
import com.appsamurai.storyly.StoryComponentType
import com.appsamurai.storyly.StoryEmojiComponent
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StoryGroupBadgeStyle
import com.appsamurai.storyly.StoryGroupStyle
import com.appsamurai.storyly.StoryPollComponent
import com.appsamurai.storyly.StoryProductCardComponent
import com.appsamurai.storyly.StoryProductCatalogComponent
import com.appsamurai.storyly.StoryProductTagComponent
import com.appsamurai.storyly.StoryPromoCodeComponent
import com.appsamurai.storyly.StoryQuizComponent
import com.appsamurai.storyly.StoryRatingComponent
import com.appsamurai.storyly.StorySwipeComponent
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.appsamurai.storyly.data.managers.product.STRProductInformation
import com.appsamurai.storyly.data.managers.product.STRProductItem
import com.appsamurai.storyly.data.managers.product.STRProductVariant

internal fun createStoryGroupMap(storyGroup: StoryGroup): Map<String, Any?> {
    return mapOf(
        "id" to storyGroup.uniqueId,
        "title" to storyGroup.title,
        "iconUrl" to storyGroup.iconUrl,
        "pinned" to storyGroup.pinned,
        "index" to storyGroup.index,
        "seen" to storyGroup.seen,
        "stories" to storyGroup.stories.map { story -> createStoryMap(story) },
        "type" to storyGroup.type.customName,
        "name" to storyGroup.name,
        "nudge" to storyGroup.nudge,
        "style" to createStoryGroupStyleMap(storyGroup.style)
    )
}

internal fun createStoryGroupStyleMap(style: StoryGroupStyle?): Map<String, Any?>? {
    style ?: return null
    return mapOf(
        "borderUnseenColors" to style.borderUnseenColors?.map { it.toHexString() },
        "textUnseenColor" to style.textUnseenColor?.toHexString(),
        "badge" to createStoryGroupStyleBadgeMap(style.badge)
    )
}

internal fun createStoryGroupStyleBadgeMap(badge: StoryGroupBadgeStyle?): Map<String, Any?>? {
    badge ?: return null
    return mapOf(
        "backgroundColor" to badge.backgroundColor,
        "textColor" to badge.textColor,
        "endTime" to badge.endTime,
        "template" to badge.template,
        "text" to badge.text,
    )
}

internal fun createStoryMap(story: Story): Map<String, Any?> {
    return mapOf(
        "id" to story.uniqueId,
        "index" to story.index,
        "title" to story.title,
        "name" to story.name,
        "seen" to story.seen,
        "currentTime" to story.currentTime?.toInt(),
        "products" to story.actionProducts?.map { product -> createSTRProductItemMap(product) },
        "actionUrl" to story.actionUrl,
        "previewUrl" to story.previewUrl,
        "storyComponentList" to story.storyComponentList?.map { createStoryComponentMap(it) },
        "actionProducts" to story.actionProducts?.map { createSTRProductItemMap(it) },
    )
}

internal fun createStoryComponentMap(storyComponent: StoryComponent): Map<String, Any?> {
    return when (storyComponent.type) {
        StoryComponentType.ButtonAction -> {
            val buttonComponent = storyComponent as StoryButtonComponent
            mapOf(
                "type" to "buttonaction",
                "id" to buttonComponent.id,
                "customPayload" to buttonComponent.customPayload,
                "text" to buttonComponent.text,
                "actionUrl" to buttonComponent.actionUrl,
                "products" to  buttonComponent.products?.map { createSTRProductItemMap(it) }
            )
        }
        StoryComponentType.SwipeAction -> {
            val swipeComponent = storyComponent as StorySwipeComponent
            mapOf(
                "type" to "swipeaction",
                "id" to swipeComponent.id,
                "customPayload" to swipeComponent.customPayload,
                "text" to swipeComponent.text,
                "actionUrl" to swipeComponent.actionUrl,
                "products" to swipeComponent.products?.map { createSTRProductItemMap(it) }
            )
        }
        StoryComponentType.ProductTag -> {
            val ptagComponent = storyComponent as StoryProductTagComponent
            mapOf(
                "type" to "producttag",
                "id" to ptagComponent.id,
                "customPayload" to ptagComponent.customPayload,
                "actionUrl" to ptagComponent.actionUrl,
                "products" to ptagComponent.products?.map { createSTRProductItemMap(it) },
            )
        }
        StoryComponentType.ProductCard -> {
            val pcardComponent = storyComponent as StoryProductCardComponent
            mapOf(
                "type" to "productcard",
                "id" to pcardComponent.id,
                "customPayload" to pcardComponent.customPayload,
                "text" to pcardComponent.text,
                "actionUrl" to pcardComponent.actionUrl,
                "products" to pcardComponent.products?.map { createSTRProductItemMap(it) },
            )
        }
        StoryComponentType.ProductCatalog -> {
            val catalogComponent = storyComponent as StoryProductCatalogComponent
            mapOf(
                "type" to "productcatalog",
                "id" to catalogComponent.id,
                "customPayload" to catalogComponent.customPayload,
                "actionUrlList" to catalogComponent.actionUrlList?.filterNotNull(),
                "products" to catalogComponent.products?.map { createSTRProductItemMap(it) },
            )
        }
        StoryComponentType.Quiz -> {
            val quizComponent = storyComponent as StoryQuizComponent
            mapOf(
                "type" to "quiz",
                "id" to quizComponent.id,
                "customPayload" to quizComponent.customPayload,
                "title" to quizComponent.title,
                "options" to quizComponent.options,
                "rightAnswerIndex" to quizComponent.rightAnswerIndex,
                "selectedOptionIndex" to quizComponent.selectedOptionIndex
            )
        }
        StoryComponentType.Poll -> {
            val pollComponent = storyComponent as StoryPollComponent
            mapOf(
                "type" to "poll",
                "id" to pollComponent.id,
                "customPayload" to pollComponent.customPayload,
                "title" to pollComponent.title,
                "options" to pollComponent.options,
                "selectedOptionIndex" to pollComponent.selectedOptionIndex,
            )
        }
        StoryComponentType.Emoji -> {
            val emojiComponent = storyComponent as StoryEmojiComponent
            mapOf(
                "type" to "emoji",
                "id" to emojiComponent.id,
                "customPayload" to emojiComponent.customPayload,
                "emojiCodes" to emojiComponent.emojiCodes,
                "selectedEmojiIndex" to emojiComponent.selectedEmojiIndex,
            )
        }
        StoryComponentType.Rating -> {
            val ratingComponent = storyComponent as StoryRatingComponent
            mapOf(
                "type" to "rating",
                "id" to ratingComponent.id,
                "customPayload" to ratingComponent.customPayload,
                "emojiCode" to ratingComponent.emojiCode,
                "rating" to ratingComponent.rating,
            )
        }
        StoryComponentType.PromoCode -> {
            val promoCodeComponent = storyComponent as StoryPromoCodeComponent
            mapOf(
                "type" to "promocode",
                "id" to promoCodeComponent.id,
                "customPayload" to promoCodeComponent.customPayload,
                "text" to promoCodeComponent.text,
            )
        }
        StoryComponentType.Comment -> {
            val commentComponent = storyComponent as StoryCommentComponent
            mapOf(
                "type" to "comment",
                "id" to commentComponent.id,
                "customPayload" to commentComponent.customPayload,
                "text" to commentComponent.text,
            )
        }
        else -> {
            mapOf(
                "id" to storyComponent.id,
                "type" to storyComponent.type.name.lowercase(),
                "customPayload" to storyComponent.customPayload,
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
            "ctaText" to product.ctaText,
        )
    } ?: emptyMap()
}

internal fun createSTRProductVariantMap(variant: STRProductVariant): Map<String, Any?> {
    return mapOf(
        "name" to variant.name,
        "value" to variant.value,
        "key" to variant.key,
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
            key = variant["key"] as? String ?: "",
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


internal fun Int.toHexString() = Integer.toHexString(this)
