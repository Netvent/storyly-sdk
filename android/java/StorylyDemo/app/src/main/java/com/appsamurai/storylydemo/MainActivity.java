package com.appsamurai.storylydemo;

import android.os.Bundle;
import android.util.Log;

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

import java.util.List;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        StorylyView storylyView = findViewById(R.id.storyly_view);
        storylyView.setStorylyInit(new StorylyInit(YOUR_APP_INSTANCE_TOKEN_FROM_DASHBOARD));
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

            //StoryComponent can be one of the following subclasses: StoryEmojiComponent, StoryQuizComponent, StoryPollComponent.
            //Based on "type" property of storyComponent, cast this argument to the proper subclass
            @Override
            public void storylyUserInteracted(@NonNull StorylyView storylyView, @NonNull StoryGroup storyGroup, @NonNull Story story, @NonNull StoryComponent storyComponent) {
                switch (storyComponent.type) {
                    case Quiz:
                        StoryQuizComponent interactedQuiz = (StoryQuizComponent) storyComponent;
                        Log.d("[Storyly]", interactedQuiz.toString());
                        break;
                    case Poll:
                        StoryPollComponent interactedPoll = (StoryPollComponent) storyComponent;
                        Log.d("[Storyly]", interactedPoll.toString());
                        break;
                    case Emoji:
                        StoryEmojiComponent interactedEmoji = (StoryEmojiComponent) storyComponent;
                        Log.d("[Storyly]", interactedEmoji.toString());
                        break;
                    default:
                        break;
                }
            }
        });
    }
}
