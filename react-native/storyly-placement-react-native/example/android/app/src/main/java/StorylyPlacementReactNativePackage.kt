import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.storylyplacementreactnative.newarch.StorylyPlacementProviderModule
import com.storylyplacementreactnative.newarch.StorylyPlacementViewManager


class StorylyPlacementReactNativePackage : ReactPackage {

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
}
