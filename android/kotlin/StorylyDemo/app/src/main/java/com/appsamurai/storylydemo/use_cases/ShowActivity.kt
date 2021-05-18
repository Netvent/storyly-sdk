package com.appsamurai.storylydemo.use_cases

import android.graphics.Color
import android.os.Bundle
import android.os.Handler
import android.widget.RelativeLayout
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storylydemo.databinding.ActivityShowBinding


class ShowActivity: AppCompatActivity() {
    private lateinit var binding: ActivityShowBinding

    private lateinit var storylyView: StorylyView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityShowBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        val STORYLY_INSTANCE_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40"

        storylyView = StorylyView(this)
        storylyView.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)

        storylyView.storylyListener = object : StorylyListener {
            var initialLoad = true

            override fun storylyLoaded(storylyView: StorylyView, storyGroupList: List<StoryGroup>) {
                //  for not to re-animate already loaded StorylyView
                if (initialLoad && storyGroupList.isNotEmpty()) {
                    initialLoad = false

                    binding.storylyViewHolder.addView(storylyView, 2)
                }
            }
        }
    }
}