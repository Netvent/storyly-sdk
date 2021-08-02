package com.appsamurai.storylydemo;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import com.appsamurai.storyly.StorylyInit;
import com.appsamurai.storyly.StorylyView;
import com.appsamurai.storyly.monetization.StorylyAdViewProvider;

public class AdActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ad);

        StorylyView storylyView = findViewById(R.id.storyly_view);
        storylyView.setStorylyInit(new StorylyInit(Tokens.STORYLY_INSTANCE_TOKEN));
        storylyView.setStorylyAdViewProvider(new StorylyAdViewProvider(this, Tokens.ADMOB_NATIVE_AD_ID));
    }
}
