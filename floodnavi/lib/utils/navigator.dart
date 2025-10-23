import 'package:flutter/material.dart';

class TabNavigatorPage extends StatelessWidget {
  final Widget page;
  final Key navigatorKey;

  const TabNavigatorPage({
    required this.navigatorKey,
    required this.page,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }
}
