import '../product.dart';
import '../events/payloads.dart';

class CanvasItem {
  final String? actionUrl;
  final List<STRProductItem>? actionProducts;

  CanvasItem({this.actionUrl, this.actionProducts});

  factory CanvasItem.fromJson(Map<String, dynamic> json) {
    return CanvasItem(
      actionUrl: json['actionUrl'],
      actionProducts: (json['actionProducts'] as List<dynamic>?)
          ?.map((e) => STRProductItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actionUrl': actionUrl,
      'actionProducts': actionProducts?.map((e) => e.toJson()).toList(),
    };
  }
}

class CanvasDataPayload extends STRDataPayload {
  final List<CanvasItem> items;

  CanvasDataPayload({required String type, required this.items})
    : super(type: type);

  factory CanvasDataPayload.fromJson(Map<String, dynamic> json) {
    return CanvasDataPayload(
      type: json['type'],
      items: (json['items'] as List<dynamic>)
          .map((e) => CanvasItem.fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['items'] = items.map((e) => e.toJson()).toList();
    return json;
  }
}

class STRCanvasPayload extends STRPayload {
  final CanvasItem? item;

  STRCanvasPayload({this.item});

  factory STRCanvasPayload.fromJson(Map<String, dynamic> json) {
    return STRCanvasPayload(
      item: json['item'] != null ? CanvasItem.fromJson(json['item']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'item': item?.toJson()};
  }
}
