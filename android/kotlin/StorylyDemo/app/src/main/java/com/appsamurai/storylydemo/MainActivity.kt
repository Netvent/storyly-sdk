package com.appsamurai.storylydemo

import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.*
import com.appsamurai.storyly.analytics.StorylyEvent
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.custom_external_view.view.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        storyly_view.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)

        val storylyView = StorylyView(this)
        storylyView.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        storyly_view_holder.addView(storylyView)
    }
}
