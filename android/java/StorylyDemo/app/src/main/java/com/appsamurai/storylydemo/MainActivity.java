package com.appsamurai.storylydemo;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;

import com.appsamurai.storyly.Story;
import com.appsamurai.storyly.StorylyListener;
import com.appsamurai.storyly.StorylyView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        StorylyView storylyView = findViewById(R.id.storyly_view);
        storylyView.setStorylyId("[YOUR_APP_ID_FROM_DASHBOARD]");
        storylyView.setStorylyListener(new StorylyListener() {
            @Override
            public void storylyLoaded(@NonNull StorylyView storylyView) {
                Log.d("[Storyly]", "storylyLoaded");
            }

            @Override
            public void storylyLoadFailed(@NonNull StorylyView storylyView) {
                Log.d("[Storyly]", "storylyLoadFailed");
            }

            // return true if app wants to handle redirection, otherwise return false
            @Override
            public boolean storylyActionClicked(@NonNull StorylyView storylyView, @NonNull Story story) {
                Log.d("[Storyly]", "storylyActionClicked");
                return false;
            }
        });
    }
}
