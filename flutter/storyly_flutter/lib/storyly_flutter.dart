import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void StorylyViewCreatedCallback(StorylyViewController controller);

class StorylyView extends StatefulWidget {
  final StorylyViewCreatedCallback onStorylyViewCreated;

  final StorylyParam androidParam;
  final StorylyParam iosParam;

  final Function(List) storylyLoaded;
  final Function(String) storylyLoadFailed;
  final Function(Map) storylyActionClicked;
  final Function() storylyStoryShown;
  final Function() storylyStoryDismissed;

  const StorylyView(
      {Key key,
      this.onStorylyViewCreated,
      this.androidParam,
      this.iosParam,
      this.storylyLoaded,
      this.storylyLoadFailed,
      this.storylyActionClicked,
      this.storylyStoryShown,
      this.storylyStoryDismissed})
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
          creationParams: widget.androidParam.toMap(),
          creationParamsCodec: const StandardMessageCodec());
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
          viewType: 'FlutterStorylyView',
          onPlatformViewCreated: _onPlatformViewCreated,
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
}

class StorylyParam {
  @required String storylyId;

  List<Color> storyGroupIconBorderColorSeen;
  List<Color> storyGroupIconBorderColorNotSeen;
  Color storyGroupIconBackgroundColor;
  Color storyGroupTextColor;
  Color storyGroupPinIconColor;
  List<Color> storyItemIconBorderColor;
  Color storyItemTextColor;
  List<Color> storyItemProgressBarColor;

  dynamic toMap() {
    Map<String, dynamic> paramsMap = <String, dynamic>{ "storylyId": this.storylyId };
    paramsMap['storyGroupIconBorderColorSeen'] = this.storyGroupIconBorderColorSeen != null ? this.storyGroupIconBorderColorSeen.map((color) => '#${color.value.toRadixString(16)}').toList() : null;
    paramsMap['storyGroupIconBorderColorNotSeen'] = this.storyGroupIconBorderColorNotSeen != null ? this.storyGroupIconBorderColorNotSeen.map((color) => '#${color.value.toRadixString(16)}').toList() : null;
    paramsMap['storyGroupIconBackgroundColor'] = this.storyGroupIconBackgroundColor != null ? '#${this.storyGroupIconBackgroundColor.value.toRadixString(16)}' : null;
    paramsMap['storyGroupTextColor'] = this.storyGroupTextColor != null ? '#${this.storyGroupTextColor.value.toRadixString(16)}' : null;
    paramsMap['storyGroupPinIconColor'] = this.storyGroupPinIconColor != null ? '#${this.storyGroupPinIconColor.value.toRadixString(16)}' : null;
    paramsMap['storyItemIconBorderColor'] = this.storyItemIconBorderColor != null ? this.storyItemIconBorderColor.map((color) => '#${color.value.toRadixString(16)}').toList() : null;
    paramsMap['storyItemTextColor'] = this.storyItemTextColor != null ? '#${this.storyItemTextColor.value.toRadixString(16)}' : null;
    paramsMap['storyItemProgressBarColor'] = this.storyItemProgressBarColor != null ? this.storyItemProgressBarColor.map((color) => '#${color.value.toRadixString(16)}').toList() : null;
    return paramsMap;
  }
}
