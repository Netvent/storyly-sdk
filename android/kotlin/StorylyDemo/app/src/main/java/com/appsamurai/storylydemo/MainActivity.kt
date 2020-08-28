package com.appsamurai.storylydemo

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.*
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        storyly_view.storylyInit = StorylyInit(YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD)
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

            //StoryComponent can be one of the following subclasses: StoryEmojiComponent, StoryQuizComponent, StoryPollComponent.
            //Based on "type" property of storyComponent, cast this argument to the proper subclass
            override fun storylyUserInteracted(
                storylyView: StorylyView,
                storyGroup: StoryGroup,
                story: Story,
                storyComponent: StoryComponent
            ) {
                when (storyComponent.type) {
                    StoryComponentType.Quiz -> {
                        val quizComponent = storyComponent as StoryQuizComponent
                        Log.d("[Storyly]", quizComponent.toString())
                    }
                    StoryComponentType.Poll -> {
                        val pollComponent = storyComponent as StoryPollComponent
                        Log.d("[Storyly]", pollComponent.toString())
                    }
                    StoryComponentType.Emoji -> {
                        val emojiComponent = storyComponent as StoryEmojiComponent
                        Log.d("[Storyly]", emojiComponent.toString())
                    }
                }
            }
        }
    }
}
