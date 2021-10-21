package com.appsamurai.storylydemo

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.StorylyView
import android.util.Log
import android.view.LayoutInflater
import com.appsamurai.storyly.*
import com.appsamurai.storyly.analytics.StorylyEvent
import com.appsamurai.storyly.demo.templates.GradientPortraitViewFactory
import com.appsamurai.storyly.demo.templates.LandscapeViewFactory
import com.appsamurai.storyly.demo.templates.PortraitViewFactory
import com.appsamurai.storyly.demo.templates.WideLandscapeViewFactory
import com.appsamurai.storylydemo.databinding.CustomStylingContainerBinding

class CustomStylingActivity : AppCompatActivity() {
    private lateinit var binding: CustomStylingContainerBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = CustomStylingContainerBinding.inflate(LayoutInflater.from(this))
        setContentView(binding.root)
        onNewIntent(intent)

        binding.stylingLandscape.storyGroupViewFactory = LandscapeViewFactory(this)
        binding.stylingGradientPortrait.storyGroupViewFactory = GradientPortraitViewFactory(this)
        binding.stylingPortrait.storyGroupViewFactory = PortraitViewFactory(this)
        binding.stylingWideLandscape.storyGroupViewFactory = WideLandscapeViewFactory(this)

        initStoryly()

        val storylyListener = object : StorylyListener {
            override fun storylyLoaded(storylyView: StorylyView, storyGroupList: List<StoryGroup>) {
                super.storylyLoaded(storylyView, storyGroupList)
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

            override fun storylyStoryShowFailed(storylyView: StorylyView, errorMessage: String) {
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

        binding.stylingLandscape.storylyListener = storylyListener
        binding.stylingGradientPortrait.storylyListener = storylyListener
        binding.stylingPortrait.storylyListener = storylyListener
        binding.stylingWideLandscape.storylyListener = storylyListener
    }

    private fun initStoryly(storylyToken: String = STORYLY_INSTANCE_TOKEN) {
        binding.stylingLandscape.storylyInit = StorylyInit(storylyToken)
        binding.stylingGradientPortrait.storylyInit = StorylyInit(storylyToken)
        binding.stylingPortrait.storylyInit = StorylyInit(storylyToken)
        binding.stylingWideLandscape.storylyInit = StorylyInit(storylyToken)
    }
}
