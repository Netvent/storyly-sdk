package com.appsamurai.storylydemo

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storylydemo.databinding.ActivityCustomSizeBinding

class CustomSizeActivity : AppCompatActivity() {
    private lateinit var binding: ActivityCustomSizeBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityCustomSizeBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.storylyViewCustomLarge.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storyly_view_custom_large.setStoryGroupSize(StoryGroupSize.Large)

        binding.storylyViewCustomSmall.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storyly_view_custom_small.setStoryGroupSize(StoryGroupSize.Small)

        binding.storylyViewCustomPortrait.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storylyViewCustomPortrait.setStoryGroupSize(StoryGroupSize.Custom)
        // storylyViewCustomPortrait.setStoryGroupIconStyling(StoryGroupIconStyling(250F, 200F, 50F))

        binding.storylyViewCustomLandscape.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storylyViewCustomLandscape.setStoryGroupSize(StoryGroupSize.Custom)
        // storylyViewCustomLandscape.setStoryGroupIconStyling(StoryGroupIconStyling(200F, 250F, 50F))
    }
}