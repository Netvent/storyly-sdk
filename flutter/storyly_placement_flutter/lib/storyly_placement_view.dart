import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'storyly_placement_provider.dart';

typedef StorylyPlacementCreatedCallback =
    void Function(StorylyPlacementController controller);

class STRPlacementView extends StatefulWidget {
  final STRPlacementDataProvider? provider;

  final StorylyPlacementCreatedCallback? onStorylyPlacementCreated;
  final void Function(PlacementWidgetReadyEvent)? onWidgetReady;
  final void Function(PlacementActionClickEvent)? onActionClicked;
  final void Function(PlacementEvent)? onEvent;
  final void Function(PlacementFailEvent)? onFail;
  final void Function(PlacementOnVisibilityChangeEvent)? onVisibilityChange;
  final void Function(PlacementProductEvent)? onProductEvent;
  final void Function(PlacementCartUpdateEvent)? onUpdateCart;
  final void Function(PlacementWishlistUpdateEvent)? onUpdateWishlist;

  const STRPlacementView({
    super.key,
    required this.provider,
    this.onStorylyPlacementCreated,
    this.onWidgetReady,
    this.onActionClicked,
    this.onEvent,
    this.onFail,
    this.onVisibilityChange,
    this.onProductEvent,
    this.onUpdateCart,
    this.onUpdateWishlist,
  }) : super();

  @override
  State<STRPlacementView> createState() => _STRPlacementViewState();
}

class _STRPlacementViewState extends State<STRPlacementView> {
  late StorylyPlacementController _controller;
  String? _scrollAxis; // 'horizontal' | 'vertical' | 'all' | none

  @override
  void initState() {
    super.initState();
    debugPrint(
      'STRPlacementView: initState provider: ${widget.provider?.providerId}',
    );
    _controller = StorylyPlacementController();
  }

  @override
  void didUpdateWidget(STRPlacementView oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint(
      'STRPlacementView: didUpdateWidget, provider: ${widget.provider?.providerId}',
    );
    if (widget.provider == null) return;
    if (widget.provider?.providerId != oldWidget.provider?.providerId) {
      debugPrint(
        'STRPlacementView: configure: ${widget.provider?.providerId}',
      );
      _controller.configure(widget.provider!.providerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'STRPlacementView: build,provider: ${widget.provider?.providerId}',
    );
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'storyly_placement_flutter_view',
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: _buildGestureRecognizers(),
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'storyly_placement_flutter_view',
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: _buildGestureRecognizers(),
      );
    }

    return Text(
      '$defaultTargetPlatform is not yet supported by the storyly_placement_flutter plugin',
    );
  }

  Set<Factory<OneSequenceGestureRecognizer>> _buildGestureRecognizers() {
    final tap = Factory<TapGestureRecognizer>(() => TapGestureRecognizer());
    final h = Factory<HorizontalDragGestureRecognizer>(
      () => HorizontalDragGestureRecognizer(),
    );
    final v = Factory<VerticalDragGestureRecognizer>(
      () => VerticalDragGestureRecognizer(),
    );
    final all = Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer());
    return switch (_scrollAxis) {
      'horizontal' => {tap, h},
      'vertical' => {tap, v},
      'none' => {tap},
      'all' => {all},
      _ => {all},
    };
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
    MethodChannel(
      'storyly_placement_flutter/view_$id',
    ).setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      final args = call.arguments;
      final data = args is String
          ? jsonDecode(args) as Map<String, dynamic>
          : args as Map<String, dynamic>;
      switch (call.method) {
        case 'onWidgetReady':
          debugPrint('STRPlacementView: onWidgetReady, data: $data');
          final event = PlacementWidgetReadyEvent.fromJson(data);
          final axis = event.widget.scrollAxis;
          if (axis != _scrollAxis) {
            setState(() => _scrollAxis = axis);
          }
          widget.onWidgetReady?.call(event);
          break;
        case 'onActionClicked':
          debugPrint('STRPlacementView: onActionClicked, data: $data');
          widget.onActionClicked?.call(
            PlacementActionClickEvent.fromJson(data),
          );
          break;
        case 'onEvent':
          debugPrint('STRPlacementView: onEvent, data: $data');
          widget.onEvent?.call(PlacementEvent.fromJson(data));
          break;
        case 'onFail':
          debugPrint('STRPlacementView: onFail, data: $data');
          widget.onFail?.call(PlacementFailEvent.fromJson(data));
          break;
        case 'onVisibilityChange':
          debugPrint('STRPlacementView: onVisibilityChange, data: $data');
          widget.onVisibilityChange?.call(
            PlacementOnVisibilityChangeEvent.fromJson(data),
          );
          break;
        case 'onProductEvent':
          debugPrint('STRPlacementView: onProductEvent, data: $data');
          widget.onProductEvent?.call(PlacementProductEvent.fromJson(data));
          break;
        case 'onUpdateCart':
          debugPrint('STRPlacementView: onUpdateCart, data: $data');
          widget.onUpdateCart?.call(PlacementCartUpdateEvent.fromJson(data));
          break;
        case 'onUpdateWishlist':
          debugPrint('STRPlacementView: onUpdateWishlist, data: $data');
          widget.onUpdateWishlist?.call(
            PlacementWishlistUpdateEvent.fromJson(data),
          );
          break;
        default:
          debugPrint("Unknown method: ${call.method}");
      }
    } catch (e) {
      debugPrint(
        "Error handling method call ${call.method}: $e: ${call.arguments}",
      );
    }
  }
}
