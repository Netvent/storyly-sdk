package com.storylyplacementreactnative.newarch

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event
import com.storylyplacementreactnative.common.RNPlacementEventType


class RNPlacementEvent(
    surfaceId: Int,
    viewId: Int,
    private val eventType: RNPlacementEventType,
    private val jsonPayload: String
) : Event<RNPlacementEvent>(surfaceId, viewId) {
    override fun getEventName(): String = eventType.eventName

    override fun canCoalesce() = false

    override fun getEventData(): WritableMap {
        return Arguments.createMap().apply {
            putString("raw", jsonPayload)
        }
    }
}


