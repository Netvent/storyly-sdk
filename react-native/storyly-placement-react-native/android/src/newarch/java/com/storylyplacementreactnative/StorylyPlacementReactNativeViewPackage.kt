package com.storylyplacementreactnative

import com.facebook.react.BaseReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider
import com.facebook.react.uimanager.ViewManager
import com.storylyplacementreactnative.newarch.StorylyPlacementProviderModule
import com.storylyplacementreactnative.newarch.StorylyPlacementViewManager


class StorylyPlacementReactNativeViewPackage : BaseReactPackage() {

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return listOf(
            StorylyPlacementViewManager()
        )
    }

    override fun getModule(name: String, reactContext: ReactApplicationContext): NativeModule? {
        return when (name) {
            StorylyPlacementProviderModule.NAME -> StorylyPlacementProviderModule(reactContext)
            else -> null
        }
    }

    override fun getReactModuleInfoProvider(): ReactModuleInfoProvider {
        return ReactModuleInfoProvider {
            mapOf(
                StorylyPlacementProviderModule.NAME to ReactModuleInfo(
                    StorylyPlacementProviderModule.NAME,
                    StorylyPlacementProviderModule::class.java.name,
                    false, // canOverrideExistingModule
                    false, // needsEagerInit
                    false, // isCxxModule
                    true   // isTurboModule
                )
            )
        }
    }
}
