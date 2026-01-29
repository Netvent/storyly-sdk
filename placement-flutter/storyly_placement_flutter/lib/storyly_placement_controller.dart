import 'dart:convert';
import 'package:flutter/services.dart';
import 'data/product.dart';
import 'data/events/payloads.dart';

abstract class STRWidgetController {}

class StoryBarController implements STRWidgetController {
  final StorylyPlacementController _controller;
  final PlacementWidget _widget;

  StoryBarController(this._controller, this._widget);

  Future<void> pause() {
    return _controller.callWidget(_widget.viewId, 'pause', '{}');
  }

  Future<void> resume() {
    return _controller.callWidget(_widget.viewId, 'resume', '{}');
  }

  Future<void> close() {
    return _controller.callWidget(_widget.viewId, 'close', '{}');
  }

  Future<void> open({required String uri}) {
    return _controller.callWidget(
      _widget.viewId,
      'open',
      jsonEncode({'uri': uri}),
    );
  }

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

class VideoFeedController implements STRWidgetController {
  final StorylyPlacementController _controller;
  final PlacementWidget _widget;

  VideoFeedController(this._controller, this._widget);

  Future<void> pause() {
    return _controller.callWidget(_widget.viewId, 'pause', '{}');
  }

  Future<void> resume() {
    return _controller.callWidget(_widget.viewId, 'resume', '{}');
  }

  Future<void> close() {
    return _controller.callWidget(_widget.viewId, 'close', '{}');
  }

  Future<void> open({required String uri}) {
    return _controller.callWidget(
      _widget.viewId,
      'open',
      jsonEncode({'uri': uri}),
    );
  }

  Future<void> openWithId({
    required String groupId,
    String? itemId,
    String? playMode, // "feedgroup" | "feed" | "default"
  }) {
    return _controller.callWidget(
      _widget.viewId,
      'openWithId',
      jsonEncode({'groupId': groupId, 'itemId': itemId, 'playMode': playMode}),
    );
  }
}

class VideoFeedPresenterController implements STRWidgetController {
  final StorylyPlacementController _controller;
  final PlacementWidget _widget;

  VideoFeedPresenterController(this._controller, this._widget);

  Future<void> pause() {
    return _controller.callWidget(_widget.viewId, 'pause', '{}');
  }

  Future<void> play() {
    return _controller.callWidget(_widget.viewId, 'play', '{}');
  }

  Future<void> open({required String groupId}) {
    return _controller.callWidget(
      _widget.viewId,
      'open',
      jsonEncode({'groupId': groupId}),
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
        return StoryBarController(this, widget) as T;
      case "video-feed":
        return VideoFeedController(this, widget) as T;
      case "video-feed-presenter":
        return VideoFeedPresenterController(this, widget) as T;
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
