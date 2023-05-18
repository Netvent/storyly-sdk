package com.appsamurai.storylymomentsdemo

import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import android.util.Log
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatImageView
import androidx.appcompat.widget.AppCompatTextView
import androidx.core.view.isVisible
import com.appsamurai.storyly.Story
import com.appsamurai.storyly.StoryComponent
import com.appsamurai.storyly.StoryGroup
import com.appsamurai.storyly.StorylyDataSource
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.StorylyListener
import com.appsamurai.storyly.StorylyMomentsListener
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storyly.analytics.StorylyEvent
import com.appsamurai.storyly.moments.MomentsListener
import com.appsamurai.storyly.moments.StorylyMomentsManager
import com.appsamurai.storyly.moments.analytics.StorylyMomentsEvent
import com.appsamurai.storyly.moments.config.CustomFont
import com.appsamurai.storyly.moments.config.LinkCTAState
import com.appsamurai.storyly.moments.config.MomentsConfig
import com.appsamurai.storyly.moments.config.MomentsInteractiveConfig
import com.appsamurai.storyly.moments.config.MomentsLinkCTAConfig
import com.appsamurai.storyly.moments.config.MomentsLinkItem
import com.appsamurai.storyly.moments.config.MomentsTextConfig
import com.appsamurai.storyly.moments.data.entity.MomentsCTAComponent
import com.appsamurai.storyly.moments.data.entity.MomentsComponentType
import com.appsamurai.storyly.moments.data.entity.MomentsStory
import com.appsamurai.storyly.moments.data.entity.MomentsStoryGroup
import com.appsamurai.storyly.moments.data.entity.MomentsTextComponent
import com.appsamurai.storyly.moments.data.entity.PreModeration
import com.appsamurai.storyly.moments.data.entity.PreModerationStatus
import com.appsamurai.storyly.moments.demo.util.RoundImageView
import com.appsamurai.storyly.moments.demo.util.dp2px
import com.appsamurai.storyly.storylylist.MomentsItem
import com.appsamurai.storyly.styling.moments.MomentsCustomFont
import com.appsamurai.storyly.styling.moments.StorylyMomentsLinkCTAStyling
import com.appsamurai.storyly.styling.moments.StorylyMomentsTextStyling
import com.appsamurai.storyly.styling.moments.StorylyMomentsTheme
import com.appsamurai.storylymomentsdemo.Tokens.MOMENTS_DEFAULT_TOKEN
import com.appsamurai.storylymomentsdemo.Tokens.STORYLY_DEFAULT_TOKEN
import com.appsamurai.storylymomentsdemo.Tokens.storylyPayload
import com.appsamurai.storylymomentsdemo.databinding.ActivityMainBinding

object Tokens {
    const val STORYLY_DEFAULT_TOKEN = ""
    const val MOMENTS_DEFAULT_TOKEN = ""
    const val storylyPayload = ""
}

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    private lateinit var ugc: StorylyMomentsManager

    private var userRoundImageView: RoundImageView? = null

    private val createStoryView: MomentsItem by lazy {
        val container: LinearLayout = LinearLayout(this).also {
            it.orientation = LinearLayout.VERTICAL
            it.gravity = Gravity.CENTER_HORIZONTAL
            it.layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT)
            val imageContainer: FrameLayout = FrameLayout(this).also { frameLayout ->
                frameLayout.layoutParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT)
                val roundImageView: RoundImageView = RoundImageView(this).apply {
                    layoutParams = FrameLayout.LayoutParams(80.dp2px, 80.dp2px)
                    borderColor = arrayOf(Color.parseColor("#0DFFFFFF"), Color.parseColor("#0DFFFFFF"))
                    avatarBackgroundColor = Color.parseColor("#FF212121")
                }
                val imageView = AppCompatImageView(this).apply {
                    layoutParams = FrameLayout.LayoutParams(20.dp2px, 20.dp2px, Gravity.CENTER)
                    setImageResource(R.drawable.st_create_story)
                }
                frameLayout.addView(roundImageView)
                frameLayout.addView(imageView)
                frameLayout.setOnClickListener {
                    ugc.openStoryCreator()
                }
            }
            val textView = AppCompatTextView(this).apply {
                layoutParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT)
                setLines(2)
                textSize = 12f
                text = "New Story"
                setTextColor(Color.WHITE)
            }
            it.addView(imageContainer)
            it.addView(textView)
        }
        MomentsItem(container)
    }

    private val showMyStoriesView: MomentsItem by lazy {
        val wrapper: FrameLayout = FrameLayout(this).also {
            it.layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT)
            val container: LinearLayout = LinearLayout(this).also {
                it.orientation = LinearLayout.VERTICAL
                it.layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT)
                userRoundImageView = RoundImageView(this).apply {
                    layoutParams = FrameLayout.LayoutParams(80.dp2px, 80.dp2px)
                    borderColor = arrayOf(
                        Color.parseColor("#FFFED169"), Color.parseColor("#FFFA7C20"), Color.parseColor("#FFC9287B"),
                        Color.parseColor("#FF962EC2"), Color.parseColor("#FFFED169")
                    )
                }
                val textView = AppCompatTextView(this).apply {
                    layoutParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT)
                    setLines(2)
                    textSize = 12f
                    text = ""
                    setTextColor(Color.WHITE)
                }
                it.addView(userRoundImageView)
                it.addView(textView, LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).apply {
                    gravity = Gravity.CENTER_HORIZONTAL
                })
                it.setOnClickListener {
                    ugc.openUserStories()
                }
            }
            it.addView(container)
            it.addView(preModerationFailedIcon, FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.WRAP_CONTENT,
                FrameLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                gravity = Gravity.BOTTOM or Gravity.END
                setMargins(0, 0, 0, 28.dp2px)
            })
        }
        MomentsItem(wrapper)
    }

    private val preModerationFailedIcon: AppCompatImageView by lazy {
        val preModerationFailedImageView = AppCompatImageView(this).apply {
            layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT, FrameLayout.LayoutParams.WRAP_CONTENT)
            setImageResource(R.drawable.st_moments_premoderation_failed_icon)
            visibility = View.INVISIBLE
        }
        preModerationFailedImageView
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val linkCTAItems = listOf(
            MomentsLinkItem(name = "Pizza Margherita", link = "recipify=//storyly?g=41277&s=305019&instance=11196&play=s"),
            MomentsLinkItem(name = "Eggs & Olives", link = "recipify=//storyly?g=41277&s=305020&instance=11196&play=s"),
            MomentsLinkItem(name = "Mushroom Pizza", link = "recipify=//storyly?g=41277&s=305021&instance=11196&play=s"),
            MomentsLinkItem(name = "Pepperoni Pizza", link = "recipify=//storyly?g=41277&s=305022&instance=11196&play=s"),
            MomentsLinkItem(name = "Chicken Kebab", link = "recipify=//storyly?g=41278&s=305023&instance=11196&play=s"),
            MomentsLinkItem(name = "Roasted Chicken", link = "recipify=//storyly?g=41278&s=305024&instance=11196&play=s"),
            MomentsLinkItem(name = "Chicken Pot", link = "recipify=//storyly?g=41278&s=305025&instance=11196&play=s"),
            MomentsLinkItem(name = "Strawberry Pancakes", link = "recipify=//storyly?g=41279&s=305026&instance=11196&play=s"),
            MomentsLinkItem(name = "Pecan Pancakes", link = "recipify=//storyly?g=41279&s=305027&instance=11196&play=s"),
            MomentsLinkItem(name = "Blueberry Pancakes", link = "recipify=//storyly?g=41279&s=305028&instance=11196&play=s")
        )
        val customFonts = listOf<CustomFont>(
            CustomFont("lobster", Typeface.createFromAsset(assets, "Lobster1.4.otf")),
            CustomFont("avara", Typeface.createFromAsset(assets, "Avara.otf")),
            CustomFont("nemoy_bold", Typeface.createFromAsset(assets, "NemoyBold.otf")),
            CustomFont("nemoy_light", Typeface.createFromAsset(assets, "NemoyLight.otf")),
            CustomFont("nunito", Typeface.createFromAsset(assets, "NunitoLight.otf")),
            CustomFont("moments_system", Typeface.DEFAULT)
        )

        val storylyMomentsCustomFonts = listOf<MomentsCustomFont>(
            MomentsCustomFont("lobster", Typeface.createFromAsset(assets, "Lobster1.4.otf")),
            MomentsCustomFont("avara", Typeface.createFromAsset(assets, "Avara.otf")),
            MomentsCustomFont("nemoy_bold", Typeface.createFromAsset(assets, "NemoyBold.otf")),
            MomentsCustomFont("nemoy_light", Typeface.createFromAsset(assets, "NemoyLight.otf")),
            MomentsCustomFont("nunito", Typeface.createFromAsset(assets, "NunitoLight.otf")),
            MomentsCustomFont("moments_system", Typeface.DEFAULT)
        )

            val linkCTAConfig = MomentsLinkCTAConfig.Builder()
                .setMomentsLinkCTAState(LinkCTAState.All)
                .setMomentsLinkItems(linkCTAItems)
                .setLinkTextColor(Color.RED)
                .build()
            val textConfig = MomentsTextConfig.Builder()
                .setCustomFonts(customFonts)
                .build()
            val interactiveConfig = MomentsInteractiveConfig.Builder()
                .setLinkCTAConfig(linkCTAConfig)
                .setTextConfig(textConfig)
                .build()
            val momentsConfig = MomentsConfig.Builder()
                .setInteractiveConfig(interactiveConfig)
                .build(MOMENTS_DEFAULT_TOKEN, storylyPayload)
            ugc = StorylyMomentsManager(this, momentsConfig)

            val storylyMomentsTheme = StorylyMomentsTheme.Builder()
                .setMomentsUserAnalyticsVisibility(true)
                .setTextStylingStyling(StorylyMomentsTextStyling.Builder()
                    .setCustomFonts(storylyMomentsCustomFonts)
                    .build())
                .setLinkCtaStyling(StorylyMomentsLinkCTAStyling.Builder()
                    .setLinkTextColor(Color.RED)
                    .build())
                .build()
            binding.storylyView.setMomentsTheme(storylyMomentsTheme)
        val storylyMomentsListener = object : MomentsListener {
            override fun storylyMomentsEvent(
                event: StorylyMomentsEvent,
                momentsStoryGroup: MomentsStoryGroup?,
                stories: List<MomentsStory>?
            ) {
                Log.d("[Storyly Moments]", "storylyEvent:${event.name}")
                super.storylyMomentsEvent(event, momentsStoryGroup, stories)
                if (event == StorylyMomentsEvent.UserStoryScreenClosed) {
                    if ((momentsStoryGroup?.stories?.size ?: 0) > 0) {
                        binding.storylyView.setMomentsItem(listOf(createStoryView, showMyStoriesView))
                        if (momentsStoryGroup?.stories?.any { it.preModerationStatus == PreModerationStatus.Failed } == true) {
                            preModerationFailedIcon.isVisible = true
                            userRoundImageView?.borderColor = arrayOf(
                                Color.parseColor("#FD0B0B"), Color.parseColor("#FD0B0B")
                            )
                        } else {
                            preModerationFailedIcon.isVisible = false
                            val storyNotSeen = momentsStoryGroup?.stories?.filter { !it.seen }
                            if ((storyNotSeen?.size ?: 0) > 0) {
                                userRoundImageView?.borderColor = arrayOf(
                                    Color.parseColor("#FFFED169"), Color.parseColor("#FFFA7C20"), Color.parseColor("#FFC9287B"),
                                    Color.parseColor("#FF962EC2"), Color.parseColor("#FFFED169")
                                )
                            } else {
                                userRoundImageView?.borderColor = arrayOf(
                                    Color.parseColor("#DCDCDC"), Color.parseColor("#DCDCDC")
                                )
                            }
                        }
                    } else {
                        binding.storylyView.setMomentsItem(listOf(createStoryView))
                    }
                }
            }

            override fun onStoryCreatorOpen() {
                Log.d("[Storyly Moments]", "Open Story creator ")
                super.onStoryCreatorOpen()
            }

            override fun onStoryCreatorClose() {
                Log.d("[Storyly Moments]", "Close Story creator")
                super.onStoryCreatorClose()
            }

            override fun onUserStoriesOpen() {
                Log.d("[Storyly Moments]", "Open user stories")
                super.onUserStoriesOpen()
            }

            override fun onUserStoriesClose() {
                Log.d("[Storyly Moments]", "User stories closed")
                super.onUserStoriesClose()
            }

            override fun onPreModeration(preModerationList: List<PreModeration?>, onCompletion: () -> Unit) {
                preModerationList.forEach { preModeration ->
                    if (preModeration?.storyComponents?.any { component ->
                            when (component.type) {
                                MomentsComponentType.Text -> {
                                    (component as MomentsTextComponent).text.contains("bad")
                                }
                                MomentsComponentType.CTA -> (component as MomentsCTAComponent).urlText.contains("bad") || component.stickerText.contains("bad")
                                MomentsComponentType.Image -> false
                                MomentsComponentType.Video -> false
                            }
                        } == true) {
                        preModeration.status = PreModerationStatus.Failed
                        preModeration.failMessage = "Oops, You are not allowed to use the word: “bad”."
                        Log.d("premoderation", preModeration.status.toString() + " ${preModeration.failMessage}")
                    }
                }
                onCompletion()
            }

            override fun onUserActionClicked(story: MomentsStory) {
                Log.d("TAG", "onUserActionClicked: ${story.media.actionUrl} ")
            }

            override fun onUserStoriesLoadFailed(errorMessage: String) {
                Log.d("[Storyly Moments]", "User stories load failed")
                super.onUserStoriesLoadFailed(errorMessage)
            }

            override fun storyHeaderClicked(momentsStoryGroup: MomentsStoryGroup?, story: MomentsStory?) {
                Log.d("[Storyly Moments]", "Story Header clicked")
                super.storyHeaderClicked(momentsStoryGroup, story)
            }

            override fun onUserStoriesLoaded(momentsStoryGroup: MomentsStoryGroup?) {
                Log.d("[Storyly Moments]", "User stories loaded successfully with ${momentsStoryGroup?.stories?.size} stories")
                super.onUserStoriesLoaded(momentsStoryGroup)
                if ((momentsStoryGroup?.stories?.size ?: 0) > 0) {
                    binding.storylyView.setMomentsItem(listOf(createStoryView, showMyStoriesView))
                    if (momentsStoryGroup?.stories?.any { it.preModerationStatus == PreModerationStatus.Failed } == true) {
                        preModerationFailedIcon.isVisible = true
                        userRoundImageView?.borderColor = arrayOf(
                            Color.parseColor("#FD0B0B"), Color.parseColor("#FD0B0B")
                        )
                    } else {
                        preModerationFailedIcon.isVisible = false
                        val storyNotSeen = momentsStoryGroup?.stories?.filter { !it.seen }
                        if ((storyNotSeen?.size ?: 0) > 0) {
                            userRoundImageView?.borderColor = arrayOf(
                                Color.parseColor("#FFFED169"), Color.parseColor("#FFFA7C20"), Color.parseColor("#FFC9287B"),
                                Color.parseColor("#FF962EC2"), Color.parseColor("#FFFED169")
                            )
                        } else {
                            userRoundImageView?.borderColor = arrayOf(
                                Color.parseColor("#DCDCDC"), Color.parseColor("#DCDCDC")
                            )
                        }
                    }
                } else {
                    binding.storylyView.setMomentsItem(listOf(createStoryView))
                }
            }
        }

        val storylyListener = object : StorylyListener {
            override fun storylyLoaded(storylyView: StorylyView, storyGroupList: List<StoryGroup>, dataSource: StorylyDataSource) {
                super.storylyLoaded(storylyView, storyGroupList, dataSource)
                Log.d("[Storyly]", "storylyLoaded:${storyGroupList.size}")
            }

            override fun storylyLoadFailed(storylyView: StorylyView, errorMessage: String) {
                super.storylyLoadFailed(storylyView, errorMessage)
                Log.d("[Storyly]", "storylyLoadFailed:errorMessage:$errorMessage")
            }

            override fun storylyActionClicked(storylyView: StorylyView, story: Story) {
                Log.d("[Storyly]", "storylyActionClicked:${story.media.actionUrl}")
            }

            override fun storylyStoryShown(storylyView: StorylyView) {
                super.storylyStoryShown(storylyView)
                Log.d("[Storyly]", "storylyStoryShown")
            }

            override fun storylyStoryDismissed(storylyView: StorylyView) {
                super.storylyStoryDismissed(storylyView)
                Log.d("[Storyly]", "storylyStoryDismissed")
            }

            override fun storylyStoryShowFailed(storylyView: StorylyView, errorMessage: String) {
                super.storylyStoryShowFailed(storylyView, errorMessage)
                Log.d("[Storyly]", "storylyStoryShowFailed:$errorMessage")
            }

            override fun storylyUserInteracted(
                storylyView: StorylyView,
                storyGroup: StoryGroup,
                story: Story,
                storyComponent: StoryComponent
            ) {
                super.storylyUserInteracted(storylyView, storyGroup, story, storyComponent)
                Log.d("[Storyly]", "storylyStoryLayerInteracted")
            }

            override fun storylyEvent(
                storylyView: StorylyView,
                event: StorylyEvent,
                storyGroup: StoryGroup?,
                story: Story?,
                storyComponent: StoryComponent?
            ) {
                super.storylyEvent(storylyView, event, storyGroup, story, storyComponent)
                Log.d("[Storyly]", "storylyEvent:${event.name}")
            }
        }

        binding.storylyView.storylyListener = storylyListener
        ugc.momentsListener = storylyMomentsListener
        binding.storylyView.storylyInit =
            StorylyInit(STORYLY_DEFAULT_TOKEN, storylyPayload = storylyPayload)
        binding.storylyView.setMomentsItem(listOf(createStoryView, showMyStoriesView))

        binding.storylyView.storylyMomentsListener = object : StorylyMomentsListener {
            override fun storyHeaderClicked(
                storylyView: StorylyView,
                storyGroup: StoryGroup?,
                story: Story?
            ) {

                Log.d("[Storyly]", "storylyHeaderClicked")
                super.storyHeaderClicked(storylyView, storyGroup, story)
            }
        }

    }
}