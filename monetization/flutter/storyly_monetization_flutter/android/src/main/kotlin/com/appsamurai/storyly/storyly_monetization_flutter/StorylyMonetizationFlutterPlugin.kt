package com.appsamurai.storyly.storyly_monetization_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class StorylyMonetizationFlutterPlugin: FlutterPlugin, ActivityAware {
    private lateinit var storylyMonetizationFlutter: StorylyMonetizationFlutter

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        storylyMonetizationFlutter = StorylyMonetizationFlutter(binding.binaryMessenger, binding.flutterEngine)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {}

    override fun onDetachedFromActivity() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        storylyMonetizationFlutter.context = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}
}
