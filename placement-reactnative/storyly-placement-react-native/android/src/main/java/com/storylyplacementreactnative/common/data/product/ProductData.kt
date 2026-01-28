package com.storylyplacementreactnative.common.data.product

import com.appsamurai.storyly.core.data.model.product.STRCart
import com.appsamurai.storyly.core.data.model.product.STRCartItem
import com.appsamurai.storyly.core.data.model.product.STRProductInformation
import com.appsamurai.storyly.core.data.model.product.STRProductItem
import com.appsamurai.storyly.core.data.model.product.STRProductVariant

internal fun encodeSTRProductItem(product: STRProductItem): Map<String, Any?> {
    return mapOf(
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
    val price = (product["price"] as? Number)?.toFloat() ?: return null
    return STRProductItem(
        productId = productId,
        productGroupId = productGroupId,
        title = title,
        url = url,
        desc = desc,
        price = price,
        salesPrice = (product["salesPrice"] as? Number)?.toFloat(),
        lowestPrice = (product["lowestPrice"] as? Number)?.toFloat(),
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

internal fun decodeSTRProductInformation(info: Map<String, Any?>): STRProductInformation? {
    val productId = info["productId"] as? String ?: return null
    val productGroupId = info["productGroupId"] as? String ?: return null
    return STRProductInformation(
        productId = productId,
        productGroupId = productGroupId,
    )
}

internal fun encodeSTRCartItem(item: STRCartItem?): Map<String, Any?>? {
    item ?: return null
    return mapOf(
        "product" to encodeSTRProductItem(item.product),
        "quantity" to item.quantity,
    )
}