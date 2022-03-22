package com.appsamurai.storylydemo.use_cases

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.*
import com.appsamurai.storylydemo.STORYLY_INSTANCE_TOKEN
import com.appsamurai.storylydemo.databinding.ActivityHideBinding


class HideActivity: AppCompatActivity() {
    private lateinit var binding: ActivityHideBinding


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityHideBinding.inflate(layoutInflater)
        setContentView(binding.root)
        supportActionBar?.hide()

        binding.storylyView.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)

        binding.storylyView.storylyListener = object : StorylyListener {
            var storylyLoaded = false

            override fun storylyLoaded(storylyView: StorylyView, storyGroupList: List<StoryGroup>, dataSource: StorylyDataSource) {
                if (storyGroupList.isNotEmpty()) {
                    storylyLoaded = true
                }
            }

            override fun storylyLoadFailed(storylyView: StorylyView, errorMessage: String) {
                // if cached before not hide
                if (!storylyLoaded) {
                    storylyView.visibility = View.GONE;
                }
            }
        }
    }
}