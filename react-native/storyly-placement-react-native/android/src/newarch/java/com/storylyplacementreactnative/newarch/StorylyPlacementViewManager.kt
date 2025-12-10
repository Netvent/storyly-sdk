package com.storylyplacementreactnative.newarch

import android.util.Log
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.UIManagerHelper
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.StorylyPlacementReactNativeViewManagerInterface
import com.facebook.react.viewmanagers.StorylyPlacementReactNativeViewManagerDelegate
import com.storylyplacementreactnative.common.RNPlacementEventType
import com.storylyplacementreactnative.common.RNStorylyPlacementView


@ReactModule(name = StorylyPlacementViewManager.NAME)
class StorylyPlacementViewManager : SimpleViewManager<RNStorylyPlacementView>(),
    StorylyPlacementReactNativeViewManagerInterface<RNStorylyPlacementView> {

    companion object {
        const val NAME = "StorylyPlacementReactNativeView"
    }

    private val delegate: ViewManagerDelegate<RNStorylyPlacementView> =
        StorylyPlacementReactNativeViewManagerDelegate(this)

    override fun getDelegate(): ViewManagerDelegate<RNStorylyPlacementView> = delegate

    override fun getName(): String = NAME

    override fun createViewInstance(context: ThemedReactContext): RNStorylyPlacementView {
        return RNStorylyPlacementView(context).apply {
            dispatchEvent = { eventType, jsonPayload ->
                val surfaceId = UIManagerHelper.getSurfaceId(context)
                val eventDispatcher = UIManagerHelper.getEventDispatcherForReactTag(context, id)
                eventDispatcher?.dispatchEvent(
                    RNPlacementEvent(surfaceId, id, eventType, jsonPayload)
                )
            }
        }
    }


    override fun setProviderId(view: RNStorylyPlacementView?, providerId: String?) {
        providerId ?: return
        view?.configure(providerId)
    }

    override fun approveCartChange(view: RNStorylyPlacementView?, responseId: String, raw: String?) {
        view?.approveCartChange(responseId, raw)
    }

    override fun rejectCartChange(view: RNStorylyPlacementView?, responseId: String, raw: String?) {
        view?.rejectCartChange(responseId, raw)
    }

    override fun approveWishlistChange(view: RNStorylyPlacementView?, responseId: String, raw: String?) {
        view?.approveWishlistChange(responseId, raw)
    }

    override fun rejectWishlistChange(view: RNStorylyPlacementView?, responseId: String, raw: String?) {
        view?.rejectWishlistChange(responseId, raw)
    }

    override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any>? {
        val events = super.getExportedCustomDirectEventTypeConstants()
        val eventMap = mutableMapOf<String, Any>()
        events?.forEach { eventMap[it.key] = it.value }
        RNPlacementEventType.entries.forEach {
            eventMap[it.eventName] = mapOf("registrationName" to it.eventName)
        }
        return eventMap
    }
}


