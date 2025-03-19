package com.appsamurai.storyly.storyly_flutter.vertical_feed

import android.content.Context
import android.net.Uri
import android.view.View
import com.appsamurai.storyly.StorylyDataSource
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.analytics.VerticalFeedEvent
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartEventResult
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.appsamurai.storyly.data.managers.product.STRProductInformation
import com.appsamurai.storyly.data.managers.product.STRProductItem
import com.appsamurai.storyly.data.managers.product.STRWishlistEventResult
import com.appsamurai.storyly.storyly_flutter.createSTRCart
import com.appsamurai.storyly.storyly_flutter.createSTRCartItemMap
import com.appsamurai.storyly.storyly_flutter.createSTRCartMap
import com.appsamurai.storyly.storyly_flutter.createSTRProductInformationMap
import com.appsamurai.storyly.storyly_flutter.createSTRProductItem
import com.appsamurai.storyly.storyly_flutter.createSTRProductItemMap
import com.appsamurai.storyly.verticalfeed.StorylyVerticalFeedView
import com.appsamurai.storyly.verticalfeed.VerticalFeedGroup
import com.appsamurai.storyly.verticalfeed.VerticalFeedItem
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemComponent
import com.appsamurai.storyly.verticalfeed.core.STRVerticalFeedView
import com.appsamurai.storyly.verticalfeed.listener.StorylyVerticalFeedListener
import com.appsamurai.storyly.verticalfeed.listener.StorylyVerticalFeedProductListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.UUID

class FlutterVerticalFeedViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    internal lateinit var context: Context

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView = FlutterVerticalFeedView(this.context, messenger, viewId, args as HashMap<String, Any>)
}

class FlutterVerticalFeedView(
    private val context: Context,
    messenger: BinaryMessenger,
    viewId: Int,
    private val args: HashMap<String, Any>
) : PlatformView, StorylyListener {

    private var cartUpdateSuccessFailCallbackMap: MutableMap<String, Pair<((STRCart?) -> Unit)?, ((STRCartEventResult) -> Unit)?>> = mutableMapOf()
    private var wishlistUpdateSuccessFailCallbackMap: MutableMap<String, Pair<((STRProductItem?) -> Unit)?, ((STRWishlistEventResult) -> Unit)?>> = mutableMapOf()

    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.appsamurai.storyly/flutter_vertical_feed_$viewId").apply {
        setMethodCallHandler { call, _ ->
            val callArguments = call.arguments as? Map<String, *>
            when (call.method) {
                "refresh" -> verticalFeedView.refresh()
                "resumeStory" -> verticalFeedView.resumeStory()
                "pauseStory" -> verticalFeedView.pauseStory()
                "closeStory" -> verticalFeedView.closeStory()
                "openStory" -> verticalFeedView.openStory(
                    callArguments?.get("storyGroupId") as? String ?: "",
                    callArguments?.getOrElse("storyId") { null } as? String
                )

                "openStoryUri" -> verticalFeedView.openStory(Uri.parse(callArguments?.get("uri") as? String))
                "hydrateProducts" -> (callArguments?.get("products") as? List<Map<String, Any?>>)?.let {
                    val products = it.map { product -> createSTRProductItem(product) }
                    verticalFeedView.hydrateProducts(products)
                }

                "updateCart" -> (callArguments?.get("cart") as? Map<String, Any?>)?.let {
                    verticalFeedView.updateCart(createSTRCart(it))
                }

                "approveCartChange" -> (callArguments?.get("responseId") as? String)?.let {
                    val onSuccess = cartUpdateSuccessFailCallbackMap[it]?.first
                    (callArguments["cart"] as? Map<String, Any?>)?.let { cartMap ->
                        onSuccess?.invoke(createSTRCart(cartMap))
                    } ?: kotlin.run {
                        onSuccess?.invoke(null)
                    }
                    cartUpdateSuccessFailCallbackMap.remove(it)
                }

                "rejectCartChange" -> (callArguments?.get("responseId") as? String)?.let {
                    val onFail = cartUpdateSuccessFailCallbackMap[it]?.second
                    (callArguments["failMessage"] as? String)?.let { failMessage ->
                        onFail?.invoke(STRCartEventResult(failMessage))
                    }
                    cartUpdateSuccessFailCallbackMap.remove(it)
                }

                "approveWishlistChange" -> (callArguments?.get("responseId") as? String)?.let {
                    val onSuccess = wishlistUpdateSuccessFailCallbackMap[it]?.first
                    (callArguments["item"] as? Map<String, Any?>)?.let { item ->
                        onSuccess?.invoke(createSTRProductItem(item))
                    } ?: kotlin.run {
                        onSuccess?.invoke(null)
                    }
                    cartUpdateSuccessFailCallbackMap.remove(it)
                }

                "rejectWishlistChange" -> (callArguments?.get("responseId") as? String)?.let {
                    val onFail = wishlistUpdateSuccessFailCallbackMap[it]?.second
                    (callArguments["failMessage"] as? String)?.let { failMessage ->
                        onFail?.invoke(STRWishlistEventResult(failMessage))
                    }
                    cartUpdateSuccessFailCallbackMap.remove(it)
                }
            }
        }
    }

    private val verticalFeedView: StorylyVerticalFeedView by lazy {
        StorylyVerticalFeedView(context).apply {
            storylyVerticalFeedInit = VerticalFeedInitMapper(context).getStorylyInit(json = args) ?: return@apply

            storylyVerticalFeedProductListener = object : StorylyVerticalFeedProductListener {
                override fun verticalFeedEvent(
                    view: STRVerticalFeedView,
                    event: VerticalFeedEvent
                ) {
                    methodChannel.invokeMethod(
                        "verticalFeedProductEvent",
                        mapOf(
                            "event" to event.name,
                        )
                    )
                }

                override fun verticalFeedHydration(
                    view: STRVerticalFeedView,
                    products: List<STRProductInformation>
                ) {
                    methodChannel.invokeMethod(
                        "verticalFeedOnProductHydration",
                        mapOf(
                            "products" to products.map { createSTRProductInformationMap(it) }
                        )
                    )
                }

                override fun verticalFeedUpdateCartEvent(
                    view: STRVerticalFeedView,
                    event: VerticalFeedEvent,
                    cart: STRCart?,
                    change: STRCartItem?,
                    onSuccess: ((STRCart?) -> Unit)?,
                    onFail: ((STRCartEventResult) -> Unit)?
                ) {
                    val responseId = UUID.randomUUID().toString()
                    cartUpdateSuccessFailCallbackMap[responseId] = Pair(onSuccess, onFail)

                    methodChannel.invokeMethod(
                        "verticalFeedOnProductCartUpdated",
                        mapOf(
                            "event" to event.name,
                            "cart" to createSTRCartMap(cart),
                            "change" to createSTRCartItemMap(change),
                            "responseId" to responseId
                        )
                    )
                }

                override fun verticalFeedUpdateWishlistEvent(
                    view: STRVerticalFeedView,
                    item: STRProductItem?,
                    event: VerticalFeedEvent,
                    onSuccess: ((STRProductItem?) -> Unit)?,
                    onFail: ((STRWishlistEventResult) -> Unit)?
                ) {
                    val responseId = UUID.randomUUID().toString()
                    wishlistUpdateSuccessFailCallbackMap[responseId] = Pair(onSuccess, onFail)

                    methodChannel.invokeMethod(
                        "verticalFeedOnWishlistUpdated",
                        mapOf(
                            "event" to event.name,
                            "item" to createSTRProductItemMap(item),
                            "responseId" to responseId
                        )
                    )
                }
            }

            storylyVerticalFeedListener = object : StorylyVerticalFeedListener {

                override fun verticalFeedLoaded(
                    view: STRVerticalFeedView,
                    feedGroupList: List<VerticalFeedGroup>,
                    dataSource: StorylyDataSource
                ) {
                    methodChannel.invokeMethod(
                        "verticalFeedLoaded",
                        mapOf(
                            "feedGroupList" to feedGroupList.map { storyGroup -> createStoryGroupMap(storyGroup) },
                            "dataSource" to dataSource.value
                        )
                    )
                }

                override fun verticalFeedLoadFailed(
                    view: STRVerticalFeedView,
                    errorMessage: String
                ) {
                    methodChannel.invokeMethod("verticalFeedLoadFailed", errorMessage)
                }

                override fun verticalFeedEvent(
                    view: STRVerticalFeedView,
                    event: VerticalFeedEvent,
                    feedGroup: VerticalFeedGroup?,
                    feedItem: VerticalFeedItem?,
                    feedItemComponent: VerticalFeedItemComponent?
                ) {
                    methodChannel.invokeMethod(
                        "verticalFeedEvent",
                        mapOf("event" to event.name,
                            "feedGroup" to feedGroup?.let { createStoryGroupMap(feedGroup) },
                            "feedItem" to feedItem?.let { createStoryMap(feedItem) },
                            "feedItemComponent" to feedItemComponent?.let { createStoryComponentMap(feedItemComponent) })
                    )
                }

                override fun verticalFeedShown(view: STRVerticalFeedView) {
                    methodChannel.invokeMethod("verticalFeedShown", null)
                }

                override fun verticalFeedShowFailed(
                    view: STRVerticalFeedView,
                    errorMessage: String
                ) {
                    methodChannel.invokeMethod("verticalFeedShowFailed", errorMessage)
                }

                override fun verticalFeedDismissed(view: STRVerticalFeedView) {
                    methodChannel.invokeMethod("verticalFeedDismissed", null)
                }

                override fun verticalFeedActionClicked(
                    view: STRVerticalFeedView,
                    feedItem: VerticalFeedItem
                ) {
                    methodChannel.invokeMethod(
                        "verticalFeedActionClicked",
                        createStoryMap(feedItem)
                    )
                }

                override fun verticalFeedUserInteracted(
                    view: STRVerticalFeedView,
                    feedGroup: VerticalFeedGroup,
                    feedItem: VerticalFeedItem,
                    feedItemComponent: VerticalFeedItemComponent
                ) {
                    methodChannel.invokeMethod(
                        "verticalFeedUserInteracted",
                        mapOf(
                            "feedGroup" to createStoryGroupMap(feedGroup),
                            "feedItem" to createStoryMap(feedItem),
                            "feedItemComponent" to createStoryComponentMap(feedItemComponent)
                        )
                    )
                }
            }
        }
    }

    override fun getView(): View = verticalFeedView

    override fun dispose() {}
}
