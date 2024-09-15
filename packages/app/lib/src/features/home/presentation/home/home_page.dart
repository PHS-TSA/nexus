import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../app/router.gr.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      //Loads in feed and passes whether or not it's a local or global feed. Have navigation bar in here
      routes: const [
        LocalFeedRoute(),
        WorldFeedRoute(),
      ],
      appBarBuilder: (context, tabsRouter) {
        // obtain the scoped TabsRouter controller using context
        final tabsRouter = AutoTabsRouter.of(context);
        // Here we're building our Scaffold inside of AutoTabsRouter
        // to access the tabsRouter controller provided in this context
        //
        // alternatively, you could use a global key
        return AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(24),
            child: NavigationBar(
              selectedIndex: tabsRouter.activeIndex,
              onDestinationSelected: tabsRouter.setActiveIndex,
              destinations: const [
                NavigationDestination(
                  label: 'Local',
                  icon: Icon(Icons.my_location),
                ),
                NavigationDestination(
                  label: 'World',
                  icon: Icon(Icons.public),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
