import 'dart:math';

import 'package:flutter/material.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

class ScrollExample extends StatefulWidget {
  const ScrollExample({Key? key}) : super(key: key);

  @override
  _ScrollExampleState createState() => _ScrollExampleState();
}

class _ScrollExampleState extends State<ScrollExample> {
  static const storylyInstanceToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40";

  late StorylyViewController storylyViewController;

  void onStorylyViewCreated(StorylyViewController storylyViewController) {
    this.storylyViewController = storylyViewController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scroll Example"),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Welcome to Storyly",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          storylyArea(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Latest from our blog",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          storylyArea(),
          ...latestPosts(50),
        ],
      ),
    );
  }

  Widget storylyArea() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("width:$width:height:$height");

    var pixelRatio = WidgetsBinding.instance?.window.devicePixelRatio ?? 0;

    //Size in physical pixels
    var physicalScreenSize = WidgetsBinding.instance?.window.physicalSize;
    var physicalWidth = physicalScreenSize?.width ?? 0;
    var physicalHeight = physicalScreenSize?.height ?? 0;

    print("physicalWidth:$physicalWidth:physicalHeight:$physicalHeight");
    return Container(
      height: (physicalHeight * 0.2) / pixelRatio + 20,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: StorylyView(
        onStorylyViewCreated: onStorylyViewCreated,
        androidParam: StorylyParam()
          ..storyGroupSize = "custom"
          ..storyGroupIconWidth = (physicalWidth * 0.3).toInt()
          ..storyGroupIconHeight = (physicalHeight * 0.2).toInt()
          ..storyGroupIconCornerRadius = 38
          ..storylyId = storylyInstanceToken
          ..storyGroupListEdgePadding = 20
          ..storyGroupListPaddingBetweenItems = 20,
        iosParam: StorylyParam()
          ..storylyId = storylyInstanceToken
          ..storyGroupListEdgePadding = 20
          ..storyGroupListPaddingBetweenItems = 20,
      ),
    );
  }

  List<Widget> latestPosts(int postCount) {
    return List<Widget>.generate(
      postCount,
      (_) {
        final randomColor = (Random().nextDouble() * 0xFFFFFF).toInt();
        return Container(
          color: Color(randomColor).withOpacity(1.0),
          height: 150,
        );
      },
    );
  }
}
