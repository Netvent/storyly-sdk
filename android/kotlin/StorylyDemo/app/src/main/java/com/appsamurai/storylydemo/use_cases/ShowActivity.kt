package com.appsamurai.storylydemo.use_cases

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.*
import com.appsamurai.storylydemo.STORYLY_INSTANCE_TOKEN
import com.appsamurai.storylydemo.databinding.ActivityShowBinding


class ShowActivity: AppCompatActivity() {
    private lateinit var binding: ActivityShowBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityShowBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        binding.storylyView.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        binding.storylyView.visibility = View.GONE

        binding.storylyView.storylyListener = object : StorylyListener {
            var initialLoad = true

            override fun storylyLoaded(storylyView: StorylyView, storyGroupList: List<StoryGroup>, dataSource: StorylyDataSource) {
                //  for not to re-animate already loaded StorylyView
                if (initialLoad && storyGroupList.isNotEmpty()) {
                    initialLoad = false

                    storylyView.visibility = View.VISIBLE
                }
            }
        }
    }
}