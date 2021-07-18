import 'package:flutter/cupertino.dart';
import 'main_view_model.dart';

class MainCupertinoApp extends StatelessWidget {
  const MainCupertinoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => CupertinoApp(home: _HomePage());
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = MainViewModel();
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: viewModel.tabBarItems),
      tabBuilder: (context, index) =>
          Center(child: viewModel.cupertinoTabScreen(index)),
    );
  }
}
