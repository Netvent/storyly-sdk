import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

typedef void StorylyViewCreatedCallback(StorylyViewController controller);

class StorylyView extends StatefulWidget {
  final StorylyViewCreatedCallback onStorylyViewCreated;

  final StorylyParam androidParam;
  final StorylyParam iosParam;

  final Function(List) storylyLoaded;
  final Function(String) storylyLoadFailed;
  final Function(Map) storylyEvent;
  final Function(Map) storylyActionClicked;
  final Function() storylyStoryShown;
  final Function() storylyStoryDismissed;
  final Function(Map) storylyUserInteracted;

  const StorylyView(
      {Key key,
      this.onStorylyViewCreated,
      this.androidParam,
      this.iosParam,
      this.storylyLoaded,
      this.storylyLoadFailed,
      this.storylyEvent,
      this.storylyActionClicked,
      this.storylyStoryShown,
      this.storylyStoryDismissed,
      this.storylyUserInteracted})
      : super(key: key);

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
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
            new Factory<OneSequenceGestureRecognizer>(
              () => new EagerGestureRecognizer(),
            ),
          ].toSet(),
          creationParams: widget.androidParam.toMap(),
          creationParamsCodec: const StandardMessageCodec());
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
          viewType: 'FlutterStorylyView',
          onPlatformViewCreated: _onPlatformViewCreated,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
            new Factory<OneSequenceGestureRecognizer>(
              () => new EagerGestureRecognizer(),
            ),
          ].toSet(),
          creationParams: widget.iosParam.toMap(),
          creationParamsCodec: const StandardMessageCodec());
    }
    return Text(
        '$defaultTargetPlatform is not supported yet for Storyly Flutter plugin.');
  }

  void _onPlatformViewCreated(int _id) {
    final StorylyViewController controller = StorylyViewController.init(_id);
    controller._methodChannel.setMethodCallHandler(handleMethod);
    if (widget.onStorylyViewCreated != null) {
      widget.onStorylyViewCreated(controller);
    }
  }

  Future<dynamic> handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'storylyLoaded':
        widget.storylyLoaded(call.arguments);
        break;
      case 'storylyLoadFailed':
        widget.storylyLoadFailed(call.arguments);
        break;
      case 'storylyEvent':
        widget.storylyEvent(call.arguments);
        break;
      case 'storylyActionClicked':
        widget.storylyActionClicked(call.arguments);
        break;
      case 'storylyStoryShown':
      case 'storylyStoryPresented':
        widget.storylyStoryShown();
        break;
      case 'storylyStoryDismissed':
        widget.storylyStoryDismissed();
        break;
      case 'storylyUserInteracted':
        widget.storylyUserInteracted(call.arguments);
        break;
    }
  }
}

class StorylyViewController {
  MethodChannel _methodChannel;

  StorylyViewController.init(int id) {
    _methodChannel =
        new MethodChannel('com.appsamurai.storyly/flutter_storyly_view_$id');
  }

  Future<void> refresh() {
    return _methodChannel.invokeMethod('refresh');
  }

  Future<void> storyShow() {
    return _methodChannel.invokeMethod('show');
  }

  Future<void> storyDismiss() {
    return _methodChannel.invokeMethod('dismiss');
  }

  Future<void> openStory(int storyGroupId, int storyId) {
    return _methodChannel.invokeMethod('openStory',
        <String, dynamic>{'storyGroupId': storyGroupId, 'storyId': storyId});
  }

  Future<void> openStoryUri(String uri) {
    return _methodChannel
        .invokeMethod('openStoryUri', <String, dynamic>{'uri': uri});
  }

  Future<void> setExternalData(List<Map> externalData) {
    return _methodChannel.invokeMethod(
        'setExternalData', <String, dynamic>{'externalData': externalData});
  }
}

class StorylyParam {
  @required
  String storylyId;
  List<String> storylySegments;
  String storylyCustomParameters;

  String storyGroupSize;
  int storyGroupIconWidth;
  int storyGroupIconHeight;
  int storyGroupIconCornerRadius;
  int storyGroupListEdgePadding;
  int storyGroupListPaddingBetweenItems;
  bool storyGroupTextIsVisible;
  bool storyHeaderTextIsVisible;
  bool storyHeaderIconIsVisible;
  bool storyHeaderCloseButtonIsVisible;

  List<Color> storyGroupIconBorderColorSeen;
  List<Color> storyGroupIconBorderColorNotSeen;
  Color storyGroupIconBackgroundColor;
  Color storyGroupTextColor;
  Color storyGroupPinIconColor;
  List<Color> storyItemIconBorderColor;
  Color storyItemTextColor;
  List<Color> storyItemProgressBarColor;

  dynamic toMap() {
    Map<String, dynamic> paramsMap = <String, dynamic>{
      "storylyId": this.storylyId,
      "storylySegments": this.storylySegments,
      "storylyCustomParameters": this.storylyCustomParameters
    };
    paramsMap['storyGroupIconStyling'] = {
      'width': this.storyGroupIconWidth,
      'height': this.storyGroupIconHeight,
      'cornerRadius': this.storyGroupIconCornerRadius
    };
    paramsMap['storyGroupListStyling'] = {
      'edgePadding': this.storyGroupListEdgePadding,
      'paddingBetweenItems': this.storyGroupListPaddingBetweenItems
    };
    paramsMap['storyGroupTextStyling'] = {
      'isVisible': this.storyGroupTextIsVisible
    };
    paramsMap['storyHeaderStyling'] = {
      'isTextVisible': this.storyHeaderTextIsVisible,
      'isIconVisible': this.storyHeaderIconIsVisible,
      'isCloseButtonVisible': this.storyHeaderCloseButtonIsVisible
    };
    paramsMap['storyGroupSize'] =
        this.storyGroupSize != null ? this.storyGroupSize : "large";
    paramsMap['storyGroupIconBorderColorSeen'] =
        this.storyGroupIconBorderColorSeen != null
            ? this
                .storyGroupIconBorderColorSeen
                .map((color) => toHexString(color))
                .toList()
            : null;
    paramsMap['storyGroupIconBorderColorNotSeen'] =
        this.storyGroupIconBorderColorNotSeen != null
            ? this
                .storyGroupIconBorderColorNotSeen
                .map((color) => toHexString(color))
                .toList()
            : null;
    paramsMap['storyGroupIconBackgroundColor'] =
        this.storyGroupIconBackgroundColor != null
            ? toHexString(storyGroupIconBackgroundColor)
            : null;
    paramsMap['storyGroupTextColor'] = this.storyGroupTextColor != null
        ? toHexString(storyGroupTextColor)
        : null;
    paramsMap['storyGroupPinIconColor'] = this.storyGroupPinIconColor != null
        ? toHexString(storyGroupPinIconColor)
        : null;
    paramsMap['storyItemIconBorderColor'] =
        this.storyItemIconBorderColor != null
            ? this
                .storyItemIconBorderColor
                .map((color) => toHexString(color))
                .toList()
            : null;
    paramsMap['storyItemTextColor'] = this.storyItemTextColor != null
        ? toHexString(storyItemTextColor)
        : null;
    paramsMap['storyItemProgressBarColor'] =
        this.storyItemProgressBarColor != null
            ? this
                .storyItemProgressBarColor
                .map((color) => toHexString(color))
                .toList()
            : null;
    return paramsMap;
  }

  String toHexString(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0')}';
}
