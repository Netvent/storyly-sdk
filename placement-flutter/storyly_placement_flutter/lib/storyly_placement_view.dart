import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'storyly_placement_provider.dart';

typedef StorylyPlacementCreatedCallback = void Function(StorylyPlacementController controller);

class StorylyPlacementView extends StatefulWidget {
  final StorylyPlacementProvider? provider;
  
  final StorylyPlacementCreatedCallback? onStorylyPlacementCreated;
  final void Function(PlacementWidgetReadyEvent)? onWidgetReady;
  final void Function(PlacementActionClickEvent)? onActionClicked;
  final void Function(PlacementEvent)? onEvent;
  final void Function(PlacementFailEvent)? onFail;
  final void Function(PlacementProductEvent)? onProductEvent;
  final void Function(PlacementCartUpdateEvent)? onUpdateCart;
  final void Function(PlacementWishlistUpdateEvent)? onUpdateWishlist;

  const StorylyPlacementView({
    super.key,
    required this.provider,
    this.onStorylyPlacementCreated,
    this.onWidgetReady,
    this.onActionClicked,
    this.onEvent,
    this.onFail,
    this.onProductEvent,
    this.onUpdateCart,
    this.onUpdateWishlist,
  }) : super();

  @override
  State<StorylyPlacementView> createState() => _StorylyPlacementViewState();
}

class _StorylyPlacementViewState extends State<StorylyPlacementView> {
  late StorylyPlacementController _controller;

  @override
  void initState() {
    super.initState();
    debugPrint('StorylyPlacementView: initState provider: ${widget.provider?.providerId}');
    _controller = StorylyPlacementController();
  }

  @override
  void didUpdateWidget(StorylyPlacementView oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('StorylyPlacementView: didUpdateWidget, provider: ${widget.provider?.providerId}');
    if (widget.provider == null) return;
    if (widget.provider?.providerId != oldWidget.provider?.providerId) {
      debugPrint('StorylyPlacementView: configure: ${widget.provider?.providerId}');
      _controller.configure(widget.provider!.providerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('StorylyPlacementView: build,provider: ${widget.provider?.providerId}');
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformViewLink(
        viewType: 'storyly_placement_flutter_view',
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: 'storyly_placement_flutter_view',
            layoutDirection: TextDirection.ltr,
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
        viewType: 'storyly_placement_flutter_view',
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }

    return Text(
        '$defaultTargetPlatform is not yet supported by the storyly_placement_flutter plugin');
  }

  void _onPlatformViewCreated(int id) {
    _controller.init(id);

    if (widget.provider != null) {
      _controller.configure(widget.provider!.providerId);
    }
    
    if (widget.onStorylyPlacementCreated != null) {
      widget.onStorylyPlacementCreated!(_controller);
    }
    
    // Register method call handler
    MethodChannel('storyly_placement_flutter/view_$id').setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      final args = call.arguments;
      final data = args is String ? jsonDecode(args) : args;
      
      switch (call.method) {
        case 'onWidgetReady':
          debugPrint('StorylyPlacementView: onWidgetReady, data: $data');
          widget.onWidgetReady?.call(PlacementWidgetReadyEvent.fromJson(data));
          break;
        case 'onActionClicked':
          debugPrint('StorylyPlacementView: onActionClicked, data: $data');
          widget.onActionClicked?.call(PlacementActionClickEvent.fromJson(data));
          break;
        case 'onEvent':
          debugPrint('StorylyPlacementView: onEvent, data: $data');
          widget.onEvent?.call(PlacementEvent.fromJson(data));
          break;
        case 'onFail':
          debugPrint('StorylyPlacementView: onFail, data: $data');
          widget.onFail?.call(PlacementFailEvent.fromJson(data));
          break;
        case 'onProductEvent':
          debugPrint('StorylyPlacementView: onProductEvent, data: $data');
          widget.onProductEvent?.call(PlacementProductEvent.fromJson(data));
          break;
        case 'onUpdateCart':
          debugPrint('StorylyPlacementView: onUpdateCart, data: $data');
          widget.onUpdateCart?.call(PlacementCartUpdateEvent.fromJson(data));
          break;
        case 'onUpdateWishlist':
          debugPrint('StorylyPlacementView: onUpdateWishlist, data: $data');
          widget.onUpdateWishlist?.call(PlacementWishlistUpdateEvent.fromJson(data));
          break;
        default:
          debugPrint("Unknown method: ${call.method}");
      }
    } catch (e) {
      debugPrint("Error handling method call ${call.method}: $e");
    }
  }
}

