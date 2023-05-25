import 'dart:math';

import 'package:flutter/material.dart';
import 'package:storyly_demo/constants.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

class ScrollExample extends StatefulWidget {
  const ScrollExample({Key? key}) : super(key: key);

  @override
  _ScrollExampleState createState() => _ScrollExampleState();
}

class _ScrollExampleState extends State<ScrollExample> {
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
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: StorylyView(
        onStorylyViewCreated: onStorylyViewCreated,
        androidParam: StorylyParam()
          ..storylyId = Constants.storylyId,
        iosParam: StorylyParam()
          ..storylyId = Constants.storylyId,
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
