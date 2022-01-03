package com.appsamurai.storylydemo.styling_templates

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.LayoutInflater
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StoryGroupType
import com.appsamurai.storyly.styling.StoryGroupView
import com.appsamurai.storyly.styling.StoryGroupViewFactory
import com.appsamurai.storylydemo.R
import com.appsamurai.storylydemo.databinding.StylingLargeBinding
import com.appsamurai.storylydemo.styling_templates.ui.dpToPixel
import com.bumptech.glide.Glide

@SuppressLint("ViewConstructor")
class TitleParameterLargeView(context: Context) : LargeView(context) {

    private val parameterTestValue = "TestName"

    override fun populateView(storyGroup: StoryGroup?) {
        super.populateView(storyGroup)

        /*  In storyly dashboard, update story group name giving a parameter (that would not affect normal texts)
         *  that will be programmatically updated with custom factory.
         *  Example story group name from dashboard for parameter {a}:
         *      "Hello {a}"
         */
        val populatedText = super.binding.groupTitle.text
        super.binding.groupTitle.text = populatedText.toString().replace("{a}", parameterTestValue)
    }
}

class TitleParameterLargeViewFactory(val context: Context): StoryGroupViewFactory() {
    override fun createView(): StoryGroupView {
        return TitleParameterLargeView(context)
    }
}