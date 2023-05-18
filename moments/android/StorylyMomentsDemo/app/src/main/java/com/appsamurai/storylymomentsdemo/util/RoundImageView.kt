package com.appsamurai.storyly.moments.demo.util

import android.animation.AnimatorSet
import android.animation.ValueAnimator
import android.annotation.SuppressLint
import android.content.Context
import android.graphics.*
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import android.view.ViewOutlineProvider
import android.view.animation.LinearInterpolator
import androidx.annotation.DrawableRes
import androidx.annotation.RequiresApi
import androidx.appcompat.widget.AppCompatImageView
import androidx.core.animation.addListener
import com.appsamurai.storyly.moments.R
import kotlin.math.floor
import kotlin.math.max
import kotlin.math.min
import kotlin.math.pow
import kotlin.properties.Delegates

/**
 * Thanks to https://github.com/vitorhugods/AvatarView
 */
@SuppressLint("ViewConstructor")
internal class RoundImageView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0,
    val isRect: Boolean = false
) : AppCompatImageView(context, attrs, defStyleAttr) {

    private val avatarDrawableRect = RectF()
    private val middleRect = RectF()
    private val borderRect = RectF()
    private val arcBorderRect = RectF()

    private val shaderMatrix = Matrix()
    private val bitmapPaint = Paint()
    private val middlePaint = Paint()
    private val borderPaint = Paint()
    private val circleBackgroundPaint = Paint()

    private var middleThickness = 0f
    private val avatarInset
        get() = distanceToBorder + borderThickness.toFloat()

    private var avatarDrawable: Bitmap? = null
    private var bitmapShader: BitmapShader? = null
    private var bitmapWidth = 0
    private var bitmapHeight = 0

    private var drawableRadius = 0f
    private var middleRadius = 0f
    private var borderRadius = 0f

    private var animationArchesSparseness = 0f
    /**
     * The length (in degrees) available for the arches when animating.
     */
    private var totalArchesDegreeArea = 90f
    /**
     * The number of arches displayed across the border when animating.
     * This can be set to zero, if no secondary arches are wanted.
     */
    private var numberOfArches = 5
    /**
     * The length (in degrees) of each arch when animating.
     * Keep in mind that the arches may overlap if this value is too high
     * and [totalArchesDegreeArea] is too low.
     */
    private var individualArcDegreeLength = 3f
    /**
     * The color of the gap between the border and the avatar.
     * Default: [Color.TRANSPARENT]
     */
    private var middleColor = Color.TRANSPARENT
    /**
     * The border color.
     * Remember: The border is colored using a gradient.
     */
    internal var borderColor by Delegates.observable(arrayOf(Color.TRANSPARENT, Color.TRANSPARENT)) { _, _, _ ->
        distanceToBorder = resources.getDimensionPixelSize(R.dimen.mom_story_group_icon_distance_to_border)
        borderThickness = resources.getDimensionPixelSize(R.dimen.mom_story_group_icon_border_thickness)
        setup()
    }
    /**
     * The distance (in pixels) between the avatar and the border.
     */
    private var distanceToBorder = 0
    /**
     * The border thickness (in pixels) when not highlighted
     */
    private var borderThickness = 0
    /**
     * The background color of the avatar.
     * Only visible if the image has any transparency.
     */
    internal var avatarBackgroundColor by Delegates.observable(Color.parseColor("#FFF1F1F1")) { _, _, _ ->
        setup()
    }

    private val spaceBetweenArches
        get() = totalArchesDegreeArea / (numberOfArches) - individualArcDegreeLength

    private val currentAnimationArchesArea
        get() = animationArchesSparseness * totalArchesDegreeArea

    private var animationLoopDegrees = 0f

    private val setupAnimator = ValueAnimator.ofFloat(0f, 1f).apply {
        interpolator = LinearInterpolator()
    }!!.apply {
        addUpdateListener {
            animationArchesSparseness = it.animatedValue as Float
            invalidate()
        }
        addListener(onEnd = {
            if (isReversedAnimating) {
                animationLoopDegrees = 0f
                isReversedAnimating = false
            }
        })
    }
    private val loopAnimator = ValueAnimator.ofFloat(0f, 360f).apply {
        repeatCount = ValueAnimator.INFINITE
        duration = 2000L
        interpolator = LinearInterpolator()
    }!!.apply {
        addUpdateListener {
            animationLoopDegrees = it.animatedValue as Float
            invalidate()
        }
    }
    private val animatorSet = AnimatorSet().apply {
        playSequentially(setupAnimator, loopAnimator)
    }

    private var isReversedAnimating = false

    private var isAnimating = false
        set(value) {
            if (value && !field) {
                if (isReversedAnimating) {
                    setupAnimator.reverse()
                }
                animatorSet.start()
            } else if (!value && field) {
                isReversedAnimating = true
                animatorSet.cancel()
                setupAnimator.reverse()
            }
            field = value
            setup()
        }

    init {
        scaleType = ScaleType.CENTER_CROP
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            outlineProvider = OutlineProvider()
        }
        setup()
    }

    override fun setImageBitmap(bm: Bitmap) {
        super.setImageBitmap(bm)
        initializeBitmap()
    }

    override fun setImageDrawable(drawable: Drawable?) {
        super.setImageDrawable(drawable)
        initializeBitmap()
    }

    override fun setImageResource(@DrawableRes resId: Int) {
        super.setImageResource(resId)
        initializeBitmap()
    }

    override fun setImageURI(uri: Uri?) {
        super.setImageURI(uri)
        initializeBitmap()
    }

    private fun setup() {
        if (width == 0 && height == 0) {
            return
        }

        if (avatarDrawable == null) {
            setImageResource(android.R.color.transparent)
            return
        }

        bitmapHeight = avatarDrawable!!.height
        bitmapWidth = avatarDrawable!!.width

        bitmapShader = BitmapShader(avatarDrawable!!, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP)
        bitmapPaint.isAntiAlias = true
        bitmapPaint.shader = bitmapShader

        val currentBorderThickness = borderThickness.toFloat()

        borderRect.set(calculateBounds())
        borderRadius = min((borderRect.height() - currentBorderThickness) / 2.0f, (borderRect.width() - currentBorderThickness) / 2.0f)

        val currentBorderGradient = SweepGradient(
            width / 2.0f, height / 2.0f,
            borderColor.toIntArray(),
            null
        )
        borderPaint.apply {
            shader = currentBorderGradient
            strokeWidth = currentBorderThickness
            isAntiAlias = true
            strokeCap = if (isRect) Paint.Cap.SQUARE else Paint.Cap.ROUND
            style = Paint.Style.STROKE
        }

        avatarDrawableRect.set(borderRect)
        if (isRect) avatarDrawableRect.inset(3 * avatarInset / 4, 3 * avatarInset / 4) else avatarDrawableRect.inset(avatarInset, avatarInset)

        middleThickness = (borderRect.width() - currentBorderThickness * 2 - avatarDrawableRect.width()) / 2

        middleRect.set(borderRect)
        middleRect.inset(currentBorderThickness + middleThickness / 2, currentBorderThickness + middleThickness / 2)

        middleRadius = min(floor(middleRect.height() /  2.0f), floor(middleRect.width() / 2.0f))
        drawableRadius = min(avatarDrawableRect.height() /  2.0f, avatarDrawableRect.width() / 2.0f)

        middlePaint.apply {
            style = Paint.Style.STROKE
            isAntiAlias = true
            color = middleColor
            strokeWidth = middleThickness
        }

        circleBackgroundPaint.apply {
            style = Paint.Style.FILL
            isAntiAlias = true
            color = avatarBackgroundColor
        }

        arcBorderRect.apply {
            set(borderRect)
            inset(currentBorderThickness / 2f, currentBorderThickness / 2f)
        }

        updateShaderMatrix()
        invalidate()
    }

    private fun updateShaderMatrix() {
        val scale: Float
        var dx = 0f
        var dy = 0f

        shaderMatrix.set(null)

        if (bitmapWidth * avatarDrawableRect.height() > avatarDrawableRect.width() * bitmapHeight) {
            scale = avatarDrawableRect.height() / bitmapHeight.toFloat()
            dx = (avatarDrawableRect.width() - bitmapWidth * scale) / 2f
        } else {
            scale = avatarDrawableRect.width() / bitmapWidth.toFloat()
            dy = (avatarDrawableRect.height() - bitmapHeight * scale) / 2f
        }

        shaderMatrix.setScale(scale, scale)
        shaderMatrix.postTranslate((dx + 0.5f).toInt() + avatarDrawableRect.left, (dy + 0.5f).toInt() + avatarDrawableRect.top)

        bitmapShader!!.setLocalMatrix(shaderMatrix)
    }

    private fun getBitmapFromDrawable(drawable: Drawable?): Bitmap? {
        if (drawable == null) {
            return null
        }

        if (drawable is BitmapDrawable) {
            return drawable.bitmap
        }

        return try {
            val bitmap = if (drawable is ColorDrawable) {
                Bitmap.createBitmap(2, 2, Bitmap.Config.ARGB_8888)
            } else {
                Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
            }

            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bitmap
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun initializeBitmap() {
        avatarDrawable = getBitmapFromDrawable(drawable)
        setup()
    }

    private fun calculateBounds(): RectF {
        var availableWidth = width - paddingLeft - paddingRight
        var availableHeight = height - paddingTop - paddingBottom

        return if (isRect) {
            availableWidth -= borderThickness
            availableHeight -= borderThickness
            val left = paddingLeft.toFloat() + borderThickness / 2
            val top = paddingTop.toFloat() + borderThickness / 2

            RectF(left, top, left + availableWidth, top + availableHeight)

        } else {
            val sideLength = min(availableWidth, availableHeight)

            val left = paddingLeft + (availableWidth - sideLength) / 2f
            val top = paddingTop + (availableHeight - sideLength) / 2f

            RectF(left, top, left + sideLength, top + sideLength)
        }
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent): Boolean {
        return inTouchableArea(event.x, event.y) && super.onTouchEvent(event)
    }

    private fun inTouchableArea(x: Float, y: Float): Boolean {
        return (x - borderRect.centerX().toDouble()).pow(2.0) + (y - borderRect.centerY().toDouble()).pow(2.0) <= borderRadius.toDouble().pow(2.0)
    }

    override fun onDraw(canvas: Canvas) {
        if (avatarDrawable == null) {
            return
        }
        if (isRect) {
            val avatarCornerRadius = max(40.dp2px - avatarInset, 0.0f)
            val middleCornerRadius = max(40.dp2px - (borderThickness + middleThickness / 2), 0.0f)

            if (avatarBackgroundColor != Color.TRANSPARENT) {
                canvas.drawRoundRect(avatarDrawableRect, avatarCornerRadius, avatarCornerRadius, circleBackgroundPaint)
            }
            canvas.drawRoundRect(avatarDrawableRect, avatarCornerRadius, avatarCornerRadius, bitmapPaint)
            if (middleThickness > 0) {
                canvas.drawRoundRect(middleRect, middleCornerRadius, middleCornerRadius, middlePaint)
            }
        } else {
            if (avatarBackgroundColor != Color.TRANSPARENT) {
                canvas.drawCircle(avatarDrawableRect.centerX(), avatarDrawableRect.centerY(), drawableRadius, circleBackgroundPaint)
            }
            canvas.drawCircle(avatarDrawableRect.centerX(), avatarDrawableRect.centerY(), drawableRadius, bitmapPaint)
            if (middleThickness > 0) {
                canvas.drawCircle(middleRect.centerX(), middleRect.centerY(), middleRadius, middlePaint)
            }
        }
        drawBorder(canvas)
    }

    private fun drawBorder(canvas: Canvas) {
        if (isAnimating || isReversedAnimating) {
            val totalDegrees = (270f + animationLoopDegrees) % 360
            drawArches(totalDegrees, canvas)
            val startOfMainArch = totalDegrees + (currentAnimationArchesArea)
            canvas.drawArc(arcBorderRect, startOfMainArch, 360 - currentAnimationArchesArea, false, borderPaint)
        } else {
            if (isRect) {
                val cornerRadius = max(40.dp2px.toFloat() - borderThickness / 2, 0.0f)
                canvas.drawRoundRect(borderRect, cornerRadius, cornerRadius, borderPaint)
            } else {
                canvas.drawCircle(borderRect.centerX(), borderRect.centerY(), borderRadius, borderPaint)
            }
        }
    }

    private fun drawArches(totalDegrees: Float, canvas: Canvas) {
        for (i in 0..numberOfArches) {
            val deg = totalDegrees + (spaceBetweenArches + individualArcDegreeLength) * i * (animationArchesSparseness)
            canvas.drawArc(arcBorderRect, deg, individualArcDegreeLength, false, borderPaint)
        }
    }

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        setup()
    }

    override fun setPadding(left: Int, top: Int, right: Int, bottom: Int) {
        super.setPadding(left, top, right, bottom)
        setup()
    }

    override fun setPaddingRelative(start: Int, top: Int, end: Int, bottom: Int) {
        super.setPaddingRelative(start, top, end, bottom)
        setup()
    }

    /**
     * This section makes the elevation settings on Lollipop+ possible,
     * drawing a circlar shadow around the border
     */
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private inner class OutlineProvider : ViewOutlineProvider() {

        override fun getOutline(view: View, outline: Outline) = Rect().let {
            borderRect.roundOut(it)
            outline.setRoundRect(it, it.width() / 2.0f)
        }
    }
}