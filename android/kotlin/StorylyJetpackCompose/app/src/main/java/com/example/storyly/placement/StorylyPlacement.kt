package com.example.storyly.placement

import android.util.Log
import androidx.compose.animation.animateContentSize
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.key
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import com.appsamurai.storyly.core.analytics.error.STRErrorPayload
import com.appsamurai.storyly.core.analytics.event.STREventPayload
import com.appsamurai.storyly.core.analytics.product.STRProductEvent
import com.appsamurai.storyly.core.config.placement.STRPlacementConfig
import com.appsamurai.storyly.core.config.placement.STRProductConfig
import com.appsamurai.storyly.core.data.model.STRDataPayload
import com.appsamurai.storyly.core.data.model.STRDataSource
import com.appsamurai.storyly.core.data.model.STRPayload
import com.appsamurai.storyly.core.data.model.product.STRCartItem
import com.appsamurai.storyly.core.data.model.product.STRProductInformation
import com.appsamurai.storyly.core.data.model.product.STRProductItem
import com.appsamurai.storyly.core.listener.log.STRLog
import com.appsamurai.storyly.core.listener.log.StorylyLogLevel
import com.appsamurai.storyly.core.listener.log.StorylyLogListener
import com.appsamurai.storyly.core.listener.provider.STRDataProviderListener
import com.appsamurai.storyly.core.listener.provider.STRDataProviderProductListener
import com.appsamurai.storyly.core.ui.STRWidgetController
import com.appsamurai.storyly.placement.data.provider.STRPlacementDataProvider
import com.appsamurai.storyly.placement.ui.STRListener
import com.appsamurai.storyly.placement.ui.STRPlacementView
import com.appsamurai.storyly.placement.ui.STRProductListener

private const val TAG = "StorylyPlacement"

/**
 * Renders a Storyly placement inside Jetpack Compose.
 *
 * Storyly ships its widgets as a classic Android [android.view.View]
 * ([STRPlacementView]), so this composable bridges it into Compose with
 * [AndroidView] — the same integration the SDK showcase demonstrates for the View
 * system.
 *
 * The typical usage is:
 * 1. Create an [STRPlacementDataProvider] and set its `config` (with your token) —
 *    this kicks off the network request for the placement.
 * 2. Create an [STRPlacementView] bound to that data provider and attach the
 *    [STRListener] / [STRProductListener] callbacks.
 *
 * @param token the placement token identifying which widget to render.
 * @param modifier applied to the hosting [AndroidView].
 */
@Composable
fun StorylyPlacement(
    token: String,
    modifier: Modifier = Modifier,
) {
    key(token) {
        val context = LocalContext.current

        var aspectRatio by remember { mutableStateOf<Float?>(null) }
        var placementVisible by remember { mutableStateOf(true) }

        val dataProvider = remember {
            STRPlacementDataProvider(context.applicationContext).apply {
                listener = object : STRDataProviderListener {
                    override fun onLoad(data: STRDataPayload, dataSource: STRDataSource) {
                        Log.d(TAG, "onLoad: dataSource=${dataSource.name}")
                    }

                    override fun onLoadFail(errorMessage: String) {
                        Log.d(TAG, "onLoadFail: $errorMessage")
                    }
                }
                config = STRPlacementConfig.Builder()
                    .build(token = token)
            }
        }

        val ratio = aspectRatio
        val sizeModifier = when {
            placementVisible && ratio != null -> Modifier.aspectRatio(ratio)
            else -> Modifier.height(0.dp)
        }

        AndroidView(
            modifier = modifier
                .fillMaxWidth()
                .then(sizeModifier)
                .animateContentSize(),
            factory = { context ->
                STRPlacementView(context, dataProvider = dataProvider).apply {
                    listener = object : STRListener {
                        override fun onActionClicked(
                            widget: STRWidgetController,
                            url: String,
                            payload: STRPayload,
                        ) {
                            Log.d(TAG, "onActionClicked: type=${widget.getType()}, url=$url")
                        }

                        override fun onVisibilityChange(
                            widget: STRWidgetController?,
                            isVisible: Boolean,
                        ) {
                            placementVisible = isVisible
                        }

                        override fun onWidgetReady(widget: STRWidgetController, ratio: Float) {
                            aspectRatio = ratio
                        }
                    }
                }
            },
        )
    }
}
