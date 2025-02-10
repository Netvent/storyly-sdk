package com.appsamurai.storyly.storyly_flutter

import android.content.Context
import android.content.res.Resources
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.util.DisplayMetrics
import androidx.core.content.ContextCompat


internal fun dpToPixel(dpValue: Int): Int {
    return (dpValue * (Resources.getSystem().displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)).toInt()
}

internal fun getTypefaceOrNull(context: Context, fontName: String?): Typeface? {
    fontName ?: return null
    return try {
        Typeface.createFromAsset(context.assets, fontName)
    } catch (_: Exception) {
        null
    }
}

internal fun getTypeface(context: Context, fontName: String?): Typeface {
    return getTypefaceOrNull(context, fontName) ?: Typeface.DEFAULT
}

internal fun getDrawable(context: Context, name: String?): Drawable? {
    name ?: return null
    return ContextCompat.getDrawable(context, context.resources.getIdentifier(name, "drawable", context.packageName))
}