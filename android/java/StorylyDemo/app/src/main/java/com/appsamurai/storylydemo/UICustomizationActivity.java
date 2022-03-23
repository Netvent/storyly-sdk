package com.appsamurai.storylydemo;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.appsamurai.storyly.Story;
import com.appsamurai.storyly.StoryComponent;
import com.appsamurai.storyly.StoryGroup;
import com.appsamurai.storyly.StorylyDataSource;
import com.appsamurai.storyly.StorylyInit;
import com.appsamurai.storyly.StorylyListener;
import com.appsamurai.storyly.StorylyView;
import com.appsamurai.storyly.analytics.StorylyEvent;

import java.util.List;

public class UICustomizationActivity  extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ui_customization);


        StorylyView storylyView = findViewById(R.id.storyly_view);
//        storylyView.setStorylyInit(new StorylyInit(STORYLY_DEMO_TOKEN));
        storylyView.setStorylyListener(new StorylyListener() {
            @Override
            public void storylyLoaded(@NonNull StorylyView storylyView, @NonNull List<StoryGroup> storyGroupList, @NonNull StorylyDataSource storylyDataSource) {
                Log.d("[storyly]", "IntegrationActivity:storylyLoaded - storyGroupList size {"+storyGroupList.size()+"} - source {"+storylyDataSource+"}");
            }

            @Override
            public void storylyLoadFailed(@NonNull StorylyView storylyView, @NonNull String errorMessage) {
                Log.d("[storyly]", "IntegrationActivity:storylyLoadFailed - error {"+errorMessage+"}");
            }

            @Override
            public void storylyActionClicked(@NonNull StorylyView storylyView, @NonNull Story story) {}

            @Override
            public void storylyStoryShown(@NonNull StorylyView storylyView) {}

            @Override
            public void storylyStoryShowFailed(@NonNull StorylyView storylyView, @NonNull String errorMessage) {}

            @Override
            public void storylyStoryDismissed(@NonNull StorylyView storylyView) {}

            @Override
            public void storylyUserInteracted(@NonNull StorylyView storylyView, @NonNull StoryGroup storyGroup, @NonNull Story story, @NonNull StoryComponent storyComponent) {}

            @Override
            public void storylyEvent(@NonNull StorylyView storylyView, @NonNull StorylyEvent storylyEvent, @Nullable StoryGroup storyGroup, @Nullable Story story, @Nullable StoryComponent storyComponent) {}
        });
    }
}
