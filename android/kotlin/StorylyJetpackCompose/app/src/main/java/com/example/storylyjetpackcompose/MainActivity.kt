package com.example.storylyjetpackcompose

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.viewinterop.AndroidView
import com.appsamurai.storyly.*
import com.appsamurai.storyly.analytics.StorylyEvent
import com.example.storylyjetpackcompose.ui.theme.StorylyJetpackComposeTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            StorylyJetpackComposeTheme() {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colors.background
                ) {
                    StorylyView("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40")
                }
            }
        }
    }
}

@Composable
fun StorylyView(token: String) {
    val token = remember { mutableStateOf(token) }

    // Adds view to Compose
    AndroidView(
        modifier = Modifier.fillMaxSize(), // Occupy the max size in the Compose UI tree
        factory = { context ->
            // Create StorylyView
            StorylyView(context)
        },
        update = { view ->
            view.storylyInit = StorylyInit(
                storylyId = token.value,
                segmentation = StorylySegmentation(segments = null),
                customParameter = null,
                isTestMode = true
            )
            view.storylyListener = object : StorylyListener {
                override fun storylyLoaded(
                    storylyView: StorylyView,
                    storyGroupList: List<StoryGroup>,
                    dataSource: StorylyDataSource
                ) {
                    super.storylyLoaded(storylyView, storyGroupList, dataSource)
                    Log.d("[Storyly]", "storylyLoaded:${storyGroupList.size}")
                }

                override fun storylyLoadFailed(storylyView: StorylyView, errorMessage: String) {
                    super.storylyLoadFailed(storylyView, errorMessage)
                    Log.d("[Storyly]", "storylyLoadFailed:errorMessage:$errorMessage")
                }

                override fun storylyActionClicked(storylyView: StorylyView, story: Story) {
                    Log.d("[Storyly]", "storylyActionClicked:${story.media.actionUrl}")
                }

                override fun storylyStoryShown(storylyView: StorylyView) {
                    super.storylyStoryShown(storylyView)
                    Log.d("[Storyly]", "storylyStoryShown")
                }

                override fun storylyStoryDismissed(storylyView: StorylyView) {
                    super.storylyStoryDismissed(storylyView)
                    Log.d("[Storyly]", "storylyStoryDismissed")
                }

                override fun storylyStoryShowFailed(
                    storylyView: StorylyView,
                    errorMessage: String
                ) {
                    super.storylyStoryShowFailed(storylyView, errorMessage)
                    Log.d("[Storyly]", "storylyStoryShowFailed:$errorMessage")
                }

                override fun storylyUserInteracted(
                    storylyView: StorylyView,
                    storyGroup: StoryGroup,
                    story: Story,
                    storyComponent: StoryComponent
                ) {
                    super.storylyUserInteracted(storylyView, storyGroup, story, storyComponent)
                    Log.d("[Storyly]", "storylyStoryLayerInteracted")
                }

                override fun storylyEvent(
                    storylyView: StorylyView,
                    event: StorylyEvent,
                    storyGroup: StoryGroup?,
                    story: Story?,
                    storyComponent: StoryComponent?
                ) {
                    super.storylyEvent(storylyView, event, storyGroup, story, storyComponent)
                    Log.d("[Storyly]", "storylyEvent:${event.name}")
                }
            }
        }
    )
}
