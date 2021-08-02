package com.appsamurai.storylydemo;

import android.os.Bundle;
import android.widget.LinearLayout;

import androidx.appcompat.app.AppCompatActivity;

import com.appsamurai.storyly.StorylyInit;
import com.appsamurai.storyly.StorylyView;

public class BasicActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        LinearLayout storylyViewHolder = findViewById(R.id.storyly_view_holder);

        StorylyView storyly_view = findViewById(R.id.storyly_view);
        storyly_view.setStorylyInit(new StorylyInit(Tokens.STORYLY_INSTANCE_TOKEN));

        StorylyView storylyView = new StorylyView(this);
        storylyView.setStorylyInit(new StorylyInit(Tokens.STORYLY_INSTANCE_TOKEN));
        storylyViewHolder.addView(storylyView);
    }
}
