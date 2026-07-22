package com.appsamurai.storylytwiliosample

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.Story
import com.appsamurai.storyly.StoryComponent
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StorylyDataSource
import com.appsamurai.storyly.StorylyInit
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
import com.appsamurai.storylytwiliosample.databinding.ActivityMainBinding

/**
 * Hosts a StorylyView and forwards every Storyly event to Twilio Segment.
 *
 * The Activity implements both listeners:
 *  - [StorylyListener] for story & interactive events
 *  - [StorylyProductListener] for commerce (cart / wishlist / product) events
 */
class MainActivity : AppCompatActivity(), StorylyListener, StorylyProductListener {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        SegmentManager.initialize(applicationContext)

        binding.storylyView.apply {
            storylyListener = this@MainActivity
            storylyProductListener = this@MainActivity
            storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        }
    }

    // region StorylyListener — story & interactive events

    override fun storylyLoaded(
        storylyView: StorylyView,
        storyGroupList: List<StoryGroup>,
        dataSource: StorylyDataSource
    ) {
        Log.d(TAG, "storylyLoaded: ${storyGroupList.size} group(s), source: $dataSource")

        // Identify the current user once Storyly has data. Replace this dummy
        // user with your real user id/traits in a production integration.
        SegmentManager.identify(
            "demo-user-123",
            mapOf(
                "name" to "Demo User",
                "email" to "demo.user@example.com",
                "plan" to "free"
            )
        )
    }

    override fun storylyEvent(
        storylyView: StorylyView,
        event: StorylyEvent,
        storyGroup: StoryGroup?,
        story: Story?,
        storyComponent: StoryComponent?
    ) {
        Log.d(TAG, "storylyEvent: ${event.name}")

        // Forward every Storyly event to Segment as a `track` call. The event
        // name becomes the Segment event; the story context becomes properties.
        val properties = SegmentEventMapper.properties(event, storyGroup, story, storyComponent)
        SegmentManager.track(event.name, properties)
    }

    // endregion

    // region StorylyProductListener — commerce events

    // Cart events (add / update / remove). Map the cart context to Segment
    // properties, forward it as a `track` call, then confirm the operation so
    // the Storyly UI can proceed. In a real integration you'd apply the change
    // to your own cart and return the updated STRCart via onSuccess.
    override fun storylyUpdateCartEvent(
        storylyView: StorylyView,
        event: StorylyEvent,
        cart: STRCart?,
        change: STRCartItem?,
        onSuccess: ((STRCart?) -> Unit)?,
        onFail: ((STRCartEventResult) -> Unit)?
    ) {
        Log.d(TAG, "storylyUpdateCartEvent: ${event.name}")

        val properties = SegmentEventMapper.cartProperties(event, cart, change)
        SegmentManager.track(event.name, properties)

        // Optimistically accept the change in this demo.
        onSuccess?.invoke(cart)
    }

    // Wishlist events (add / remove). Same pattern as the cart events.
    override fun storylyUpdateWishlistEvent(
        storylyView: StorylyView,
        item: STRProductItem?,
        event: StorylyEvent,
        onSuccess: ((STRProductItem?) -> Unit)?,
        onFail: ((STRWishlistEventResult) -> Unit)?
    ) {
        Log.d(TAG, "storylyUpdateWishlistEvent: ${event.name}")

        val properties = SegmentEventMapper.wishlistProperties(event, item)
        SegmentManager.track(event.name, properties)

        // Optimistically accept the change in this demo.
        onSuccess?.invoke(item)
    }

    // Product events that are neither cart mutations nor wishlist updates
    // (e.g. StoryProductSheetOpened, StoryCheckoutButtonClicked) arrive here
    // with just the event. Map and track them like the others.
    override fun storylyEvent(storylyView: StorylyView, event: StorylyEvent) {
        Log.d(TAG, "storylyEvent (product): ${event.name}")

        val properties = SegmentEventMapper.properties(event, null, null, null)
        SegmentManager.track(event.name, properties)
    }

    // Called with the product ids found in the stories so the app can supply
    // full product data. This demo has no catalog, so we just log the request.
    override fun storylyHydration(storylyView: StorylyView, products: List<STRProductInformation>) {
        Log.d(TAG, "storylyHydration: ${products.size} product(s) requested")
    }

    // endregion

    companion object {
        private const val TAG = "StorylyTwilio"
    }
}
