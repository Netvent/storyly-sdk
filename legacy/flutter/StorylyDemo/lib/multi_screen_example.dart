import 'dart:math';

import 'package:flutter/material.dart';
import 'package:storyly_demo/constants.dart';
import 'package:storyly_flutter/storyly_flutter.dart';



class MultiScreenExample extends StatefulWidget {
  const MultiScreenExample({Key? key}) : super(key: key);

  @override
  _MultiScreenExampleState createState() => _MultiScreenExampleState();
}

class _MultiScreenExampleState extends State<MultiScreenExample> {
  late StorylyViewController storylyViewController;
  int selectedIndex = 0;

  void onStorylyViewCreated(StorylyViewController storylyViewController) {
    this.storylyViewController = storylyViewController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi-Screen Example"),
      ),
      body: (selectedIndex == 0) ? createFirstScreen() : createSecondScreen(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
        currentIndex: selectedIndex,
        onTap: ((value) => setState(() { selectedIndex = value; })),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.grey,
            icon: Icon(Icons.search),
            label: 'Storyly',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'SubScreen',
          ),
        ],
      ),
    );
  }

  Widget createFirstScreen() {
    return ListView(
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
      );
  
  }

  Widget createSecondScreen() {
    return Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: ElevatedButton(
              onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Button Clicked"),
              ));
            }, child: const Text("Click Test"))
          )  
        ],
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