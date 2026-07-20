package com.example.storyly.placement

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp

/**
 * Sample Story Bar placement token shipped with the Storyly Android SDK demos.
 * Replace it with your own placement token from https://dashboard.storyly.io.
 */
private const val STORY_BAR_TOKEN =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDY4LCJzZGtfcGwiOiJpb3MifQ.0jBYuIL2vKDSR6is34tRCKViGm5_jfqElkJhSgRL_dE"

/**
 * A typical customer integration: a single Story Bar placement pinned to the top of
 * the screen, above the rest of the app content.
 *
 * Rendering Storyly is just the [StorylyPlacement] call below — everything else here
 * is ordinary app chrome.
 */
@Composable
fun PlacementScreen(modifier: Modifier = Modifier) {
    Column(modifier = modifier.fillMaxSize()) {
        // Story Bar placement — this is all the host app needs to render Storyly.
        StorylyPlacement(
            token = STORY_BAR_TOKEN,
            modifier = Modifier.padding(vertical = 8.dp),
        )

        HorizontalDivider()

        Text(
            text = "The Story Bar above is a Storyly placement embedded with AndroidView.",
            style = MaterialTheme.typography.bodyMedium,
            textAlign = TextAlign.Center,
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
        )
    }
}
