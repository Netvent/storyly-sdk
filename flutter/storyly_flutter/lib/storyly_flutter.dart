import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// [StorylyView] created callback
typedef StorylyViewCreatedCallback = void Function(
  StorylyViewController controller,
);

/// [StorylyView] loaded callback
typedef StorylyViewLoadedCallback = void Function(
  List<StoryGroup> storyGroups,
  String dataSource,
);

/// [StorylyView] load failed callback
typedef StorylyViewLoadFailedCallback = void Function(
  String message,
);

/// [StorylyView] event callback
typedef StorylyViewEventCallback = void Function(
  String event,
  StoryGroup? storyGroup,
  Story? story,
  StoryComponent? storyComponent,
);

/// [StorylyView] action clicked callback
typedef StorylyViewActionClickedCallback = void Function(
  Story story,
);

/// [StorylyView] user interacted callback
typedef StorylyViewUserInteractedCallback = void Function(
  StoryGroup storyGroup,
  Story story,
  StoryComponent? storyComponent,
);

T? castOrNull<T>(x) => x is T ? x : null;

/// Storyly UI Widget
class StorylyView extends StatefulWidget {
  /// This callback function allows you to access `StorylyViewController`
  ///
  /// ```dart
  /// StorylyView(
  ///   onStorylyViewCreated: onStorylyViewCreated,
  /// )
  ///
  /// void onStorylyViewCreated(StorylyViewController storylyViewController) {
  ///   this.storylyViewController = storylyViewController;
  /// }
  /// ```
  final StorylyViewCreatedCallback? onStorylyViewCreated;

  /// Android specific [StorylyParam]
  final StorylyParam? androidParam;

  /// iOS specific [StorylyParam]
  final StorylyParam? iosParam;

  /// This callback function will let you know that Storyly has completed
  /// its network operations and story group list has just shown to the user.
  final StorylyViewLoadedCallback? storylyLoaded;

  /// This callback function will let you know that Storyly has completed
  /// its network operations and had a problem while fetching your stories.
  final StorylyViewLoadFailedCallback? storylyLoadFailed;

  /// This callback function will notify you about all Storyly events and let
  /// you to send these events to specific data platforms
  final StorylyViewEventCallback? storylyEvent;

  /// This callback function will notify your application in case of Swipe Up
  /// or CTA Button action.
  final StorylyViewActionClickedCallback? storylyActionClicked;

  /// This callback function will let you know that stories are started to be
  /// shown to the users.
  final VoidCallback? storylyStoryShown;

  /// This callback function will let you know that user dismissed the current
  /// story while watching it.
  final VoidCallback? storylyStoryDismissed;

  /// This callback function will allow you to get reactions of users from
  /// specific interactive components.
  final StorylyViewUserInteractedCallback? storylyUserInteracted;

  const StorylyView({
    Key? key,
    this.onStorylyViewCreated,
    this.androidParam,
    this.iosParam,
    this.storylyLoaded,
    this.storylyLoadFailed,
    this.storylyEvent,
    this.storylyActionClicked,
    this.storylyStoryShown,
    this.storylyStoryDismissed,
    this.storylyUserInteracted,
  }) : super(key: key);

  @override
  State<StorylyView> createState() => _StorylyViewState();
}

class _StorylyViewState extends State<StorylyView> {
  @override
  Widget build(BuildContext context) {
    const viewType = 'FlutterStorylyView';

    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: widget.androidParam?._toMap() ?? {},
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
            ..create();
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        creationParams: widget.iosParam?._toMap() ?? {},
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
      '$defaultTargetPlatform is not supported yet for Storyly Flutter plugin.',
    );
  }

  void _onPlatformViewCreated(int _id) {
    final methodChannel = MethodChannel(
      'com.appsamurai.storyly/flutter_storyly_view_$_id',
    );
    methodChannel.setMethodCallHandler(_handleMethod);

    widget.onStorylyViewCreated?.call(StorylyViewController(methodChannel));
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'storylyLoaded':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.storylyLoaded?.call(
          storyGroupFromJson(jsonData['storyGroups']),
          jsonData['dataSource'],
        );
        break;
      case 'storylyLoadFailed':
        widget.storylyLoadFailed?.call(call.arguments);
        break;
      case 'storylyEvent':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.storylyEvent?.call(
          jsonData['event'],
          StoryGroup.fromJson(jsonData['storyGroup']),
          Story.fromJson(jsonData['story']),
          getStorylyComponent(jsonData['storyComponent']),
        );
        break;
      case 'storylyActionClicked':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.storylyActionClicked?.call(
          Story.fromJson(jsonData),
        );
        break;
      case 'storylyStoryShown':
      case 'storylyStoryPresented':
        widget.storylyStoryShown?.call();
        break;
      case 'storylyStoryDismissed':
        widget.storylyStoryDismissed?.call();
        break;
      case 'storylyUserInteracted':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.storylyUserInteracted?.call(
          StoryGroup.fromJson(jsonData['storyGroup']),
          Story.fromJson(jsonData['story']),
          getStorylyComponent(jsonData['storyComponent']),
        );
        break;
    }
  }
}

class StorylyViewController {
  final MethodChannel _methodChannel;

  StorylyViewController(this._methodChannel);

  /// This function allows you to refetch the data from network
  /// by default you do not need to use this function.
  Future<void> refresh() {
    return _methodChannel.invokeMethod('refresh');
  }

  /// This function allows you to open the story view.
  Future<void> storyShow() {
    return _methodChannel.invokeMethod('show');
  }

  /// This function allows you to dismiss story view.
  Future<void> storyDismiss() {
    return _methodChannel.invokeMethod('dismiss');
  }

  /// This function allows you to open a specific story using
  /// `storyGroupId` and `storyId`.
  Future<void> openStory(String storyGroupId, String storyId) {
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

  /// This function allows you to specify data of custom template groups.
  Future<void> setExternalData(List<Map> externalData) {
    return _methodChannel.invokeMethod(
      'setExternalData',
      <String, dynamic>{
        'externalData': externalData,
      },
    );
  }
}

/// This class is used to customize the [StorylyView]
class StorylyParam {
  /// This attribute required for your app's correct initialization.
  @required
  String? storylyId;

  /// This attribute takes a list of string which will be used in process
  /// of segmentation to show sepecific story groups to the users.
  List<String>? storylySegments;

  /// This attribue takes a map which will be used to replace user data set in
  /// dashboard to show user specific content.
  Map<String, String>? storylyUserProperty;

  /// This attibute allows you to change share URL of stories.
  String? storylyShareUrl;

  /// Storyly SDK allows you to send a string parameter in the initialization
  /// process. This field is used for this analytical pruposes.
  ///
  /// * This value cannot have more than 200 characters. If you exceed the
  ///   size limit, your value will be set to null.
  String? storylyCustomParameters;

  // This attribute is for user payload to use for Moments by Storyly
  String? storylyPayload;

  /// This attribute defines whether it is a test device or not. If true,
  /// test groups are sent from the server.
  bool? storylyTestMode;

  /// This attribute allows you to change the background color of the
  /// [StorylyView]
  Color? storylyBackgroundColor;

  /// This attribute changes the size of the story group. Currently,
  /// supported sizes are `small`, `large`, `xlarge` and `custom` sizes.
  /// Default story group size is `large` size.
  ///
  /// * This section is effective if you set your story group size as `custom`.
  ///   If you set any other size and use this attribute, your changes will
  ///   not take effect.
  ///
  /// In order to set this attribute use the following method:
  ///
  /// ```dart
  /// StorylyParam()
  ///   ...
  ///   storyGroupIconWidth = 100
  ///   storyGroupIconHeight = 100
  ///   storyGroupIconCornerRadius = 50;
  /// ```
  ///
  /// * You need to set all parameters to this customization to be effective.
  String? storyGroupSize;

  /// This attribute allows you to changes the width of story group icon.
  int? storyGroupIconWidth;

  /// This attribute allows you to changes the height of story group icon.
  int? storyGroupIconHeight;

  /// This attribute allows you to changes the corner radius of story group
  /// icon.
  int? storyGroupIconCornerRadius;

  /// This attribute allows you to changes the edge padding of story group
  /// list.
  int? storyGroupListEdgePadding;

  /// This attribute allows you to changes the distance between of story group
  /// icons.
  int? storyGroupListPaddingBetweenItems;

  /// This attribute allows you to use different story groups images for
  /// different labels.
  String? storyGroupIconImageThematicLabel;

  /// This attribute allows you to changes the visibility of story group
  /// text.
  bool? storyGroupTextIsVisible;

  /// This attribute allows you to change text size story group
  /// text.
  int? storyGroupTextSize;

  /// This attribute allows you to change line count of story group
  /// text.
  int? storyGroupTextLines;

  /// This attribute allows you to change font of story group
  /// text.
  String? storyGroupTextTypeface;

  /// This attribute allows you to change the text color of the seen story group.
  Color? storyGroupTextColorSeen;

  /// This attribute allows you to change the text color of the not seen story group.
  Color? storyGroupTextColorNotSeen;

  /// This attribute allows you to changes the visibility of story
  /// header text.
  bool? storyHeaderTextIsVisible;

  /// This attribute allows you to changes the visibility of story
  /// header icon.
  bool? storyHeaderIconIsVisible;

  /// This attribute allows you to changes the visibility of story
  /// header close button.
  bool? storyHeaderCloseButtonIsVisible;

  /// This attribute allows you to use custom icon for 
  /// header close button.
  String? storyHeaderCloseIcon;

  /// This attribute allows you to use custom icon for 
  /// header share button.
  String? storyHeaderShareIcon;

  /// This attribute allows you to change the layout direction
  /// the story view.
  String? storylyLayoutDirection;

  /// This attribute allows you to the border color of the story group
  /// icons which are watched by the user.
  List<Color>? storyGroupIconBorderColorSeen;

  /// This attribute allows you to change the border color of the story
  /// group icons which are unwatched by the user.
  List<Color>? storyGroupIconBorderColorNotSeen;

  /// This attribute allows you to change the background color of the story
  /// group icon which is shown to the user as skeleton view till the stories
  /// are loaded.
  Color? storyGroupIconBackgroundColor;

  /// If any of the story group is selected as pinned group from dashboard,
  /// a little star icon will appear along with the story group icon. This
  /// attribute allows you to change the background color of this pin icon.
  Color? storyGroupPinIconColor;

  /// This attribute allows you to change the header icon border
  /// color of the story view.
  List<Color>? storyItemIconBorderColor;

  /// This attribute allows you to change the header text color of the
  /// story view.
  Color? storyItemTextColor;

  /// This attribute allows you to change the progress bar colors of
  /// the story view.
  List<Color>? storyItemProgressBarColor;

  /// This attribute allows you to change the header text font of the
  /// story view.
  String? storyItemTextTypeface;

  /// This attribute allows you to change the interactive component font of the
  /// story view.
  String? storyInteractiveTextTypeface;

  Map<String, dynamic> _toMap() {
    final paramsMap = <String, dynamic>{
      'storylyId': storylyId,
      'storylySegments': storylySegments,
      'storylyUserProperty': storylyUserProperty,
      'storylyCustomParameters': storylyCustomParameters,
      'storylyPayload': storylyPayload,
      'storylyShareUrl': storylyShareUrl,
      'storylyIsTestMode': storylyTestMode,
    };

    paramsMap['storylyBackgroundColor'] = storylyBackgroundColor?.toHexString();

    paramsMap['storyGroupIconStyling'] = {
      'width': storyGroupIconWidth,
      'height': storyGroupIconHeight,
      'cornerRadius': storyGroupIconCornerRadius,
    };

    paramsMap['storyGroupListStyling'] = {
      'edgePadding': storyGroupListEdgePadding,
      'paddingBetweenItems': storyGroupListPaddingBetweenItems
    };

    paramsMap['storyGroupIconImageThematicLabel'] =
        storyGroupIconImageThematicLabel;

    paramsMap['storyGroupTextStyling'] = {
      'isVisible': storyGroupTextIsVisible,
      'textSize': storyGroupTextSize,
      'lines': storyGroupTextLines,
      'typeface': storyGroupTextTypeface,
      'colorSeen': storyGroupTextColorSeen?.toHexString(),
      'colorNotSeen': storyGroupTextColorNotSeen?.toHexString(),
    };

    paramsMap['storyHeaderStyling'] = {
      'isTextVisible': storyHeaderTextIsVisible,
      'isIconVisible': storyHeaderIconIsVisible,
      'isCloseButtonVisible': storyHeaderCloseButtonIsVisible,
      'closeIcon': storyHeaderCloseIcon,
      'shareIcon': storyHeaderShareIcon,
    };

    paramsMap['storyGroupSize'] = storyGroupSize ?? 'large';

    paramsMap['storylyLayoutDirection'] = storylyLayoutDirection ?? 'ltr';

    paramsMap['storyGroupIconBorderColorSeen'] = storyGroupIconBorderColorSeen
        ?.map((color) => color.toHexString())
        .toList();

    paramsMap['storyGroupIconBorderColorNotSeen'] =
        storyGroupIconBorderColorNotSeen
            ?.map((color) => color.toHexString())
            .toList();

    paramsMap['storyGroupIconBackgroundColor'] =
        storyGroupIconBackgroundColor?.toHexString();

    paramsMap['storyGroupPinIconColor'] = storyGroupPinIconColor?.toHexString();

    paramsMap['storyItemIconBorderColor'] =
        storyItemIconBorderColor?.map((color) => color.toHexString()).toList();

    paramsMap['storyItemTextColor'] = storyItemTextColor?.toHexString();

    paramsMap['storyItemProgressBarColor'] =
        storyItemProgressBarColor?.map((color) => color.toHexString()).toList();

    paramsMap['storyItemTextTypeface'] = storyItemTextTypeface;

    paramsMap['storyInteractiveTextTypeface'] = storyInteractiveTextTypeface;

    return paramsMap;
  }
}

StoryComponent? getStorylyComponent(Map<String, dynamic>? json) {
  if (json == null) return null;

  switch (json['type']) {
    case 'quiz':
      return StoryQuizComponent.fromJson(json);
    case 'poll':
      return StoryPollComponent.fromJson(json);
    case 'emoji':
      return StoryEmojiComponent.fromJson(json);
    case 'rating':
      return StoryRatingComponent.fromJson(json);
    case 'promocode':
      return StoryPromocodeComponent.fromJson(json);
    case 'commment':
      return StoryCommentComponent.fromJson(json);
    default:
      return StoryComponent.fromJson(json);
  }
}

/// This parent class represents the interactive components which users are interacted with.
class StoryComponent {
  /// type Type of the interactive component
  final String type;

  /// id of the interactive component
  final String id;

  StoryComponent(this.type, this.id);

  factory StoryComponent.fromJson(Map<String, dynamic> json) {
    return StoryComponent(json['type'], json['id']);
  }
}

/// This data class represents the Quiz component.
class StoryQuizComponent implements StoryComponent {
  StoryQuizComponent({
    required this.type,
    required this.id,
    this.rightAnswerIndex,
    this.customPayload,
    required this.title,
    required this.options,
    required this.selectedOptionIndex,
  });

  @override
  final String type;

  @override
  final String id;

  /// rightAnswerIndex Index of the right answer if exists
  final int? rightAnswerIndex;

  /// customPayload Custom payload for this quiz if exists
  final String? customPayload;

  /// title Title of the quiz if exists
  final String title;

  /// options List of options in the quiz
  final List<String> options;

  /// selectedOptionIndex Option index that the user selected
  final int selectedOptionIndex;

  factory StoryQuizComponent.fromJson(Map<String, dynamic> json) {
    return StoryQuizComponent(
      type: json['type'],
      id: json['id'],
      rightAnswerIndex: json['rightAnswerIndex'],
      customPayload: json['customPayload'],
      title: json['title'],
      options:  List<String>.from(json['options'].map((x) => x)) ,
      selectedOptionIndex: json['selectedOptionIndex'],
    );
  }
}

/// This data class represents the Poll component.
class StoryPollComponent implements StoryComponent {
  StoryPollComponent({
    required this.type,
    required this.id,
    required this.options,
    this.customPayload,
    required this.selectedOptionIndex,
    required this.title,
  });

  @override
  final String type;

  @override
  final String id;

  /// options List of options in the poll
  final List<String> options;

  /// customPayload Custom payload for this poll if exists
  final String? customPayload;

  /// selectedOptionIndex Option index that the user selected
  final int selectedOptionIndex;

  /// title Title of the poll if exists
  final String title;

  factory StoryPollComponent.fromJson(Map<String, dynamic> json) {
    return StoryPollComponent(
      type: json['type'],
      id: json['id'],
      options:  List<String>.from(json['options'].map((x) => x)) ,
      customPayload: json['customPayload'],
      selectedOptionIndex: json['selectedOptionIndex'],
      title: json['title'],
    );
  }
}

/// This data class represents the Emoji component.
class StoryEmojiComponent implements StoryComponent {
  StoryEmojiComponent({
    required this.type,
    required this.id,
    this.customPayload,
    required this.selectedEmojiIndex,
    required this.emojiCodes,
  });

  @override
  final String type;

  @override
  final String id;

  /// customPayload Custom payload for this emoji if exists
  final String? customPayload;

  /// selectedEmojiIndex Emoji index that the user selected
  final int selectedEmojiIndex;

  /// emojiCodes List of the emojis in the component
  final List<String> emojiCodes;

  factory StoryEmojiComponent.fromJson(Map<String, dynamic> json) {
    return StoryEmojiComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      selectedEmojiIndex: json['selectedEmojiIndex'],
      emojiCodes: List<String>.from(json['emojiCodes'].map((x) => x)) ,
    );
  }
}

/// This data class represents the Rating component.
class StoryRatingComponent implements StoryComponent {
  StoryRatingComponent({
    required this.type,
    required this.id,
    this.customPayload,
    required this.rating,
    required this.emojiCode,
  });

  @override
  final String type;

  @override
  final String id;

  /// customPayload Custom payload for this rating if exists
  final String? customPayload;

  /// rating Rating value which user rated in the component
  final int rating;

  /// emojiCode Emoji code as the thumb emoji
  final String emojiCode;

  factory StoryRatingComponent.fromJson(Map<String, dynamic> json) {
    return StoryRatingComponent(
      type: json['type'],
      id: json['id'],
      customPayload: json['customPayload'],
      rating: json['rating'],
      emojiCode: json['emojiCode'],
    );
  }
}

/// This data class represents the Promocode component.
class StoryPromocodeComponent implements StoryComponent {
  StoryPromocodeComponent({
    required this.type,
    required this.id,
    required this.text,
  });

  @override
  final String type;

  @override
  final String id;

  /// copied value from user in Promocode component
  final String text;

  factory StoryPromocodeComponent.fromJson(Map<String, dynamic> json) {
    return StoryPromocodeComponent(
      type: json['type'],
      id: json['id'],
      text: json['text'],
    );
  }
}


/// This data class represents the Comment component.
class StoryCommentComponent implements StoryComponent {
  StoryCommentComponent({
    required this.type,
    required this.id,
    required this.text,
  });

  @override
  final String type;

  @override
  final String id;

  /// user sent value in Comment component
  final String text;

  factory StoryCommentComponent.fromJson(Map<String, dynamic> json) {
    return StoryCommentComponent(
      type: json['type'],
      id: json['id'],
      text: json['text'],
    );
  }
}

List<StoryGroup> storyGroupFromJson(List<dynamic> json) {
  return List<StoryGroup>.from(json.map((x) => StoryGroup.fromJson(x)));
}

/// This data class represents a story group in the StorylyView.
class StoryGroup {
  StoryGroup({
    required this.id,
    required this.title,
    required this.index,
    required this.seen,
    required this.iconUrl,
    required this.stories,
    required this.pinned,
    required this.type,
    this.groupTheme,
    this.thematicIconUrls,
    this.coverUrl,
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
  final String iconUrl;

  /// stories List of stories in the story group
  final List<Story> stories;

  final String? groupTheme;

  final Map<String,String>? thematicIconUrls;

  final String? coverUrl;

  final bool pinned;

  final int type;

  factory StoryGroup.fromJson(Map<String, dynamic> json) {
    return StoryGroup(
      seen: json['seen'],
      title: json['title'],
      index: json['index'],
      iconUrl: json['iconUrl'],
      stories: List<Story>.from(json['stories'].map((x) => Story.fromJson(x))),
      id: json['id'],
      groupTheme: json['grupTheme'],
      thematicIconUrls: json['thematicIconUrls'] != null ? Map<String,String>.from(json['thematicIconUrls']) : null,
      coverUrl: json['coverUrl'],
      pinned: json['pinned'],
      type: json['type'],
    );
  }
}

/// This data class represents a story inside a story group.
class Story {
  Story({
    required this.id,
    required this.title,
    required this.index,
    required this.seen,
    required this.currentTime,
    required this.media,
    this.name,
  });

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

  /// Media content of the story
  final Media media;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      name: json['name'],
      index: json['index'],
      seen: json['seen'],
      currentTime: json['currentTime'],
      media: Media.fromJson(json['media']),
    );
  }
}

/// This data class represents the media of a story.
class Media {
  Media({
    required this.type,
    this.storyComponentList,
    this.actionUrlList,
    this.actionUrl,
    this.previewUrl,
  });

  /// Type of the story
  final int type;

  final List<StoryComponent?>? storyComponentList;

  final List<String>? actionUrlList;

  /// URL which the user has just interacted with
  final String? actionUrl;

  final String? previewUrl;

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      type: json['type'],
      storyComponentList: castOrNull(json['storyComponentList']?.map<StoryComponent?>((e) => getStorylyComponent(e)).toList()),
      actionUrlList: castOrNull(json['actionUrlList']?.map<String>((e) => e as String).toList()),
      actionUrl: json['actionUrl'],
      previewUrl: json['previewUrl'],
    );
  }
}

extension StorylyHexColor on Color {
  String toHexString() {
    return '#${value.toRadixString(16).padLeft(8, '0')}';
  }
}
