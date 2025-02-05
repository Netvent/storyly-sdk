
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'storyly_flutter.dart';
import 'storyly_util.dart';

/// [VerticalFeed] created callback
typedef VerticalFeedCreatedCallback = void Function(
  VerticalFeedController controller,
);


/// [VerticalFeed] created callback
typedef VerticalFeedPresenterCreatedCallback = void Function(
  VerticalFeedPresenterController controller,
);


/// [VerticalFeed] loaded callback
typedef VerticalFeedLoadedCallback = void Function(
  List<VerticalFeedGroup> feedGroupList,
  String dataSource,
);

/// [VerticalFeed] load failed callback
typedef VerticalFeedLoadFailedCallback = void Function(
  String message,
);

/// [VerticalFeed] present failed callback
typedef VerticalFeedPresentFailed = void Function(
  String message,
);

/// [VerticalFeed] action clicked callback
typedef VerticalFeedActionClickedCallback = void Function(
  VerticalFeedItem feedItem,
);

/// [VerticalFeed] user interacted callback
typedef VerticalFeedUserInteractedCallback = void Function(
  VerticalFeedGroup feedGroup,
  VerticalFeedItem feedItem,
  VerticalFeedItemComponent? verticalFeedItemComponent,
);

/// [VerticalFeed] event callback
typedef VerticalFeedEventCallback = void Function(
  String event,
  VerticalFeedGroup? feedGroup,
  VerticalFeedItem? feedItem,
  VerticalFeedItemComponent? verticalFeedItemComponent,
);

/// [VerticalFeed]  on product hydration callback
typedef VerticalFeedOnProductHydrationCallback = void Function(
  List<ProductInformation> products,
);

/// [VerticalFeed]  on product event callback
typedef VerticalFeedProductEventCallback = void Function(
  String event
  );

/// [VerticalFeed]  on product cart callback
typedef VerticalFeedOnProductCartUpdatedCallback = void Function(
  String event,
  STRCart? cart,
  STRCartItem? change,
  String responseId,
);


class VerticalFeedController {
  final MethodChannel _methodChannel;
  final int _viewId;

  VerticalFeedController(this._viewId, this._methodChannel);

  // This function allows to get `VerticalFeed` viewId
  int getViewId() {
    return _viewId;
  }

  /// This function allows you to refetch the data from network
  /// by default you do not need to use this function.
  Future<void> refresh() {
    return _methodChannel.invokeMethod('refresh');
  }

  Future<void> resumeStory() {
    return _methodChannel.invokeMethod('resumeStory');
  }

  Future<void> pauseStory() {
    return _methodChannel.invokeMethod('pauseStory');
  }

  Future<void> closeStory() {
    return _methodChannel.invokeMethod('closeStory');
  }

  /// This function allows you to open a specific story using
  /// `storyGroupId` and `storyId`.
  Future<void> openStory(String storyGroupId, String? storyId) {
    return _methodChannel.invokeMethod(
      'openStory',
      <String, dynamic>{
        'storyGroupId': storyGroupId,
        'storyId': storyId,
      },
    );
  }

  /// This function allows you to open using deeplink uri.
  Future<void> openStoryUri(String uri) {
    return _methodChannel.invokeMethod(
      'openStoryUri',
      <String, dynamic>{
        'uri': uri,
      },
    );
  }

  /// This function allows you to hydrate products.
  Future<void> hydrateProducts(List<STRProductItem> products) {
    return _methodChannel.invokeMethod(
      'hydrateProducts',
      <String, dynamic>{
        'products': products.map((e) => e.toJson()).toList(),
      },
    );
  }

  /// This function allows you to update your cart.
  Future<void> updateCart(Map cart) {
    return _methodChannel.invokeMethod(
      'updateCart',
      <String, dynamic>{
        'items': cart['items'],
        'totalPrice': cart['totalPrice'],
        'oldTotalPrice': cart['oldTotalPrice'],
        'currency': cart['currency'],
      },
    );
  }

  Future<void> approveCartChange(
      String responseId, Map<String, dynamic>? cart) {
    return _methodChannel.invokeMethod(
      'approveCartChange',
      <String, dynamic>{'responseId': responseId, 'cart': cart},
    );
  }

  Future<void> rejectCartChange(String responseId, String failMessage) {
    return _methodChannel.invokeMethod(
      'rejectCartChange',
      <String, dynamic>{'responseId': responseId, 'failMessage': failMessage},
    );
  }
}


class VerticalFeedPresenterController {
  final MethodChannel _methodChannel;
  final int _viewId;

  VerticalFeedPresenterController(this._viewId, this._methodChannel);

  // This function allows to get `VerticalFeed` viewId
  int getViewId() {
    return _viewId;
  }

  /// This function allows you to refetch the data from network
  /// by default you do not need to use this function.
  Future<void> refresh() {
    return _methodChannel.invokeMethod('refresh');
  }

  /// This function allows you to pause the presenter
  Future<void> pause() {
    return _methodChannel.invokeMethod('pause');
  }

  /// This function allows you to play the presenter
  Future<void> play() {
    return _methodChannel.invokeMethod('play');
  }

  /// This function allows you to hydrate products.
  Future<void> hydrateProducts(List<STRProductItem> products) {
    return _methodChannel.invokeMethod(
      'hydrateProducts',
      <String, dynamic>{
        'products': products.map((e) => e.toJson()).toList(),
      },
    );
  }

  /// This function allows you to update your cart.
  Future<void> updateCart(Map cart) {
    return _methodChannel.invokeMethod(
      'updateCart',
      <String, dynamic>{
        'items': cart['items'],
        'totalPrice': cart['totalPrice'],
        'oldTotalPrice': cart['oldTotalPrice'],
        'currency': cart['currency'],
      },
    );
  }

  Future<void> approveCartChange(
      String responseId, Map<String, dynamic>? cart) {
    return _methodChannel.invokeMethod(
      'approveCartChange',
      <String, dynamic>{'responseId': responseId, 'cart': cart},
    );
  }

  Future<void> rejectCartChange(String responseId, String failMessage) {
    return _methodChannel.invokeMethod(
      'rejectCartChange',
      <String, dynamic>{'responseId': responseId, 'failMessage': failMessage},
    );
  }
}


/// This class is used to customize the [VerticalFeed]
class VerticalFeedParam {
  /// This attribute required for your app's correct initialization.
  @required
  String? storylyId;

  /// Storyly SDK allows you to send a string parameter in the initialization
  /// process. This field is used for this analytical pruposes.
  ///
  /// * This value cannot have more than 200 characters. If you exceed the
  ///   size limit, your value will be set to null.
  String? storylyCustomParameters;

  /// This attribute defines whether it is a test device or not. If true,
  /// test groups are sent from the server.
  bool? storylyTestMode;

  /// This attribute takes a list of string which will be used in process
  /// of segmentation to show sepecific story groups to the users.
  List<String>? storylySegments;

  /// This attribue takes a map which will be used to replace user data set in
  /// dashboard to show user specific content.
  Map<String, String>? storylyUserProperty;

  /// This attribute allows you to change the layout direction
  /// the vertical feed view.
  String? storylyLayoutDirection;

  /// This function allows you to set localization for
  /// the storyly view. Sample convention is en-GB
  String? storylyLocale;


  /** Share Config */

  /// This attibute allows you to change share URL of stories.
  String? storylyShareUrl;

  /// This attibute allows you to set Facebook app id to be used in Instagram share to storiess.
  String? storylyFacebookAppID;


  /** List Config */

  /// This attribute changes orientation value of story group list
  String? verticalFeedGroupListOrientation;

  /// This attribute changes based on orientation horizontal orientation row count
  /// or vertical orientation column count of vertical feed group list
  int? verticalFeedGroupListSections;

  /// This attribute changes edge padding value of the first and last vertical feed groups
  /// for orientation horizontal
  int? verticalFeedGroupListHorizontalEdgePadding;

  /// This attribute changes edge padding value of the first and last vertical feed groups
  /// for orientation vertical
  int? verticalFeedGroupListVerticalEdgePadding;

  /// This attribute changes horizontal padding value between vertical feed groups
  int? verticalFeedGroupListHorizontalPaddingBetweenItems;

  /// This attribute changes vertical padding value between vertical feed groups
  int? verticalFeedGroupListVerticalPaddingBetweenItems;


  /** Group Styling */

  /// This attribute allows you to changes the height of vertical feed group icon.
  int? verticalFeedGroupIconHeight;

  /// This attribute allows you to changes the corner radius of vertical feed group
  /// icon.
  int? verticalFeedGroupIconCornerRadius;

  /// This attribute allows you to change the background color of the vertical feed
  /// group icon which is shown to the user as skeleton view till the stories
  /// are loaded.
  Color? verticalFeedGroupIconBackgroundColor;

  /// This attribute allows you to changes the visibility of vertical feed group
  /// text.
  bool? verticalFeedGroupTextIsVisible;

  /// This attribute allows you to change text size vertical feed group
  /// text.
  int? verticalFeedGroupTextSize;

  /// This attribute allows you to change font of vertical feed group
  /// text.
  String? verticalFeedGroupTextTypeface;

  /// This attribute allows you to change the text color of the vertical feed group.
  Color? verticalFeedGroupTextColor;

  /// This attribute allows you to set vertical feed type indicator visibility.
  bool? verticalFeedTypeIndicatorIsVisible;

  /// This attribute allows you to change the order of the vertical feed group.
  String?  verticalFeedGroupOrder;

  /// This attribute allows you to set minimum like count to show like icon
  int? verticalFeedGroupMinLikeCountToShowIcon;

  /// This attribute allows you to set minimum impression count to show impression icon
  int? verticalFeedGroupMinImpressionCountToShowIcon;

  /// This attribute allows you to set minimum impression count to show impression icon.
  String? verticalFeedGroupImpressionIcon;

  /// This attribute allows you to set minimum like count to show like icon.
  String? verticalFeedGroupLikeIcon;


  /** Story Styling */

  /// This attribute allows you to changes the visibility of story
  /// header text.
  bool? verticalFeedItemTitleIsVisible;


  /// This attribute allows you to changes the visibility of vertical feed
  /// header close button.
  bool? verticalFeedItemCloseButtonIsVisible;

  /// This attribute allows you to use custom icon for
  /// header close button.
  String? verticalFeedItemCloseIcon;


  /// This attribute allows you to changes the visibility of vertical feed
  /// share button.
  bool? verticalFeedItemShareButtonIsVisible;

  /// This attribute allows you to use custom icon for
  /// header share button.
  String? verticalFeedItemShareIcon;

  /// This attribute allows you to changes the visibility of vertical feed
  /// like button.
  bool? verticalFeedItemLikeButtonIsVisible;

  /// This attribute allows you to use custom icon for
  /// like button.
  String? verticalFeedItemLikeIcon;

  /// This attribute allows you to changes the visibility of vertical feed
  /// progress bar.
  bool? verticalFeedItemProgressBarIsVisible;

  /// This attribute allows you to change the progress bar colors of
  /// the vertical feed view.
  List<Color>? verticalFeedItemProgressBarColor;

  /// This attribute allows you to change the header text font of the
  /// vertical feed view.
  String? verticalFeedItemTextTypeface;

  /// This attribute allows you to change the interactive component font of the
  /// vertical feed view.
  String? verticalFeedInteractiveTextTypeface;


  /** Product Config */

  /// This attribute allows you to enable hydration from feed data from backend
  bool? isProductFallbackEnabled;

  /// This attribute allows you to set availability of cart
  bool? isProductCartEnabled;

  /// This attribute allows you to set product feed
  Map<String, List<STRProductItem>>? storyProductFeed;


  Map<String, dynamic> toMap() {
    final paramsMap = <String, dynamic>{};
  
    paramsMap['storylyInit'] = {
        'storylyId': storylyId,
        'storylySegments': storylySegments,
        'userProperty': storylyUserProperty,
        'customParameter': storylyCustomParameters,
        'storylyIsTestMode': storylyTestMode, 
        'storylyLayoutDirection': storylyLayoutDirection,
        'storylyLocale': storylyLocale,
    };
    paramsMap['verticalFeedGroupStyling'] = {
      'iconBackgroundColor': verticalFeedGroupIconBackgroundColor?.toHexString(),
      'iconCornerRadius': verticalFeedGroupIconCornerRadius,
      'iconHeight': verticalFeedGroupIconHeight, 
      'textColor': verticalFeedGroupTextColor?.toHexString(), 
      'titleFont': verticalFeedGroupTextTypeface, 
      'titleTextSize': verticalFeedGroupTextSize,  
      'titleVisible': verticalFeedGroupTextIsVisible, 
      'groupOrder': verticalFeedGroupOrder,
      'typeIndicatorVisible': verticalFeedTypeIndicatorIsVisible,
      'minLikeCountToShowIcon': verticalFeedGroupMinLikeCountToShowIcon,
      'minImpressionCountToShowIcon': verticalFeedGroupMinImpressionCountToShowIcon,
      'impressionIcon': verticalFeedGroupImpressionIcon,
      'likeIcon': verticalFeedGroupLikeIcon,
    };
    paramsMap['verticalFeedBarStyling'] = {
      'sections': verticalFeedGroupListSections,
      'horizontalEdgePadding': verticalFeedGroupListHorizontalEdgePadding,
      'verticalEdgePadding': verticalFeedGroupListVerticalEdgePadding,
      'horizontalPaddingBetweenItems': verticalFeedGroupListHorizontalPaddingBetweenItems,
      'verticalPaddingBetweenItems': verticalFeedGroupListVerticalPaddingBetweenItems,
    };
    paramsMap['verticalFeedCustomization'] = { 
      'titleFont': verticalFeedItemTextTypeface,
      'interactiveFont': verticalFeedInteractiveTextTypeface,
      'progressBarColor': verticalFeedItemProgressBarColor
          ?.map((color) => color.toHexString())
          .toList(),
      'isTitleVisible': verticalFeedItemTitleIsVisible,
      'isCloseButtonVisible': verticalFeedItemCloseButtonIsVisible,
      'isLikeButtonVisible': verticalFeedItemLikeButtonIsVisible,
      'isShareButtonVisible': verticalFeedItemShareButtonIsVisible,
      'closeButtonIcon': verticalFeedItemCloseIcon,
      'shareButtonIcon': verticalFeedItemShareIcon,
      "likeButtonIcon": verticalFeedItemLikeIcon,
      'isProgressBarVisible': verticalFeedItemProgressBarIsVisible,
    };
    paramsMap['verticalFeedItemShareConfig'] = {
      'storylyShareUrl': storylyShareUrl,
      'storylyFacebookAppID': storylyFacebookAppID,
    };
    paramsMap['verticalFeedItemProductConfig'] = { 
      'isFallbackEnabled': isProductFallbackEnabled,
      'isCartEnabled': isProductCartEnabled,
      'productFeed': storyProductFeed?.map(
          (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
    };
    return paramsMap;
  }
}



VerticalFeedItemComponent? getVerticalFeedItemComponent(Map<String, dynamic>? json) {
  if (json == null) return null;

  switch (json['type']) {
    case 'buttonaction':
      return VerticalFeedItemButtonActionComponent.fromJson(json);
    case 'swipeaction':
      return VerticalFeedItemSwipeActionComponent.fromJson(json);
    case 'producttag':
      return VerticalFeedItemProductTagComponent.fromJson(json);
    case 'productcard':
      return VerticalFeedItemProductCardComponent.fromJson(json);
    case 'productcatalog':
      return VerticalFeedItemProductCatalogComponent.fromJson(json);
    case 'quiz':
      return VerticalFeedItemQuizComponent.fromJson(json);
    case 'poll':
      return VerticalFeedItemPollComponent.fromJson(json);
    case 'emoji':
      return VerticalFeedItemEmojiComponent.fromJson(json);
    case 'rating':
      return VerticalFeedItemRatingComponent.fromJson(json);
    case 'promocode':
      return VerticalFeedItemPromocodeComponent.fromJson(json);
    case 'comment':
      return VerticalFeedItemCommentComponent.fromJson(json);
    default:
      return VerticalFeedItemComponent.fromJson(json);
  }
}

/// This parent class represents the interactive components which users are interacted with.
class VerticalFeedItemComponent {
  /// type Type of the interactive component
  final String type;

  /// id of the interactive component
  final String id;

  /// custom payload for the interactive component if exists
  final String? customPayload;

  VerticalFeedItemComponent(this.type, this.id, this.customPayload);

  factory VerticalFeedItemComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemComponent(json['type'], json['id'], json['customPayload']);
  }
}

/// This data class represents the Quiz component.
class VerticalFeedItemQuizComponent implements VerticalFeedItemComponent {
  VerticalFeedItemQuizComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    this.rightAnswerIndex,
    required this.title,
    required this.options,
    required this.selectedOptionIndex,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// rightAnswerIndex Index of the right answer if exists
  final int? rightAnswerIndex;

  /// title Title of the quiz if exists
  final String title;

  /// options List of options in the quiz
  final List<String> options;

  /// selectedOptionIndex Option index that the user selected
  final int selectedOptionIndex;

  factory VerticalFeedItemQuizComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemQuizComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      rightAnswerIndex: json['rightAnswerIndex'],
      title: json['title'],
      options: List<String>.from(json['options'].map((x) => x)),
      selectedOptionIndex: json['selectedOptionIndex'],
    );
  }
}

/// This data class represents the Poll component.
class VerticalFeedItemPollComponent implements VerticalFeedItemComponent {
  VerticalFeedItemPollComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    required this.options,
    required this.selectedOptionIndex,
    required this.title,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// options List of options in the poll
  final List<String> options;

  /// selectedOptionIndex Option index that the user selected
  final int selectedOptionIndex;

  /// title Title of the poll if exists
  final String title;

  factory VerticalFeedItemPollComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemPollComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      options: List<String>.from(json['options'].map((x) => x)),
      selectedOptionIndex: json['selectedOptionIndex'],
      title: json['title'],
    );
  }
}

/// This data class represents the Emoji component.
class VerticalFeedItemEmojiComponent implements VerticalFeedItemComponent {
  VerticalFeedItemEmojiComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    required this.selectedEmojiIndex,
    required this.emojiCodes,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// selectedEmojiIndex Emoji index that the user selected
  final int selectedEmojiIndex;

  /// emojiCodes List of the emojis in the component
  final List<String> emojiCodes;

  factory VerticalFeedItemEmojiComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemEmojiComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      selectedEmojiIndex: json['selectedEmojiIndex'],
      emojiCodes: List<String>.from(json['emojiCodes'].map((x) => x)),
    );
  }
}

/// This data class represents the Rating component.
class VerticalFeedItemRatingComponent implements VerticalFeedItemComponent {
  VerticalFeedItemRatingComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    required this.rating,
    required this.emojiCode,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// rating Rating value which user rated in the component
  final int rating;

  /// emojiCode Emoji code as the thumb emoji
  final String emojiCode;

  factory VerticalFeedItemRatingComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemRatingComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      rating: json['rating'],
      emojiCode: json['emojiCode'],
    );
  }
}

/// This data class represents the Promocode component.
class VerticalFeedItemPromocodeComponent implements VerticalFeedItemComponent {
  VerticalFeedItemPromocodeComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    required this.text,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// copied value from user in Promocode component
  final String text;

  factory VerticalFeedItemPromocodeComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemPromocodeComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      text: json['text'],
    );
  }
}

/// This data class represents the Comment component.
class VerticalFeedItemCommentComponent implements VerticalFeedItemComponent {
  VerticalFeedItemCommentComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    required this.text,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// user sent value in Comment component
  final String text;

  factory VerticalFeedItemCommentComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemCommentComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      text: json['text'],
    );
  }
}

/// This data class represents the ButtonAction component.
class VerticalFeedItemButtonActionComponent implements VerticalFeedItemComponent {
  VerticalFeedItemButtonActionComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    required this.text,
    this.actionUrl,
    this.products,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// text text of the interactive component
  final String text;

  /// actionUrl action url assigned to the interactive component
  final String? actionUrl;

  /// products products assigned to the interactive component
  final List<STRProductItem>? products;

  factory VerticalFeedItemButtonActionComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemButtonActionComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      text: json['text'],
      actionUrl: json['actionUrl'],
      products: List<STRProductItem>.from(
          json['products'].map((x) => STRProductItem.fromJson(x))),
    );
  }
}

/// This data class represents the SwipeAction component.
class VerticalFeedItemSwipeActionComponent implements VerticalFeedItemComponent {
  VerticalFeedItemSwipeActionComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    required this.text,
    this.actionUrl,
    this.products,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// text text of the interactive component
  final String text;

  /// actionUrl action url assigned to the interactive component
  final String? actionUrl;

  /// products products assigned to the interactive component
  final List<STRProductItem>? products;

  factory VerticalFeedItemSwipeActionComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemSwipeActionComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      text: json['text'],
      actionUrl: json['actionUrl'],
      products: List<STRProductItem>.from(
          json['products'].map((x) => STRProductItem.fromJson(x))),
    );
  }
}

/// This data class represents the ProductTag component.
class VerticalFeedItemProductTagComponent implements VerticalFeedItemComponent {
  VerticalFeedItemProductTagComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    this.actionUrl,
    this.products,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// actionUrl action url assigned to the interactive component
  final String? actionUrl;

  /// products products assigned to the interactive component
  final List<STRProductItem>? products;

  factory VerticalFeedItemProductTagComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemProductTagComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      actionUrl: json['actionUrl'],
      products: List<STRProductItem>.from(
          json['products'].map((x) => STRProductItem.fromJson(x))),
    );
  }
}

/// This data class represents the ProductCatalog component.
class VerticalFeedItemProductCardComponent implements VerticalFeedItemComponent {
  VerticalFeedItemProductCardComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    this.text,
    this.actionUrl,
    this.products,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// text text of the interactive component
  final String? text;

  /// actionUrl action url assigned to the interactive component
  final String? actionUrl;

  /// products products assigned to the interactive component
  final List<STRProductItem>? products;

  factory VerticalFeedItemProductCardComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemProductCardComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      text: json['text'],
      actionUrl: json['actionUrl'],
      products: List<STRProductItem>.from(
          json['products'].map((x) => STRProductItem.fromJson(x))),
    );
  }
}

/// This data class represents the ProductCatalog component.
class VerticalFeedItemProductCatalogComponent implements VerticalFeedItemComponent {
  VerticalFeedItemProductCatalogComponent({
    required this.type,
    required this.id,
    required this.customPayload,
    this.actionUrlList,
    this.products,
  });

  @override
  final String type;

  @override
  final String id;

  @override
  final String? customPayload;

  /// actionUrlList action url list assigned to the interactive component
  final List<String>? actionUrlList;

  /// products products assigned to the interactive component
  final List<STRProductItem>? products;

  factory VerticalFeedItemProductCatalogComponent.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItemProductCatalogComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      actionUrlList: castOrNull(
          json['actionUrlList']?.map<String>((e) => e as String).toList()),
      products: List<STRProductItem>.from(
          json['products'].map((x) => STRProductItem.fromJson(x))),
    );
  }
}

List<VerticalFeedGroup> verticalFeedGroupFromJson(List<dynamic> json) {
  return List<VerticalFeedGroup>.from(json.map((x) => VerticalFeedGroup.fromJson(x)));
}

/// This data class represents a story group in the VerticalFeed.
class VerticalFeedGroup {
  VerticalFeedGroup({
    required this.id,
    required this.title,
    required this.index,
    required this.seen,
    required this.iconUrl,
    required this.feedList,
    required this.pinned,
    required this.type,
    required this.nudge,
    this.name,
  });

  /// id ID of the story group
  final String id;

  /// title Title of the story group
  final String title;

  /// index Order index of the story group
  final int index;

  /// seen State of the story group that shows whether all of the stories are seen or not
  final bool seen;

  /// iconUrl URL of the story group icon image
  final String? iconUrl;

  /// stories List of stories in the story group
  final List<VerticalFeedItem> feedList;

  final bool pinned;

  final bool nudge;

  final String? name;

  final int type;

  factory VerticalFeedGroup.fromJson(Map<String, dynamic> json) {
    return VerticalFeedGroup(
      seen: json['seen'],
      title: json['title'],
      index: json['index'],
      iconUrl: json['iconUrl'],
      feedList: List<VerticalFeedItem>.from(json['feedList'].map((x) => VerticalFeedItem.fromJson(x))),
      id: json['id'],
      pinned: json['pinned'],
      type: json['type'],
      name: json['name'],
      nudge: json['nudge'],
    );
  }
}

/// This data class represents a story inside a story group.
class VerticalFeedItem {
  VerticalFeedItem(
      {required this.id,
      required this.title,
      required this.index,
      required this.seen,
      required this.currentTime,
      this.previewUrl,
      this.actionUrl,
      this.actionProducts,
      this.name,
      this.verticalFeedItemComponentList});

  /// ID of the story
  final String id;

  /// Title of the story
  final String title;

  /// Name of the story
  final String? name;

  /// Index of the story among other stories of the story group
  final int index;

  /// State of the story that shows whether the story is seen or not
  final bool seen;

  /// Time of the story that user watched
  final int currentTime;

  /// URL which the user has just interacted with
  final String? actionUrl;

  /// Related product content of interactive incase of click action
  final List<STRProductItem>? actionProducts;

  final List<VerticalFeedItemComponent?>? verticalFeedItemComponentList;

  final String? previewUrl;

  factory VerticalFeedItem.fromJson(Map<String, dynamic> json) {
    return VerticalFeedItem(
      id: json['id'],
      title: json['title'],
      name: json['name'],
      index: json['index'],
      seen: json['seen'],
      currentTime: json['currentTime'],
      previewUrl: json['previewUrl'],
      actionUrl: json['actionUrl'],
      verticalFeedItemComponentList: castOrNull(json['verticalFeedItemComponentList']
          ?.map<VerticalFeedItemComponent?>((e) => getVerticalFeedItemComponent(e))
          .toList()),
      actionProducts: List<STRProductItem>.from(
          json['actionProducts'].map((x) => STRProductItem.fromJson(x))),
    );
  }
}
