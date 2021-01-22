package com.appsamurai.storylydemo

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.StorylyView
import kotlinx.android.synthetic.main.activity_main.*

class BasicActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        storyly_view.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)

        val storylyView = StorylyView(this)
        storylyView.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        storyly_view_holder.addView(storylyView)
    }
}
