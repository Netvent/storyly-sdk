package com.appsamurai.storylydemo

import androidx.multidex.MultiDexApplication
import com.google.android.gms.ads.MobileAds

class MainApplication: MultiDexApplication() {
    override fun onCreate() {
        super.onCreate()

        MobileAds.initialize(this) {}
    }
}