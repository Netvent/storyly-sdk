package com.appsamurai.storylydemo

import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.appsamurai.storyly.StorylyInit
import com.appsamurai.storyly.StorylyView
import com.appsamurai.storylydemo.databinding.ActivityRecyclerViewBinding

class RecyclerViewActivity: AppCompatActivity() {
    private lateinit var binding: ActivityRecyclerViewBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityRecyclerViewBinding.inflate(LayoutInflater.from(this))
        setContentView(binding.root)

        binding.recyclerView.apply {
            layoutManager = LinearLayoutManager(this@RecyclerViewActivity)
            addItemDecoration(DividerItemDecoration(this@RecyclerViewActivity, RecyclerView.VERTICAL))
            adapter = StorylyAdapter().apply { notifyDataSetChanged() }
        }
    }

    private inner class StorylyAdapter: RecyclerView.Adapter<StorylyAdapter.ViewHolder>() {
        private val StorylyViewType = 0
        private val NonStorylyViewType = 1

        private val nonStorylyViewCount = 40
        private val storylyViewCount = 4

        // It's safer and network friendly creating StorylyView instance and using it inside RecyclerView instead of creating for each RecyclerView
        // item. StorylyView does a network request each initialization time. So, doing a creation and initialization process when each time view
        // is recycled performance might be affected. Keeping a StorylyView instance or several instances inside array and use them each time can
        // improve performance according to your case. Please note that, if the view is not recycled in your case(less items in RecyclerView,
        // more RecyclerView pool size), this improvement may not have an effect on your case.
        private val storylyView = StorylyView(this@RecyclerViewActivity).apply { storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN) }

        private inner class ViewHolder(view: View): RecyclerView.ViewHolder(view.apply { layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, context.resources.getDimension(R.dimen.st_storyly_large_height).toInt()) })

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            // Creating StorylyView inside onCreateViewHolder might cause rendering of view several times and network request as a plus.
            return when (viewType) {
                StorylyViewType -> {
                    // ViewHolder(StorylyView(this@RecyclerViewActivity).apply { /** storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN) */ })
                    ViewHolder(storylyView)
                }
                else -> ViewHolder(View(this@RecyclerViewActivity).apply { setBackgroundColor(Color.rgb((30..200).random(), (30..200).random(), (30..200).random())) })
            }
        }

        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            // Initializing StorylyView inside onBindViewHolder causes network requests to update data and rendering processes. Those most likely
            // are unnecessary for the user according to your use case.
//            if (holder.itemView is StorylyView) {
//                holder.itemView.storylyInit = StorylyInit(STORYLY_INSTANCE_TOKEN)
//            }
        }

        override fun getItemCount(): Int = nonStorylyViewCount + storylyViewCount

        override fun getItemViewType(position: Int): Int = if (position % (nonStorylyViewCount / storylyViewCount + 1) == 0) StorylyViewType else NonStorylyViewType
    }
}