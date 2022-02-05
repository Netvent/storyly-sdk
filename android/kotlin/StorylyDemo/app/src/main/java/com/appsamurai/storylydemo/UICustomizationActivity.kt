package com.appsamurai.storylydemo

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StorylyDataSource
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storylydemo.databinding.ActivityUiCustomizationBinding

class UICustomizationActivity : AppCompatActivity() {
    private lateinit var binding: ActivityUiCustomizationBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityUiCustomizationBinding.inflate(layoutInflater)
        setContentView(binding.root)

//        binding.storylyView.storylyInit = StorylyInit(IntegrationActivity.STORYLY_DEMO_TOKEN)
        binding.storylyView.storylyListener = object : StorylyListener {
            override fun storylyLoaded(
                storylyView: StorylyView,
                storyGroupList: List<StoryGroup>,
                dataSource: StorylyDataSource
            ) {
                Log.d("[storyly]", "UICustomizationActivity:storylyLoaded - storyGroupList size {${storyGroupList.size}} - source {$dataSource}")
            }

            override fun storylyLoadFailed(
                storylyView: StorylyView,
                errorMessage: String
            ) {
                Log.d("[storyly]", "UICustomizationActivity:storylyLoadFailed - error {$errorMessage}")
            }
        }
    }
}