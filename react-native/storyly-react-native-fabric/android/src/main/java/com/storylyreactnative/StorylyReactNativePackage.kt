package com.storylyreactnative

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import java.util.ArrayList

class StorylyReactNativeViewPackage : ReactPackage {
    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return listOf(StorylyReactNativeViewManager(), StorylyGroupViewManager())
    }

    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return emptyList()
    }
}
