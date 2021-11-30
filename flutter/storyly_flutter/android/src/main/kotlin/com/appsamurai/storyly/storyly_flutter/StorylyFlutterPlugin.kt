package com.appsamurai.storyly.storyly_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class StorylyFlutterPlugin: FlutterPlugin, ActivityAware {
    private lateinit var flutterStorylyViewFactory: FlutterStorylyViewFactory

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterStorylyViewFactory = FlutterStorylyViewFactory(flutterPluginBinding.binaryMessenger)

        flutterPluginBinding
                .platformViewRegistry
                .registerViewFactory("FlutterStorylyView", flutterStorylyViewFactory)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {}

    override fun onDetachedFromActivity() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        flutterStorylyViewFactory.context = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}
}
