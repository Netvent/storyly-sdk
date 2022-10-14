import 'package:flutter/material.dart';
import 'package:storyly_flutter/storyly_flutter.dart';
import 'package:storyly_monetization_flutter/storyly_monetization_flutter.dart';

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
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjU1NiwiYXBwX2lkIjoxMzg5LCJpbnNfaWQiOjE0Mjd9.cGTn_uElzFerKU-ul3EnrTn7pMZlhA3HvG4EEoygDcQ";

  late StorylyViewController storylyViewController;

  void onStorylyViewCreated(StorylyViewController storylyViewController) {
    this.storylyViewController = storylyViewController;
    debugPrint("aaa ${this.storylyViewController.getViewId()}");
    StorylyMonetization.setAdViewProvider(storylyViewController.getViewId(), AdViewProvider(adMobAdUnitId: "ca-app-pub-3940256099942544/2247696110", adMobAdExtras: {"npa": "1", "aa": {"test": "a"}}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Plugin example app'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Expanded(
          child: StorylyView(
            onStorylyViewCreated: onStorylyViewCreated,
            androidParam: StorylyParam()
              ..storylyId = storylyToken,
            iosParam: StorylyParam()
              ..storylyId = storylyToken,
            storylyLoaded: (storyGroups, dataSource) {
              debugPrint("storylyLoaded -> storyGroups: ${storyGroups.length}");
              debugPrint("storylyLoaded -> dataSource: $dataSource");
            },
            storylyLoadFailed: (errorMessage) =>
                debugPrint("storylyLoadFailed -> $errorMessage"),
            storylyActionClicked: (story) {
              debugPrint("storylyActionClicked -> ${story.title}");
            },
            storylyEvent: (event, storyGroup, story, storyComponent) {
              debugPrint("storylyEvent -> event: $event");
              debugPrint("storylyEvent -> storyGroup: ${storyGroup?.title}");
              debugPrint("storylyEvent -> story: ${story?.title}");
              debugPrint("storylyEvent -> storyComponent: $storyComponent");
            },
            storylyStoryShown: () => debugPrint("storylyStoryShown"),
            storylyStoryDismissed: () => debugPrint("storylyStoryDismissed"),
            storylyUserInteracted: (storyGroup, story, storyComponent) {
              debugPrint("userInteracted -> storyGroup: ${storyGroup.title}");
              debugPrint("userInteracted -> story: ${story.title}");
              debugPrint("userInteracted -> storyComponent: $storyComponent");
            },
          ),
        ),
        Expanded(
          child: StorylyView(
            onStorylyViewCreated: onStorylyViewCreated,
            androidParam: StorylyParam()
              ..storylyId = storylyToken,
            iosParam: StorylyParam()
              ..storylyId = storylyToken,
            storylyLoaded: (storyGroups, dataSource) {
              debugPrint("storylyLoaded -> storyGroups: ${storyGroups.length}");
              debugPrint("storylyLoaded -> dataSource: $dataSource");
            },
            storylyLoadFailed: (errorMessage) =>
                debugPrint("storylyLoadFailed -> $errorMessage"),
            storylyActionClicked: (story) {
              debugPrint("storylyActionClicked -> ${story.title}");
            },
            storylyEvent: (event, storyGroup, story, storyComponent) {
              debugPrint("storylyEvent -> event: $event");
              debugPrint("storylyEvent -> storyGroup: ${storyGroup?.title}");
              debugPrint("storylyEvent -> story: ${story?.title}");
              debugPrint("storylyEvent -> storyComponent: $storyComponent");
            },
            storylyStoryShown: () => debugPrint("storylyStoryShown"),
            storylyStoryDismissed: () => debugPrint("storylyStoryDismissed"),
            storylyUserInteracted: (storyGroup, story, storyComponent) {
              debugPrint("userInteracted -> storyGroup: ${storyGroup.title}");
              debugPrint("userInteracted -> story: ${story.title}");
              debugPrint("userInteracted -> storyComponent: $storyComponent");
            },
          ),
        ),
        ],)
      ),
    );
  }
}
