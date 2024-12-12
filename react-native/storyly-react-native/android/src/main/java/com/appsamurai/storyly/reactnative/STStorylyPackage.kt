package com.appsamurai.storyly.reactnative

import com.appsamurai.storyly.reactnative.verticalFeed.STVerticalFeedManager
import com.appsamurai.storyly.reactnative.verticalFeedBar.STVerticalFeedBarManager
import com.appsamurai.storyly.reactnative.verticalFeedPresenter.STVerticalFeedPresenterManager
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

class STStorylyPackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> = listOf()

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> = listOf(STStorylyManager(), STVerticalFeedBarManager(), STVerticalFeedManager(), STVerticalFeedPresenterManager(), STStorylyGroupViewManager())
}