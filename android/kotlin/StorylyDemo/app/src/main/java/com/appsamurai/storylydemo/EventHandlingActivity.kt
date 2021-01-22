package com.appsamurai.storylydemo

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.*
import com.appsamurai.storyly.analytics.StorylyEvent
import kotlinx.android.synthetic.main.activity_event_handling.*

class EventHandlingActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_event_handling)

        storyly_view.storylyInit =
            StorylyInit(STORYLY_INSTANCE_TOKEN)
        storyly_view.storylyListener = object : StorylyListener {
            override fun storylyLoaded(
                storylyView: StorylyView,
                storyGroupList: List<StoryGroup>
            ) {
            }

            override fun storylyLoadFailed(
                storylyView: StorylyView,
                errorMessage: String
            ) {
            }

            override fun storylyStoryShown(storylyView: StorylyView) {
            }

            override fun storylyStoryDismissed(storylyView: StorylyView) {
            }

            override fun storylyActionClicked(
                storylyView: StorylyView,
                story: Story
            ) {
                // story.media.actionUrl is important field
            }

            override fun storylyUserInteracted(
                storylyView: StorylyView,
                storyGroup: StoryGroup,
                story: Story,
                storyComponent: StoryComponent
            ) {
            }

            override fun storylyEvent(
                storylyView: StorylyView,
                event: StorylyEvent,
                storyGroup: StoryGroup?,
                story: Story?,
                storyComponent: StoryComponent?
            ) {
            }
        }
    }
}