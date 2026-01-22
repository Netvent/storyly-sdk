class STRProductVariant {
  final String name;
  final String value;
  final String key;

  STRProductVariant({
    required this.name,
    required this.value,
    required this.key,
  });

  factory STRProductVariant.fromJson(Map<String, dynamic> json) {
    return STRProductVariant(
      name: json['name'],
      value: json['value'],
      key: json['key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value, 'key': key};
  }
}

class STRProductItem {
  final String productId;
  final String? productGroupId;
  final String? title;
  final String? desc;
  final double price;
  final double? salesPrice;
  final double? lowestPrice;
  final String currency;
  final String? url;
  final List<String>? imageUrls;
  final List<STRProductVariant>? variants;
  final String? ctaText;

  STRProductItem({
    required this.productId,
    this.productGroupId,
    this.title,
    this.desc,
    required this.price,
    this.salesPrice,
    this.lowestPrice,
    required this.currency,
    this.url,
    this.imageUrls,
    this.variants,
    this.ctaText,
  });

  factory STRProductItem.fromJson(Map<String, dynamic> json) {
    return STRProductItem(
      productId: json['productId'],
      productGroupId: json['productGroupId'],
      title: json['title'],
      desc: json['desc'],
      price: (json['price'] as num).toDouble(),
      salesPrice: (json['salesPrice'] as num?)?.toDouble(),
      lowestPrice: (json['lowestPrice'] as num?)?.toDouble(),
      currency: json['currency'],
      url: json['url'],
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.cast<String>(),
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => STRProductVariant.fromJson(e))
          .toList(),
      ctaText: json['ctaText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productGroupId': productGroupId,
      'title': title,
      'desc': desc,
      'price': price,
      'salesPrice': salesPrice,
      'lowestPrice': lowestPrice,
      'currency': currency,
      'url': url,
      'imageUrls': imageUrls,
      'variants': variants?.map((e) => e.toJson()).toList(),
      'ctaText': ctaText,
    };
  }
}

class STRProductInformation {
  final String? productId;
  final String? productGroupId;

  STRProductInformation({this.productId, this.productGroupId});

  factory STRProductInformation.fromJson(Map<String, dynamic> json) {
    return STRProductInformation(
      productId: json['productId'],
      productGroupId: json['productGroupId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'productGroupId': productGroupId};
  }
}

class STRCartItem {
  final STRProductItem product;
  final int quantity;

  STRCartItem({
    required this.product,
    required this.quantity
  });

  factory STRCartItem.fromJson(Map<String, dynamic> json) {
    return STRCartItem(
      product: STRProductItem.fromJson(json['product']),
      quantity: json['quantity']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': product.toJson(),
      'quantity': quantity
    };
  }
}

class STRCart {
  final List<STRCartItem> items;
  final double totalPrice;
  final double? oldTotalPrice;
  final String currency;

  STRCart({
    required this.items,
    required this.totalPrice,
    this.oldTotalPrice,
    required this.currency,
  });

  factory STRCart.fromJson(Map<String, dynamic> json) {
    return STRCart(
      items: (json['items'] as List<dynamic>)
          .map((e) => STRCartItem.fromJson(e))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      oldTotalPrice: (json['oldTotalPrice'] as num?)?.toDouble(),
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'totalPrice': totalPrice,
      'oldTotalPrice': oldTotalPrice,
      'currency': currency,
    };
  }
}
