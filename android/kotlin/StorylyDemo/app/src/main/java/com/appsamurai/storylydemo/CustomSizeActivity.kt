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

        val storylyViewXLarge = StorylyView(this)
        storylyViewXLarge.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        storylyViewXLarge.setStoryGroupSize(StoryGroupSize.XLarge)
        storyly_view_holder.addView(storylyViewXLarge)

        val storylyViewLarge = StorylyView(this)
        storylyViewLarge.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        storylyViewLarge.setStoryGroupSize(StoryGroupSize.Large)
        storyly_view_holder.addView(storylyViewLarge)

        val storylyViewSmall = StorylyView(this)
        storylyViewSmall.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        storylyViewSmall.setStoryGroupSize(StoryGroupSize.Small)
        storyly_view_holder.addView(storylyViewSmall)


        val storylyViewCustomPortrait = StorylyView(this)
        storylyViewCustomPortrait.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        storylyViewCustomPortrait.setStoryGroupSize(StoryGroupSize.Custom)
        storylyViewCustomPortrait.setStoryGroupIconStyling(
            StoryGroupIconStyling(250F, 200F, 50F))
        storyly_view_holder.addView(storylyViewCustomPortrait)


        val storylyViewCustomLandscape = StorylyView(this)
        storylyViewCustomLandscape.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        storylyViewCustomLandscape.setStoryGroupSize(StoryGroupSize.Custom)
        storylyViewCustomLandscape.setStoryGroupIconStyling(
            StoryGroupIconStyling(200F, 250F, 50F))
        storyly_view_holder.addView(storylyViewCustomLandscape)
    }
}