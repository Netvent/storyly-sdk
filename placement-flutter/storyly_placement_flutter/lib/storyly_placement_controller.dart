import 'dart:convert';
import 'package:flutter/services.dart';
import 'data/product.dart';
import 'data/events/payloads.dart';

class STRWidgetController {
  final StorylyPlacementController _controller;
  final PlacementWidget _widget;

  STRWidgetController(this._controller, this._widget);

  Future<void> pause() {
    return _controller.callWidget(_widget.viewId, 'pause', '{}');
  }

  Future<void> resume() {
    return _controller.callWidget(_widget.viewId, 'resume', '{}');
  }

  Future<void> open({required String uri}) {
    return _controller.callWidget(
      _widget.viewId,
      'open',
      jsonEncode({'uri': uri}),
    );
  }
}

class STRStoryBarController extends STRWidgetController {
  STRStoryBarController(super._controller, super._widget);

  Future<void> openWithId({
    required String storyGroupId,
    String? storyId,
    String? playMode, // "storygroup" | "story" | "default"
  }) {
    return _controller.callWidget(
      _widget.viewId,
      'openWithId',
      jsonEncode({
        'storyGroupId': storyGroupId,
        'storyId': storyId,
        'playMode': playMode,
      }),
    );
  }
}

class STRVideoFeedController extends STRWidgetController {
  STRVideoFeedController(super._controller, super._widget);

  Future<void> openWithId({
    required String feedGroupId,
    String? feedId,
    String? playMode, // "feedgroup" | "feed" | "default"
  }) {
    return _controller.callWidget(
      _widget.viewId,
      'openWithId',
      jsonEncode({
        'feedGroupId': feedGroupId,
        'feedId': feedId,
        'playMode': playMode,
      }),
    );
  }
}

class STRVideoFeedPresenterController extends STRWidgetController {
  STRVideoFeedPresenterController(super._controller, super._widget);

  Future<void> play() {
    return _controller.callWidget(_widget.viewId, 'play', '{}');
  }

  Future<void> openWithId({required String feedGroupId}) {
    return _controller.callWidget(
      _widget.viewId,
      'openWithId',
      jsonEncode({'feedGroupId': feedGroupId}),
    );
  }
}

class StorylyPlacementController {
  MethodChannel? _methodChannel;

  void init(int viewId) {
    _methodChannel = MethodChannel('storyly_placement_flutter/view_$viewId');
  }

  T getWidget<T extends STRWidgetController>(PlacementWidget widget) {
    switch (widget.type) {
      case "story-bar":
        return STRStoryBarController(this, widget) as T;
      case "video-feed":
        return STRVideoFeedController(this, widget) as T;
      case "video-feed-presenter":
        return STRVideoFeedPresenterController(this, widget) as T;
      default:
        throw Exception("Unknown widget type: ${widget.type}");
    }
  }

  Future<void> approveCartChange(String responseId) async {
    await _methodChannel?.invokeMethod('approveCartChange', {
      'responseId': responseId,
      'raw': null,
    });
  }

  Future<void> rejectCartChange(String responseId, String failMessage) async {
    await _methodChannel?.invokeMethod('rejectCartChange', {
      'responseId': responseId,
      'raw': jsonEncode({'failMessage': failMessage}),
    });
  }

  Future<void> approveWishlistChange(String responseId) async {
    await _methodChannel?.invokeMethod('approveWishlistChange', {
      'responseId': responseId,
      'raw': null,
    });
  }

  Future<void> rejectWishlistChange(
    String responseId,
    String failMessage,
  ) async {
    await _methodChannel?.invokeMethod('rejectWishlistChange', {
      'responseId': responseId,
      'raw': jsonEncode({'failMessage': failMessage}),
    });
  }

  Future<void> callWidget(String viewId, String method, String raw) async {
    await _methodChannel?.invokeMethod('callWidget', {
      'viewId': viewId,
      'method': method,
      'raw': raw,
    });
  }

  Future<void> configure(String providerId) async {
    await _methodChannel?.invokeMethod('configure', {'providerId': providerId});
  }
}
