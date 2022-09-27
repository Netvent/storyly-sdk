package com.appsamurai.storyly.monetization.reactnative

import android.content.Context
import android.os.Handler
import com.appsamurai.storyly.reactnative.STStorylyView
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.uimanager.UIManagerModule

class STStorylyMonetizationModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  companion object {
        const val REACT_CLASS = "RNStorylyMonetization"
    }

    override fun initialize() {
        super.initialize()
    }

    @ReactMethod
    fun setAdViewProvider(reactViewId: Int, testParam: String) {
        Handler(reactContext.mainLooper).post {
            val uiManagerModule = reactContext.getNativeModule(UIManagerModule::class.java) ?: return@post
            val storylyView = uiManagerModule.resolveView(reactViewId) as? STStorylyView ?: return@post
//          StorylyView
//            val storylyView = stStorylyView.getChildAt(0) as StorylyView
            println("test - storyly view => $storylyView")
//          storylyView.storylyAdViewProvider(testParam)
//          STStorylyPackage
        }
    }


    override fun getName(): String = REACT_CLASS

    private fun getActivityContext(): Context {
        return reactApplicationContext.currentActivity ?: reactApplicationContext
    }
}
