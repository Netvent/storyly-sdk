package com.appsamurai.storylydemo;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.appsamurai.storyly.Story;
import com.appsamurai.storyly.StoryGroup;
import com.appsamurai.storyly.StorylyListener;
import com.appsamurai.storyly.StorylyView;

import java.util.List;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        StorylyView storylyView = findViewById(R.id.storyly_view);
        storylyView.setStorylyId([YOUR_APP_ID_FROM_DASHBOARD]);
        storylyView.setStorylyListener(new StorylyListener() {
            @Override
            public void storylyLoaded(@NonNull StorylyView storylyView,
                                      @NonNull List<StoryGroup> storyGroupList) {
                Log.d("[Storyly]", "storylyLoaded");
            }

            @Override
            public void storylyLoadFailed(@NonNull StorylyView storylyView,
                                          @NonNull String errorMessage) {
                Log.d("[Storyly]", "storylyLoadFailed");
            }

            // return true if app wants to handle redirection, otherwise return false
            @Override
            public boolean storylyActionClicked(@NonNull StorylyView storylyView, @NonNull Story story) {
                Log.d("[Storyly]", "storylyActionClicked");
                return true;
            }

            @Override
            public void storylyStoryShown(@NonNull StorylyView storylyView) {
                Log.d("[Storyly]", "storylyStoryShown");
            }

            @Override
            public void storylyStoryDismissed(@NonNull StorylyView storylyView) {
                Log.d("[Storyly]", "storylyStoryDismissed");
            }
        });
    }
}
