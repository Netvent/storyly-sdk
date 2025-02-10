import 'dart:io';

import 'package:flutter/material.dart';
import 'package:storyly_flutter/storyly_flutter.dart';
import 'package:storyly_flutter/vertical_feed_data.dart';
import 'package:storyly_flutter/vertical_feed_flutter.dart';
import 'package:storyly_flutter/vertical_feed_bar_flutter.dart';
import 'package:storyly_flutter/vertical_feed_presenter_flutter.dart';

const String STORYLY_TOKEN =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StorylyDemo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const StorylyPage(),
          const VerticalFeedPage(),
          VerticalFeedPresenterPage(isPlaying: _selectedIndex == 2),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Storyly'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Feed'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class StorylyPage extends StatefulWidget {
  const StorylyPage({Key? key}) : super(key: key);

  @override
  _StorylyPageState createState() => _StorylyPageState();
}

class _StorylyPageState extends State<StatefulWidget> {
  late StorylyViewController storylyViewController;

  void onStorylyViewCreated(StorylyViewController storylyViewController) {
    this.storylyViewController = storylyViewController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      const Padding(padding: EdgeInsets.all(8.0)),
      Container(
          height: 120,
          color: Colors.lightGreen,
          child: StorylyView(
            onStorylyViewCreated: onStorylyViewCreated,
            androidParam: StorylyParam()
              ..storylyId = STORYLY_TOKEN
              ..storyGroupSize = "large",
            iosParam: StorylyParam()
              ..storylyId = STORYLY_TOKEN
              ..storyGroupSize = "large",
            storylyLoaded: (storyGroups, dataSource) {
              debugPrint("storylyLoaded -> storyGroups: ${storyGroups.length}");
            },
          )),
      const Padding(padding: EdgeInsets.all(8.0)),
      Container(
          height: 170,
          color: Colors.orange,
          child: StorylyView(
            onStorylyViewCreated: onStorylyViewCreated,
            androidParam: StorylyParam()
              ..storylyId = STORYLY_TOKEN
              ..storyGroupSize = "custom"
              ..storyGroupIconHeight = px (80)
              ..storyGroupIconWidth = px(80)
              ..storylyLayoutDirection = "rtl"
              ..storyGroupIconCornerRadius = px(20)
              ..storyGroupListHorizontalEdgePadding = px(20)
              ..storyGroupListHorizontalPaddingBetweenItems = px(10)
              ..storyGroupTextTypeface = "Lobster1.4.otf"
              ..storyGroupTextSize = px(20)
              ..storyGroupTextLines = 3
              ..storyGroupTextColorSeen = Colors.green
              ..storyGroupTextColorNotSeen = Colors.red
              ..storyGroupIconBorderColorNotSeen = [Colors.red, Colors.red]
              ..storyGroupIconBorderColorSeen = [Colors.white, Colors.white]
              ..storyGroupIconBackgroundColor = Colors.black
              ..storyGroupPinIconColor = Colors.black,
            iosParam: StorylyParam()
              ..storylyId = STORYLY_TOKEN
              ..storyGroupSize = "custom"
              ..storyGroupIconHeight = 80
              ..storyGroupIconWidth = 80
              ..storyGroupIconCornerRadius = 20
              ..storyGroupListHorizontalEdgePadding = 20
              ..storyGroupListHorizontalPaddingBetweenItems = 10
              ..storyGroupTextTypeface = "Lobster1.4.otf"
              ..storyGroupTextSize = 20
              ..storyGroupTextLines = 3
              ..storyGroupTextColorSeen = Colors.green
              ..storyGroupTextColorNotSeen = Colors.red
              ..storyGroupIconBorderColorNotSeen = [Colors.red, Colors.red]
              ..storyGroupIconBorderColorSeen = [Colors.white, Colors.white]
              ..storyGroupIconBackgroundColor = Colors.black
              ..storyGroupPinIconColor = Colors.black,
            storylyLoaded: (storyGroups, dataSource) {
              debugPrint("storylyLoaded -> storyGroups: ${storyGroups.length}");
            },
          )),
    ])));
  }
}

class VerticalFeedPage extends StatefulWidget {
  const VerticalFeedPage({Key? key}) : super(key: key);

  @override
  _VerticalFeedPageState createState() => _VerticalFeedPageState();
}

class _VerticalFeedPageState extends State<VerticalFeedPage> {
  late VerticalFeedController verticalFeedController;
  late VerticalFeedController verticalFeedBarController;

  void onVerticalFeedCreated(VerticalFeedController verticalFeedController) {
    this.verticalFeedController = verticalFeedController;
  }

  void onVerticalFeedBarCreated(VerticalFeedController verticalFeedController) {
    verticalFeedBarController = verticalFeedController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(8.0)),
            Container(
              height: 220,
              color: Colors.cyan,
              child: VerticalFeedBar(
                onVerticalFeedCreated: onVerticalFeedBarCreated,
                androidParam: getFeedBarParam(context),
                iosParam: getFeedBarParam(context),
                verticalFeedLoaded: (feedGroupList, dataSource) {
                  debugPrint(
                      "VerticalFeedBar: verticalFeedLoaded: $dataSource: [${feedGroupList.map((e) => debugVerticalGroup(e))}]");
                },
                verticalFeedLoadFailed: (message) {
                  debugPrint(
                      "VerticalFeedBar: verticalFeedLoadFailed: $message");
                },
                verticalFeedEvent:
                    (event, feedGroup, feedItem, verticalFeedItemComponent) {
                  debugPrint(
                      "VerticalFeedBar: verticalFeedEvent: $event: ${feedGroup?.id}: ${feedItem?.id}: ${verticalFeedItemComponent?.type}");
                },
                verticalFeedActionClicked: (feedItem) {
                  debugPrint(
                      "VerticalFeedBar: verticalFeedActionClicked: ${feedItem.id}: ${feedItem.actionUrl}");
                },
                verticalFeedUserInteracted:
                    (feedGroup, feedItem, verticalFeedItemComponent) {
                  debugPrint(
                      "VerticalFeedBar: verticalFeedUserInteracted: ${debugVerticalGroup(feedGroup)}: ${debugVerticalItem(feedItem)}: ${verticalFeedItemComponent?.type}");
                },
                verticalFeedShown: () {
                  debugPrint("VerticalFeedBar: verticalFeedShown");
                },
                verticalFeedShowFailed: (message) {
                  debugPrint(
                      "VerticalFeedBar: verticalFeedShowFailed: $message");
                },
                verticalFeedDismissed: () {
                  debugPrint(
                      "VerticalFeedBar: verticalFeedDismissed");
                },
                verticalFeedOnProductHydration: (products) {
                  debugPrint(
                      "VerticalFeedBar: verticalFeedOnProductHydration: [${products.map((e) => debugProductItem(e)).join(", ")}]");
                },
                verticalFeedProductEvent: (event) {
                  debugPrint(
                      "VerticalFeedBar: verticalFeedProductEvent: $event");
                },
                verticalFeedOnProductCartUpdated:
                    (event, cart, change, responseId) {
                  debugPrint(
                      "VerticalFeedBar: verticalFeedOnProductCartUpdated: $event");
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            Container(
              height: 400,
              color: Colors.cyan,
              child: VerticalFeed(
                onVerticalFeedCreated: onVerticalFeedCreated,
                androidParam: getFeedParam(context),
                iosParam: getFeedParam(context),
                verticalFeedLoaded: (feedGroupList, dataSource) {
                  debugPrint(
                      "VerticalFeed: verticalFeedLoaded: $dataSource: [${feedGroupList.map((e) => debugVerticalGroup(e))}]");
                },
                verticalFeedLoadFailed: (message) {
                  debugPrint("VerticalFeed: verticalFeedLoadFailed: $message");
                },
                verticalFeedEvent:
                    (event, feedGroup, feedItem, verticalFeedItemComponent) {
                  debugPrint(
                      "VerticalFeed: verticalFeedEvent: $event: ${feedGroup?.id}: ${feedItem?.id}: ${verticalFeedItemComponent?.type}");
                },
                verticalFeedActionClicked: (feedItem) {
                  debugPrint(
                      "VerticalFeed: verticalFeedActionClicked: ${feedItem.id}: ${feedItem.actionUrl}");
                },
                verticalFeedUserInteracted:
                    (feedGroup, feedItem, verticalFeedItemComponent) {
                  debugPrint(
                      "VerticalFeed: verticalFeedUserInteracted: ${debugVerticalGroup(feedGroup)}: ${debugVerticalItem(feedItem)}: ${verticalFeedItemComponent?.type}");
                },
                verticalFeedShown: () {
                  debugPrint("VerticalFeed: verticalFeedShown");
                },
                verticalFeedShowFailed: (message) {
                  debugPrint("VerticalFeed: verticalFeedShowFailed: $message");
                },
                verticalFeedDismissed: () {
                  debugPrint("VerticalFeed: verticalFeedDismissed");
                },
                verticalFeedOnProductHydration: (products) {
                  debugPrint(
                      "VerticalFeed: verticalFeedOnProductHydration: [${products.map((e) => debugProductItem(e)).join(", ")}]");
                },
                verticalFeedProductEvent: (event) {
                  debugPrint("VerticalFeed: verticalFeedProductEvent: $event");
                },
                verticalFeedOnProductCartUpdated:
                    (event, cart, change, responseId) {
                  debugPrint(
                      "VerticalFeed: verticalFeedOnProductCartUpdated: $event");
                },
              ),
            ),
            // Add a button to open VerticalFeedPresenterPage
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const VerticalFeedPresenterPage(isPlaying: true),
                  ),
                );
              },
              child: const Text('Open Full Screen Presenter'),
            ),
          ],
        ),
      ),
    );
  }

  VerticalFeedParam getFeedBarParam(BuildContext context) {
    return VerticalFeedParam()
      ..storylyId = STORYLY_TOKEN
      ..storylyCustomParameters = "your_custom_parameters"
      ..storylyTestMode = true
      ..storylySegments = ["segment1", "segment2"]
      ..storylyUserProperty = {"key1": "value1", "key2": "value2"}
      ..storylyLayoutDirection = "ltr"
      ..storylyLocale = "en-GB"
      ..storylyShareUrl = "https://yourshareurl.com"
      ..storylyFacebookAppID = "your_facebook_app_id"
      ..verticalFeedGroupIconHeight = px(200)
      ..verticalFeedGroupIconCornerRadius = px(4)
      ..verticalFeedGroupListHorizontalEdgePadding = px(20)
      ..verticalFeedGroupListVerticalEdgePadding = px(10)
      ..verticalFeedGroupListHorizontalPaddingBetweenItems = px(10)
      ..verticalFeedGroupListVerticalPaddingBetweenItems = px(5)
      ..verticalFeedGroupIconBackgroundColor = Colors.black
      ..verticalFeedGroupTextIsVisible = true
      ..verticalFeedGroupTextSize = px(20)
      ..verticalFeedGroupTextTypeface = "Lobster1.4.otf"
      ..verticalFeedGroupTextColor = Colors.red
      ..verticalFeedTypeIndicatorIsVisible = true
      ..verticalFeedGroupOrder = "default"
      ..verticalFeedGroupMinLikeCountToShowIcon = 100
      ..verticalFeedGroupMinImpressionCountToShowIcon = 500
      // ..verticalFeedGroupImpressionIcon = "impression_icon.png"
      // ..verticalFeedGroupLikeIcon = "like_icon.png"
      ..verticalFeedItemTitleIsVisible = true
      ..verticalFeedItemCloseButtonIsVisible = true
      // ..verticalFeedItemCloseIcon = "close_icon.png"
      ..verticalFeedItemShareButtonIsVisible = true
      // ..verticalFeedItemShareIcon = "share_icon.png"
      ..verticalFeedItemLikeButtonIsVisible = true
      // ..verticalFeedItemLikeIcon = "like_icon.png"
      ..verticalFeedItemProgressBarIsVisible = true
      ..verticalFeedItemProgressBarColor = [Colors.red, Colors.green]
      ..verticalFeedItemTextTypeface = "Lobster1.4.otf"
      ..verticalFeedInteractiveTextTypeface = "Lobster1.4.otf"
      ..isProductFallbackEnabled = true
      ..isProductCartEnabled = true;
  }

  VerticalFeedParam getFeedParam(BuildContext context) {
    return VerticalFeedParam()
      ..storylyId = STORYLY_TOKEN
      ..storylyCustomParameters = "your_custom_parameters"
      ..storylyTestMode = true
      ..storylySegments = ["segment1", "segment2"]
      ..storylyUserProperty = {"key1": "value1", "key2": "value2"}
      ..storylyLayoutDirection = "ltr"
      ..storylyLocale = "en-GB"
      ..storylyShareUrl = "https://yourshareurl.com"
      ..storylyFacebookAppID = "your_facebook_app_id"
      ..verticalFeedGroupListSections = 3
      ..verticalFeedGroupListHorizontalEdgePadding = px(20)
      ..verticalFeedGroupListVerticalEdgePadding = px(10)
      ..verticalFeedGroupListHorizontalPaddingBetweenItems = px(10)
      ..verticalFeedGroupListVerticalPaddingBetweenItems = px(5)
      ..verticalFeedGroupIconHeight = px(200)
      ..verticalFeedGroupIconCornerRadius = px(5)
      ..verticalFeedGroupIconBackgroundColor = Colors.black
      ..verticalFeedGroupTextIsVisible = true
      ..verticalFeedGroupTextSize = px(20)
      ..verticalFeedGroupTextTypeface = "Lobster1.4.otf"
      ..verticalFeedGroupTextColor = Colors.red
      ..verticalFeedTypeIndicatorIsVisible = true
      ..verticalFeedGroupOrder = "default"
      ..verticalFeedGroupMinLikeCountToShowIcon = 100
      ..verticalFeedGroupMinImpressionCountToShowIcon = 500
      // ..verticalFeedGroupImpressionIcon = "impression_icon.png"
      // ..verticalFeedGroupLikeIcon = "like_icon.png"
      ..verticalFeedItemTitleIsVisible = true
      ..verticalFeedItemCloseButtonIsVisible = true
      // ..verticalFeedItemCloseIcon = "close_icon.png"
      ..verticalFeedItemShareButtonIsVisible = true
      // ..verticalFeedItemShareIcon = "share_icon.png"
      ..verticalFeedItemLikeButtonIsVisible = true
      // ..verticalFeedItemLikeIcon = "like_icon.png"
      ..verticalFeedItemProgressBarIsVisible = true
      ..verticalFeedItemProgressBarColor = [Colors.red, Colors.green]
      ..verticalFeedItemTextTypeface = "Lobster1.4.otf"
      ..verticalFeedInteractiveTextTypeface = "Lobster1.4.otf"
      ..isProductFallbackEnabled = true
      ..isProductCartEnabled = true;
  }
}

class VerticalFeedPresenterPage extends StatefulWidget {
  final bool isPlaying;
  const VerticalFeedPresenterPage({Key? key, required this.isPlaying})
      : super(key: key);

  @override
  _VerticalFeedPresenterPageState createState() =>
      _VerticalFeedPresenterPageState();
}

class _VerticalFeedPresenterPageState extends State<VerticalFeedPresenterPage> {
  late VerticalFeedPresenterController verticalFeedPresenterController;

  void onVerticalFeedPresenterCreated(
      VerticalFeedPresenterController verticalFeedPresenterController) {
    this.verticalFeedPresenterController = verticalFeedPresenterController;
    if (widget.isPlaying) {
      verticalFeedPresenterController.play();
    } else {
      verticalFeedPresenterController.pause();
    }
  }

  @override
  void didUpdateWidget(covariant VerticalFeedPresenterPage oldWidget) {
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        verticalFeedPresenterController.play();
      } else {
        verticalFeedPresenterController.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the AppBar for full-screen mode
      appBar: null,
      body: Container(
        color: Colors.cyan,
        child: VerticalFeedPresenter(
          onVerticalFeedCreated: onVerticalFeedPresenterCreated,
          androidParam: getFeedPresenterParam(context),
          iosParam: getFeedPresenterParam(context),
          verticalFeedLoaded: (feedGroupList, dataSource) {
            debugPrint(
                "VerticalFeedPresenter: verticalFeedLoaded: $dataSource: [${feedGroupList.map((e) => debugVerticalGroup(e))}]");
          },
          verticalFeedLoadFailed: (message) {
            debugPrint(
                "VerticalFeedPresenter: verticalFeedLoadFailed: $message");
          },
          verticalFeedEvent:
              (event, feedGroup, feedItem, verticalFeedItemComponent) {
            debugPrint(
                "VerticalFeedPresenter: verticalFeedEvent: $event: ${feedGroup?.id}: ${feedItem?.id}: ${verticalFeedItemComponent?.type}");
          },
          verticalFeedActionClicked: (feedItem) {
            debugPrint(
                "VerticalFeedPresenter: verticalFeedActionClicked: ${feedItem.id}: ${feedItem.actionUrl}");
          },
          verticalFeedUserInteracted:
              (feedGroup, feedItem, verticalFeedItemComponent) {
            debugPrint(
                "VerticalFeedPresenter: verticalFeedUserInteracted: ${debugVerticalGroup(feedGroup)}: ${debugVerticalItem(feedItem)}: ${verticalFeedItemComponent?.type}");
          },
          verticalFeedShown: () {
            debugPrint("VerticalFeedPresenter: verticalFeedShown");
          },
          verticalFeedShowFailed: (message) {
            debugPrint(
                "VerticalFeedPresenter: verticalFeedShowFailed: $message");
          },
          verticalFeedDismissed: () {
            debugPrint("VerticalFeedPresenter: verticalFeedDismissed");
          },
          verticalFeedOnProductHydration: (products) {
            debugPrint(
                "VerticalFeedPresenter: verticalFeedOnProductHydration: [${products.map((e) => debugProductItem(e)).join(", ")}]");
          },
          verticalFeedProductEvent: (event) {
            debugPrint(
                "VerticalFeedPresenter: verticalFeedProductEvent: $event");
          },
          verticalFeedOnProductCartUpdated: (event, cart, change, responseId) {
            debugPrint(
                "VerticalFeedPresenter: verticalFeedOnProductCartUpdated: $event");
          },
        ),
      ),
    );
  }

  VerticalFeedParam getFeedPresenterParam(BuildContext context) {
    return VerticalFeedParam()
      ..storylyId = STORYLY_TOKEN
      ..storylyCustomParameters = "your_custom_parameters"
      ..storylyTestMode = true
      ..storylySegments = ["segment1", "segment2"]
      ..storylyUserProperty = {"key1": "value1", "key2": "value2"}
      ..storylyLayoutDirection = "ltr"
      ..storylyLocale = "en-GB"
      ..storylyShareUrl = "https://yourshareurl.com"
      ..storylyFacebookAppID = "your_facebook_app_id"
      ..verticalFeedItemTitleIsVisible = true
      ..verticalFeedItemCloseButtonIsVisible = true
      // ..verticalFeedItemCloseIcon = "close_icon.png"
      ..verticalFeedItemShareButtonIsVisible = true
      // ..verticalFeedItemShareIcon = "share_icon.png"
      ..verticalFeedItemLikeButtonIsVisible = true
      // ..verticalFeedItemLikeIcon = "like_icon.png"
      ..verticalFeedItemProgressBarIsVisible = true
      ..verticalFeedItemProgressBarColor = [Colors.red, Colors.green]
      ..verticalFeedItemTextTypeface = "Lobster1.4.otf"
      ..verticalFeedInteractiveTextTypeface = "Lobster1.4.otf"
      ..isProductFallbackEnabled = true
      ..isProductCartEnabled = true;
  }
}

String debugVerticalGroup(VerticalFeedGroup g) {
  return "${g.id}: [${g.feedList.map((s) => debugVerticalItem(s)).join(",")}]";
}

String debugVerticalItem(VerticalFeedItem s) {
  return "${s.id}: [${s.verticalFeedItemComponentList?.map((c) => c?.type).join(", ")}]";
}

String debugProductItem(ProductInformation p) {
  return "${p.productGroupId}-${p.productId}";
}


int px(int x) {
  if (Platform.isAndroid) {
    return (WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio * x).round();
  } else {
    return x;
  }
}