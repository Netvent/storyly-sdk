import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [StorylyView] created callback
typedef StorylyViewCreatedCallback = void Function(
  StorylyViewController controller,
);

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
  final Function(List<StoryGroup> storyGroups)? storylyLoaded;

  /// This callback function will let you know that Storyly has completed
  /// its network operations and had a problem while fetching your stories.
  final Function(String? message)? storylyLoadFailed;

  /// This callback function will notify you about all Storyly events and let
  /// you to send these events to specific data platforms
  final Function(
    String? event,
    StoryGroup storyGroup,
    Story story,
    StoryComponent? storyComponent,
  )? storylyEvent;

  /// This callback function will notify your application in case of Swipe Up
  /// or CTA Button action.
  final Function(Story story)? storylyActionClicked;

  /// This callback function will let you know that stories are started to be
  /// shown to the users.
  final Function()? storylyStoryShown;

  /// This callback function will let you know that user dismissed the current
  /// story while watching it.
  final Function()? storylyStoryDismissed;

  /// This callback function will allow you to get reactions of users from
  /// specific interactive components.
  final Function(
    StoryGroup storyGroup,
    Story story,
    StoryComponent? storyComponent,
  )? storylyUserInteracted;

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
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'FlutterStorylyView',
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        creationParams: widget.androidParam!._toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'FlutterStorylyView',
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        creationParams: widget.iosParam!._toMap(),
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

    if (widget.onStorylyViewCreated != null) {
      widget.onStorylyViewCreated!(
        StorylyViewController(methodChannel),
      );
    }
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'storylyLoaded':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.storylyLoaded!(storyGroupFromJson(jsonData));
        break;
      case 'storylyLoadFailed':
        widget.storylyLoadFailed!(call.arguments);
        break;
      case 'storylyEvent':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.storylyEvent!(
          jsonData['event'],
          StoryGroup.fromJson(jsonData['storyGroup']),
          Story.fromJson(jsonData['story']),
          getStorylyComponent(jsonData['storyComponent']),
        );
        break;
      case 'storylyActionClicked':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.storylyActionClicked!(
          Story.fromJson(jsonData),
        );
        break;
      case 'storylyStoryShown':
      case 'storylyStoryPresented':
        widget.storylyStoryShown!();
        break;
      case 'storylyStoryDismissed':
        widget.storylyStoryDismissed!();
        break;
      case 'storylyUserInteracted':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.storylyUserInteracted!(
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
  Future<void> openStory(int storyGroupId, int storyId) {
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

  /// Storyly SDK allows you to send a string parameter in the initialization
  /// process. This field is used for this analytical pruposes.
  ///
  /// * This value cannot have more than 200 characters. If you exceed the
  ///   size limit, your value will be set to null.
  String? storylyCustomParameters;

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

  /// This attribute allows you to changes the visibility of story group
  /// text.
  bool? storyGroupTextIsVisible;

  /// This attribute allows you to changes the visibility of story
  /// header text.
  bool? storyHeaderTextIsVisible;

  /// This attribute allows you to changes the visibility of story
  /// header icon.
  bool? storyHeaderIconIsVisible;

  /// This attribute allows you to changes the visibility of story
  /// header close button.
  bool? storyHeaderCloseButtonIsVisible;

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

  /// This attribute allows you to change the text color of the story group.
  Color? storyGroupTextColor;

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

  Map<String, dynamic> _toMap() {
    final paramsMap = <String, dynamic>{
      'storylyId': storylyId,
      'storylySegments': storylySegments,
      'storylyCustomParameters': storylyCustomParameters,
      'storylyIsTestMode': storylyTestMode,
    };

    paramsMap['storylyBackgroundColor'] = storylyBackgroundColor != null
        ? _toHexString(storylyBackgroundColor!)
        : null;

    paramsMap['storyGroupIconStyling'] = {
      'width': storyGroupIconWidth,
      'height': storyGroupIconHeight,
      'cornerRadius': storyGroupIconCornerRadius,
    };

    paramsMap['storyGroupListStyling'] = {
      'edgePadding': storyGroupListEdgePadding,
      'paddingBetweenItems': storyGroupListPaddingBetweenItems
    };

    paramsMap['storyGroupTextStyling'] = {
      'isVisible': storyGroupTextIsVisible,
    };

    paramsMap['storyHeaderStyling'] = {
      'isTextVisible': storyHeaderTextIsVisible,
      'isIconVisible': storyHeaderIconIsVisible,
      'isCloseButtonVisible': storyHeaderCloseButtonIsVisible
    };

    paramsMap['storyGroupSize'] = storyGroupSize ?? 'large';

    paramsMap['storyGroupIconBorderColorSeen'] =
        storyGroupIconBorderColorSeen != null
            ? storyGroupIconBorderColorSeen!
                .map((color) => _toHexString(color))
                .toList()
            : null;

    paramsMap['storyGroupIconBorderColorNotSeen'] =
        storyGroupIconBorderColorNotSeen != null
            ? storyGroupIconBorderColorNotSeen!
                .map((color) => _toHexString(color))
                .toList()
            : null;

    paramsMap['storyGroupIconBackgroundColor'] =
        storyGroupIconBackgroundColor != null
            ? _toHexString(storyGroupIconBackgroundColor!)
            : null;

    paramsMap['storyGroupTextColor'] =
        storyGroupTextColor != null ? _toHexString(storyGroupTextColor!) : null;

    paramsMap['storyGroupPinIconColor'] = storyGroupPinIconColor != null
        ? _toHexString(storyGroupPinIconColor!)
        : null;

    paramsMap['storyItemIconBorderColor'] = storyItemIconBorderColor != null
        ? storyItemIconBorderColor!.map((color) => _toHexString(color)).toList()
        : null;

    paramsMap['storyItemTextColor'] =
        storyItemTextColor != null ? _toHexString(storyItemTextColor!) : null;

    paramsMap['storyItemProgressBarColor'] = storyItemProgressBarColor != null
        ? storyItemProgressBarColor!.map((color) => _toHexString(color)).toList()
        : null;

    return paramsMap;
  }

  String _toHexString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }
}

StoryComponent? getStorylyComponent(dynamic json) {
  StoryComponent? storyComponent;

  if (json == null) {
    return storyComponent;
  }

  if (json['type'] == 'quiz') {
    storyComponent = StoryQuizComponent.fromJson(json);
  } else if (json['type'] == 'poll') {
    storyComponent = StoryPollComponent.fromJson(json);
  } else if (json['type'] == 'emoji') {
    storyComponent = StoryEmojiComponent.fromJson(json);
  } else if (json['type'] == 'rating') {
    storyComponent = StoryRatingComponent.fromJson(json);
  }

  return storyComponent;
}

/// This parent class represents the interactive components which users are interacted with.
abstract class StoryComponent {
  /// type Type of the interactive component
  final String? type;

  StoryComponent(this.type);

  static dynamic fromJson(Map<String, dynamic> json) {}
}

/// This data class represents the Quiz component.
class StoryQuizComponent implements StoryComponent {
  StoryQuizComponent({
    this.type,
    this.rightAnswerIndex,
    this.customPayload,
    this.title,
    this.options,
    this.selectedOptionIndex,
  });

  @override
  final String? type;

  /// rightAnswerIndex Index of the right answer if exists
  final int? rightAnswerIndex;

  /// customPayload Custom payload for this quiz if exists
  final String? customPayload;

  /// title Title of the quiz if exists
  final String? title;

  /// options List of options in the quiz
  final List<String>? options;

  /// selectedOptionIndex Option index that the user selected
  final int? selectedOptionIndex;

  factory StoryQuizComponent.fromJson(Map<String, dynamic> json) {
    return StoryQuizComponent(
      type: json['type'],
      rightAnswerIndex: json['rightAnswerIndex'],
      customPayload: json['customPayload'],
      title: json['title'],
      options: List<String>.from(json['options'].map((x) => x)),
      selectedOptionIndex: json['selectedOptionIndex'],
    );
  }
}

/// This data class represents the Poll component.
class StoryPollComponent implements StoryComponent {
  StoryPollComponent({
    this.type,
    this.options,
    this.customPayload,
    this.selectedOptionIndex,
    this.title,
  });

  @override
  final String? type;

  /// options List of options in the poll
  final List<String>? options;

  /// customPayload Custom payload for this poll if exists
  final String? customPayload;

  /// selectedOptionIndex Option index that the user selected
  final int? selectedOptionIndex;

  /// title Title of the poll if exists
  final String? title;

  factory StoryPollComponent.fromJson(Map<String, dynamic> json) {
    return StoryPollComponent(
      type: json['type'],
      options: List<String>.from(json['options'].map((x) => x)),
      customPayload: json['customPayload'],
      selectedOptionIndex: json['selectedOptionIndex'],
      title: json['title'],
    );
  }
}

/// This data class represents the Emoji component.
class StoryEmojiComponent implements StoryComponent {
  StoryEmojiComponent({
    this.type,
    this.customPayload,
    this.selectedEmojiIndex,
    this.emojiCodes,
  });

  @override
  final String? type;

  /// customPayload Custom payload for this emoji if exists
  final String? customPayload;

  /// selectedEmojiIndex Emoji index that the user selected
  final int? selectedEmojiIndex;

  /// emojiCodes List of the emojis in the component
  final List<String>? emojiCodes;

  factory StoryEmojiComponent.fromJson(Map<String, dynamic> json) {
    return StoryEmojiComponent(
      type: json['type'],
      customPayload: json['customPayload'],
      selectedEmojiIndex: json['selectedEmojiIndex'],
      emojiCodes: List<String>.from(json['emojiCodes'].map((x) => x)),
    );
  }
}

/// This data class represents the Rating component.
class StoryRatingComponent implements StoryComponent {
  StoryRatingComponent({
    this.type,
    this.customPayload,
    this.rating,
    this.emojiCode,
  });

  @override
  final String? type;

  /// customPayload Custom payload for this rating if exists
  final String? customPayload;

  /// rating Rating value which user rated in the component
  final int? rating;

  /// emojiCode Emoji code as the thumb emoji
  final String? emojiCode;

  factory StoryRatingComponent.fromJson(Map<String, dynamic> json) {
    return StoryRatingComponent(
      type: json['type'],
      customPayload: json['customPayload'],
      rating: json['rating'],
      emojiCode: json['emojiCode'],
    );
  }
}

List<StoryGroup> storyGroupFromJson(List<dynamic> json) {
  return List<StoryGroup>.from(json.map((x) => StoryGroup.fromJson(x)));
}

/// This data class represents a story group in the StorylyView.
class StoryGroup {
  StoryGroup({
    this.seen,
    this.title,
    this.index,
    this.iconUrl,
    this.stories,
    this.id,
  });

  /// seen State of the story group that shows whether all of the stories are seen or not
  final bool? seen;

  /// title Title of the story group
  final String? title;

  /// index Order index of the story group
  final int? index;

  /// iconUrl URL of the story group icon image
  final String? iconUrl;

  /// stories List of stories in the story group
  final List<Story>? stories;

  /// id ID of the story group
  final int? id;

  factory StoryGroup.fromJson(Map<String, dynamic> json) {
    return StoryGroup(
      seen: json['seen'],
      title: json['title'],
      index: json['index'],
      iconUrl: json['iconUrl'],
      stories: List<Story>.from(json['stories'].map((x) => Story.fromJson(x))),
      id: json['id'],
    );
  }
}

/// This data class represents a story inside a story group.
class Story {
  Story({
    this.media,
    this.title,
    this.seen,
    this.index,
    this.id,
  });

  /// media Media content of the story
  final Media? media;

  /// title Title of the story
  final String? title;

  /// seen State of the story that shows whether the story is seen or not
  final bool? seen;

  /// index Index of the story among other stories of the story group
  final int? index;

  /// id ID of the story
  final int? id;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      media: Media.fromJson(json['media']),
      title: json['title'],
      seen: json['seen'],
      index: json['index'],
      id: json['id'],
    );
  }
}

/// This data class represents the media of a story.
class Media {
  Media({
    this.actionUrl,
    this.type,
  });

  /// actionUrl URL which the user has just interacted with
  final String? actionUrl;

  /// type Type of the story
  final int? type;

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      actionUrl: json['actionUrl'],
      type: json['type'],
    );
  }
}
