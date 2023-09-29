package com.storylyreactnative.data

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event
import org.json.JSONObject

internal class STEvent(
    surfaceId: Int,
    viewId: Int,
    private val event: Type,
    private val raw: Map<String, Any?>? = null
) : Event<STEvent>(surfaceId, viewId) {

    override fun getEventName() = event.rawName

    override fun getCoalescingKey(): Short = 0

    override fun getEventData(): WritableMap? = Arguments.createMap().apply {
        raw?. let {
            try {
                val json = JSONObject(it).toString()
                putString("raw", json)
            } catch (exc: Exception) {
                exc.printStackTrace()
            }
        }
    }

    enum class Type(val rawName: String) {
        ON_STORYLY_LOADED("onStorylyLoaded"),
        ON_STORYLY_LOAD_FAILED("onStorylyLoadFailed"),
        ON_STORYLY_EVENT("onStorylyEvent"),
        ON_STORYLY_ACTION_CLICKED("onStorylyActionClicked"),
        ON_STORYLY_STORY_PRESENTED("onStorylyStoryPresented"),
        ON_STORYLY_STORY_PRESENT_FAILED("onStorylyStoryPresentFailed"),
        ON_STORYLY_STORY_DISMISSED("onStorylyStoryDismissed"),
        ON_STORYLY_USER_INTERACTED("onStorylyUserInteracted"),
        ON_STORYLY_ON_HYDRATION("onStorylyProductHydration"),
        ON_STORYLY_ON_CART_UPDATED("onStorylyCartUpdated"),
        ON_STORYLY_PRODUCT_EVENT("onStorylyProductEvent"),
        ON_CREATE_CUSTOM_VIEW("onCreateCustomView"),
        ON_UPDATE_CUSTOM_VIEW("onUpdateCustomView"),
    }
}
