package com.appsamurai.storylytwiliosample

import android.content.Context
import com.segment.analytics.kotlin.android.Analytics
import com.segment.analytics.kotlin.core.Analytics
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.add
import kotlinx.serialization.json.buildJsonArray
import kotlinx.serialization.json.buildJsonObject
import kotlinx.serialization.json.put

/**
 * A thin wrapper around Twilio Segment's analytics-kotlin SDK that exposes a
 * single shared [Analytics] instance for the app.
 *
 * Setup:
 * 1. The Segment dependency is declared in app/build.gradle:
 *    `com.segment.analytics.kotlin:android`
 * 2. Replace [WRITE_KEY] below with your source's write key from the Segment
 *    dashboard (Connections > Sources > <your source> > Settings > API Keys).
 * 3. Call [initialize] once, early in the app lifecycle (see MainActivity).
 */
object SegmentManager {

    /** Your Segment source write key. Replace with your own value. */
    private const val WRITE_KEY = "YOUR_SEGMENT_WRITE_KEY"

    private lateinit var analytics: Analytics

    /** Spins up the shared Analytics instance. Safe to call more than once. */
    fun initialize(context: Context) {
        if (::analytics.isInitialized) return
        analytics = Analytics(WRITE_KEY, context) {
            // Automatically track Application Opened / Installed / Updated, etc.
            trackApplicationLifecycleEvents = true
            // Flush after this many events are queued.
            flushAt = 3
            // Or flush at least this often (seconds).
            flushInterval = 10
        }
    }

    /**
     * Records a Segment `track` call for a single user action.
     *
     * @param event Human-readable event name (e.g. "StoryGroupOpened").
     * @param properties Free-form map describing the event.
     */
    fun track(event: String, properties: Map<String, Any?>) {
        analytics.track(event, properties.toJsonObject())
    }

    /**
     * Records a Segment `identify` call, associating the current (and all
     * subsequent) events with a known user.
     *
     * @param userId Your app's unique identifier for the user.
     * @param traits Optional attributes describing the user (name, email, plan, …).
     */
    fun identify(userId: String, traits: Map<String, Any?> = emptyMap()) {
        if (traits.isEmpty()) {
            analytics.identify(userId)
        } else {
            analytics.identify(userId, traits.toJsonObject())
        }
    }

    // region Map -> JsonObject conversion

    private fun Map<String, Any?>.toJsonObject(): JsonObject = buildJsonObject {
        this@toJsonObject.forEach { (key, value) -> put(key, value.toJsonElement()) }
    }

    private fun Any?.toJsonElement(): JsonElement = when (val value = this) {
        null -> JsonNull
        is JsonElement -> value
        is String -> JsonPrimitive(value)
        is Boolean -> JsonPrimitive(value)
        is Number -> JsonPrimitive(value)
        is Map<*, *> -> buildJsonObject {
            value.forEach { (k, v) -> put(k.toString(), v.toJsonElement()) }
        }
        is Iterable<*> -> buildJsonArray {
            value.forEach { add(it.toJsonElement()) }
        }
        else -> JsonPrimitive(value.toString())
    }

    // endregion
}
