import 'package:almaty_metro/pages/route_timer_page.dart';
import 'package:almaty_metro/widgets/content_page/bottom_panel_new.dart';
import 'package:flutter/material.dart';
/*
class AppContentPage extends StatefulWidget {
  @override
  _AppContentPageState createState() => _AppContentPageState();
}

class _AppContentPageState extends State<AppContentPage> {
  PageController pageViewController;
  int initialPage = 0;
  double currentPageAnimationValue = 0;

  int _departureStationIndex = 0;
  int _arrivalStationIndex = 8;

  List<Widget> pages;

  Widget _createRouteTimePage() {
    return RouteTimerPage(
      departureStationIndex: _departureStationIndex,
      arrivalStationIndex: _arrivalStationIndex,
    );
  }

  Widget _createArrivalsPage() {
    return ArrivalsPage(
      departureStationIndex: _departureStationIndex,
      arrivalStationIndex: _arrivalStationIndex,
    );
  }

  @override
  void initState() {
    pageViewController = PageController(keepPage: true, initialPage: 0);

    pageViewController.addListener(() {
      setState(() {
        currentPageAnimationValue = pageViewController.page;
      });
    });

    pages = [
      _createRouteTimePage(),
      _createArrivalsPage(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: PageView(
            controller: pageViewController,
            physics: BouncingScrollPhysics(),
            children: pages,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: BottomPanelNew(),
        ),
      ],
    );
  }
}
*/

class AppContentPage extends StatefulWidget {
  @override
  _AppContentPageState createState() => _AppContentPageState();
}

class _AppContentPageState extends State<AppContentPage> {
  int _stationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: RouteTimerPage(
            stationIndex: _stationIndex,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: BottomPanelNew(
            onStationIndexChange: (index) => setState(() => _stationIndex = index),
          ),
        ),
      ],
    );
  }
}
