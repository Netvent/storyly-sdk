import '../product.dart';
import '../events/payloads.dart';

class VideoFeedComponent {
  final String type;
  final String id;
  final String? customPayload;

  VideoFeedComponent({
    required this.type,
    required this.id,
    this.customPayload,
  });

  factory VideoFeedComponent.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'button':
        return VideoFeedButtonComponent.fromJson(json);
      case 'swipe':
        return VideoFeedSwipeComponent.fromJson(json);
      case 'productTag':
        return VideoFeedProductTagComponent.fromJson(json);
      case 'productCard':
        return VideoFeedProductCardComponent.fromJson(json);
      case 'productCatalog':
        return VideoFeedProductCatalogComponent.fromJson(json);
      case 'quiz':
        return VideoFeedQuizComponent.fromJson(json);
      case 'imageQuiz':
        return VideoFeedImageQuizComponent.fromJson(json);
      case 'poll':
        return VideoFeedPollComponent.fromJson(json);
      case 'emoji':
        return VideoFeedEmojiComponent.fromJson(json);
      case 'rating':
        return VideoFeedRatingComponent.fromJson(json);
      case 'promoCode':
        return VideoFeedPromoCodeComponent.fromJson(json);
      case 'comment':
        return VideoFeedCommentComponent.fromJson(json);
      case 'countDown':
        return VideoFeedCountDownComponent.fromJson(json);
      default:
        return VideoFeedComponent(
          type: type,
          id: json['id'],
          customPayload: json['customPayload'],
        );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'customPayload': customPayload,
    };
  }
}

class VideoFeedButtonComponent extends VideoFeedComponent {
  final String? text;
  final String? actionUrl;
  final List<STRProductItem>? products;

  VideoFeedButtonComponent({
    required String id,
    String? customPayload,
    this.text,
    this.actionUrl,
    this.products,
  }) : super(type: 'button', id: id, customPayload: customPayload);

  factory VideoFeedButtonComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedButtonComponent(
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

class VideoFeedSwipeComponent extends VideoFeedComponent {
  final String? text;
  final String? actionUrl;
  final List<STRProductItem>? products;

  VideoFeedSwipeComponent({
    required String id,
    String? customPayload,
    this.text,
    this.actionUrl,
    this.products,
  }) : super(type: 'swipe', id: id, customPayload: customPayload);

  factory VideoFeedSwipeComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedSwipeComponent(
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

class VideoFeedProductTagComponent extends VideoFeedComponent {
  final String? actionUrl;
  final List<STRProductItem>? products;

  VideoFeedProductTagComponent({
    required String id,
    String? customPayload,
    this.actionUrl,
    this.products,
  }) : super(type: 'productTag', id: id, customPayload: customPayload);

  factory VideoFeedProductTagComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedProductTagComponent(
      id: json['id'],
      customPayload: json['customPayload'],
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
      'actionUrl': actionUrl,
      'products': products?.map((e) => e.toJson()).toList(),
    });
    return json;
  }
}

class VideoFeedProductCardComponent extends VideoFeedComponent {
  final String? text;
  final String? actionUrl;
  final List<STRProductItem>? products;

  VideoFeedProductCardComponent({
    required String id,
    String? customPayload,
    this.text,
    this.actionUrl,
    this.products,
  }) : super(type: 'productCard', id: id, customPayload: customPayload);

  factory VideoFeedProductCardComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedProductCardComponent(
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

class VideoFeedProductCatalogComponent extends VideoFeedComponent {
  final List<String>? actionUrlList;
  final List<STRProductItem>? products;

  VideoFeedProductCatalogComponent({
    required String id,
    String? customPayload,
    this.actionUrlList,
    this.products,
  }) : super(type: 'productCatalog', id: id, customPayload: customPayload);

  factory VideoFeedProductCatalogComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedProductCatalogComponent(
      id: json['id'],
      customPayload: json['customPayload'],
      actionUrlList: (json['actionUrlList'] as List<dynamic>?)?.cast<String>(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => STRProductItem.fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'actionUrlList': actionUrlList,
      'products': products?.map((e) => e.toJson()).toList(),
    });
    return json;
  }
}

class VideoFeedQuizComponent extends VideoFeedComponent {
  final String? title;
  final List<String>? options;
  final int? rightAnswerIndex;
  final int? selectedOptionIndex;

  VideoFeedQuizComponent({
    required String id,
    String? customPayload,
    this.title,
    this.options,
    this.rightAnswerIndex,
    this.selectedOptionIndex,
  }) : super(type: 'quiz', id: id, customPayload: customPayload);

  factory VideoFeedQuizComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedQuizComponent(
      id: json['id'],
      customPayload: json['customPayload'],
      title: json['title'],
      options: (json['options'] as List<dynamic>?)?.cast<String>(),
      rightAnswerIndex: json['rightAnswerIndex'],
      selectedOptionIndex: json['selectedOptionIndex'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'title': title,
      'options': options,
      'rightAnswerIndex': rightAnswerIndex,
      'selectedOptionIndex': selectedOptionIndex,
    });
    return json;
  }
}

class VideoFeedImageQuizComponent extends VideoFeedComponent {
  final String? title;
  final List<String>? options;
  final int? rightAnswerIndex;
  final int? selectedOptionIndex;

  VideoFeedImageQuizComponent({
    required String id,
    String? customPayload,
    this.title,
    this.options,
    this.rightAnswerIndex,
    this.selectedOptionIndex,
  }) : super(type: 'imageQuiz', id: id, customPayload: customPayload);

  factory VideoFeedImageQuizComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedImageQuizComponent(
      id: json['id'],
      customPayload: json['customPayload'],
      title: json['title'],
      options: (json['options'] as List<dynamic>?)?.cast<String>(),
      rightAnswerIndex: json['rightAnswerIndex'],
      selectedOptionIndex: json['selectedOptionIndex'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'title': title,
      'options': options,
      'rightAnswerIndex': rightAnswerIndex,
      'selectedOptionIndex': selectedOptionIndex,
    });
    return json;
  }
}

class VideoFeedPollComponent extends VideoFeedComponent {
  final String? title;
  final List<String>? options;
  final int? selectedOptionIndex;

  VideoFeedPollComponent({
    required String id,
    String? customPayload,
    this.title,
    this.options,
    this.selectedOptionIndex,
  }) : super(type: 'poll', id: id, customPayload: customPayload);

  factory VideoFeedPollComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedPollComponent(
      id: json['id'],
      customPayload: json['customPayload'],
      title: json['title'],
      options: (json['options'] as List<dynamic>?)?.cast<String>(),
      selectedOptionIndex: json['selectedOptionIndex'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'title': title,
      'options': options,
      'selectedOptionIndex': selectedOptionIndex,
    });
    return json;
  }
}

class VideoFeedEmojiComponent extends VideoFeedComponent {
  final List<String>? emojiCodes;
  final int? selectedEmojiIndex;

  VideoFeedEmojiComponent({
    required String id,
    String? customPayload,
    this.emojiCodes,
    this.selectedEmojiIndex,
  }) : super(type: 'emoji', id: id, customPayload: customPayload);

  factory VideoFeedEmojiComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedEmojiComponent(
      id: json['id'],
      customPayload: json['customPayload'],
      emojiCodes: (json['emojiCodes'] as List<dynamic>?)?.cast<String>(),
      selectedEmojiIndex: json['selectedEmojiIndex'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'emojiCodes': emojiCodes,
      'selectedEmojiIndex': selectedEmojiIndex,
    });
    return json;
  }
}

class VideoFeedRatingComponent extends VideoFeedComponent {
  final String? emojiCode;
  final int? rating;

  VideoFeedRatingComponent({
    required String id,
    String? customPayload,
    this.emojiCode,
    this.rating,
  }) : super(type: 'rating', id: id, customPayload: customPayload);

  factory VideoFeedRatingComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedRatingComponent(
      id: json['id'],
      customPayload: json['customPayload'],
      emojiCode: json['emojiCode'],
      rating: json['rating'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'emojiCode': emojiCode,
      'rating': rating,
    });
    return json;
  }
}

class VideoFeedPromoCodeComponent extends VideoFeedComponent {
  final String? text;

  VideoFeedPromoCodeComponent({
    required String id,
    String? customPayload,
    this.text,
  }) : super(type: 'promoCode', id: id, customPayload: customPayload);

  factory VideoFeedPromoCodeComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedPromoCodeComponent(
      id: json['id'],
      customPayload: json['customPayload'],
      text: json['text'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'text': text,
    });
    return json;
  }
}

class VideoFeedCommentComponent extends VideoFeedComponent {
  final String? text;

  VideoFeedCommentComponent({
    required String id,
    String? customPayload,
    this.text,
  }) : super(type: 'comment', id: id, customPayload: customPayload);

  factory VideoFeedCommentComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedCommentComponent(
      id: json['id'],
      customPayload: json['customPayload'],
      text: json['text'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'text': text,
    });
    return json;
  }
}

class VideoFeedCountDownComponent extends VideoFeedComponent {
  VideoFeedCountDownComponent({
    required String id,
    String? customPayload,
  }) : super(type: 'countDown', id: id, customPayload: customPayload);

  factory VideoFeedCountDownComponent.fromJson(Map<String, dynamic> json) {
    return VideoFeedCountDownComponent(
      id: json['id'],
      customPayload: json['customPayload'],
    );
  }
}

class STRVideoFeedItem {
  final String id;
  final String? title;
  final String? name;
  final int index;
  final bool seen;
  final String? previewUrl;
  final String? actionUrl;
  final List<STRProductItem>? actionProducts;
  final int? currentTime;
  final List<VideoFeedComponent>? feedItemComponentList;

  STRVideoFeedItem({
    required this.id,
    this.title,
    this.name,
    required this.index,
    required this.seen,
    this.previewUrl,
    this.actionUrl,
    this.actionProducts,
    this.currentTime,
    this.feedItemComponentList,
  });

  factory STRVideoFeedItem.fromJson(Map<String, dynamic> json) {
    return STRVideoFeedItem(
      id: json['id'],
      title: json['title'],
      name: json['name'],
      index: json['index'],
      seen: json['seen'],
      previewUrl: json['previewUrl'],
      actionUrl: json['actionUrl'],
      actionProducts: (json['actionProducts'] as List<dynamic>?)
          ?.map((e) => STRProductItem.fromJson(e))
          .toList(),
      currentTime: json['currentTime'],
      feedItemComponentList: (json['feedItemComponentList'] as List<dynamic>?)
          ?.map((e) => VideoFeedComponent.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'index': index,
      'seen': seen,
      'previewUrl': previewUrl,
      'actionUrl': actionUrl,
      'actionProducts': actionProducts?.map((e) => e.toJson()).toList(),
      'currentTime': currentTime,
      'feedItemComponentList': feedItemComponentList?.map((e) => e.toJson()).toList(),
    };
  }
}

class STRVideoFeedGroup {
  final String id;
  final String title;
  final String? name;
  final String? iconUrl;
  final int index;
  final bool seen;
  final String type;
  final bool pinned;
  final bool nudge;
  final String? iconVideoUrl;
  final String? iconVideoThumbnailUrl;
  final List<STRVideoFeedItem> feedList;

  STRVideoFeedGroup({
    required this.id,
    required this.title,
    this.name,
    this.iconUrl,
    required this.index,
    required this.seen,
    required this.type,
    required this.pinned,
    required this.nudge,
    this.iconVideoUrl,
    this.iconVideoThumbnailUrl,
    required this.feedList,
  });

  factory STRVideoFeedGroup.fromJson(Map<String, dynamic> json) {
    return STRVideoFeedGroup(
      id: json['id'],
      title: json['title'],
      name: json['name'],
      iconUrl: json['iconUrl'],
      index: json['index'],
      seen: json['seen'],
      type: json['type'],
      pinned: json['pinned'],
      nudge: json['nudge'],
      iconVideoUrl: json['iconVideoUrl'],
      iconVideoThumbnailUrl: json['iconVideoThumbnailUrl'],
      feedList: (json['feedList'] as List<dynamic>)
          .map((e) => STRVideoFeedItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'iconUrl': iconUrl,
      'index': index,
      'seen': seen,
      'type': type,
      'pinned': pinned,
      'nudge': nudge,
      'iconVideoUrl': iconVideoUrl,
      'iconVideoThumbnailUrl': iconVideoThumbnailUrl,
      'feedList': feedList.map((e) => e.toJson()).toList(),
    };
  }
}

class VideoFeedDataPayload extends STRDataPayload {
  final STRVideoFeedGroup items;

  VideoFeedDataPayload({
    required String type,
    required this.items,
  }) : super(type: type);

  factory VideoFeedDataPayload.fromJson(Map<String, dynamic> json) {
    return VideoFeedDataPayload(
      type: json['type'],
      items: STRVideoFeedGroup.fromJson(json['items']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['items'] = items.toJson();
    return json;
  }
}

class STRVideoFeedPayload extends STRPayload {
  final STRVideoFeedGroup? group;
  final STRVideoFeedItem? feedItem;
  final VideoFeedComponent? component;

  STRVideoFeedPayload({
    this.group,
    this.feedItem,
    this.component,
  });

  factory STRVideoFeedPayload.fromJson(Map<String, dynamic> json) {
    return STRVideoFeedPayload(
      group: json['group'] != null
          ? STRVideoFeedGroup.fromJson(json['group'])
          : null,
      feedItem: json['feedItem'] != null
          ? STRVideoFeedItem.fromJson(json['feedItem'])
          : null,
      component: json['component'] != null
          ? VideoFeedComponent.fromJson(json['component'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'group': group?.toJson(),
      'feedItem': feedItem?.toJson(),
      'component': component?.toJson(),
    };
  }
}

