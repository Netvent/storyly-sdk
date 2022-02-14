package com.appsamurai.storylydemo.integration_demo

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.*
import com.appsamurai.storylydemo.databinding.ActivityIntegrationBinding


class IntegrationActivity : AppCompatActivity() {
    companion object {
        const val STORYLY_DEMO_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjM3MzAsImFwcF9pZCI6OTkwNSwiaW5zX2lkIjoxMDQxOX0.eBNUkBBLrdd30175KsntgLhq9hqJ1K9PZRR5IZqG8gk"
    }

    private lateinit var binding: ActivityIntegrationBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityIntegrationBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setSupportActionBar(binding.toolbar)

        binding.storylyView.storylyInit = StorylyInit(STORYLY_DEMO_TOKEN)
        binding.storylyView.storylyListener = object : StorylyListener {
            override fun storylyLoaded(
                storylyView: StorylyView,
                storyGroupList: List<StoryGroup>,
                dataSource: StorylyDataSource
            ) {
                Log.d("[storyly]", "IntegrationActivity:storylyLoaded - storyGroupList size {${storyGroupList.size}} - source {$dataSource}")
            }

            override fun storylyLoadFailed(
                storylyView: StorylyView,
                errorMessage: String
            ) {
                Log.d("[storyly]", "IntegrationActivity:storylyLoadFailed - error {$errorMessage}")
            }

            override fun storylyActionClicked(
                storylyView: StorylyView,
                story: Story
            ) {
                Log.d("[storyly]", "IntegrationActivity:storylyActionClicked - story {$story}")
                try {
                    story.media.actionUrl?.let { url ->
                        Log.d("[storyly]", "IntegrationActivity:storylyActionClicked - forwarding to url {$url}")
                        startActivity(
                            Intent(Intent.ACTION_VIEW).apply {
                                data = Uri.parse("app://storyly-demo/custom-ui")
                            }
                        )
                    }
                } catch (exception: Exception) {
                    Toast.makeText(baseContext, exception.localizedMessage, Toast.LENGTH_LONG).show()
                }
            }
        }
    }
}
