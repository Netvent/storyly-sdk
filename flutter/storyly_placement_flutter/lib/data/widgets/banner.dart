import '../product.dart';
import '../events/payloads.dart';

class BannerComponent {
  final String type;
  final String id;
  final String? customPayload;

  BannerComponent({required this.type, required this.id, this.customPayload});

  factory BannerComponent.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    if (type == 'Button') {
      return BannerButtonComponent.fromJson(json);
    }
    return BannerComponent(
      type: type,
      id: json['id'],
      customPayload: json['customPayload'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'id': id, 'customPayload': customPayload};
  }
}

class BannerButtonComponent extends BannerComponent {
  final String? text;
  final String? actionUrl;
  final List<STRProductItem>? products;

  BannerButtonComponent({
    required String type,
    required String id,
    String? customPayload,
    this.text,
    this.actionUrl,
    this.products,
  }) : super(type: type, id: id, customPayload: customPayload);

  factory BannerButtonComponent.fromJson(Map<String, dynamic> json) {
    return BannerButtonComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      text: json['text'],
      actionUrl: json['actionUrl'],
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => STRProductItem.fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'text': text,
      'actionUrl': actionUrl,
      'products': products?.map((e) => e.toJson()).toList(),
    });
    return json;
  }
}

class STRBannerItem {
  final String id;
  final String? name;
  final int index;
  final String? actionUrl;
  final List<BannerComponent>? componentList;
  final List<STRProductItem>? actionProducts;
  final int? currentTime;

  STRBannerItem({
    required this.id,
    this.name,
    required this.index,
    this.actionUrl,
    this.componentList,
    this.actionProducts,
    this.currentTime,
  });

  factory STRBannerItem.fromJson(Map<String, dynamic> json) {
    return STRBannerItem(
      id: json['id'],
      name: json['name'],
      index: json['index'],
      actionUrl: json['actionUrl'],
      componentList: (json['componentList'] as List<dynamic>?)
          ?.map((e) => BannerComponent.fromJson(e))
          .toList(),
      actionProducts: (json['actionProducts'] as List<dynamic>?)
          ?.map((e) => STRProductItem.fromJson(e))
          .toList(),
      currentTime: json['currentTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'index': index,
      'actionUrl': actionUrl,
      'componentList': componentList?.map((e) => e.toJson()).toList(),
      'actionProducts': actionProducts?.map((e) => e.toJson()).toList(),
      'currentTime': currentTime,
    };
  }
}

class BannerDataPayload extends STRDataPayload {
  final List<STRBannerItem> items;

  BannerDataPayload({required String type, required this.items})
    : super(type: type);

  factory BannerDataPayload.fromJson(Map<String, dynamic> json) {
    return BannerDataPayload(
      type: json['type'],
      items: (json['items'] as List<dynamic>)
          .map((e) => STRBannerItem.fromJson(e))
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

class STRBannerPayload extends STRPayload {
  final STRBannerItem? item;
  final BannerComponent? component;

  STRBannerPayload({this.item, this.component});

  factory STRBannerPayload.fromJson(Map<String, dynamic> json) {
    return STRBannerPayload(
      item: json['item'] != null ? STRBannerItem.fromJson(json['item']) : null,
      component: json['component'] != null
          ? BannerComponent.fromJson(json['component'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'item': item?.toJson(), 'component': component?.toJson()};
  }
}
