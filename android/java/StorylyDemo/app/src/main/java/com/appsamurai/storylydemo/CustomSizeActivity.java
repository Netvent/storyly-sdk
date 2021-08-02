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

        StorylyView storyly_view_custom_xlarge = findViewById(R.id.storyly_view_custom_xlarge);
        storyly_view_custom_xlarge.setStorylyInit(new StorylyInit(Tokens.STORYLY_INSTANCE_TOKEN));
        // storyly_view_custom_xlarge.setStoryGroupSize(StoryGroupSize.XLarge);

        StorylyView storyly_view_custom_large = findViewById(R.id.storyly_view_custom_large);
        storyly_view_custom_large.setStorylyInit(new StorylyInit(Tokens.STORYLY_INSTANCE_TOKEN));
        // storyly_view_custom_large.setStoryGroupSize(StoryGroupSize.Large);

        StorylyView storyly_view_custom_small = findViewById(R.id.storyly_view_custom_small);
        storyly_view_custom_small.setStorylyInit(new StorylyInit(Tokens.STORYLY_INSTANCE_TOKEN));
        // storyly_view_custom_small.setStoryGroupSize(StoryGroupSize.Small);

        StorylyView storyly_view_custom_portrait = findViewById(R.id.storyly_view_custom_portrait);
        storyly_view_custom_portrait.setStorylyInit(new StorylyInit(Tokens.STORYLY_INSTANCE_TOKEN));
        // storyly_view_custom_portrait.setStoryGroupSize(StoryGroupSize.Custom);
        // storyly_view_custom_portrait.setStoryGroupIconStyling(new StoryGroupIconStyling(250F, 200F, 50F));

        StorylyView storyly_view_custom_landscape = findViewById(R.id.storyly_view_custom_landscape);
        storyly_view_custom_landscape.setStorylyInit(new StorylyInit(Tokens.STORYLY_INSTANCE_TOKEN));
        // storyly_view_custom_landscape.setStoryGroupSize(StoryGroupSize.Custom);
        // storyly_view_custom_landscape.setStoryGroupIconStyling(new StoryGroupIconStyling(200F, 250F, 50F));
    }
}
