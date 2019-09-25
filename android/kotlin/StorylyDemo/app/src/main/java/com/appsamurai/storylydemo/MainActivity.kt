package com.appsamurai.storylydemo

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.StorylyView
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        storyly_view.storylyId = "[YOUR_APP_ID]"
        storyly_view.storylyListener = object: StorylyListener{
            override fun storylyLoaded(storylyView: StorylyView) {
                super.storylyLoaded(storylyView)
                Log.d("[Storyly]", "storylyLoaded")
            }

            override fun storylyLoadFailed(storylyView: StorylyView) {
                super.storylyLoadFailed(storylyView)
                Log.d("[Storyly]", "storylyLoadFailed")
            }
        }
    }
}
