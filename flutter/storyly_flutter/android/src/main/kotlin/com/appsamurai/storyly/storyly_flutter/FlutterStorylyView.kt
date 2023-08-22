package com.appsamurai.storyly.storyly_flutter

import android.content.Context
import android.content.res.Resources
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.net.Uri
import android.util.DisplayMetrics
import android.util.TypedValue
import android.view.View
import androidx.core.content.ContextCompat
import com.appsamurai.storyly.*
import com.appsamurai.storyly.analytics.StorylyEvent
import com.appsamurai.storyly.config.StorylyConfig
import com.appsamurai.storyly.config.StorylyProductConfig
import com.appsamurai.storyly.config.StorylyShareConfig
import com.appsamurai.storyly.config.styling.bar.StorylyBarStyling
import com.appsamurai.storyly.config.styling.group.StorylyStoryGroupStyling
import com.appsamurai.storyly.config.styling.story.StorylyStoryStyling
import com.appsamurai.storyly.data.managers.product.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.*

class FlutterStorylyViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    internal lateinit var context: Context

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView = FlutterStorylyView(this.context, messenger, viewId, args as HashMap<String, Any>)
}

class FlutterStorylyView(
    private val context: Context,
    messenger: BinaryMessenger,
    viewId: Int,
    private val args: HashMap<String, Any>
) : PlatformView, StorylyListener {

    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.appsamurai.storyly/flutter_storyly_view_$viewId").apply {
        setMethodCallHandler { call, _ ->
            val callArguments = call.arguments as? Map<String, *>
            when (call.method) {
                "refresh" -> storylyView.refresh()
                "show" -> storylyView.show()
                "dismiss" -> storylyView.dismiss()
                "openStory" -> storylyView.openStory(
                    callArguments?.get("storyGroupId") as? String ?: "",
                    callArguments?.getOrElse("storyId") { null } as? String
                )
                "openStoryUri" -> storylyView.openStory(Uri.parse(callArguments?.get("uri") as? String))
                "hydrateProducts" -> (callArguments?.get("products") as? List<Map<String, Any?>>)?.let {
                    val products = it.map { product -> createSTRProductItem(product) }
                    storylyView.hydrateProducts(products)
                }
                "updateCart" -> (callArguments?.get("cart") as? Map<String, Any?>)?.let {
                    storylyView.updateCart(createSTRCart(it))
                }
            }
        }
    }

    private val storylyView: StorylyView by lazy {
        StorylyView(context).apply {
            storylyInit = getStorylyInit(json = args) ?: return@apply
            (args["storylyBackgroundColor"] as? String)?.let { setBackgroundColor(Color.parseColor(it)) }

            storylyProductListener = object : StorylyProductListener {
                override fun storylyEvent(
                    storylyView: StorylyView,
                    event: StorylyEvent
                ) {
                    methodChannel.invokeMethod(
                        "storylyProductEvent",
                        mapOf(
                            "event" to event.name,
                        )
                    )
                }

                override fun storylyHydration(
                    storylyView: StorylyView,
                    productIds: List<String>
                ) {
                    methodChannel.invokeMethod(
                        "storylyOnHydration",
                        mapOf(
                            "productIds" to productIds
                        )
                    )
                }

                override fun storylyUpdateCartEvent(
                    storylyView: StorylyView,
                    event: StorylyEvent,
                    cart: STRCart?,
                    change: STRCartItem?,
                    onSuccess: ((STRCart?) -> Unit)?,
                    onFail: ((STRCartEventResult) -> Unit)?
                ) {
                    methodChannel.invokeMethod(
                        "storylyOnCartUpdated",
                        mapOf(
                            "event" to event.name,
                            "cart" to createSTRCartMap(cart),
                            "change" to createSTRCartItemMap(change),
                        )
                    )
                }
            }

            storylyListener = object : StorylyListener {
                override fun storylyActionClicked(storylyView: StorylyView, story: Story) {
                    methodChannel.invokeMethod(
                        "storylyActionClicked",
                        createStoryMap(story)
                    )
                }

                override fun storylyLoaded(
                    storylyView: StorylyView,
                    storyGroupList: List<StoryGroup>,
                    dataSource: StorylyDataSource
                ) {
                    methodChannel.invokeMethod(
                        "storylyLoaded",
                        mapOf(
                            "storyGroups" to storyGroupList.map { storyGroup -> createStoryGroupMap(storyGroup) },
                            "dataSource" to dataSource.value
                        )
                    )
                }

                override fun storylyLoadFailed(
                    storylyView: StorylyView,
                    errorMessage: String
                ) {
                    methodChannel.invokeMethod("storylyLoadFailed", errorMessage)
                }

                override fun storylyEvent(
                    storylyView: StorylyView,
                    event: StorylyEvent,
                    storyGroup: StoryGroup?,
                    story: Story?,
                    storyComponent: StoryComponent?
                ) {
                    methodChannel.invokeMethod(
                        "storylyEvent",
                        mapOf("event" to event.name,
                            "storyGroup" to storyGroup?.let { createStoryGroupMap(storyGroup) },
                            "story" to story?.let { createStoryMap(story) },
                            "storyComponent" to storyComponent?.let { createStoryComponentMap(storyComponent) })
                    )
                }

                override fun storylyStoryShown(storylyView: StorylyView) {
                    methodChannel.invokeMethod("storylyStoryShown", null)
                }

                override fun storylyStoryDismissed(storylyView: StorylyView) {
                    methodChannel.invokeMethod("storylyStoryDismissed", null)
                }

                override fun storylyUserInteracted(
                    storylyView: StorylyView,
                    storyGroup: StoryGroup,
                    story: Story,
                    storyComponent: StoryComponent
                ) {
                    methodChannel.invokeMethod(
                        "storylyUserInteracted",
                        mapOf(
                            "storyGroup" to createStoryGroupMap(storyGroup),
                            "story" to createStoryMap(story),
                            "storyComponent" to createStoryComponentMap(storyComponent)
                        )
                    )
                }
            }
        }
    }

    override fun getView(): View = storylyView

    override fun dispose() {}

    private fun getStorylyInit(
        json: HashMap<String, Any>
    ): StorylyInit? {
        val storylyInitJson = json["storylyInit"] as? Map<String, *> ?: return null
        val storylyId = storylyInitJson["storylyId"] as? String ?: return null
        val storyGroupStylingJson = json["storyGroupStyling"] as? Map<String, *> ?: return null
        val storyBarStylingJson = json["storyBarStyling"] as? Map<String, *> ?: return null
        val storyStylingJson = json["storyStyling"] as? Map<String, *> ?: return null
        val storyShareConfigJson = json["storyShareConfig"] as? Map<String, *> ?: return null
        val storyProductConfigJson = json["storyProductConfig"] as? Map<String, *> ?: return null

        var storylyConfigBuilder = StorylyConfig.Builder()
        storylyConfigBuilder = stStorylyInit(json = storylyInitJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stStorylyGroupStyling(context = context, json = storyGroupStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stStoryBarStyling(json = storyBarStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stStoryStyling(context = context, json = storyStylingJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stShareConfig(json = storyShareConfigJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = stProductConfig(json = storyProductConfigJson, configBuilder = storylyConfigBuilder)
        storylyConfigBuilder = storylyConfigBuilder.setLayoutDirection(getStorylyLayoutDirection(json["storylyLayoutDirection"] as? String))

        return StorylyInit(
            storylyId = storylyId,
            config = storylyConfigBuilder
                .build()
        )
    }

    private fun stStorylyInit(
        json: Map<String, *>,
        configBuilder: StorylyConfig.Builder
    ): StorylyConfig.Builder {
        return configBuilder
            .setLabels((json["storylySegments"] as? List<String>)?.toSet())
            .setCustomParameter(json["customParameter"] as? String)
            .setTestMode(json["storylyIsTestMode"] as? Boolean ?: false)
            .setStorylyPayload(json["storylyPayload"] as? String)
            .setUserData(json["userProperty"] as? Map<String, String> ?: emptyMap())
    }

    private fun stStorylyGroupStyling(
        context: Context,
        json: Map<String, *>,
        configBuilder: StorylyConfig.Builder,
    ): StorylyConfig.Builder {
        var groupStylingBuilder = StorylyStoryGroupStyling.Builder()
        (json["iconBorderColorSeen"] as? List<String>?)?.let { groupStylingBuilder = groupStylingBuilder.setIconBorderColorSeen( it.map { hexColor ->Color.parseColor(hexColor) }) }
        (json["iconBorderColorNotSeen"] as? List<String>?)?.let { groupStylingBuilder = groupStylingBuilder.setIconBorderColorNotSeen( it.map { hexColor ->Color.parseColor(hexColor) }) }
        (json["iconBackgroundColor"] as? String)?.let { groupStylingBuilder = groupStylingBuilder.setIconBackgroundColor(Color.parseColor(it)) }
        (json["pinIconColor"] as? String)?.let { groupStylingBuilder = groupStylingBuilder.setPinIconColor(Color.parseColor(it)) }
        (json["iconHeight"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setIconHeight(it) } // dpToPixel(80)
        (json["iconWidth"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setIconWidth(it) } // dpToPixel(80)
        (json["iconCornerRadius"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setIconCornerRadius(it) } // dpToPixel(40)
        groupStylingBuilder = groupStylingBuilder.setIconBorderAnimation(getStoryGroupAnimation(json["iconBorderAnimation"] as? String))
        (json["titleSeenColor"] as? String)?.let { groupStylingBuilder = groupStylingBuilder.setTitleSeenColor(Color.parseColor(it)) }
        (json["titleNotSeenColor"] as? String)?.let { groupStylingBuilder = groupStylingBuilder.setTitleNotSeenColor(Color.parseColor(it)) }
        groupStylingBuilder = groupStylingBuilder.setTitleLineCount(json["titleLineCount"] as? Int)
        groupStylingBuilder.setTitleTypeface(getTypeface(context, json["titleFont"] as? String))
        (json["titleTextSize"] as? Int)?.let { groupStylingBuilder = groupStylingBuilder.setTitleTextSize(Pair(TypedValue.COMPLEX_UNIT_PX, it)) }
        groupStylingBuilder = groupStylingBuilder.setTitleVisibility(json["titleVisible"] as? Boolean ?: true)
        groupStylingBuilder = groupStylingBuilder.setSize(getStoryGroupSize(json["groupSize"] as? String))

        return configBuilder
            .setStoryGroupStyling(
                styling = groupStylingBuilder
                    .build()
            )
    }

    private fun stStoryBarStyling(
        json: Map<String, *>,
        configBuilder: StorylyConfig.Builder
    ): StorylyConfig.Builder {
        return configBuilder
            .setBarStyling(
                StorylyBarStyling.Builder()
                    .setOrientation(getStoryGroupListOrientation(json["orientation"] as? String))
                    .setSection(json["sections"] as? Int ?: 1)
                    .setHorizontalEdgePadding(json["horizontalEdgePadding"] as? Int ?: dpToPixel(4))
                    .setVerticalEdgePadding(json["verticalEdgePadding"] as? Int ?: dpToPixel(4))
                    .setHorizontalPaddingBetweenItems(json["horizontalPaddingBetweenItems"] as? Int ?: dpToPixel(8))
                    .setVerticalPaddingBetweenItems(json["verticalPaddingBetweenItems"] as? Int ?: dpToPixel(8))
                    .build()
            )
    }

    private fun stStoryStyling(
        context: Context,
        json: Map<String, *>,
        configBuilder: StorylyConfig.Builder
    ): StorylyConfig.Builder {
        var storyStylingBuilder = StorylyStoryStyling.Builder()
        (json["headerIconBorderColor"] as? List<String>?)?.let { storyStylingBuilder = storyStylingBuilder.setHeaderIconBorderColor( it.map { hexColor ->Color.parseColor(hexColor) }) }
        (json["titleColor"] as? String)?.let { storyStylingBuilder = storyStylingBuilder.setTitleColor(Color.parseColor(it)) }
        storyStylingBuilder.setTitleTypeface(getTypeface(context, json["titleFont"] as? String))
        storyStylingBuilder.setInteractiveTypeface(getTypeface(context, json["interactiveFont"] as? String))
        (json["progressBarColor"] as? List<String>?)?.let { storyStylingBuilder = storyStylingBuilder.setProgressBarColor( it.map { hexColor ->Color.parseColor(hexColor) }) }
        storyStylingBuilder = storyStylingBuilder.setTitleVisibility(json["isTitleVisible"] as? Boolean ?: true)
        storyStylingBuilder = storyStylingBuilder.setHeaderIconVisibility(json["isHeaderIconVisible"] as? Boolean ?: true)
        storyStylingBuilder = storyStylingBuilder.setCloseButtonVisibility(json["isCloseButtonVisible"] as? Boolean ?: true)
        storyStylingBuilder = storyStylingBuilder.setCloseButtonIcon(getDrawable(context, json["closeButtonIcon"] as? String))
        storyStylingBuilder = storyStylingBuilder.setShareButtonIcon(getDrawable(context, json["shareButtonIcon"] as? String))

        return configBuilder
            .setStoryStyling(
                storyStylingBuilder
                    .build()
            )
    }

    private fun stShareConfig(
        json: Map<String, *>,
        configBuilder: StorylyConfig.Builder
    ): StorylyConfig.Builder {
        var shareConfigBuilder = StorylyShareConfig.Builder()
        (json["storylyShareUrl"] as? String)?.let { shareConfigBuilder = shareConfigBuilder.setShareUrl(it) }
        (json["storylyFacebookAppID"] as? String)?.let { shareConfigBuilder = shareConfigBuilder.setFacebookAppID(it) }
        return configBuilder
            .setShareConfig(
                shareConfigBuilder
                    .build()
            )
    }

    private fun stProductConfig(
        json: Map<String, *>,
        configBuilder: StorylyConfig.Builder
    ): StorylyConfig.Builder {
        var productConfigBuilder = StorylyProductConfig.Builder()
        (json["isFallbackEnabled"] as? Boolean)?.let { productConfigBuilder = productConfigBuilder.setFallbackAvailability(it) }
        (json["isCartEnabled"] as? Boolean)?.let { productConfigBuilder = productConfigBuilder.setCartAvailability(it) }
        return configBuilder
            .setProductConfig(
                productConfigBuilder
                    .build()
            )
    }

    private fun getStoryGroupSize(size: String?): StoryGroupSize {
        return when (size) {
            "small" -> StoryGroupSize.Small
            "custom" -> StoryGroupSize.Custom
            else -> StoryGroupSize.Large
        }
    }

    private fun getStoryGroupAnimation(animation: String?): StoryGroupAnimation {
        return when (animation) {
            "border-rotation" -> StoryGroupAnimation.BorderRotation
            "disabled" -> StoryGroupAnimation.Disabled
            else -> StoryGroupAnimation.BorderRotation
        }
    }

    private fun getStoryGroupListOrientation(orientation: String?): StoryGroupListOrientation {
        return when (orientation) {
            "horizontal" -> StoryGroupListOrientation.Horizontal
            "vertical" -> StoryGroupListOrientation.Vertical
            else -> StoryGroupListOrientation.Horizontal
        }
    }

    private fun getStorylyLayoutDirection(layoutDirection: String?): StorylyLayoutDirection {
        return when (layoutDirection) {
            "ltr" -> StorylyLayoutDirection.LTR
            "rtl" -> StorylyLayoutDirection.RTL
            else -> StorylyLayoutDirection.LTR
        }
    }

    private fun createStoryGroupMap(storyGroup: StoryGroup): Map<String, *> {
        return mapOf(
            "id" to storyGroup.uniqueId,
            "title" to storyGroup.title,
            "index" to storyGroup.index,
            "seen" to storyGroup.seen,
            "iconUrl" to storyGroup.iconUrl,
            "stories" to storyGroup.stories.map { story -> createStoryMap(story) },
            "thematicIconUrls" to storyGroup.thematicIconUrls,
            "coverUrl" to storyGroup.coverUrl,
            "pinned" to storyGroup.pinned,
            "type" to storyGroup.type.ordinal,
        )
    }

    private fun createStoryMap(story: Story): Map<String, *> {
        return mapOf("id" to story.uniqueId,
            "title" to story.title,
            "name" to story.name,
            "index" to story.index,
            "seen" to story.seen,
            "currentTime" to story.currentTime,
            "media" to story.media.let {
                mapOf(
                    "type" to it.type.ordinal,
                    "actionUrlList" to it.actionUrlList,
                    "actionUrl" to it.actionUrl,
                    "previewUrl" to it.previewUrl,
                    "storyComponentList" to it.storyComponentList?.map { component -> createStoryComponentMap(component) }
                )
            }
        )
    }

    private fun createStoryComponentMap(storyComponent: StoryComponent): Map<String, *> {
        when (storyComponent) {
            is StoryQuizComponent -> {
                return mapOf(
                    "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                    "id" to storyComponent.id,
                    "title" to storyComponent.title,
                    "options" to storyComponent.options,
                    "rightAnswerIndex" to storyComponent.rightAnswerIndex,
                    "selectedOptionIndex" to storyComponent.selectedOptionIndex,
                    "customPayload" to storyComponent.customPayload
                )
            }
            is StoryPollComponent -> {
                return mapOf(
                    "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                    "id" to storyComponent.id,
                    "title" to storyComponent.title,
                    "options" to storyComponent.options,
                    "selectedOptionIndex" to storyComponent.selectedOptionIndex,
                    "customPayload" to storyComponent.customPayload
                )
            }
            is StoryEmojiComponent -> {
                return mapOf(
                    "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                    "id" to storyComponent.id,
                    "emojiCodes" to storyComponent.emojiCodes,
                    "selectedEmojiIndex" to storyComponent.selectedEmojiIndex,
                    "customPayload" to storyComponent.customPayload
                )
            }
            is StoryRatingComponent -> {
                return mapOf(
                    "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                    "id" to storyComponent.id,
                    "emojiCode" to storyComponent.emojiCode,
                    "rating" to storyComponent.rating,
                    "customPayload" to storyComponent.customPayload
                )
            }
            is StoryPromoCodeComponent -> {
                return mapOf(
                    "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                    "id" to storyComponent.id,
                    "text" to storyComponent.text
                )
            }
            is StoryCommentComponent -> {
                return mapOf(
                    "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                    "id" to storyComponent.id,
                    "text" to storyComponent.text
                )
            }
            else -> {
                return mapOf(
                    "type" to storyComponent.type.name.lowercase(Locale.ENGLISH),
                    "id" to storyComponent.id,
                )
            }
        }
    }

    internal fun createSTRProductItemMap(product: STRProductItem?): Map<String, *> {
        product ?: return emptyMap<String, Any>()
        return mapOf(
            "productId" to product.productId,
            "productGroupId" to product.productGroupId,
            "title" to product.title,
            "desc" to product.desc,
            "price" to product.price.toDouble(),
            "salesPrice" to product.salesPrice?.toDouble(),
            "currency" to product.currency,
            "imageUrls" to product.imageUrls,
            "variants" to product.variants.map {
                createSTRProductVariantMap(it)
            }
        )
    }

    private fun createSTRProductVariantMap(variant: STRProductVariant): Map<String, *> {
        return mapOf(
            "name" to variant.name,
            "value" to variant.value
        )
    }

    private fun createSTRProductItem(product: Map<String, Any?>?): STRProductItem {
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

    private fun createSTRProductVariant(variants: List<Map<String, Any?>>?): List<STRProductVariant> {
        return variants?.map { variant ->
            STRProductVariant(
                name = variant["name"] as? String ?: "",
                value = variant["value"] as? String ?: ""
            )
        } ?: listOf()
    }

    internal fun createSTRCartMap(cart: STRCart?): Map<String, *> {
        cart ?: return emptyMap<String, Any>()
        return mapOf(
            "items" to cart.items.map { createSTRCartItemMap(it) },
            "oldTotalPrice" to cart.oldTotalPrice,
            "totalPrice" to cart.totalPrice,
            "currency" to cart.currency
        )
    }

    internal fun createSTRCartItemMap(cartItem: STRCartItem?): Map<String, *> {
        cartItem ?: return emptyMap<String, Any>()
        return mapOf(
            "item" to createSTRProductItemMap(cartItem.item),
            "quantity" to cartItem.quantity,
            "oldTotalPrice" to cartItem.oldTotalPrice,
            "totalPrice" to cartItem.totalPrice
        )
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

    private fun dpToPixel(dpValue: Int): Int {
        return (dpValue * (Resources.getSystem().displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)).toInt()
    }

    private fun getTypeface(context: Context, fontName: String?): Typeface {
        fontName ?: return Typeface.DEFAULT
        return try {
            Typeface.createFromAsset(context.assets, fontName)
        } catch (_: Exception) {
            Typeface.DEFAULT
        }
    }

    private fun getDrawable(context: Context, name: String?): Drawable? {
        name ?: return null
        return ContextCompat.getDrawable(context, context.resources.getIdentifier(name, "drawable", context.packageName))
    }
}