package com.appsamurai.storylydemo.integration_demo

import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import android.util.Log
import android.util.TypedValue
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.children
import com.appsamurai.storyly.*
import com.appsamurai.storyly.styling.StoryGroupIconStyling
import com.appsamurai.storyly.styling.StoryGroupListStyling
import com.appsamurai.storyly.styling.StoryGroupTextStyling
import com.appsamurai.storyly.styling.StoryHeaderStyling
import com.appsamurai.storylydemo.R
import com.appsamurai.storylydemo.databinding.ActivityUiCustomizationBinding
import com.skydoves.colorpickerview.ColorPickerDialog
import com.skydoves.colorpickerview.listeners.ColorEnvelopeListener

class UICustomizationActivity : AppCompatActivity() {
    companion object {
        const val STORYLY_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40"
        const val CUSTOMIZATION_KEY = "customization"
    }

    private lateinit var binding: ActivityUiCustomizationBinding
    private var customizations: StorylyUICustomization? = StorylyUICustomization()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityUiCustomizationBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setSupportActionBar(binding.toolbar)

        setupStoryly()
        addCustomizationEvents()
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
                Pair(TypedValue.COMPLEX_UNIT_PX, customization.storyGroupTextTextSize),
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


    private fun saveCustomizations() {
        binding.apply {
            customizations?.storyGroupSize = StoryGroupSize.values()[spinnerStoryGroupSize.selectedItemPosition]
            customizations?.storyGroupIconHeight = editTextStoryGroupIconHeight.text.toString().toFloatOrNull()
            customizations?.storyGroupIconWidth = editTextStoryGroupIconWidth.text.toString().toFloatOrNull()
            customizations?.storyGroupIconCornerRadius = editTextStoryGroupIconCornerRadius.text.toString().toFloatOrNull()

            customizations?.storyGroupTextIsVisible = checkboxStoryGroupTextIsVisible.isChecked

            customizations?.storyGroupTextTextSize = editTextStoryGroupTextTextSize.text.toString().toIntOrNull()
            customizations?.storyGroupTextMinLines = editTextStoryGroupTextMinLines.text.toString().toIntOrNull()
            customizations?.storyGroupTextMaxLines = editTextStoryGroupTextMaxLines.text.toString().toIntOrNull()
            customizations?.storyGroupTextLines = editTextStoryGroupTextLines.text.toString().toIntOrNull()

            customizations?.storyHeaderIsTextVisible = checkboxStoryHeaderIsTextVisible.isChecked
            customizations?.storyHeaderIsIconVisible = checkboxStoryHeaderIsIconVisible.isChecked
            customizations?.storyHeaderIsCloseButtonVisible = checkboxStoryHeaderIsCloseButtonVisible.isChecked

            customizations?.storyGroupListEdgePadding = editTextStoryGroupListEdgePadding.text.toString().toFloatOrNull()
            customizations?.storyGroupListPaddingBetweenItems = editTextStoryGroupListPaddingBetweenItems.text.toString().toFloatOrNull()
        }
    }

    private fun addCustomizationEvents() {
        binding.apply {
            buttonStoryGroupIconBackgroundColor.setOnClickListener {
                showColorPickerDialog { color ->
                    customizations?.storyGroupIconBackgroundColor = color
                    it.setBackgroundColor(color)
                }
            }
            buttonStoryItemTextColor.setOnClickListener {
                showColorPickerDialog { color ->
                    customizations?.storyItemTextColor = color
                    it.setBackgroundColor(color)
                }
            }
            holderStoryGroupIconBorderColorNotSeen.children.forEachIndexed { index, view ->
                view.setOnClickListener {
                    showColorPickerDialog { color ->
                        customizations?.apply {
                            storyGroupIconBorderColorNotSeen = storyGroupIconBorderColorNotSeen ?: Array(holderStoryGroupIconBorderColorNotSeen.children.count()) { 0 }
                            storyGroupIconBorderColorNotSeen?.let { it[index] = color }
                        }

                        view.setBackgroundColor(color)
                    }
                }
            }
            holderStoryGroupIconBorderColorSeen.children.forEachIndexed { index, view ->
                view.setOnClickListener {
                    showColorPickerDialog { color ->
                        customizations?.apply {
                            storyGroupIconBorderColorSeen = storyGroupIconBorderColorSeen ?: Array(holderStoryGroupIconBorderColorSeen.children.count()) { 0 }
                            storyGroupIconBorderColorSeen?.let { it[index] = color }
                        }

                        view.setBackgroundColor(color)
                    }
                }
            }
            holderStoryGroupIconBorderColorSeen.children.forEachIndexed { index, view ->
                view.setOnClickListener {
                    showColorPickerDialog { color ->
                        customizations?.apply {
                            storyGroupIconBorderColorSeen = storyGroupIconBorderColorSeen ?: Array(holderStoryGroupIconBorderColorSeen.children.count()) { 0 }
                            storyGroupIconBorderColorSeen?.let { it[index] = color }
                        }

                        view.setBackgroundColor(color)
                    }
                }
            }
            holderStoryItemIconBorderColor.children.forEachIndexed { index, view ->
                view.setOnClickListener {
                    showColorPickerDialog { color ->
                        customizations?.apply {
                            storyItemIconBorderColor = storyItemIconBorderColor ?: Array(holderStoryItemIconBorderColor.children.count()) { 0 }
                            storyGroupIconBorderColorSeen?.let { it[index] = color }
                        }

                        view.setBackgroundColor(color)
                    }
                }
            }
            holderStorylyItemProgressBarColor.children.forEachIndexed { index, view ->
                view.setOnClickListener {
                    showColorPickerDialog { color ->
                        customizations?.apply {
                            storylyItemProgressBarColor = storylyItemProgressBarColor ?: Array(holderStorylyItemProgressBarColor.children.count()) { 0 }
                            storylyItemProgressBarColor?.let { it[index] = color }
                        }

                        view.setBackgroundColor(color)
                    }
                }
            }
            buttonStoryGroupPinIconColor.setOnClickListener {
                showColorPickerDialog { color ->
                    customizations?.storyGroupPinIconColor = color
                    it.setBackgroundColor(color)
                }
            }
            buttonStoryGroupIVodIconColor.setOnClickListener {
                showColorPickerDialog { color ->
                    customizations?.storyGroupIVodIconColor = color
                    it.setBackgroundColor(color)
                }
            }

            buttonStoryGroupTextColor.setOnClickListener {
                showColorPickerDialog { color ->
                    customizations?.storyGroupTextColor = color
                    it.setBackgroundColor(color)
                }
            }
        }
    }

    private fun showColorPickerDialog(onComplete: ((Int) -> Unit)) {
        ColorPickerDialog.Builder(this)
            .setPositiveButton("Confirm",
                ColorEnvelopeListener { envelope, _ ->  onComplete(envelope.color)})
            .setNegativeButton("Cancel") { dialogInterface, i -> dialogInterface.dismiss() }
            .show()
    }


    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.demo_ui_customization_settings_menu, menu)
        return true;
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if (item.itemId == R.id.action_setting_save) {
            saveCustomizations()
            customizations?.also { setStorylyCustomizations(binding.storylyView, it) }
        }
        return super.onOptionsItemSelected(item)
    }
}


internal class StorylyUICustomization(
    var storyGroupSize: StoryGroupSize? = null,

    var storyGroupIconHeight: Float? = null,
    var storyGroupIconWidth: Float? = null,
    var storyGroupIconCornerRadius: Float? = null,

    var storyGroupIconBackgroundColor: Int? = null,
    var storyItemTextColor: Int? = null,
    var storyGroupIconBorderColorNotSeen: Array<Int>? = null,
    var storyGroupIconBorderColorSeen: Array<Int>? = null,

    var storyItemIconBorderColor: Array<Int>? = null,
    var storylyItemProgressBarColor: Array<Int>? = null,
    var storyGroupPinIconColor: Int? = null,
    var storyGroupIVodIconColor: Int? = null,

    var storyGroupTextIsVisible: Boolean? = null,
    var storyGroupTextTextSize: Int? = null,
    var storyGroupTextMinLines: Int? = null,
    var storyGroupTextMaxLines: Int? = null,
    var storyGroupTextLines: Int? = null,
    var storyGroupTextColor: Int? = null,

    var storyHeaderIsTextVisible: Boolean? = null,
    var storyHeaderIsIconVisible: Boolean? = null,
    var storyHeaderIsCloseButtonVisible: Boolean? = null,

    var storyGroupListEdgePadding: Float? = null,
    var storyGroupListPaddingBetweenItems: Float? = null,
)