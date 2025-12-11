package com.storylyplacementreactnative.oldarch

import android.util.Log
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.common.MapBuilder
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.facebook.react.uimanager.events.RCTModernEventEmitter
import com.storylyplacementreactnative.common.RNPlacementEventType
import com.storylyplacementreactnative.common.RNStorylyPlacementView


@ReactModule(name = StorylyPlacementViewManager.NAME)
class StorylyPlacementViewManager : SimpleViewManager<RNStorylyPlacementView>() {

    companion object {
        const val NAME = "StorylyPlacementReactNativeViewLegacy"
    }

    enum class Command(val id: Int, val commandName: String) {
        APPROVE_CART_CHANGE(1, "approveCartChange"),
        REJECT_CART_CHANGE(2, "rejectCartChange"),
        APPROVE_WISHLIST_CHANGE(3, "approveWishlistChange"),
        REJECT_WISHLIST_CHANGE(4, "rejectWishlistChange");

        companion object {
            fun fromName(name: String): Command? = entries.find { it.commandName == name }
        }
    }

    override fun getName(): String = NAME

    override fun createViewInstance(context: ThemedReactContext): RNStorylyPlacementView {
        return RNStorylyPlacementView(context).apply {
            dispatchEvent = { eventType, jsonPayload ->
                context
                    .getJSModule(RCTEventEmitter::class.java)
                    .receiveEvent(id, eventType.eventName, createEventMap(jsonPayload))
            }
        }
    }

    private fun createEventMap(jsonPayload: String?): WritableMap {
        return Arguments.createMap().apply {
            jsonPayload?.let { putString("raw", it) }
        }
    }

    @ReactProp(name = "providerId")
    fun setProviderId(view: RNStorylyPlacementView, providerId: String?) {
        providerId ?: return
        view.configure(providerId)
    }

    override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any>? {
        val events = super.getExportedCustomDirectEventTypeConstants()
        val eventMap = mutableMapOf<String, Any>()
        events?.forEach { eventMap[it.key] = it.value }
        RNPlacementEventType.entries.forEach {
            eventMap[it.eventName] = MapBuilder.of("registrationName", it.eventName)
        }
        return eventMap
    }

    override fun getCommandsMap(): MutableMap<String, Int> {
        return Command.entries.associate { it.commandName to it.id }.toMutableMap()
    }

    override fun receiveCommand(view: RNStorylyPlacementView, commandId: String?, args: ReadableArray?) {
        val command = commandId?.let { Command.fromName(it) } ?: return
        val responseId = args?.getString(0) ?: return
        val raw = args?.getString(1)

        when (command) {
            Command.APPROVE_CART_CHANGE -> view.approveCartChange(responseId, raw)
            Command.REJECT_CART_CHANGE -> view.rejectCartChange(responseId, raw)
            Command.APPROVE_WISHLIST_CHANGE -> view.approveWishlistChange(responseId, raw)
            Command.REJECT_WISHLIST_CHANGE -> view.rejectWishlistChange(responseId, raw)
        }
    }
}
