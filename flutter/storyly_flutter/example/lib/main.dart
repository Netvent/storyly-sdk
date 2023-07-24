import 'package:flutter/material.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

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
      home: const HomePage(title: 'Storyly Demo Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const storylyToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40";

  late StorylyViewController storylyViewController;

  void onStorylyViewCreated(StorylyViewController storylyViewController) {
    this.storylyViewController = storylyViewController;
  }

  @override
  Widget build(BuildContext context) {
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Plugin example app'),
        ),
        body: ListView(
          children: [
            const Padding(padding: EdgeInsets.all(8.0)),
            Container(
                height: 90,
                color: Colors.cyan,
                child: StorylyView(
                  onStorylyViewCreated: onStorylyViewCreated,
                  androidParam: StorylyParam()
                    ..storylyId = storylyToken
                    ..storyGroupSize = "small"
                    ..storyHeaderShareIcon = "launch_background"
                    ..storyHeaderCloseIcon = "launch_background"
                    ..storyItemTextTypeface = "Lobster1.4.otf"
                    ..storyInteractiveTextTypeface = "Lobster1.4.otf"
                    ..storyItemProgressBarColor = [Colors.red, Colors.yellow]
                    ..storyItemIconBorderColor = [Colors.red, Colors.red],
                  iosParam: StorylyParam()
                    ..storylyId = storylyToken
                    ..storyGroupSize = "small"
                    ..storyHeaderShareIcon = "AppIcon"
                    ..storyHeaderCloseIcon = "AppIcon"
                    ..storyItemTextTypeface = "Lobster1.4.otf"
                    ..storyInteractiveTextTypeface = "Lobster1.4.otf"
                    ..storyItemProgressBarColor = [Colors.red, Colors.yellow]
                    ..storyItemIconBorderColor = [Colors.red, Colors.red],
                  storylyLoaded: (storyGroups, dataSource) {
                    debugPrint(
                        "storylyLoaded -> storyGroups: ${storyGroups.length}");
                  },
                )),
            const Padding(padding: EdgeInsets.all(8.0)),
            Container(
                height: 120,
                color: Colors.lightGreen,
                child: StorylyView(
                  onStorylyViewCreated: onStorylyViewCreated,
                  androidParam: StorylyParam()
                    ..storylyId = storylyToken
                    ..storyGroupSize = "large",
                  iosParam: StorylyParam()
                    ..storylyId = storylyToken
                    ..storyGroupSize = "large",
                  storylyLoaded: (storyGroups, dataSource) {
                    debugPrint(
                        "storylyLoaded -> storyGroups: ${storyGroups.length}");
                  },
                )),
            const Padding(padding: EdgeInsets.all(8.0)),
            Container(
                height: 170,
                color: Colors.orange,
                child: StorylyView(
                  onStorylyViewCreated: onStorylyViewCreated,
                  androidParam: StorylyParam()
                    ..storylyId = storylyToken
                    ..storyGroupSize = "custom"
                    ..storyGroupIconHeight = (80 * devicePixelRatio).round()
                    ..storyGroupIconWidth = (80 * devicePixelRatio).round()
                    ..storyGroupIconCornerRadius =
                        (20 * devicePixelRatio).round()
                    ..storyGroupListHorizontalEdgePadding =
                        (20 * devicePixelRatio).round()
                    ..storyGroupListHorizontalPaddingBetweenItems =
                        (10 * devicePixelRatio).round()
                    ..storyGroupTextTypeface = "Lobster1.4.otf"
                    ..storyGroupTextSize = (20 * devicePixelRatio).round()
                    ..storyGroupTextLines = 3
                    ..storyGroupTextColorSeen = Colors.green
                    ..storyGroupTextColorNotSeen = Colors.red
                    ..storyGroupIconBorderColorNotSeen = [
                      Colors.red,
                      Colors.red
                    ]
                    ..storyGroupIconBorderColorSeen = [
                      Colors.white,
                      Colors.white
                    ]
                    ..storyGroupIconBackgroundColor = Colors.black
                    ..storyGroupPinIconColor = Colors.black,
                  iosParam: StorylyParam()
                    ..storylyId = storylyToken
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
                    ..storyGroupIconBorderColorNotSeen = [
                      Colors.red,
                      Colors.red
                    ]
                    ..storyGroupIconBorderColorSeen = [
                      Colors.white,
                      Colors.white
                    ]
                    ..storyGroupIconBackgroundColor = Colors.black
                    ..storyGroupPinIconColor = Colors.black,
                  storylyLoaded: (storyGroups, dataSource) {
                    debugPrint(
                        "storylyLoaded -> storyGroups: ${storyGroups.length}");
                  },
                )),
          ],
        ),
      ),
    );
  }
}
