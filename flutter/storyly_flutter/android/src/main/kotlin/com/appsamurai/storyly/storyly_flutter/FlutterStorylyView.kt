package com.appsamurai.storyly.storyly_flutter

import android.content.Context
import android.graphics.Color
import android.net.Uri
import android.view.View
import com.appsamurai.storyly.Story
import com.appsamurai.storyly.StoryComponent
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StorylyDataSource
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.StorylyProductListener
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storyly.analytics.StorylyEvent
import com.appsamurai.storyly.data.managers.product.STRCart
import com.appsamurai.storyly.data.managers.product.STRCartEventResult
import com.appsamurai.storyly.data.managers.product.STRCartItem
import com.appsamurai.storyly.data.managers.product.STRProductInformation
import com.appsamurai.storyly.data.managers.product.STRProductItem
import com.appsamurai.storyly.data.managers.product.STRWishlistEventResult
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.UUID

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

    private var cartUpdateSuccessFailCallbackMap: MutableMap<String, Pair<((STRCart?) -> Unit)?, ((STRCartEventResult) -> Unit)?>> = mutableMapOf()
    private var wishlistUpdateSuccessFailCallbackMap: MutableMap<String, Pair<((STRProductItem?) -> Unit)?, ((STRWishlistEventResult) -> Unit)?>> = mutableMapOf()

    private val methodChannel: MethodChannel = MethodChannel(messenger, "com.appsamurai.storyly/flutter_storyly_view_$viewId").apply {
        setMethodCallHandler { call, _ ->
            val callArguments = call.arguments as? Map<String, *>
            when (call.method) {
                "refresh" -> storylyView.refresh()
                "resumeStory" -> storylyView.resumeStory()
                "pauseStory" -> storylyView.pauseStory()
                "closeStory" -> storylyView.closeStory()
                "openStory" -> storylyView.openStory(
                    callArguments?.get("storyGroupId") as? String ?: "",
                    callArguments?.getOrElse("storyId") { null } as? String
                )

                "openStoryUri" -> storylyView.openStory(Uri.parse(callArguments?.get("uri") as? String))
                "hydrateProducts" -> (callArguments?.get("products") as? List<Map<String, Any?>>)?.let {
                    val products = it.map { product -> createSTRProductItem(product) }
                    storylyView.hydrateProducts(products)
                }

                "hydrateWishlist" -> (callArguments?.get("products") as? List<Map<String, Any?>>)?.let {
                    val products = it.map { product -> createSTRProductItem(product) }
                    storylyView.hydrateWishlist(products)
                }

                "updateCart" -> (callArguments?.get("cart") as? Map<String, Any?>)?.let {
                    storylyView.updateCart(createSTRCart(it))
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
                    wishlistUpdateSuccessFailCallbackMap.remove(it)
                }

                "rejectWishlistChange" -> (callArguments?.get("responseId") as? String)?.let {
                    val onFail = wishlistUpdateSuccessFailCallbackMap[it]?.second
                    (callArguments["failMessage"] as? String)?.let { failMessage ->
                        onFail?.invoke(STRWishlistEventResult(failMessage))
                    }
                    wishlistUpdateSuccessFailCallbackMap.remove(it)
                }
            }
        }
    }

    private val storylyView: StorylyView by lazy {
        StorylyView(context).apply {
            storylyInit = StorylyInitMapper(context).getStorylyInit(json = args) ?: return@apply
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
                    products: List<STRProductInformation>
                ) {
                    methodChannel.invokeMethod(
                        "storylyOnHydration",
                        mapOf(
                            "products" to products.map { createSTRProductInformationMap(it) }
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
                    val responseId = UUID.randomUUID().toString()
                    cartUpdateSuccessFailCallbackMap[responseId] = Pair(onSuccess, onFail)

                    methodChannel.invokeMethod(
                        "storylyOnProductCartUpdated",
                        mapOf(
                            "event" to event.name,
                            "cart" to createSTRCartMap(cart),
                            "change" to createSTRCartItemMap(change),
                            "responseId" to responseId
                        )
                    )
                }

                override fun storylyUpdateWishlistEvent(
                    storylyView: StorylyView,
                    item: STRProductItem?,
                    event: StorylyEvent,
                    onSuccess: ((STRProductItem?) -> Unit)?,
                    onFail: ((STRWishlistEventResult) -> Unit)?
                ) {
                    val responseId = UUID.randomUUID().toString()
                    wishlistUpdateSuccessFailCallbackMap[responseId] = Pair(onSuccess, onFail)

                    methodChannel.invokeMethod(
                        "storylyOnWishlistUpdated",
                        mapOf(
                            "event" to event.name,
                            "item" to createSTRProductItemMap(item),
                            "responseId" to responseId
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

                override fun storylySizeChanged(
                    storylyView: StorylyView,
                    size: Pair<Int, Int>
                ) {
                    methodChannel.invokeMethod(
                        "storylySizeChanged",
                        mapOf(
                            "width" to size.first.toFloat(),
                            "height" to size.second.toFloat()
                        )
                    )
                }
            }
        }
    }

    override fun getView(): View = storylyView

    override fun dispose() {}
}
