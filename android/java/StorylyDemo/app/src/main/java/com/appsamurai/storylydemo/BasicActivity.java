package com.appsamurai.storylydemo;

import android.os.Bundle;
import android.util.Log;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.appsamurai.storyly.Story;
import com.appsamurai.storyly.StoryComponent;
import com.appsamurai.storyly.StoryEmojiComponent;
import com.appsamurai.storyly.StoryGroup;
import com.appsamurai.storyly.StoryPollComponent;
import com.appsamurai.storyly.StoryQuizComponent;
import com.appsamurai.storyly.StorylyInit;
import com.appsamurai.storyly.StorylyListener;
import com.appsamurai.storyly.StorylyView;
import com.appsamurai.storyly.analytics.StorylyEvent;

import java.util.List;

public class BasicActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        LinearLayout storylyViewHolder = findViewById(R.id.storyly_view_holder);

        StorylyView storyly_view = findViewById(R.id.storyly_view);
        storyly_view.setStorylyInit(new StorylyInit(STORYLY_INSTANCE_TOKEN));

        StorylyView storylyView = new StorylyView(this);
        storylyView.setStorylyInit(new StorylyInit(STORYLY_INSTANCE_TOKEN));
        storylyViewHolder.addView(storylyView);
    }
}
