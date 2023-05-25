import 'package:flutter/material.dart';
import 'package:storyly_demo/constants.dart';
import 'package:storyly_flutter/storyly_flutter.dart';

class ShowStorylyPage extends StatefulWidget {
  const ShowStorylyPage({Key? key}) : super(key: key);

  @override
  _ShowStorylyPageState createState() => _ShowStorylyPageState();
}

class _ShowStorylyPageState extends State<ShowStorylyPage> {
  bool storylyVisible = false;

  void onStorylyLoaded(List<dynamic> storyGroupList, String dataSource) {
    debugPrint("storylyLoaded");
    if (!storylyVisible) {
      setState(() {
        storylyVisible = true;
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
