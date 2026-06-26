/// Configuration required to initialize [StorylyAnalytics].
///
/// Mirrors the native `STRAnalyticsConfig` on Android and iOS. Pass an
/// instance to [StorylyAnalytics.initialize] before tracking any events.
class STRAnalyticsConfig {
  /// The unique API token identifying the Storyly account for analytics tracking.
  final String token;

  /// An optional unique user identifier for associating events with a specific user.
  final String? userId;

  STRAnalyticsConfig({required this.token, this.userId});

  factory STRAnalyticsConfig.fromJson(Map<String, dynamic> json) {
    return STRAnalyticsConfig(token: json['token'], userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'userId': userId};
  }
}

/// A product involved in a Storyly Analytics event.
///
/// Mirrors the native `STRAnalyticProduct`. Pass one or more instances to
/// [StorylyAnalytics.track] alongside an [STRAnalyticProductEvent].
class STRAnalyticProduct {
  /// The unique identifier of the product (e.g. SKU or product feed ID).
  final String productId;

  /// The unique identifier of the product group this product belongs to.
  final String productGroupId;

  /// The display title or name of the product.
  final String title;

  /// An optional description of the product.
  final String? desc;

  /// The original (regular) price of the product.
  final double price;

  /// The discounted/sale price of the product, or `null` if not on sale.
  final double? salesPrice;

  /// The number of units of this product involved in the event. Defaults to `1`.
  final int quantity;

  STRAnalyticProduct({
    required this.productId,
    required this.productGroupId,
    required this.title,
    this.desc,
    required this.price,
    this.salesPrice,
    this.quantity = 1,
  });

  factory STRAnalyticProduct.fromJson(Map<String, dynamic> json) {
    return STRAnalyticProduct(
      productId: json['productId'],
      productGroupId: json['productGroupId'],
      title: json['title'],
      desc: json['desc'],
      price: (json['price'] as num).toDouble(),
      salesPrice: (json['salesPrice'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
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
      'quantity': quantity,
    };
  }
}

/// The types of product analytics events that can be tracked.
///
/// Mirrors the native `STRAnalyticProductEvent`. The [name] of each value is
/// sent over the method channel and must match the native enum names.
enum STRAnalyticProductEvent {
  /// A product detail page (PDP) was viewed by the user.
  pdpViewed('PDPViewed'),

  /// A product was added to the shopping cart.
  cartAdded('CartAdded'),

  /// A product was added to the user's wishlist.
  wishlistAdded('WishlistAdded'),

  /// A product purchase was completed.
  purchased('Purchased');

  /// The PascalCase identifier shared with the native SDKs.
  final String value;

  const STRAnalyticProductEvent(this.value);
}
