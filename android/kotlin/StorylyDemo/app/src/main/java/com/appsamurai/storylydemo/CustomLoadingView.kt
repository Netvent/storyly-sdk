package com.appsamurai.storylydemo

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import android.view.View
import com.appsamurai.storyly.external.StorylyLoadingView
import kotlinx.android.synthetic.main.custom_loading_view.view.*

@SuppressLint("ViewConstructor")
class CustomLoadingView(view: View, context: Context) : StorylyLoadingView(context) {

    init {
        addView(view)
    }

    override fun show() {
        Log.d("[Storyly]", "LoadingView:show")
        this.external_loading.visibility = View.VISIBLE
    }

    override fun hide() {
        Log.d("[Storyly]", "LoadingView:hide")
        this.external_loading.visibility = View.GONE
    }
}