package com.appsamurai.storyly.moments.demo.util

import android.content.res.Resources
import android.graphics.Rect
import android.text.TextUtils
import android.util.DisplayMetrics
import android.view.View
import java.util.*
import kotlin.math.roundToInt

private val displayMetrics: DisplayMetrics by lazy { Resources.getSystem().displayMetrics }

val Number.dp2px: Int
    get() = (this.toFloat() * displayMetrics.density).roundToInt()
