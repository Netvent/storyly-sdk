import 'package:flutter/material.dart';
import 'package:storyly_demo/constants.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

class BasePage extends StatefulWidget {
  final String title;

  const BasePage({Key? key, required this.title}) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late StorylyViewController storylyViewController;

  void onStorylyViewCreated(StorylyViewController storylyViewController) {
    this.storylyViewController = storylyViewController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 120,
              child: StorylyView(
                  onStorylyViewCreated: onStorylyViewCreated,
                  androidParam: StorylyParam()..storylyId = Constants.storylyId,
                  iosParam: StorylyParam()..storylyId = Constants.storylyId,
                  storylyLoaded: (storyGroups, dataSource) {
                    debugPrint(
                        "storylyLoaded -> storyGroups: ${storyGroups.length}");
                    debugPrint("storylyLoaded -> dataSource: $dataSource");
                  },
                  storylyLoadFailed: (errorMessage) =>
                      debugPrint("storylyLoadFailed"),
                  storylyActionClicked: (story) {
                    debugPrint("storylyActionClicked -> ${story.title}");
                  },
                  storylyEvent: (event, storyGroup, story, storyComponent) {
                    debugPrint("storylyEvent -> event: $event");
                    debugPrint(
                        "storylyEvent -> storyGroup: ${storyGroup?.title}");
                    debugPrint("storylyEvent -> story: ${story?.title}");
                    debugPrint(
                        "storylyEvent -> storyComponent: $storyComponent");
                  },
                  storylyStoryShown: () => debugPrint("storylyStoryShown"),
                  storylyStoryDismissed: () =>
                      debugPrint("storylyStoryDismissed"),
                  storylyUserInteracted: (storyGroup, story, storyComponent) {
                    debugPrint(
                        "userInteracted -> storyGroup: ${storyGroup.title}");
                    debugPrint("userInteracted -> story: ${story.title}");
                    debugPrint(
                        "userInteracted -> storyComponent: $storyComponent");
                  }),
            )
          ],
        ),
      ),
    );
  }
}
