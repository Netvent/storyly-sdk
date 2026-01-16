import '../util.dart';
import '../product.dart';
import 'payloads.dart';

class PlacementWidgetReadyEvent extends BaseEvent {
  final PlacementWidget widget;
  final double ratio;

  PlacementWidgetReadyEvent({required this.widget, required this.ratio});

  factory PlacementWidgetReadyEvent.fromJson(Map<String, dynamic> json) {
    return PlacementWidgetReadyEvent(
      widget: PlacementWidget.fromJson(json['widget']),
      ratio: (json['ratio'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'widget': widget.toJson(), 'ratio': ratio};
  }
}

class PlacementActionClickEvent extends BaseEvent {
  final PlacementWidget widget;
  final String url;
  final STRPayload? payload;

  PlacementActionClickEvent({
    required this.widget,
    required this.url,
    this.payload,
  });

  factory PlacementActionClickEvent.fromJson(Map<String, dynamic> json) {
    final widget = PlacementWidget.fromJson(json['widget']);
    return PlacementActionClickEvent(
      widget: widget,
      url: json['url'],
      payload: json['payload'] != null
          ? STRPayload.fromJson(json['payload'], widget.type)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'widget': widget.toJson(),
      'url': url,
      'payload': payload?.toJson(),
    };
  }
}

class PlacementEvent extends BaseEvent {
  final PlacementWidget widget;
  final STREventPayload payload;

  PlacementEvent({required this.widget, required this.payload});

  factory PlacementEvent.fromJson(Map<String, dynamic> json) {
    final widget = PlacementWidget.fromJson(json['widget']);
    return PlacementEvent(
      widget: widget,
      payload: STREventPayload.fromJson(json['payload'], widget.type),
    );
  }

  Map<String, dynamic> toJson() {
    return {'widget': widget.toJson(), 'payload': payload.toJson()};
  }
}

class PlacementFailEvent extends BaseEvent {
  final PlacementWidget widget;
  final STRErrorPayload payload;

  PlacementFailEvent({required this.widget, required this.payload});

  factory PlacementFailEvent.fromJson(Map<String, dynamic> json) {
    return PlacementFailEvent(
      widget: PlacementWidget.fromJson(json['widget']),
      payload: STRErrorPayload.fromJson(json['payload']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'widget': widget.toJson(), 'payload': payload.toJson()};
  }
}

class PlacementProductEvent extends BaseEvent {
  final PlacementWidget widget;
  final String event;

  PlacementProductEvent({required this.widget, required this.event});

  factory PlacementProductEvent.fromJson(Map<String, dynamic> json) {
    return PlacementProductEvent(
      widget: PlacementWidget.fromJson(json['widget']),
      event: json['event'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'widget': widget.toJson(), 'event': event};
  }
}

class PlacementCartUpdateEvent extends BaseEvent {
  final PlacementWidget widget;
  final String event;
  final STRCart? cart;
  final STRCartItem? change;
  final String responseId;

  PlacementCartUpdateEvent({
    required this.widget,
    required this.event,
    this.cart,
    this.change,
    required this.responseId,
  });

  factory PlacementCartUpdateEvent.fromJson(Map<String, dynamic> json) {
    return PlacementCartUpdateEvent(
      widget: PlacementWidget.fromJson(json['widget']),
      event: json['event'],
      cart: json['cart'] != null ? STRCart.fromJson(json['cart']) : null,
      change: json['change'] != null
          ? STRCartItem.fromJson(json['change'])
          : null,
      responseId: json['responseId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'widget': widget.toJson(),
      'event': event,
      'cart': cart?.toJson(),
      'change': change?.toJson(),
      'responseId': responseId,
    };
  }
}

class PlacementWishlistUpdateEvent extends BaseEvent {
  final PlacementWidget widget;
  final String event;
  final STRProductItem? item;
  final String responseId;

  PlacementWishlistUpdateEvent({
    required this.widget,
    required this.event,
    this.item,
    required this.responseId,
  });

  factory PlacementWishlistUpdateEvent.fromJson(Map<String, dynamic> json) {
    return PlacementWishlistUpdateEvent(
      widget: PlacementWidget.fromJson(json['widget']),
      event: json['event'],
      item: json['item'] != null ? STRProductItem.fromJson(json['item']) : null,
      responseId: json['responseId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'widget': widget.toJson(),
      'event': event,
      'item': item?.toJson(),
      'responseId': responseId,
    };
  }
}
