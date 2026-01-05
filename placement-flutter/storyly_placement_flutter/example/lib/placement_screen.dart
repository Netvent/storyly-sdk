import 'package:flutter/material.dart';
import 'package:storyly_placement_flutter/storyly_placement_provider.dart';

class PlacementScreen extends StatefulWidget {
  final String name;
  final String token;

  const PlacementScreen({super.key, required this.name, required this.token}) : super();

  @override
  State<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends State<PlacementScreen> {
  StorylyPlacementProvider? _provider;
  StorylyPlacementController? _controller;

  // We need to give a non-zero height for the platform view to be created.
  // 1.0 is a minimal height to ensure the view is attached and can trigger events.
  double _placementHeight = 0.1;

  PlacementWidget? _pauseWidget;
  STRCart _cart = STRCart(items: [], totalPrice: 0, currency: 'USD');

  @override
  void initState() {
    super.initState();
    StorylyPlacementProvider.create(
     config: StorylyPlacementConfig(
          token: widget.token,
          testMode: true,
          productConfig: StorylyProductConfig(
            isFallbackEnabled: true,
            isCartEnabled: true,
          ),
          shareConfig: StorylyShareConfig(
            shareUrl: 'https://www.google.com',
            facebookAppId: '1234567890',
          ),
        ),
        listener:StorylyPlacementListener(
          onLoad: (event) {
            debugPrint('[${widget.name}] onLoad $event');
          },
          onLoadFail: (event) {
            debugPrint('[${widget.name}] onLoadFail $event');
          },
          onHydration: (event) {
            debugPrint('[${widget.name}] onHydration $event');

            // final products = event.products.map((product) {
            //   return STRProductItem(
            //     productId: product.productId ?? '',
            //     productGroupId: product.productGroupId,
            //     title: 'TITLE',
            //     desc: 'DESCRIPTION',
            //     price: 80,
            //     salesPrice: 99,
            //     lowestPrice: 0,
            //     currency: 'USD',
            //     url: '',
            //     imageUrls: ['https://via.placeholder.com/150'],
            //     variants: [
            //       STRProductVariant(
            //         name: 'COLOR',
            //         value: 'RED',
            //         key: 'color_red',
            //       ),
            //     ],
            //     ctaText: '',
            //   );
            // }).toList();

            // _provider?.hydrateProducts(products);
          },
        )
    ).then((provider) => {
      setState(() { _provider = provider; })
    });
    
  }

  @override
  void dispose() {
    _provider?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        SizedBox(
          height: _placementHeight,
          width: double.infinity,
          child: StorylyPlacementView(
            provider: _provider,
            onStorylyPlacementCreated: (controller) {
              _controller = controller;
            },
            onWidgetReady: (event) {
              setState(() {
                _placementHeight = MediaQuery.of(context).size.width / event.ratio;
              });
              debugPrint('[${widget.name}] onWidgetReady $event calculated height: $_placementHeight');

              // if (event.widget.type == 'story-bar') {
              //   _controller?.getWidget<StoryBarController>(event.widget).openWithId(storyGroupId: "127248", storyId: "1571802", playMode: "story");
              // } else if (event.widget.type == 'video-feed') {
              //   _controller?.getWidget<VideoFeedController>(event.widget).openWithId(groupId: "202061", playMode: "default");
              //   // _controller?.getWidget<VideoFeedController>(event.widget).open(uri: 'https://www.google.com');
              // }
            },
            onActionClicked: (event) {
              if (event.widget.type == 'story-bar') {
                _controller?.getWidget<StoryBarController>(event.widget).pause();
                _pauseWidget = event.widget;
              } else if (event.widget.type == 'video-feed') {
                 _controller?.getWidget<VideoFeedController>(event.widget).pause();
                _pauseWidget = event.widget;
              }
              debugPrint('[${widget.name}] onActionClicked $event');
            },
            onEvent: (event) {
              debugPrint('[${widget.name}] onEvent $event');
            },
            onFail: (event) {
              debugPrint('[${widget.name}] onFail $event');
            },
            onProductEvent: (event) {
              debugPrint('[${widget.name}] onProductEvent $event');
            },
            onUpdateCart: (event) {
              debugPrint('[${widget.name}] onUpdateCart $event');
              if (event.change != null) {
                final updatedCart = _updateCart(_cart, event.change!, event.event);
                setState(() {
                  _cart = updatedCart;
                });
                _controller?.approveCartChange(event.responseId, updatedCart);
              }
            },
            onUpdateWishlist: (event) {
              debugPrint('[${widget.name}] onUpdateWishlist $event');
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_pauseWidget != null) {
              if (_pauseWidget!.type == 'story-bar') {
                 _controller?.getWidget<StoryBarController>(_pauseWidget!).resume();
              } else if (_pauseWidget!.type == 'video-feed') {
                 _controller?.getWidget<VideoFeedController>(_pauseWidget!).resume();
              }
              _pauseWidget = null;
            }
          },
          child: const Text('Resume Paused Widget'),
        ),
      ],
    );
  }
}


STRCart _updateCart(STRCart cart, STRCartItem change, String eventName) {
    final productId = change.item.productId;
    debugPrint('updateCart: event=$eventName, productId=$productId, quantity=${change.quantity}');

    final currentItems = List<STRCartItem>.from(cart.items);
    final existingItemIndex = currentItems.indexWhere((item) => item.item.productId == productId);

    void handleProductAdded() {
      if (existingItemIndex != -1) {
        currentItems[existingItemIndex] = change;
        debugPrint('Updated existing item: ${change.item.productId}');
      } else {
        currentItems.add(change);
        debugPrint('Added new item: ${change.item.productId}');
      }
    }

    void handleProductUpdated() {
      if (existingItemIndex != -1) {
        currentItems[existingItemIndex] = change;
        debugPrint('Updated item: ${change.item.productId}');
      } else {
        currentItems.add(change);
        debugPrint('Product not found for update, adding: ${change.item.productId}');
      }
    }

    void handleProductRemoved() {
      if (existingItemIndex != -1) {
        currentItems.removeAt(existingItemIndex);
        debugPrint('Removed item: $productId');
      } else {
        debugPrint('Product not found for removal: $productId');
      }
    }

    void handleUnknownEvent() {
      if (existingItemIndex != -1) {
        if (change.quantity <= 0) {
          currentItems.removeAt(existingItemIndex);
          debugPrint('Removed item (quantity<=0)');
        } else {
          currentItems[existingItemIndex] = change;
          debugPrint('Updated item');
        }
      } else if (change.quantity > 0) {
        currentItems.add(change);
        debugPrint('Added new item');
      }
    }

    switch (eventName) {
      case "StoryProductAdded":
      case "VideoFeedItemProductAdded":
        handleProductAdded();
        break;
      case "StoryProductUpdated":
      case "VideoFeedItemProductUpdated":
        handleProductUpdated();
        break;
      case "StoryProductRemoved":
      case "VideoFeedItemProductRemoved":
        handleProductRemoved();
        break;
      default:
        handleUnknownEvent();
        break;
    }

    final totalPrice = currentItems.fold<double>(0, (sum, item) => sum + (item.totalPrice ?? 0));
    final updatedCart = STRCart(
      items: currentItems,
      totalPrice: totalPrice,
      currency: change.item.currency,
    );
    debugPrint('Cart updated: ${currentItems.length} items, total=$totalPrice');
    return updatedCart;
  }
