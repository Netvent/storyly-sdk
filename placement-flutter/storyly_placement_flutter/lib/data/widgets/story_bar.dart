import '../product.dart';
import '../events/payloads.dart';

class StoryBarComponent {
  final String type;
  final String id;
  final String? customPayload;

  StoryBarComponent({
    required this.type,
    required this.id,
    this.customPayload,
  });

  factory StoryBarComponent.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'button':
        return StoryButtonComponent.fromJson(json);
      case 'swipe':
        return StorySwipeComponent.fromJson(json);
      case 'productTag':
        return StoryProductTagComponent.fromJson(json);
      case 'productCard':
        return StoryProductCardComponent.fromJson(json);
      case 'productCatalog':
        return StoryProductCatalogComponent.fromJson(json);
      case 'quiz':
        return StoryQuizComponent.fromJson(json);
      case 'imageQuiz':
        return StoryImageQuizComponent.fromJson(json);
      case 'poll':
        return StoryPollComponent.fromJson(json);
      case 'emoji':
        return StoryEmojiComponent.fromJson(json);
      case 'rating':
        return StoryRatingComponent.fromJson(json);
      case 'promoCode':
        return StoryPromoCodeComponent.fromJson(json);
      case 'comment':
        return StoryCommentComponent.fromJson(json);
      case 'countDown':
        return StoryCountDownComponent.fromJson(json);
      default:
        return StoryBarComponent(
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

class StoryButtonComponent extends StoryBarComponent {
  final String? text;
  final String? actionUrl;
  final List<STRProductItem>? products;

  StoryButtonComponent({
    required String id,
    String? customPayload,
    this.text,
    this.actionUrl,
    this.products,
  }) : super(type: 'button', id: id, customPayload: customPayload);

  factory StoryButtonComponent.fromJson(Map<String, dynamic> json) {
    return StoryButtonComponent(
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

class StorySwipeComponent extends StoryBarComponent {
  final String? text;
  final String? actionUrl;
  final List<STRProductItem>? products;

  StorySwipeComponent({
    required String id,
    String? customPayload,
    this.text,
    this.actionUrl,
    this.products,
  }) : super(type: 'swipe', id: id, customPayload: customPayload);

  factory StorySwipeComponent.fromJson(Map<String, dynamic> json) {
    return StorySwipeComponent(
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

class StoryProductTagComponent extends StoryBarComponent {
  final String? actionUrl;
  final List<STRProductItem>? products;

  StoryProductTagComponent({
    required String id,
    String? customPayload,
    this.actionUrl,
    this.products,
  }) : super(type: 'productTag', id: id, customPayload: customPayload);

  factory StoryProductTagComponent.fromJson(Map<String, dynamic> json) {
    return StoryProductTagComponent(
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

class StoryProductCardComponent extends StoryBarComponent {
  final String? text;
  final String? actionUrl;
  final List<STRProductItem>? products;

  StoryProductCardComponent({
    required String id,
    String? customPayload,
    this.text,
    this.actionUrl,
    this.products,
  }) : super(type: 'productCard', id: id, customPayload: customPayload);

  factory StoryProductCardComponent.fromJson(Map<String, dynamic> json) {
    return StoryProductCardComponent(
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

class StoryProductCatalogComponent extends StoryBarComponent {
  final List<String>? actionUrlList;
  final List<STRProductItem>? products;

  StoryProductCatalogComponent({
    required String id,
    String? customPayload,
    this.actionUrlList,
    this.products,
  }) : super(type: 'productCatalog', id: id, customPayload: customPayload);

  factory StoryProductCatalogComponent.fromJson(Map<String, dynamic> json) {
    return StoryProductCatalogComponent(
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

class StoryQuizComponent extends StoryBarComponent {
  final String? title;
  final List<String>? options;
  final int? rightAnswerIndex;
  final int? selectedOptionIndex;

  StoryQuizComponent({
    required String id,
    String? customPayload,
    this.title,
    this.options,
    this.rightAnswerIndex,
    this.selectedOptionIndex,
  }) : super(type: 'quiz', id: id, customPayload: customPayload);

  factory StoryQuizComponent.fromJson(Map<String, dynamic> json) {
    return StoryQuizComponent(
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

class StoryImageQuizComponent extends StoryBarComponent {
  final String? title;
  final List<String>? options;
  final int? rightAnswerIndex;
  final int? selectedOptionIndex;

  StoryImageQuizComponent({
    required String id,
    String? customPayload,
    this.title,
    this.options,
    this.rightAnswerIndex,
    this.selectedOptionIndex,
  }) : super(type: 'imageQuiz', id: id, customPayload: customPayload);

  factory StoryImageQuizComponent.fromJson(Map<String, dynamic> json) {
    return StoryImageQuizComponent(
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

class StoryPollComponent extends StoryBarComponent {
  final String? title;
  final List<String>? options;
  final int? selectedOptionIndex;

  StoryPollComponent({
    required String id,
    String? customPayload,
    this.title,
    this.options,
    this.selectedOptionIndex,
  }) : super(type: 'poll', id: id, customPayload: customPayload);

  factory StoryPollComponent.fromJson(Map<String, dynamic> json) {
    return StoryPollComponent(
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

class StoryEmojiComponent extends StoryBarComponent {
  final List<String>? emojiCodes;
  final int? selectedEmojiIndex;

  StoryEmojiComponent({
    required String id,
    String? customPayload,
    this.emojiCodes,
    this.selectedEmojiIndex,
  }) : super(type: 'emoji', id: id, customPayload: customPayload);

  factory StoryEmojiComponent.fromJson(Map<String, dynamic> json) {
    return StoryEmojiComponent(
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

class StoryRatingComponent extends StoryBarComponent {
  final String? emojiCode;
  final int? rating;

  StoryRatingComponent({
    required String id,
    String? customPayload,
    this.emojiCode,
    this.rating,
  }) : super(type: 'rating', id: id, customPayload: customPayload);

  factory StoryRatingComponent.fromJson(Map<String, dynamic> json) {
    return StoryRatingComponent(
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

class StoryPromoCodeComponent extends StoryBarComponent {
  final String? text;

  StoryPromoCodeComponent({
    required String id,
    String? customPayload,
    this.text,
  }) : super(type: 'promoCode', id: id, customPayload: customPayload);

  factory StoryPromoCodeComponent.fromJson(Map<String, dynamic> json) {
    return StoryPromoCodeComponent(
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

class StoryCommentComponent extends StoryBarComponent {
  final String? text;

  StoryCommentComponent({
    required String id,
    String? customPayload,
    this.text,
  }) : super(type: 'comment', id: id, customPayload: customPayload);

  factory StoryCommentComponent.fromJson(Map<String, dynamic> json) {
    return StoryCommentComponent(
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

class StoryCountDownComponent extends StoryBarComponent {
  StoryCountDownComponent({
    required String id,
    String? customPayload,
  }) : super(type: 'countDown', id: id, customPayload: customPayload);

  factory StoryCountDownComponent.fromJson(Map<String, dynamic> json) {
    return StoryCountDownComponent(
      id: json['id'],
      customPayload: json['customPayload'],
    );
  }
}

class STRStory {
  final String id;
  final String title;
  final String? name;
  final int index;
  final bool seen;
  final String? previewUrl;
  final String? actionUrl;
  final List<STRProductItem>? actionProducts;
  final int? currentTime;
  final List<StoryBarComponent>? storyComponentList;

  STRStory({
    required this.id,
    required this.title,
    this.name,
    required this.index,
    required this.seen,
    this.previewUrl,
    this.actionUrl,
    this.actionProducts,
    this.currentTime,
    this.storyComponentList,
  });

  factory STRStory.fromJson(Map<String, dynamic> json) {
    return STRStory(
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
      storyComponentList: (json['storyComponentList'] as List<dynamic>?)
          ?.map((e) => StoryBarComponent.fromJson(e))
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
      'storyComponentList': storyComponentList?.map((e) => e.toJson()).toList(),
    };
  }
}

class STRStoryGroupBadgeStyle {
  final String? backgroundColor;
  final String? textColor;
  final int? endTime;
  final String? template;
  final String? text;

  STRStoryGroupBadgeStyle({
    this.backgroundColor,
    this.textColor,
    this.endTime,
    this.template,
    this.text,
  });

  factory STRStoryGroupBadgeStyle.fromJson(Map<String, dynamic> json) {
    return STRStoryGroupBadgeStyle(
      backgroundColor: json['backgroundColor'],
      textColor: json['textColor'],
      endTime: json['endTime'],
      template: json['template'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'endTime': endTime,
      'template': template,
      'text': text,
    };
  }
}

class STRStoryGroupStyle {
  final List<String>? borderUnseenColors;
  final String? textUnseenColor;
  final STRStoryGroupBadgeStyle? badge;

  STRStoryGroupStyle({
    this.borderUnseenColors,
    this.textUnseenColor,
    this.badge,
  });

  factory STRStoryGroupStyle.fromJson(Map<String, dynamic> json) {
    return STRStoryGroupStyle(
      borderUnseenColors:
          (json['borderUnseenColors'] as List<dynamic>?)?.cast<String>(),
      textUnseenColor: json['textUnseenColor'],
      badge: json['badge'] != null
          ? STRStoryGroupBadgeStyle.fromJson(json['badge'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'borderUnseenColors': borderUnseenColors,
      'textUnseenColor': textUnseenColor,
      'badge': badge?.toJson(),
    };
  }
}

class STRStoryGroup {
  final String id;
  final String title;
  final String? name;
  final String? iconUrl;
  final int index;
  final bool pinned;
  final bool seen;
  final List<STRStory> stories;
  final String type;
  final bool nudge;
  final STRStoryGroupStyle? style;

  STRStoryGroup({
    required this.id,
    required this.title,
    this.name,
    this.iconUrl,
    required this.index,
    required this.pinned,
    required this.seen,
    required this.stories,
    required this.type,
    required this.nudge,
    this.style,
  });

  factory STRStoryGroup.fromJson(Map<String, dynamic> json) {
    return STRStoryGroup(
      id: json['id'],
      title: json['title'],
      name: json['name'],
      iconUrl: json['iconUrl'],
      index: json['index'],
      pinned: json['pinned'],
      seen: json['seen'],
      stories: (json['stories'] as List<dynamic>)
          .map((e) => STRStory.fromJson(e))
          .toList(),
      type: json['type'],
      nudge: json['nudge'],
      style: json['style'] != null
          ? STRStoryGroupStyle.fromJson(json['style'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'iconUrl': iconUrl,
      'index': index,
      'pinned': pinned,
      'seen': seen,
      'stories': stories.map((e) => e.toJson()).toList(),
      'type': type,
      'nudge': nudge,
      'style': style?.toJson(),
    };
  }
}

class StoryBarDataPayload extends STRDataPayload {
  final List<STRStoryGroup> items;

  StoryBarDataPayload({
    required String type,
    required this.items,
  }) : super(type: type);

  factory StoryBarDataPayload.fromJson(Map<String, dynamic> json) {
    return StoryBarDataPayload(
      type: json['type'],
      items: (json['items'] as List<dynamic>)
          .map((e) => STRStoryGroup.fromJson(e))
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

class STRStoryBarPayload extends STRPayload {
  final STRStoryGroup? group;
  final STRStory? story;
  final StoryBarComponent? component;

  STRStoryBarPayload({
    this.group,
    this.story,
    this.component,
  });

  factory STRStoryBarPayload.fromJson(Map<String, dynamic> json) {
    return STRStoryBarPayload(
      group:
          json['group'] != null ? STRStoryGroup.fromJson(json['group']) : null,
      story:
          json['story'] != null ? STRStory.fromJson(json['story']) : null,
      component: json['component'] != null
          ? StoryBarComponent.fromJson(json['component'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'group': group?.toJson(),
      'story': story?.toJson(),
      'component': component?.toJson(),
    };
  }
}

