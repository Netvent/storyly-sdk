package com.appsamurai.storylydemo.integration_demo

import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.os.Parcelable
import androidx.appcompat.app.AppCompatActivity
import com.appsamurai.storyly.StoryGroupSize
import com.appsamurai.storylydemo.databinding.ActivitySetupUiCustomizationBinding
import kotlinx.parcelize.Parcelize
import android.view.Menu
import android.view.MenuItem
import androidx.core.content.ContextCompat
import androidx.core.view.children
import com.appsamurai.storylydemo.R
import com.appsamurai.storylydemo.integration_demo.UICustomizationActivity.Companion.CUSTOMIZATION_KEY

import com.skydoves.colorpickerview.listeners.ColorEnvelopeListener

import com.skydoves.colorpickerview.ColorPickerDialog
import java.lang.Exception


class SetupUICustomizationActivity  : AppCompatActivity() {
    private lateinit var binding: ActivitySetupUiCustomizationBinding

    private var customizations: StorylyUICustomization? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySetupUiCustomizationBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setSupportActionBar(binding.toolbar)

        customizations = try {
            intent.getParcelableExtra(CUSTOMIZATION_KEY) ?:  StorylyUICustomization()
        } catch(_: Exception) {
            StorylyUICustomization()
        }
        loadCustomizations(customizations)
        addEvents()
    }

    private fun loadCustomizations(customization: StorylyUICustomization?) {
        binding.apply {
            spinnerStoryGroupSize.setSelection(customization?.storyGroupSize?.ordinal ?: 0)
            editTextStoryGroupIconHeight.setText((customization?.storyGroupIconHeight ?: 40f).toString())
            editTextStoryGroupIconWidth.setText((customization?.storyGroupIconWidth ?: 40f).toString())
            editTextStoryGroupIconCornerRadius.setText((customization?.storyGroupIconCornerRadius ?: 40f).toString())
            buttonStoryGroupIconBackgroundColor.setBackgroundColor(customization?.storyGroupIconBackgroundColor ?: ContextCompat.getColor(applicationContext, R.color.defaultStoryGroupIconBackgroundColor))
            buttonStoryItemTextColor.setBackgroundColor(customization?.storyGroupIconBackgroundColor ?: Color.BLACK)

            holderStoryGroupIconBorderColorNotSeen.children.forEachIndexed { index, view ->
                customization?.storyGroupIconBorderColorNotSeen?.getOrNull(index)?.also { color ->
                    view.setBackgroundColor(color)
                }
            }
            holderStoryGroupIconBorderColorSeen.children.forEachIndexed { index, view ->
                customization?.storyGroupIconBorderColorSeen?.getOrNull(index)?.also { color ->
                    view.setBackgroundColor(color)
                }
            }
        }
    }

    private fun saveCustomizations() {
        binding.apply {
            customizations?.storyGroupSize = StoryGroupSize.values()[spinnerStoryGroupSize.selectedItemPosition]
            customizations?.storyGroupIconHeight = editTextStoryGroupIconHeight.text.toString().toFloatOrNull()
            customizations?.storyGroupIconWidth = editTextStoryGroupIconWidth.text.toString().toFloatOrNull()
            customizations?.storyGroupIconCornerRadius = editTextStoryGroupIconCornerRadius.text.toString().toFloatOrNull()


        }
    }

    private fun addEvents() {
        customizations?.also { customizations ->
            binding.apply {
                buttonStoryGroupIconBackgroundColor.setOnClickListener {
                    showColorPickerDialog { color ->
                        customizations.storyGroupIconBackgroundColor = color
                        it.setBackgroundColor(color)
                    }
                }
                buttonStoryItemTextColor.setOnClickListener {
                    showColorPickerDialog { color ->
                        customizations.storyItemTextColor = color
                        it.setBackgroundColor(color)
                    }
                }
                holderStoryGroupIconBorderColorNotSeen.children.forEachIndexed { index, view ->
                    view.setOnClickListener {
                        showColorPickerDialog { color ->
                            customizations.storyGroupIconBorderColorNotSeen = customizations.storyGroupIconBorderColorNotSeen ?: Array(holderStoryGroupIconBorderColorNotSeen.children.count()) { 0 }
                            customizations.storyGroupIconBorderColorNotSeen?.let {
                                it[index] = color
                            }

                            view.setBackgroundColor(color)
                        }
                    }
                }

                holderStoryGroupIconBorderColorSeen.children.forEachIndexed { index, view ->
                    view.setOnClickListener {
                        showColorPickerDialog { color ->
                            customizations.storyGroupIconBorderColorSeen = customizations.storyGroupIconBorderColorSeen ?: Array(holderStoryGroupIconBorderColorSeen.children.count()) { 0 }
                            customizations.storyGroupIconBorderColorSeen?.let {
                                it[index] = color
                            }

                            view.setBackgroundColor(color)
                        }
                    }
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
            setResult(RESULT_OK,  Intent().apply {
                putExtra(CUSTOMIZATION_KEY, customizations)
            })
            finish()
        }
        return super.onOptionsItemSelected(item)
    }
}

@Parcelize
internal data class StorylyUICustomization(
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
//    ar storyGroupTextTypeface: Typeface? = null,
    var storyGroupTextTextSize: Pair<Int, Int?>? = null,
    var storyGroupTextMinLines: Int? = null,
    var storyGroupTextMaxLines: Int? = null,
    var storyGroupTextLines: Int? = null,
    var storyGroupTextColor: Int? = null,

    var storyHeaderIsTextVisible: Boolean? = null,
    var storyHeaderIsIconVisible: Boolean? = null,
    var storyHeaderIsCloseButtonVisible: Boolean? = null,
//    ar storyHeaderCloseButtonIcon: Drawable? = null,
//    ar storyHeaderShareButtonIcon: Drawable? = null,
//    ar storyItemTextTypeface: Typeface? = null,
//    ar storyInteractiveTypeface: Typeface? = null,
    var storyGroupListEdgePadding: Float? = null,
    var storyGroupListPaddingBetweenItems: Float? = null,
): Parcelable