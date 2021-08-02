package com.appsamurai.storylydemo;

import androidx.multidex.MultiDexApplication;
import com.google.android.gms.ads.MobileAds;

public class MainApplication extends MultiDexApplication {
    @Override
    public void onCreate() {
        super.onCreate();

        MobileAds.initialize(this);
    }
}
