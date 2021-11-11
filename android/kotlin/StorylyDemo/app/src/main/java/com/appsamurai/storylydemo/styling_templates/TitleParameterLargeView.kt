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
class TitleParameterLargeView(context: Context) : StoryGroupView(context) {

    private val binding: StylingLargeBinding = StylingLargeBinding.inflate(LayoutInflater.from(context))
    private val parameterTestValue = "TestName"

    init {
        addView(binding.root)
        layoutParams = LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
    }

    override fun populateView(storyGroup: StoryGroup?) {
        Glide.with(context.applicationContext).load(storyGroup?.iconUrl).into(binding.groupIcon)

        if (storyGroup?.type == StoryGroupType.Vod) {
            binding.vodIcon.visibility = VISIBLE
            binding.vodIcon.setImageResource(R.drawable.st_ivod_sg_icon)
            binding.vodIcon.background = GradientDrawable().apply {
                colors = listOf(Color.parseColor("#7651FF"), Color.parseColor("#7651FF")).toIntArray()
                cornerRadii = List(8) { dpToPixel(6f) }.toFloatArray()
            }
            binding.vodIcon.setPadding(3, 0, 0, 0)
        } else if (storyGroup?.pinned == true) {
            binding.pinIcon.visibility = VISIBLE
            binding.pinIcon.setImageResource(R.drawable.st_pin_icon)
            binding.pinIcon.avatarBackgroundColor = Color.parseColor("#7651FF")
        }

        /*  In storyly dashboard, update story group name giving a parameter (that would not affect normal texts)
         *  that will be programmatically updated with custom factory.
         *  Example story group name from dashboard for parameter {a}:
         *      "Hello {a}"
         */
        binding.groupTitle.text = storyGroup?.title?.replace("{a}", parameterTestValue)
        when (storyGroup?.seen) {
            true -> binding.groupIcon.borderColor = arrayOf(Color.parseColor("#FFDBDBDB"), Color.parseColor("#FFDBDBDB"))
            false -> binding.groupIcon.borderColor = arrayOf(Color.parseColor("#FFFED169"), Color.parseColor("#FFFA7C20"), Color.parseColor("#FFC9287B"), Color.parseColor("#FF962EC2"), Color.parseColor("#FFFED169"))
        }
    }
}

class TitleParameterLargeViewFactory(val context: Context): StoryGroupViewFactory() {
    override fun createView(): StoryGroupView {
        return TitleParameterLargeView(context)
    }
}