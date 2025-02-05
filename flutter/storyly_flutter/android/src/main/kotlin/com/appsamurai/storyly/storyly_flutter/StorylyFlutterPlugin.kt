package com.appsamurai.storyly.storyly_flutter

import com.appsamurai.storyly.storyly_flutter.vertical_feed.FlutterVerticalFeedBarViewFactory
import com.appsamurai.storyly.storyly_flutter.vertical_feed.FlutterVerticalFeedPresenterViewFactory
import com.appsamurai.storyly.storyly_flutter.vertical_feed.FlutterVerticalFeedViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class StorylyFlutterPlugin: FlutterPlugin, ActivityAware {
    private lateinit var flutterStorylyViewFactory: FlutterStorylyViewFactory
    private lateinit var flutterVerticalFeedViewFactory: FlutterVerticalFeedViewFactory
    private lateinit var flutterVerticalFeedBarViewFactory: FlutterVerticalFeedBarViewFactory
    private lateinit var flutterVerticalFeedPresenterViewFactory: FlutterVerticalFeedPresenterViewFactory

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

        flutterVerticalFeedPresenterViewFactory = FlutterVerticalFeedPresenterViewFactory(flutterPluginBinding.binaryMessenger)
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("FlutterVerticalFeedPresenter", flutterVerticalFeedPresenterViewFactory)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}

    override fun onDetachedFromActivity() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        flutterStorylyViewFactory.context = binding.activity
        flutterVerticalFeedViewFactory.context = binding.activity
        flutterVerticalFeedBarViewFactory.context = binding.activity
        flutterVerticalFeedPresenterViewFactory.context = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}
}
