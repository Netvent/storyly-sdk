package com.appsamurai.storylydemo

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.Story
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.StorylyView
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        storyly_view.storylyId = "[YOUR_APP_ID_FROM_DASHBOARD]"
        storyly_view.storylyListener = object : StorylyListener {
            override fun storylyLoaded(storylyView: StorylyView, storyGroupList: List<StoryGroup>) {
                Log.d("[Storyly]", "storylyLoaded")
            }

            override fun storylyLoadFailed(storylyView: StorylyView, errorMessage: String) {
                Log.d("[Storyly]", "storylyLoadFailed")
            }

            // return true if app wants to handle redirection, otherwise return false
            override fun storylyActionClicked(
                storylyView: StorylyView,
                story: Story
            ): Boolean {
                Log.d("[Storyly]", "storylyActionClicked")
                return true
            }

            override fun storylyStoryShown(storylyView: StorylyView) {
                Log.d("[Storyly]", "storylyStoryShown")
            }

            override fun storylyStoryDismissed(storylyView: StorylyView) {
                Log.d("[Storyly]", "storylyStoryDismissed")
            }
        }
    }
}
