package com.appsamurai.storylydemo.integration_demo

import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import android.os.Handler
import android.util.Log
import android.util.TypedValue
import android.view.Menu
import android.view.MenuItem
import androidx.activity.result.ActivityResult
import androidx.activity.result.contract.ActivityResultContracts.*
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.*
import com.appsamurai.storyly.styling.StoryGroupIconStyling
import com.appsamurai.storyly.styling.StoryGroupListStyling
import com.appsamurai.storyly.styling.StoryGroupTextStyling
import com.appsamurai.storyly.styling.StoryHeaderStyling
import com.appsamurai.storylydemo.R
import com.appsamurai.storylydemo.databinding.ActivityUiCustomizationBinding

class UICustomizationActivity : AppCompatActivity() {
    companion object {
        const val STORYLY_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU1NiwiYXBwX2lkIjoxMzg5LCJpbnNfaWQiOjEwNDA5fQ.kXqBdpUcKaJe7eA98PqHahMDf-123Uhb82t_mYzbBUM"
        const val CUSTOMIZATION_KEY = "customization"
    }

    private lateinit var binding: ActivityUiCustomizationBinding
    private var customizations: StorylyUICustomization? = null

    private val setupLauncher = registerForActivityResult(StartActivityForResult()) { result: ActivityResult? ->
        println("[storyly] -> result ${result?.resultCode} - ${result?.data?.getParcelableExtra<StorylyUICustomization>(CUSTOMIZATION_KEY)}")
        if (result?.resultCode == RESULT_OK) {
            val customization = result.data?.getParcelableExtra<StorylyUICustomization?>(CUSTOMIZATION_KEY) ?: return@registerForActivityResult
            customizations = customization
            Handler(mainLooper).post {
                setStorylyCustomizations(binding.storylyView, customization)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityUiCustomizationBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setSupportActionBar(binding.toolbar)

        setupStoryly()

        setupLauncher.launch(
            Intent(this, SetupUICustomizationActivity::class.java)
        )
    }

    private fun setupStoryly() {
        binding.storylyView.storylyInit = StorylyInit(STORYLY_TOKEN)
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

    private fun setStorylyCustomizations(storylyView: StorylyView, customization: StorylyUICustomization) {
        customization.storyGroupSize?.also {
            storylyView.setStoryGroupSize(it)
            if (it == StoryGroupSize.Custom) {
                storylyView.setStoryGroupIconStyling(
                    StoryGroupIconStyling(
                        customization.storyGroupIconHeight ?: 40f,
                        customization.storyGroupIconWidth ?: 40f,
                        customization.storyGroupIconCornerRadius ?: 40f,
                    )
                )
            }
        }

        customization.storyGroupIconBackgroundColor?.also { storylyView.setStoryGroupIconBackgroundColor(it) }
        customization.storyItemTextColor?.also { storylyView.setStoryItemTextColor(it) }

        customization.storyGroupIconBorderColorNotSeen?.also { storylyView.setStoryGroupIconBorderColorNotSeen(it) }
        customization.storyGroupIconBorderColorSeen?.also { storylyView.setStoryGroupIconBorderColorSeen(it) }
        customization.storyItemIconBorderColor?.also { storylyView.setStoryItemIconBorderColor(it) }
        customization.storylyItemProgressBarColor?.also { storylyView.setStoryItemProgressBarColor(it) }
        customization.storyGroupPinIconColor?.also { storylyView.setStoryGroupPinIconColor(it) }
        customization.storyGroupIVodIconColor?.also { storylyView.setStoryGroupIVodIconColor(it) }

        storylyView.setStoryGroupTextStyling(
            StoryGroupTextStyling(
                customization.storyGroupTextIsVisible ?: true,
                Typeface.DEFAULT,
                customization.storyGroupTextTextSize ?: Pair(TypedValue.COMPLEX_UNIT_PX, null),
                customization.storyGroupTextMinLines,
                customization.storyGroupTextMaxLines,
                customization.storyGroupTextLines,
                customization.storyGroupTextColor ?: Color.BLACK,
            )
        )

        storylyView.setStoryHeaderStyling(
            StoryHeaderStyling(
                customization.storyHeaderIsTextVisible ?: true,
                customization.storyHeaderIsIconVisible ?: true,
                customization.storyHeaderIsCloseButtonVisible ?: true,
                null,
                null,
            )
        )

        storylyView.setStoryGroupListStyling(
            StoryGroupListStyling(
                customization.storyGroupListEdgePadding ?: Float.MIN_VALUE,
                customization.storyGroupListPaddingBetweenItems ?: Float.MIN_VALUE,
            )
        )
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.demo_ui_customization_menu, menu)
        return true;
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if (item.itemId == R.id.action_settings) {
            setupLauncher.launch(
                Intent(this, SetupUICustomizationActivity::class.java).apply {
                    putExtra(CUSTOMIZATION_KEY, customizations)
                }
            )
        }
        return super.onOptionsItemSelected(item)
    }
}