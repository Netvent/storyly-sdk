import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'storyly_flutter.dart';
import 'vertical_feed_data.dart';



/// Vertical Feed Bar UI Widget
class VerticalFeedBar extends StatefulWidget {
  /// This callback function allows you to access `VerticalFeedController`
  ///
  /// ```dart
  /// VerticalFeedBar(
  ///   onVerticalFeedCreated: onVerticalFeedCreated,
  /// )
  ///
  /// void onVerticalFeedCreated(VerticalFeedController verticalFeedController) {
  ///   this.verticalFeedController = verticalFeedController;
  /// }
  /// ```
  final VerticalFeedCreatedCallback? onVerticalFeedCreated;

  /// Android specific [VerticalFeedParam]
  final VerticalFeedParam? androidParam;

  /// iOS specific [VerticalFeedParam]
  final VerticalFeedParam? iosParam;

  /// This callback function will let you know that Storyly has completed
  /// its network operations and story group list has just shown to the user.
  final VerticalFeedLoadedCallback? verticalFeedLoaded;

  /// This callback function will let you know that Storyly has completed
  /// its network operations and had a problem while fetching your stories.
  final VerticalFeedLoadFailedCallback? verticalFeedLoadFailed;

  /// This callback function will let you know that stories are started to be
  /// presented to the users.
  final VoidCallback? verticalFeedShown;

  /// This callback function will let you know that vertical feed present failed
  final VerticalFeedPresentFailed? verticalFeedShowFailed;

  /// This callback function will let you know that user dismissed the current
  /// story while watching it.
  final VoidCallback? verticalFeedStoryDismissed;

  /// This callback function will notify your application in case of Swipe Up
  /// or CTA Button action.
  final VerticalFeedActionClickedCallback? verticalFeedActionClicked;

  /// This callback function will allow you to get reactions of users from
  /// specific interactive components.
  final VerticalFeedUserInteractedCallback? verticalFeedUserInteracted;

  /// This callback function will notify you about all Storyly events and let
  /// you to send these events to specific data platforms
  final VerticalFeedEventCallback? verticalFeedEvent;

  /// This callback function will notify your application in case product hydration
  final VerticalFeedOnProductHydrationCallback? verticalFeedOnProductHydration;

  /// This callback function will notify your application in case product event occurs
  final VerticalFeedProductEventCallback? verticalFeedProductEvent;

  /// This callback function will notify you about updates the cart in a VerticalFeedBar component
  final VerticalFeedOnProductCartUpdatedCallback? verticalFeedOnProductCartUpdated;

  const VerticalFeedBar(
      {Key? key,
      this.onVerticalFeedCreated,
      this.androidParam,
      this.iosParam,
      this.verticalFeedLoaded,
      this.verticalFeedLoadFailed,
      this.verticalFeedActionClicked,
      this.verticalFeedShown,
      this.verticalFeedShowFailed,
      this.verticalFeedStoryDismissed,
      this.verticalFeedEvent,
      this.verticalFeedOnProductHydration,
      this.verticalFeedProductEvent,
      this.verticalFeedOnProductCartUpdated,
      this.verticalFeedUserInteracted,
    }) : super(key: key);

  @override
  State<VerticalFeedBar> createState() => _VerticalFeedBarState();
}

class _VerticalFeedBarState extends State<VerticalFeedBar> {
  @override
  Widget build(BuildContext context) {
    const viewType = 'FlutterVerticalFeedBar';

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
            creationParams: widget.androidParam?.toMap() ?? {},
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
        creationParams: widget.iosParam?.toMap() ?? {},
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
      '$defaultTargetPlatform is not supported yet for Storyly Flutter plugin.',
    );
  }

  void _onPlatformViewCreated(int _id) {
    final methodChannel = MethodChannel(
      'com.appsamurai.storyly/flutter_vertical_feed_bar_$_id',
    );
    methodChannel.setMethodCallHandler(_handleMethod);

    widget.onVerticalFeedCreated
        ?.call(VerticalFeedController(_id, methodChannel));
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'verticalFeedLoaded':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.verticalFeedLoaded?.call(
          verticalFeedGroupFromJson(jsonData['feedGroupList']),
          jsonData['dataSource'],
        );
        break;
      case 'verticalFeedLoadFailed':
        widget.verticalFeedLoadFailed?.call(call.arguments);
        break;
      case 'verticalFeedShown':
        widget.verticalFeedShown?.call();
        break;
      case 'verticalFeedShowFailed':
        widget.verticalFeedShowFailed?.call(call.arguments);
        break;
      case 'verticalFeedStoryDismissed':
        widget.verticalFeedStoryDismissed?.call();
        break;
      case 'verticalFeedActionClicked':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.verticalFeedActionClicked?.call(
          VerticalFeedItem.fromJson(jsonData),
        );
        break;
      case 'verticalFeedUserInteracted':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.verticalFeedUserInteracted?.call(
          VerticalFeedGroup.fromJson(jsonData['feedGroup']),
          VerticalFeedItem.fromJson(jsonData['feedItem']),
          getVerticalFeedItemComponent(jsonData['feedItemComponent']),
        );
        break;
      case 'verticalFeedEvent':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.verticalFeedEvent?.call(
          jsonData['event'],
          VerticalFeedGroup.fromJson(jsonData['feedGroup']),
          VerticalFeedItem.fromJson(jsonData['feedItem']),
          getVerticalFeedItemComponent(jsonData['feedItemComponent']),
        );
        break;
      case 'verticalFeedOnProductHydration':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.verticalFeedOnProductHydration?.call(
          productInformationFromJson(jsonData['products']),
        );
        break;
      case 'verticalFeedProductEvent':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        widget.verticalFeedProductEvent?.call(jsonData['event']);
        break;
      case 'verticalFeedOnProductCartUpdated':
        final jsonData = jsonDecode(jsonEncode(call.arguments));
        var cart = null;
        if (jsonData['cart'] != null) {
          cart = STRCart.fromJson(jsonData['cart']);
        }

        var change = null;
        if (jsonData['change'] != null) {
          change = STRCartItem.fromJson(jsonData['change']);
        }

        widget.verticalFeedOnProductCartUpdated
            ?.call(jsonData['event'], cart, change, jsonData['responseId']);
        break;
    }
  }
}

