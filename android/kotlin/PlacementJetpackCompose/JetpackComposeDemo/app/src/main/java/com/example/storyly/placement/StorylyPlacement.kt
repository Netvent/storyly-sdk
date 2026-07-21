package com.example.storyly.placement

import android.util.Log
import androidx.compose.animation.animateContentSize
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import com.appsamurai.storyly.core.data.model.STRPayload
import com.appsamurai.storyly.core.ui.STRWidgetController
import com.appsamurai.storyly.placement.data.provider.STRPlacementDataProvider
import com.appsamurai.storyly.placement.ui.STRListener
import com.appsamurai.storyly.placement.ui.STRPlacementView

private const val TAG = "StorylyPlacement"

/**
 * Renders a Storyly placement inside Jetpack Compose.
 *
 * The [dataProvider] is owned by the caller: create it once (`remember { … }` or in a
 * ViewModel), set its `config` (token) and listeners at that upper level, and pass it
 * in. Hoisting it keeps the placement warm across recomposition and lazy-list
 * recycling — the provider (and its already-loaded data) survives, so re-entering
 * composition rebinds the view instead of re-fetching.
 *
 * The provider instance is expected to be stable for this call site; if you ever need
 * to swap it (e.g. change token/widget), wrap the call in `key(dataProvider) { … }`.
 *
 * Storyly ships its widget as a classic Android View ([STRPlacementView]); this
 * composable bridges it with [AndroidView] and drives the view height from the
 * SDK-reported aspect ratio.
 *
 * @param dataProvider caller-owned provider, already configured with a token.
 * @param modifier applied to the hosting [AndroidView].
 */
@Composable
fun StorylyPlacement(
    dataProvider: STRPlacementDataProvider,
    modifier: Modifier = Modifier,
) {
    var aspectRatio by remember { mutableStateOf<Float?>(null) }
    var placementVisible by remember { mutableStateOf(true) }

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
