import 'package:flutter/material.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

void main() => runApp(const MyApp());

const storylyToken =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40";

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StorylyViewController storylyViewController;

  void onStorylyViewCreated(StorylyViewController storylyViewController) {
    this.storylyViewController = storylyViewController;
    // You can call any function after this.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Plugin example app'),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 5.0),
          height: 120,
          child: StorylyView(
            onStorylyViewCreated: onStorylyViewCreated,
            androidParam: StorylyParam()
              ..storylyId = storylyToken
              ..storylyTestMode = true,
            iosParam: StorylyParam()
              ..storylyId = storylyToken
              ..storylyTestMode = true,
            storylyLoaded: (storyGroups, dataSource) {
              debugPrint("storylyLoaded -> storyGroups: ${storyGroups.length}");
              debugPrint("storylyLoaded -> dataSource: $dataSource");
            },
            storylyLoadFailed: (errorMessage) =>
                debugPrint("storylyLoadFailed"),
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
      ),
    );
  }
}
