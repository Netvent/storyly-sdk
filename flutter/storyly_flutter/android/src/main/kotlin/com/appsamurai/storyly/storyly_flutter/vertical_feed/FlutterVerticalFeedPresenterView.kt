package com.appsamurai.storyly.storyly_flutter.vertical_feed


import android.content.Context
import android.view.View
import com.appsamurai.storyly.StorylyDataSource
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.analytics.VerticalFeedEvent
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartEventResult
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.appsamurai.storyly.data.managers.product.STRProductInformation
import com.appsamurai.storyly.storyly_flutter.createSTRCart
import com.appsamurai.storyly.storyly_flutter.createSTRCartItemMap
import com.appsamurai.storyly.storyly_flutter.createSTRCartMap
import com.appsamurai.storyly.storyly_flutter.createSTRProductInformationMap
import com.appsamurai.storyly.storyly_flutter.createSTRProductItem
import com.appsamurai.storyly.verticalfeed.StorylyVerticalFeedPresenterView
import com.appsamurai.storyly.verticalfeed.VerticalFeedGroup
import com.appsamurai.storyly.verticalfeed.VerticalFeedItem
import com.appsamurai.storyly.verticalfeed.VerticalFeedItemComponent
import com.appsamurai.storyly.verticalfeed.listener.StorylyVerticalFeedPresenterListener
import com.appsamurai.storyly.verticalfeed.listener.StorylyVerticalFeedPresenterProductListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.UUID


class FlutterVerticalFeedPresenterViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    internal lateinit var context: Context

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView = FlutterVerticalFeedPresenterView(this.context, messenger, viewId, args as HashMap<String, Any>)
}

class FlutterVerticalFeedPresenterView(
    private val context: Context,
    messenger: BinaryMessenger,
    viewId: Int,
    private val args: HashMap<String, Any>
) : PlatformView, StorylyListener {

    private var cartUpdateSuccessFailCallbackMap: MutableMap<String, Pair<((STRCart?) -> Unit)?, ((STRCartEventResult) -> Unit)?>> = mutableMapOf()

    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.appsamurai.storyly/flutter_vertical_feed_presenter_$viewId").apply {
        setMethodCallHandler { call, _ ->
            val callArguments = call.arguments as? Map<String, *>
            when (call.method) {
                "refresh" -> verticalFeedView.refresh()
                "pause" -> verticalFeedView.pause()
                "play" -> verticalFeedView.play()
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
            }
        }
    }

    private val verticalFeedView: StorylyVerticalFeedPresenterView by lazy {
        StorylyVerticalFeedPresenterView(context).apply {
            storylyVerticalFeedInit = VerticalFeedInitMapper(context).getStorylyInit(json = args) ?: return@apply

            storylyVerticalFeedProductListener = object : StorylyVerticalFeedPresenterProductListener {
                override fun verticalFeedEvent(
                    view: StorylyVerticalFeedPresenterView,
                    event: VerticalFeedEvent
                ) {
                    methodChannel.invokeMethod(
                        "verticalFeedEvent",
                        mapOf(
                            "event" to event.name,
                        )
                    )
                }

                override fun verticalFeedHydration(
                    view: StorylyVerticalFeedPresenterView,
                    products: List<STRProductInformation>
                ) {
                    methodChannel.invokeMethod(
                        "verticalFeedOnHydration",
                        mapOf(
                            "products" to products.map { createSTRProductInformationMap(it) }
                        )
                    )
                }

                override fun verticalFeedUpdateCartEvent(
                    view: StorylyVerticalFeedPresenterView,
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
            }

            storylyVerticalFeedListener = object : StorylyVerticalFeedPresenterListener {

                override fun verticalFeedLoaded(
                    view: StorylyVerticalFeedPresenterView,
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
                    view: StorylyVerticalFeedPresenterView,
                    errorMessage: String
                ) {
                    methodChannel.invokeMethod("verticalFeedLoadFailed", errorMessage)
                }

                override fun verticalFeedEvent(
                    view: StorylyVerticalFeedPresenterView,
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

                override fun verticalFeedShown(view: StorylyVerticalFeedPresenterView) {
                    methodChannel.invokeMethod("verticalFeedShown", null)
                }

                override fun verticalFeedShowFailed(
                    view: StorylyVerticalFeedPresenterView,
                    errorMessage: String
                ) {
                    methodChannel.invokeMethod("verticalFeedShowFailed", errorMessage)
                }

                override fun verticalFeedDismissed(view: StorylyVerticalFeedPresenterView) {
                    methodChannel.invokeMethod("verticalFeedDismissed", null)
                }

                override fun verticalFeedActionClicked(
                    view: StorylyVerticalFeedPresenterView,
                    feedItem: VerticalFeedItem
                ) {
                    methodChannel.invokeMethod(
                        "verticalFeedActionClicked",
                        createStoryMap(feedItem)
                    )
                }

                override fun verticalFeedUserInteracted(
                    view: StorylyVerticalFeedPresenterView,
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
