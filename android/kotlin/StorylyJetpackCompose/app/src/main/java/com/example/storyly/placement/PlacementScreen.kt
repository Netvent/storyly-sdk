package com.example.storyly.placement

import android.util.Log
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.appsamurai.storyly.core.config.placement.STRPlacementConfig
import com.appsamurai.storyly.core.data.model.STRDataPayload
import com.appsamurai.storyly.core.data.model.STRDataSource
import com.appsamurai.storyly.core.listener.provider.STRDataProviderListener
import com.appsamurai.storyly.placement.data.provider.STRPlacementDataProvider

private const val TAG = "StorylyPlacement"

/**
 * Sample Story Bar placement token shipped with the Storyly Android SDK demos.
 * Replace it with your own placement token from https://dashboard.storyly.io.
 */
private const val STORY_BAR_TOKEN =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjE0ODY3LCJhcHBfaWQiOjIyNDgyLCJwbGNtbnRfaWQiOjI1NDY4LCJzZGtfcGwiOiJpb3MifQ.0jBYuIL2vKDSR6is34tRCKViGm5_jfqElkJhSgRL_dE"

/**
 * A typical customer integration: a single Story Bar placement pinned to the top of
 * the screen.
 *
 * The [STRPlacementDataProvider] is created and configured here — at the level where
 * the placement is used — and passed into [StorylyPlacement]. Because it is remembered
 * at this level it survives recomposition (and, if this were a lazy list, item
 * recycling), so the placement is not re-fetched on the way back into view.
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

    Column(modifier = modifier.fillMaxSize()) {
        StorylyPlacement(
            dataProvider = dataProvider,
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
