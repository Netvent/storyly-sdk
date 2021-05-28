import 'package:flutter/material.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

void main() => runApp(MyApp());

const STORYLY_TOKEN =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StorylyViewController storylyViewController;

  @override
  void initState() {
    super.initState();
  }

  void onStorylyViewCreated(StorylyViewController storylyViewController) {
    this.storylyViewController = storylyViewController;
    // You can call any function after this.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Plugin example app'),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 5.0),
          height: 120,
          child: StorylyView(
            onStorylyViewCreated: onStorylyViewCreated,
            androidParam: StorylyParam()
              ..storylyId = STORYLY_TOKEN
              ..storylyTestMode = true,
            iosParam: StorylyParam()
              ..storylyId = STORYLY_TOKEN
              ..storylyTestMode = true,
            storylyLoaded: (storyGroups) {
              print("storylyLoaded -> ${storyGroups.length}");
            },
            storylyLoadFailed: (errorMessage) => print("storylyLoadFailed"),
            storylyActionClicked: (story) {
              print("storylyActionClicked -> ${story.title}");
            },
            storylyEvent: (event, storyGroup, story, storyComponent) {
              print("storylyEvent -> event: ${event}");
              print("storylyEvent -> storyGroup: ${storyGroup.title}");
              print("storylyEvent -> story: ${story.title}");
              print(
                "storylyEvent storyComponent: ${storyComponent.type}",
              );
            },
            storylyStoryShown: () => print("storylyStoryShown"),
            storylyStoryDismissed: () => print("storylyStoryDismissed"),
            storylyUserInteracted: (storyGroup, story, storyComponent) {
              print("userInteracted -> storyGroup: ${storyGroup.title}");
              print("userInteracted -> story: ${story.title}");
              print(
                "userInteracted -> storyComponent: ${storyComponent.type}",
              );
            },
          ),
        ),
      ),
    );
  }
}
