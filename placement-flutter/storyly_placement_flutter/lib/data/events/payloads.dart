// ignore_for_file: constant_identifier_names

class PlacementWidget {
  final String viewId;
  final String type; // STRWidgetType: 'banner' | 'story-bar' | 'video-feed' | 'video-feed-presenter' | 'swipe-card'

  PlacementWidget({
    required this.viewId,
    required this.type,
  });

  factory PlacementWidget.fromJson(Map<String, dynamic> json) {
    return PlacementWidget(
      viewId: json['viewId'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'viewId': viewId,
      'type': type,
    };
  }
}

class STRDataPayload {
  final String type; // STRWidgetType

  STRDataPayload({required this.type});

  factory STRDataPayload.fromJson(Map<String, dynamic> json) {
    return STRDataPayload(
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }
}

abstract class STRPayload {
  STRPayload();

  factory STRPayload.fromJson(Map<String, dynamic> json) {
    // This is a base class/interface. Implementation details depend on concrete subclasses.
    // For now, returning an anonymous subclass or we might need a concrete implementation.
    // However, since TS defines it as empty, we can just use it as a marker.
    return _STRPayloadImpl();
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

  STREventPayload({
    required this.event,
    this.payload,
  });

  factory STREventPayload.fromJson(Map<String, dynamic> json) {
    return STREventPayload(
      event: json['event'],
      // Payload deserialization might need to be more specific based on event type
      // but for now we keep it generic as the TS one is generic.
      // In a real app we might need a factory to decide which subclass to instantiate.
      payload: json['payload'] != null ? STRPayload.fromJson(json['payload']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'payload': payload?.toJson(),
    };
  }
}

class STRErrorPayload {
  final String event;
  final String message;

  STRErrorPayload({
    required this.event,
    required this.message,
  });

  factory STRErrorPayload.fromJson(Map<String, dynamic> json) {
    return STRErrorPayload(
      event: json['event'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'message': message,
    };
  }
}

