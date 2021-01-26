package com.appsamurai.storylydemo

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StorylyInit
import kotlinx.android.synthetic.main.activity_custom_theme.*

class CustomThemeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_custom_theme)

        storyly_view_group_text_color.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storyly_view_group_text_color.setStoryGroupTextColor(Color.parseColor("#f03932"))

        storyly_view_group_icon_background_color.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storyly_view_group_text_color.setStoryGroupIconBackgroundColor( Color.parseColor("#4CAF50"))

        storyly_view_group_icon_border_color.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // val seenBorder = arrayOf(Color.parseColor("#C5ACA5"), Color.parseColor("#000000"))
        // storyly_view_group_icon_border_color.setStoryGroupIconBorderColorSeen(seenBorder)

        // val notSeenBorder = arrayOf(Color.parseColor("#FB3200"), Color.parseColor("#FFEB3B"))
        // storyly_view_group_icon_border_color.setStoryGroupIconBorderColorNotSeen(notSeenBorder)

        storyly_view_group_pin_color.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storyly_view_group_pin_color.setStoryGroupPinIconColor(Color.parseColor("#3F51B5"))

        storyly_view_item_text_color.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // storyly_view_item_text_color.setStoryItemTextColor(Color.parseColor("#FF0057"))

        storyly_view_item_icon_border_color.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // val borderColor = arrayOf(Color.parseColor("#FB3200"), Color.parseColor("#FFEB3B"))
        // storyly_view_item_icon_border_color.setStoryItemIconBorderColor(borderColor)

        storyly_view_item_progress_bar_color.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        // val borderColor = arrayOf(Color.parseColor("#FB3200"), Color.parseColor("#FFEB3B"))
        // storyly_view_item_progress_bar_color.setStoryItemProgressBarColor(borderColor)
    }
}