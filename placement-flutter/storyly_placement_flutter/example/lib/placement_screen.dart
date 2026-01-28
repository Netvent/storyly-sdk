import 'package:flutter/material.dart';
import 'package:storyly_placement_flutter/storyly_placement_provider.dart';

class PlacementScreen extends StatefulWidget {
  final String name;
  final String token;

  const PlacementScreen({super.key, required this.name, required this.token})
    : super();

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
        productConfig: StorylyProductConfig(),
        shareConfig: StorylyShareConfig(
          shareUrl: 'https://www.google.com',
          facebookAppId: '1234567890',
        ),
      ),
      listener: StorylyPlacementListener(
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
      ),
    ).then(
      (provider) => {
        setState(() {
          _provider = provider;
        }),
      },
    );
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
                _placementHeight =
                    MediaQuery.of(context).size.width / event.ratio;
              });
              debugPrint(
                '[${widget.name}] onWidgetReady $event calculated height: $_placementHeight',
              );

              // if (event.widget.type == 'story-bar') {
              //   _controller?.getWidget<StoryBarController>(event.widget).openWithId(storyGroupId: "127248", storyId: "1571802", playMode: "story");
              // } else if (event.widget.type == 'video-feed') {
              //   _controller?.getWidget<VideoFeedController>(event.widget).openWithId(groupId: "202061", playMode: "default");
              //   // _controller?.getWidget<VideoFeedController>(event.widget).open(uri: 'https://www.google.com');
              // }
            },
            onActionClicked: (event) {
              if (event.widget.type == 'story-bar') {
                _controller
                    ?.getWidget<StoryBarController>(event.widget)
                    .pause();
                _pauseWidget = event.widget;
              } else if (event.widget.type == 'video-feed') {
                _controller
                    ?.getWidget<VideoFeedController>(event.widget)
                    .pause();
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
              debugPrint('[${widget.name}] onUpdateCart productId ${event.item?.product.productId}');
              if (event.item != null) {
                _controller?.approveCartChange(event.responseId);
              }
            },
            onUpdateWishlist: (event) {
              debugPrint('[${widget.name}] onUpdateWishlist ${event.event} ${event.item?.productId}');
              _controller?.approveWishlistChange(event.responseId);
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_pauseWidget != null) {
              if (_pauseWidget!.type == 'story-bar') {
                _controller
                    ?.getWidget<StoryBarController>(_pauseWidget!)
                    .resume();
              } else if (_pauseWidget!.type == 'video-feed') {
                _controller
                    ?.getWidget<VideoFeedController>(_pauseWidget!)
                    .resume();
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
