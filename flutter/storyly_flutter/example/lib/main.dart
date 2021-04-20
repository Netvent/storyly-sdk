import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

void main() => runApp(MyApp());

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
          title: const Text('Plugin example app'),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 5.0),
          height: 120,
          child: StorylyView(
            onStorylyViewCreated: onStorylyViewCreated,
            androidParam: StorylyParam()
              ..storylyId =
                  "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40",
            iosParam: StorylyParam()
              ..storylyId =
                  "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40",
            storylyLoaded: (storyGroupList) {
              print(storyGroupList[0].stories[0].title);
            },
            storylyLoadFailed: (errorMessage) => print("storylyLoadFailed"),
            storylyActionClicked: (story) {
              print(story.id);
              print(story.title);
              print(story.media.actionUrl);
              print(story.media.url);
            },
            storylyEvent: (event) {
              log("event: $event");
            },
            storylyStoryShown: () => print("storylyStoryShown"),
            storylyStoryDismissed: () => print("storylyStoryDismissed"),
            storylyUserInteracted: (eventPayload) {
              log("eventPayload: $eventPayload");
            },
          ),
        ),
      ),
    );
  }
}
