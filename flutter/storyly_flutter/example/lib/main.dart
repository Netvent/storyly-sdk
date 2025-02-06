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
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
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
              ..storyGroupIconHeight = (80 * devicePixelRatio).round()
              ..storyGroupIconWidth = (80 * devicePixelRatio).round()
              ..storylyLayoutDirection = "rtl"
              ..storyGroupIconCornerRadius = (20 * devicePixelRatio).round()
              ..storyGroupListHorizontalEdgePadding =
                  (20 * devicePixelRatio).round()
              ..storyGroupListHorizontalPaddingBetweenItems =
                  (10 * devicePixelRatio).round()
              ..storyGroupTextTypeface = "Lobster1.4.otf"
              ..storyGroupTextSize = (20 * devicePixelRatio).round()
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
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 220,
              color: Colors.cyan,
              child: VerticalFeedBar(
                onVerticalFeedCreated: onVerticalFeedBarCreated,
                androidParam: VerticalFeedParam()
                  ..storylyId = STORYLY_TOKEN
                  ..verticalFeedGroupListSections = 1
                  ..verticalFeedGroupIconHeight = (devicePixelRatio * 200).toInt(),
                iosParam: VerticalFeedParam()..storylyId = STORYLY_TOKEN,
                verticalFeedLoaded: (feedGroupList, dataSource) {
                  debugPrint("VerticalFeedBar: verticalFeedLoaded -> storyGroups: ${feedGroupList.length} - $dataSource");
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            Container(
              height: 200,
              color: Colors.cyan,
              child: VerticalFeed(
                onVerticalFeedCreated: onVerticalFeedCreated,
                androidParam: VerticalFeedParam()
                  ..storylyId = STORYLY_TOKEN
                  ..verticalFeedGroupListSections = 3,
                iosParam: VerticalFeedParam()
                  ..storylyId = STORYLY_TOKEN
                  ..verticalFeedGroupListSections = 2,
                verticalFeedLoaded: (feedGroupList, dataSource) {
                  debugPrint("VerticalFeed: verticalFeedLoaded -> storyGroups: ${feedGroupList.length} - $dataSource");
                },
              ),
            ),
            // Add a button to open VerticalFeedPresenterPage
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerticalFeedPresenterPage(isPlaying: true),
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

  void onVerticalFeedPresenterCreated(VerticalFeedPresenterController verticalFeedPresenterController) {
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
          androidParam: VerticalFeedParam()..storylyId = STORYLY_TOKEN,
          iosParam: VerticalFeedParam()..storylyId = STORYLY_TOKEN,
          verticalFeedLoaded: (feedGroupList, dataSource) {
            debugPrint("VerticalFeedPresenter: verticalFeedLoaded -> storyGroups: ${feedGroupList.length}");
          },
        ),
      ),
    );
  }
}