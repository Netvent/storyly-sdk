package com.appsamurai.storyly.storyly_placement_flutter.common.data.util

import android.util.Log
import org.json.JSONArray
import org.json.JSONObject


fun encodeToJson(map: Map<String, Any?>?): String? {
  map ?: return null
  return try {
    JSONObject(map.filterValues { it != null }).toString()
  } catch (e: Exception) {
    Log.e("[SPStorylyPlacement]", "SP bridge JSON encode error: ${e.localizedMessage ?: ""}")
    null
  }
}

fun decodeFromJson(json: String?): Map<String, Any?>? {
  json ?: return null
  return try {
    val jsonObject = JSONObject(json)
    jsonObject.toMap()
  } catch (e: Exception) {
    Log.e("[SPStorylyPlacement]", "SP bridge JSON decode error: ${e.localizedMessage ?: ""}")
    null
  }
}

private fun JSONObject.toMap(): Map<String, Any?> {
  val map = mutableMapOf<String, Any?>()
  keys().forEach { key ->
    map[key] = when (val value = get(key)) {
      is JSONObject -> value.toMap()
      is JSONArray -> value.toList()
      JSONObject.NULL -> null
      else -> value
    }
  }
  return map
}

private fun JSONArray.toList(): List<Any?> {
  return (0 until length()).map { i ->
    when (val value = get(i)) {
      is JSONObject -> value.toMap()
      is JSONArray -> value.toList()
      JSONObject.NULL -> null
      else -> value
    }
  }
}

internal fun Int.toHexString() = Integer.toHexString(this)