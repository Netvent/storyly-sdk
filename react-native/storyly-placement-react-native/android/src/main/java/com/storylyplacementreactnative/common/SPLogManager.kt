package com.storylyplacementreactnative.common

import com.appsamurai.storyly.core.listener.log.STRLog
import com.appsamurai.storyly.core.listener.log.StorylyLogLevel


object SPLogManager {

    fun setLogLevel(level: String) {
        STRLog.logLevel = decodeLogLevel(level)
    }
}

internal fun decodeLogLevel(level: String): StorylyLogLevel = when (level.lowercase()) {
    "debug" -> StorylyLogLevel.DEBUG
    "warning" -> StorylyLogLevel.WARNING
    "error" -> StorylyLogLevel.ERROR
    else -> StorylyLogLevel.OFF
}
