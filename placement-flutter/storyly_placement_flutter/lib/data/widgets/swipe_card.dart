import '../product.dart';
import '../events/payloads.dart';

class STRSwipeCard {
  final List<STRProductItem>? actionProducts;

  STRSwipeCard({this.actionProducts});

  factory STRSwipeCard.fromJson(Map<String, dynamic> json) {
    return STRSwipeCard(
      actionProducts: (json['actionProducts'] as List<dynamic>?)
          ?.map((e) => STRProductItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actionProducts': actionProducts?.map((e) => e.toJson()).toList(),
    };
  }
}

class SwipeCardDataPayload extends STRDataPayload {
  final STRSwipeCard items;

  SwipeCardDataPayload({
    required String type,
    required this.items,
  }) : super(type: type);

  factory SwipeCardDataPayload.fromJson(Map<String, dynamic> json) {
    return SwipeCardDataPayload(
      type: json['type'],
      items: STRSwipeCard.fromJson(json['items']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['items'] = items.toJson();
    return json;
  }
}

class STRSwipeCardPayload extends STRPayload {
  final STRSwipeCard? card;

  STRSwipeCardPayload({this.card});

  factory STRSwipeCardPayload.fromJson(Map<String, dynamic> json) {
    return STRSwipeCardPayload(
      card: json['card'] != null ? STRSwipeCard.fromJson(json['card']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'card': card?.toJson(),
    };
  }
}

