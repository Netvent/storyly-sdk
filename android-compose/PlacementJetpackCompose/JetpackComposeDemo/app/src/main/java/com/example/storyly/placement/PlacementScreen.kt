package com.example.storyly.placement

import android.util.Log
import androidx.compose.animation.animateContentSize
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.appsamurai.storyly.core.config.placement.STRPlacementConfig
import com.appsamurai.storyly.core.data.model.STRDataPayload
import com.appsamurai.storyly.core.data.model.STRDataSource
import com.appsamurai.storyly.core.data.model.STRPayload
import com.appsamurai.storyly.core.listener.provider.STRDataProviderListener
import com.appsamurai.storyly.core.ui.STRWidgetController
import com.appsamurai.storyly.placement.compose.StorylyPlacement
import com.appsamurai.storyly.placement.data.provider.STRPlacementDataProvider
import com.appsamurai.storyly.placement.ui.STRListener

private const val TAG = "StorylyPlacement"

/**
 * Sample Story Bar placement token shipped with the Storyly Android SDK demos.
 * Replace it with your own placement token from https://dashboard.storyly.io.
 */
private const val STORY_BAR_TOKEN =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDY4LCJzZGtfcGwiOiJpb3MifQ.0jBYuIL2vKDSR6is34tRCKViGm5_jfqElkJhSgRL_dE"

/**
 * A typical customer integration: a single Story Bar placement pinned to the top of
 * the screen, rendered with the `StorylyPlacement` composable from
 * `com.appsamurai.storyly:storyly-placement-compose`.
 *
 * The [STRPlacementDataProvider] is created and configured here — at the level where
 * the placement is used — and passed into `StorylyPlacement`. Because it is remembered
 * at this level it survives recomposition (and, if this were a lazy list, item
 * recycling), so the placement is not re-fetched on the way back into view.
 *
 * The composable has no intrinsic size, so sizing is the host's job: this screen keeps
 * the ratio and visibility reported through [STRListener] in snapshot state and turns
 * them into a modifier (see [placementSizeModifier]).
 */
@Composable
fun PlacementScreen(modifier: Modifier = Modifier) {
    val context = LocalContext.current
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
            config = STRPlacementConfig.Builder().build(token = STORY_BAR_TOKEN)
        }
    }

    // Width-to-height ratio reported by the widget once it is laid out; null until the
    // first onWidgetReady callback arrives.
    var aspectRatio by remember { mutableStateOf<Float?>(null) }
    // Whether the placement currently has content to show, per onVisibilityChange.
    var placementVisible by remember { mutableStateOf(false) }

    // The SDK keeps only a weak reference to the listener, so remember it here rather
    // than allocating a new one on every recomposition.
    val listener = remember {
        object : STRListener {
            override fun onActionClicked(
                widget: STRWidgetController,
                url: String,
                payload: STRPayload,
            ) {
                Log.d(TAG, "onActionClicked: type=${widget.getType()}, url=$url")
            }

            override fun onVisibilityChange(widget: STRWidgetController?, isVisible: Boolean) {
                placementVisible = isVisible
                if (!isVisible) aspectRatio = null
            }

            override fun onWidgetReady(widget: STRWidgetController, ratio: Float) {
                aspectRatio = ratio
            }
        }
    }

    Column(modifier = modifier.fillMaxSize()) {
        StorylyPlacement(
            dataProvider = dataProvider,
            modifier = Modifier
                .then(placementSizeModifier(placementVisible, aspectRatio))
                .animateContentSize(),
            listener = listener,
        )

        HorizontalDivider()

        Text(
            text = "The Story Bar above is a Storyly placement rendered with the " +
                "StorylyPlacement composable.",
            style = MaterialTheme.typography.bodyMedium,
            textAlign = TextAlign.Center,
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
        )
    }
}

/**
 * Full width, with the height derived from the ratio the widget reported
 * (height = width / ratio). Collapses to zero height while there is nothing to show, so
 * an empty placement reserves no space in the layout.
 */
private fun placementSizeModifier(visible: Boolean, ratio: Float?): Modifier =
    Modifier.fillMaxWidth().then(
        if (visible && ratio != null && ratio > 0f) {
            Modifier.aspectRatio(ratio)
        } else {
            Modifier.height(0.dp)
        },
    )
