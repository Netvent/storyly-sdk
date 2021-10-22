package com.appsamurai.storylydemo

import android.os.Bundle
import android.view.LayoutInflater
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storylydemo.databinding.ActivityCustomStylingBinding
import com.appsamurai.storylydemo.styling_templates.GradientPortraitViewFactory
import com.appsamurai.storylydemo.styling_templates.LandscapeViewFactory
import com.appsamurai.storylydemo.styling_templates.PortraitViewFactory
import com.appsamurai.storylydemo.styling_templates.WideLandscapeViewFactory

class CustomStylingActivity : AppCompatActivity() {
    private lateinit var binding: ActivityCustomStylingBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityCustomStylingBinding.inflate(LayoutInflater.from(this))
        setContentView(binding.root)

        binding.stylingLandscape.storyGroupViewFactory = LandscapeViewFactory(this)
        binding.stylingGradientPortrait.storyGroupViewFactory = GradientPortraitViewFactory(this)
        binding.stylingPortrait.storyGroupViewFactory = PortraitViewFactory(this)
        binding.stylingWideLandscape.storyGroupViewFactory = WideLandscapeViewFactory(this)

        binding.stylingLandscape.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        binding.stylingGradientPortrait.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        binding.stylingPortrait.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        binding.stylingWideLandscape.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
    }
}
