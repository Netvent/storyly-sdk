package com.appsamurai.storylydemo

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StoryGroupSize
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storyly.styling.StoryGroupIconStyling
import kotlinx.android.synthetic.main.activity_custom_size.*

class CustomSizeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_custom_size)


        storyly_view_custom_xlarge.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storyly_view_custom_xlarge.setStoryGroupSize(StoryGroupSize.XLarge)

        storyly_view_custom_large.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storyly_view_custom_large.setStoryGroupSize(StoryGroupSize.Large)

        storyly_view_custom_small.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storyly_view_custom_small.setStoryGroupSize(StoryGroupSize.Small)

        storyly_view_custom_portrait.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storylyViewCustomPortrait.setStoryGroupSize(StoryGroupSize.Custom)
        // storylyViewCustomPortrait.setStoryGroupIconStyling(StoryGroupIconStyling(250F, 200F, 50F))

        storyly_view_custom_landscape.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storylyViewCustomLandscape.setStoryGroupSize(StoryGroupSize.Custom)
        // storylyViewCustomLandscape.setStoryGroupIconStyling(StoryGroupIconStyling(200F, 250F, 50F))
    }
}