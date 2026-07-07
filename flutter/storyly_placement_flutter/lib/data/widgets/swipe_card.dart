import '../product.dart';
import '../events/payloads.dart';

class SwipeCard {
  final List<STRProductItem>? actionProducts;

  SwipeCard({this.actionProducts});

  factory SwipeCard.fromJson(Map<String, dynamic> json) {
    return SwipeCard(
      actionProducts: (json['actionProducts'] as List<dynamic>?)
          ?.map((e) => STRProductItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'actionProducts': actionProducts?.map((e) => e.toJson()).toList()};
  }
}

class SwipeCardDataPayload extends STRDataPayload {
  final List<STRProductItem> items;

  SwipeCardDataPayload({required String type, required this.items})
    : super(type: type);

  factory SwipeCardDataPayload.fromJson(Map<String, dynamic> json) {
    return SwipeCardDataPayload(
      type: json['type'],
      items: (json['items'] as List<dynamic>)
          .map((e) => STRProductItem.fromJson(e))
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

class STRSwipeCardPayload extends STRPayload {
  final SwipeCard? card;

  STRSwipeCardPayload({this.card});

  factory STRSwipeCardPayload.fromJson(Map<String, dynamic> json) {
    return STRSwipeCardPayload(
      card: json['card'] != null ? SwipeCard.fromJson(json['card']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'card': card?.toJson()};
  }
}
