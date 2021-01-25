package com.appsamurai.storylydemo;

import android.os.Bundle;
import android.widget.LinearLayout;

import androidx.appcompat.app.AppCompatActivity;

import com.appsamurai.storyly.StoryGroupSize;
import com.appsamurai.storyly.StorylyInit;
import com.appsamurai.storyly.StorylyView;
import com.appsamurai.storyly.styling.StoryGroupIconStyling;

public class CustomSizeActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_custom_size);

        LinearLayout storylyViewHolder = findViewById(R.id.storyly_view_holder);

        StorylyView storylyViewXLarge = new StorylyView(this);
        storylyViewXLarge.setStorylyInit(new StorylyInit(STORYLY_INSTANCE_TOKEN));
        storylyViewXLarge.setStoryGroupSize(StoryGroupSize.XLarge);
        storylyViewHolder.addView(storylyViewXLarge);

        StorylyView storylyViewLarge = new StorylyView(this);
        storylyViewLarge.setStorylyInit(new StorylyInit(STORYLY_INSTANCE_TOKEN));
        storylyViewLarge.setStoryGroupSize(StoryGroupSize.Large);
        storylyViewHolder.addView(storylyViewLarge);

        StorylyView storylyViewSmall = new StorylyView(this);
        storylyViewSmall.setStorylyInit(new StorylyInit(STORYLY_INSTANCE_TOKEN));
        storylyViewSmall.setStoryGroupSize(StoryGroupSize.Small);
        storylyViewHolder.addView(storylyViewSmall);

        StorylyView storylyViewCustomPortrait = new StorylyView(this);
        storylyViewCustomPortrait.setStorylyInit(new StorylyInit(STORYLY_INSTANCE_TOKEN));
        storylyViewCustomPortrait.setStoryGroupSize(StoryGroupSize.Custom);
        storylyViewCustomPortrait.setStoryGroupIconStyling(
                new StoryGroupIconStyling(250F, 200F, 50F));
        storylyViewHolder.addView(storylyViewCustomPortrait);

        StorylyView storylyViewCustomLandscape = new StorylyView(this);
        storylyViewCustomLandscape.setStorylyInit(new StorylyInit(STORYLY_INSTANCE_TOKEN));
        storylyViewCustomLandscape.setStoryGroupSize(StoryGroupSize.Custom);
        storylyViewCustomLandscape.setStoryGroupIconStyling(
                new StoryGroupIconStyling(200F, 250F, 50F));
        storylyViewHolder.addView(storylyViewCustomLandscape);
    }
}
