package com.appsamurai.storylydemo

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.monetization.StorylyAdViewProvider
import com.appsamurai.storylydemo.databinding.ActivityAdBinding

class AdActivity : AppCompatActivity() {
    private lateinit var binding: ActivityAdBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAdBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.storylyView.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
        binding.storylyView.storylyAdViewProvider = StorylyAdViewProvider(this, ADMOB_NATIVE_AD_ID)
    }
}