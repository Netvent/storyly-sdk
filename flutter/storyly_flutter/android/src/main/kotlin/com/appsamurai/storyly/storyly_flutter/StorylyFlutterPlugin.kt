package com.appsamurai.storyly.storyly_flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class StorylyFlutterPlugin: FlutterPlugin, ActivityAware {
    private lateinit var flutterStorylyViewFactory: FlutterStorylyViewFactory
    private lateinit var flutterVerticalFeedViewFactory: FlutterVerticalFeedViewFactory
    private lateinit var flutterVerticalFeedBarViewFactory: FlutterVerticalFeedBarViewFactory

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterStorylyViewFactory = FlutterStorylyViewFactory(flutterPluginBinding.binaryMessenger)
        flutterPluginBinding
                .platformViewRegistry
                .registerViewFactory("FlutterStorylyView", flutterStorylyViewFactory)

        flutterVerticalFeedViewFactory = FlutterVerticalFeedViewFactory(flutterPluginBinding.binaryMessenger)
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("FlutterVerticalFeed", flutterVerticalFeedViewFactory)

        flutterVerticalFeedBarViewFactory = FlutterVerticalFeedBarViewFactory(flutterPluginBinding.binaryMessenger)
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("FlutterVerticalFeedBar", flutterVerticalFeedBarViewFactory)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}

    override fun onDetachedFromActivity() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        flutterStorylyViewFactory.context = binding.activity
        flutterVerticalFeedViewFactory.context = binding.activity
        flutterVerticalFeedBarViewFactory.context = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}
}
