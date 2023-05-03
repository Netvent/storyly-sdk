import 'package:flutter/material.dart';
import 'package:storyly_demo/constants.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

class HideStorylyPage extends StatefulWidget {
  const HideStorylyPage({Key? key}) : super(key: key);

  @override
  _HideStorylyPageState createState() => _HideStorylyPageState();
}

class _HideStorylyPageState extends State<HideStorylyPage> {
  bool storylyVisible = true;
  bool storylyLoaded = false;

  void onStorylyLoaded(List<dynamic> storyGroupList, String dataSource) {
    if (!storylyVisible && storyGroupList.isNotEmpty) {
      storylyLoaded = true;
    }
  }

  void onStorylyLoadFailed(String err) {
    if (!storylyLoaded && storylyVisible) {
      setState(() {
        storylyVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(height: 120, color: const Color(0xFF00E0E4)),
            Container(height: 120, color: const Color(0xFF242450)),
            Visibility(
              visible: storylyVisible,
              maintainState: true,
              child: SizedBox(
                height: 120,
                child: StorylyView(
                  androidParam: StorylyParam()..storylyId = Constants.storylyId,
                  iosParam: StorylyParam()..storylyId = Constants.storylyId,
                  storylyLoaded: onStorylyLoaded,
                  storylyLoadFailed: onStorylyLoadFailed,
                ),
              ),
            ),
            Container(height: 120, color: const Color(0xFFBDBDCB)),
            Container(height: 120, color: const Color(0xFFFFCB00)),
          ],
        ),
      ),
    );
  }
}
