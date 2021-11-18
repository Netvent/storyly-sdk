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
import com.appsamurai.storylydemo.databinding.StylingNetflixBinding
import com.appsamurai.storylydemo.styling_templates.ui.dpToPixel
import com.bumptech.glide.Glide

@SuppressLint("ViewConstructor")
class NetflixStyleView(context: Context) : StoryGroupView(context) {

    internal val binding: StylingNetflixBinding = StylingNetflixBinding.inflate(LayoutInflater.from(context))

    init {
        addView(binding.root)
        layoutParams = LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
    }

    override fun populateView(storyGroup: StoryGroup?) {
        Glide.with(context.applicationContext).load(storyGroup?.iconUrl).into(binding.groupIcon)

        val (cleanTitle, borderColor) = storyGroup?.title?.let {
            when {
                it.contains("{r}") -> Pair(it.replace("{r}", ""), arrayOf(Color.parseColor("#bd181a"), Color.parseColor("#bd181a")))
                it.contains("{g}") -> Pair(it.replace("{g}", ""), arrayOf(Color.parseColor("#166e43"), Color.parseColor("#166e43")))
                it.contains("{b}") -> Pair(it.replace("{b}", ""), arrayOf(Color.parseColor("#2673d8"), Color.parseColor("#2673d8")))
                else -> Pair(it, null)
            }
        } ?: Pair("", null)

        binding.groupTitle.text = cleanTitle
        binding.groupIcon.borderColor =  borderColor ?: arrayOf(Color.parseColor("#FFFED169"), Color.parseColor("#FFFA7C20"), Color.parseColor("#FFC9287B"), Color.parseColor("#FF962EC2"), Color.parseColor("#FFFED169"))

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
    }
}

class NetflixStyleViewFactory(val context: Context): StoryGroupViewFactory() {
    override fun createView(): StoryGroupView {
        return NetflixStyleView(context)
    }
}