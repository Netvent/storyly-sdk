package com.storylyreactnative.data

import org.json.JSONArray
import org.json.JSONObject

internal fun jsonStringToMap(jsonString: String): Map<String, Any?>? {
    val map = try {
        JSONObject(jsonString).toMap()
    } catch (exc: Exception) {
        exc.printStackTrace()
        null
    }
    return map
}

internal fun JSONObject.toMap(): Map<String, Any?> = keys().asSequence().associateWith {
    when (val value = this[it])
    {
        is JSONArray ->
        {
            val map = (0 until value.length()).associate { Pair(it.toString(), value[it]) }
            JSONObject(map).toMap().values.toList()
        }
        is JSONObject -> value.toMap()
        JSONObject.NULL -> null
        else            -> value
    }
}
