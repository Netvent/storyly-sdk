package com.storylyplacementreactnative.common

import com.appsamurai.storyly.core.config.placement.STRLayoutDirection
import com.appsamurai.storyly.core.config.placement.STRPlacementConfig
import com.appsamurai.storyly.core.config.placement.STRProductConfig
import com.appsamurai.storyly.core.data.model.product.STRCart
import com.appsamurai.storyly.core.data.model.product.STRCartItem
import com.appsamurai.storyly.core.data.model.product.STRProductInformation
import com.appsamurai.storyly.core.data.model.product.STRProductItem
import com.appsamurai.storyly.core.data.model.product.STRProductVariant
import org.json.JSONArray
import org.json.JSONObject


object RNPlacementDataConverter {

    fun encodeToJson(map: Map<String, Any?>): String? {
        return try {
            JSONObject(map.filterValues { it != null }).toString()
        } catch (e: Exception) {
            null
        }
    }

    fun decodeFromJson(json: String): Map<String, Any?>? {
        return try {
            val jsonObject = JSONObject(json)
            jsonObject.toMap()
        } catch (e: Exception) {
            null
        }
    }

    private fun JSONObject.toMap(): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>()
        keys().forEach { key ->
            map[key] = when (val value = get(key)) {
                is JSONObject -> value.toMap()
                is JSONArray -> value.toList()
                JSONObject.NULL -> null
                else -> value
            }
        }
        return map
    }

    private fun JSONArray.toList(): List<Any?> {
        return (0 until length()).map { i ->
            when (val value = get(i)) {
                is JSONObject -> value.toMap()
                is JSONArray -> value.toList()
                JSONObject.NULL -> null
                else -> value
            }
        }
    }

    // MARK: - Event Creation (returns JSON strings)

    fun createWidgetReadyEvent(ratio: Float): String? {
        return encodeToJson(mapOf("ratio" to ratio))
    }

    fun createFailEvent(errorMessage: String): String? {
        return encodeToJson(mapOf("errorMessage" to errorMessage))
    }

    // MARK: - STRProductItem Conversion

    fun createSTRProductItemMap(product: STRProductItem?): Map<String, Any?> {
        return product?.let {
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
                "variants" to product.variants.map { variant -> createSTRProductVariantMap(variant) },
                "ctaText" to product.ctaText,
                "wishlist" to product.wishlist,
            )
        } ?: emptyMap()
    }

    fun createSTRProductItem(product: Map<String, Any?>?): STRProductItem? {
        if (product == null) return null
        return STRProductItem(
            productId = product["productId"] as? String ?: "",
            productGroupId = product["productGroupId"] as? String ?: "",
            title = product["title"] as? String ?: "",
            url = product["url"] as? String ?: "",
            desc = product["desc"] as? String,
            price = (product["price"] as? Double)?.toFloat() ?: 0f,
            salesPrice = (product["salesPrice"] as? Double)?.toFloat(),
            lowestPrice = (product["lowestPrice"] as? Double)?.toFloat(),
            currency = product["currency"] as? String ?: "",
            imageUrls = product["imageUrls"] as? List<String>,
            variants = createSTRProductVariant(product["variants"] as? List<Map<String, Any?>>),
            ctaText = product["ctaText"] as? String,
            wishlist = product["wishlist"] as? Boolean ?: false,
        )
    }

    fun createSTRProductVariantMap(variant: STRProductVariant): Map<String, Any?> {
        return mapOf(
            "name" to variant.name,
            "value" to variant.value,
            "key" to variant.key,
        )
    }

    fun createSTRProductVariant(variants: List<Map<String, Any?>>?): List<STRProductVariant> {
        return variants?.map { variant ->
            STRProductVariant(
                name = variant["name"] as? String ?: "",
                value = variant["value"] as? String ?: "",
                key = variant["key"] as? String ?: "",
            )
        } ?: listOf()
    }

    // MARK: - STRProductInformation Conversion

    fun createSTRProductInformationMap(productInfo: STRProductInformation): Map<String, Any?> {
        return mapOf(
            "productId" to productInfo.productId,
            "productGroupId" to productInfo.productGroupId,
        )
    }

    fun createSTRProductInformation(productInfo: Map<String, Any?>?): STRProductInformation? {
        if (productInfo == null) return null
        return STRProductInformation(
            productId = productInfo["productId"] as? String,
            productGroupId = productInfo["productGroupId"] as? String,
        )
    }

    // MARK: - STRCart Conversion

    fun createSTRCartMap(cart: STRCart?): Map<String, Any?>? {
        return cart?.let {
            mapOf(
                "items" to cart.items.map { createSTRCartItemMap(it) },
                "oldTotalPrice" to cart.oldTotalPrice?.toDouble(),
                "totalPrice" to cart.totalPrice.toDouble(),
                "currency" to cart.currency,
            )
        }
    }

    fun createSTRCart(cart: Map<String, Any?>?): STRCart? {
        if (cart == null) return null
        return STRCart(
            items = (cart["items"] as? List<Map<String, Any?>>)?.mapNotNull { createSTRCartItem(it) } ?: listOf(),
            oldTotalPrice = (cart["oldTotalPrice"] as? Double)?.toFloat(),
            totalPrice = (cart["totalPrice"] as? Double)?.toFloat() ?: 0f,
            currency = cart["currency"] as? String ?: "",
        )
    }

    fun createSTRCartItemMap(cartItem: STRCartItem?): Map<String, Any?> {
        return cartItem?.let {
            mapOf(
                "item" to createSTRProductItemMap(cartItem.item),
                "quantity" to cartItem.quantity,
                "oldTotalPrice" to cartItem.oldTotalPrice?.toDouble(),
                "totalPrice" to cartItem.totalPrice?.toDouble(),
            )
        } ?: emptyMap()
    }

    fun createSTRCartItem(cartItem: Map<String, Any?>?): STRCartItem? {
        if (cartItem == null) return null
        val productItem = createSTRProductItem(cartItem["item"] as? Map<String, Any?>) ?: return null
        return STRCartItem(
            item = productItem,
            oldTotalPrice = (cartItem["oldTotalPrice"] as? Double)?.toFloat(),
            totalPrice = (cartItem["totalPrice"] as? Double)?.toFloat() ?: 0f,
            quantity = (cartItem["quantity"] as? Double)?.toInt() ?: (cartItem["quantity"] as? Int) ?: 0,
        )
    }

    // MARK: - List Parsing

    fun parseProductItems(productsJson: String): List<STRProductItem> {
        val decoded = decodeFromJson(productsJson) ?: return emptyList()
        val products = decoded["products"] as? List<Map<String, Any?>> ?: return emptyList()
        return products.mapNotNull { createSTRProductItem(it) }
    }

    fun parseCart(cartJson: String): STRCart? {
        val decoded = decodeFromJson(cartJson) ?: return null
        return createSTRCart(decoded)
    }

    fun parseProductInformationList(productsJson: String): List<STRProductInformation> {
        val decoded = decodeFromJson(productsJson) ?: return emptyList()
        val products = decoded["products"] as? List<Map<String, Any?>> ?: return emptyList()
        return products.mapNotNull { createSTRProductInformation(it) }
    }

    // MARK: - Config Conversion

    fun createSTRPlacementConfig(config: Map<String, Any?>, token: String): STRPlacementConfig {
        val placementInit = config["placementInit"] as? Map<*, *> ?: emptyMap<Any, Any>()
        
        val builder = STRPlacementConfig.Builder()
        
        (placementInit["testMode"] as? Boolean)?.let { builder.setTestMode(it) }
        (placementInit["locale"] as? String)?.let { builder.setLocale(it) }
        (placementInit["layoutDirection"] as? String)?.let { layoutDir ->
            builder.setLayoutDirection(
                if (layoutDir == "rtl") STRLayoutDirection.RTL else STRLayoutDirection.LTR
            )
        }
        (placementInit["customParameter"] as? String)?.let { builder.setCustomParameter(it) }
        (placementInit["labels"] as? List<*>)?.filterIsInstance<String>()?.let { labels ->
            builder.setLabels(labels.toSet())
        }
        (placementInit["userProperties"] as? Map<*, *>)?.let { userProps ->
            val props = userProps.entries
                .filter { it.key is String && it.value is String }
                .associate { it.key as String to it.value as String }
            builder.setUserProperties(props)
        }
        
        val productConfig = config["productConfig"] as? Map<*, *>
        val productConfigObj = createSTRProductConfig(productConfig)
        builder.setProductConfig(productConfigObj)
        
        return builder.build(token)
    }

    fun createSTRProductConfig(productConfig: Map<*, *>?): STRProductConfig {
        val builder = STRProductConfig.Builder()
        
        if (productConfig != null) {
            (productConfig["isCartEnabled"] as? Boolean)?.let { builder.setCartAvailability(it) }
            (productConfig["isFallbackEnabled"] as? Boolean)?.let { builder.setFallbackAvailability(it) }
        }
        
        return builder.build()
    }
}


