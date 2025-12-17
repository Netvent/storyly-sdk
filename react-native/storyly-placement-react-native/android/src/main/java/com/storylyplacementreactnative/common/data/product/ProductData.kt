package com.storylyplacementreactnative.common.data.product

import com.appsamurai.storyly.core.data.model.product.STRCart
import com.appsamurai.storyly.core.data.model.product.STRCartItem
import com.appsamurai.storyly.core.data.model.product.STRProductInformation
import com.appsamurai.storyly.core.data.model.product.STRProductItem
import com.appsamurai.storyly.core.data.model.product.STRProductVariant

internal fun encodeSTRProductItem(product: STRProductItem) {
    mapOf(
        "productId" to product.productId,
        "productGroupId" to product.productGroupId,
        "title" to product.title,
        "url" to product.url,
        "desc" to product.desc,
        "price" to product.price.toDouble(),
        "salesPrice" to product.salesPrice?.toDouble(),
        "lowestPrice" to product.lowestPrice?.toDouble(),
        "currency" to product.currency,
        "imageUrls" to product.imageUrls,
        "variants" to product.variants.map { variant -> encodeSTRProductVariant(variant) },
        "ctaText" to product.ctaText,
    )
}

internal fun decodeSTRProductItem(product: Map<String, Any?>?): STRProductItem? {
    product ?: return null
    val productId = product["productId"] as? String ?: return null
    val productGroupId = product["productGroupId"] as? String ?: return null
    val title = product["title"] as? String ?: return null
    val url = product["url"] as? String ?: return null
    val desc = product["desc"] as? String ?: return null
    val price = (product["price"] as? Double)?.toFloat() ?: return null
    return STRProductItem(
        productId = productId,
        productGroupId = productGroupId,
        title = title,
        url = url,
        desc = desc,
        price = price,
        salesPrice = (product["salesPrice"] as? Double)?.toFloat(),
        lowestPrice = (product["lowestPrice"] as? Double)?.toFloat(),
        currency = product["currency"] as String,
        imageUrls = product["imageUrls"] as? List<String>,
        variants = (product["variants"] as? List<Map<String, Any?>>)
            ?.mapNotNull { variant -> decodeSTRProductVariant(variant) } ?: emptyList(),
        ctaText = product["ctaText"] as? String,
    )
}

internal fun encodeSTRProductVariant(variant: STRProductVariant): Map<String, Any?> {
    return mapOf(
        "name" to variant.name,
        "value" to variant.value,
        "key" to variant.key,
    )
}

internal fun decodeSTRProductVariant(variant: Map<String, Any?>): STRProductVariant? {
    val name = variant["name"] as? String ?: return null
    val value = variant["value"] as? String ?: return null
    val key = variant["key"] as? String ?: return null
    return STRProductVariant(
        name = name,
        value = value,
        key = key,
    )
}

internal fun encodeSTRProductInformation(info: STRProductInformation): Map<String, Any?> {
    return mapOf(
        "productId" to info.productId,
        "productGroupId" to info.productGroupId,
    )
}

internal fun encodeSTRCart(cart: STRCart?): Map<String, Any?>? {
    cart ?: return null
    return mapOf(
     "items" to cart.items.map { item -> encodeSTRCartItem(item) },
     "totalPrice" to cart.totalPrice,
     "oldTotalPrice" to cart.oldTotalPrice,
     "currency" to cart.currency,
    )
}

internal fun decodeSTRCart(cart: Map<String, Any?>?): STRCart? {
    cart ?: return null
    return STRCart(
        items = (cart["items"] as? List<Map<String, Any?>>)
            ?.mapNotNull { item -> decodeSTRCartItem(item) }
            ?: emptyList(),
        totalPrice = (cart["totalPrice"] as Double).toFloat(),
        oldTotalPrice = (cart["oldTotalPrice"] as? Double)?.toFloat(),
        currency = cart["currency"] as String,
    )
}

internal fun encodeSTRCartItem(item: STRCartItem?): Map<String, Any?>? {
    item ?: return null
    return mapOf(
        "item" to encodeSTRProductItem(item.item),
        "quantity" to item.quantity,
        "totalPrice" to item.totalPrice,
        "oldTotalPrice" to item.oldTotalPrice,
    )
}

internal fun decodeSTRCartItem(item: Map<String, Any?>?): STRCartItem? {
    item ?: return null
    val productItem = item["item"] as? Map<String, Any?> ?: return null
    val cartItem = decodeSTRProductItem(productItem) ?: return null
    val quantity = item["quantity"] as? Int ?: return null
    return STRCartItem(
        item = cartItem,
        quantity = quantity,
        totalPrice = (item["totalPrice"] as? Double)?.toFloat(),
        oldTotalPrice = (item["oldTotalPrice"] as? Double)?.toFloat(),
    )
}
