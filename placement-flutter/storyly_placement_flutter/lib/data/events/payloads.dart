import '../widgets/banner.dart';
import '../widgets/canvas.dart';
import '../widgets/story_bar.dart';
import '../widgets/swipe_card.dart';
import '../widgets/video_feed.dart';

// ignore_for_file: constant_identifier_names

class PlacementWidget {
  final String viewId;
  final String
  type; // STRWidgetType: 'banner' | 'story-bar' | 'video-feed' | 'video-feed-presenter' | 'swipe-card'

  PlacementWidget({required this.viewId, required this.type});

  factory PlacementWidget.fromJson(Map<String, dynamic> json) {
    return PlacementWidget(viewId: json['viewId'], type: json['type']);
  }

  Map<String, dynamic> toJson() {
    return {'viewId': viewId, 'type': type};
  }
}

class STRDataPayload {
  final String type; // STRWidgetType

  STRDataPayload({required this.type});

  factory STRDataPayload.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'story-bar':
        return StoryBarDataPayload.fromJson(json);
      case 'video-feed':
        return VideoFeedDataPayload.fromJson(json);
      case 'swipe-card':
        return SwipeCardDataPayload.fromJson(json);
      case 'banner':
        return BannerDataPayload.fromJson(json);
      case 'canvas':
        return CanvasDataPayload.fromJson(json);
      default:
        return STRDataPayload(type: type);
    }
  }

  Map<String, dynamic> toJson() {
    return {'type': type};
  }
}

abstract class STRPayload {
  STRPayload();

  factory STRPayload.fromJson(Map<String, dynamic> json, String? type) {
    switch (type) {
      case 'story-bar':
        return STRStoryBarPayload.fromJson(json);
      case 'video-feed':
        return STRVideoFeedPayload.fromJson(json);
      case 'swipe-card':
        return STRSwipeCardPayload.fromJson(json);
      case 'banner':
        return STRBannerPayload.fromJson(json);
      case 'canvas':
        return STRCanvasPayload.fromJson(json);
      default:
        return _STRPayloadImpl();
    }
  }

  Map<String, dynamic> toJson();
}

class _STRPayloadImpl extends STRPayload {
  @override
  Map<String, dynamic> toJson() => {};
}

class STREventPayload {
  final String event;
  final STRPayload? payload;

  STREventPayload({required this.event, this.payload});

  factory STREventPayload.fromJson(Map<String, dynamic> json, String type) {
    return STREventPayload(
      event: json['event'],
      payload: STRPayload.fromJson(json, type),
    );
  }

  Map<String, dynamic> toJson() {
    return {'event': event, 'payload': payload?.toJson()};
  }
}

class STRErrorPayload {
  final String event;
  final String message;

  STRErrorPayload({required this.event, required this.message});

  factory STRErrorPayload.fromJson(Map<String, dynamic> json) {
    return STRErrorPayload(event: json['event'], message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return {'event': event, 'message': message};
  }
}
