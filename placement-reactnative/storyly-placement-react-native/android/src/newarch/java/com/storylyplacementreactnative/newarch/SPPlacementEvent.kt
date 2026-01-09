package com.storylyplacementreactnative.newarch

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event
import com.storylyplacementreactnative.common.SPPlacementEventType


class SPPlacementEvent(
    surfaceId: Int,
    viewId: Int,
    private val eventType: SPPlacementEventType,
    private val jsonPayload: String?
) : Event<SPPlacementEvent>(surfaceId, viewId) {
    override fun getEventName(): String = eventType.eventName

    override fun canCoalesce(): Boolean {
      return false
    }

    override fun getEventData(): WritableMap {
        return Arguments.createMap().apply {
            jsonPayload?.let {
               putString("raw", jsonPayload)
            }
        }
    }
}


