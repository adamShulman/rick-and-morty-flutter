import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indieflow/models/list_item.dart';
import 'package:indieflow/screens/character_details/character_details_screen.dart';
import 'package:indieflow/screens/characters/characters_screen.dart';
import 'package:indieflow/screens/charts/charts_screen.dart';
import 'package:indieflow/screens/filter/filter_screen.dart';
import 'package:indieflow/utils/constants.dart';
import 'package:indieflow/utils/extensions.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

// This example demonstrates how to setup nested navigation using a
// BottomNavigationBar, where each bar item uses its own persistent navigator,
// i.e. navigation state is maintained separately for each item. This setup also
// enables deep linking into nested pages.
//
// This example also demonstrates how build a nested shell with a custom
// container for the branch Navigators (in this case a TabBarView).

void main() {
  runApp(IndieFlowApp());
}

/// An example demonstrating how to use nested navigators
class IndieFlowApp extends StatelessWidget {
  /// Creates a NestedTabNavigationExampleApp
  IndieFlowApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppConstants.routesPath.characters,
    routes: <RouteBase>[
      // #docregion configuration-builder
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          // Return the widget that implements the custom shell (in this case
          // using a BottomNavigationBar). The StatefulNavigationShell is passed
          // to be able access the state of the shell and to navigate to other
          // branches in a stateful way.
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        // #enddocregion configuration-builder
        // #docregion configuration-branches
        branches: <StatefulShellBranch>[
          // The route branch for the first tab of the bottom navigation bar.
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the first tab of the
                // bottom navigation bar.
                path: AppConstants.routesPath.characters,
                builder: (BuildContext context, GoRouterState state) => CharactersScreen(detailsPath: "${AppConstants.routesPath.characters}/${AppConstants.routesPath.characterDetails}"),
                    //  const RootScreen(label: 'A', detailsPath: '/a/details'),
                routes: <RouteBase>[
                  // The details screen to display stacked on navigator of the
                  // first tab. This will cover screen A but not the application
                  // shell (bottom navigation bar).
                  GoRoute(
                    pageBuilder: (context, state) {
                      ListItem listItem = state.extra as ListItem;
                      return MaterialPage(
                        key: state.pageKey,
                        child: CharacterDetailsScreen(listItem: listItem),
                      );
                    },
                    path: AppConstants.routesPath.characterDetails,
                    // builder: (BuildContext context, GoRouterState state) => const 
                    //     const DetailsScreen(label: 'A'),
                  ),
                ],
              ),
            ],
          ),
          // #enddocregion configuration-branches

          // The route branch for the second tab of the bottom navigation bar.
          StatefulShellBranch(
            // It's not necessary to provide a navigatorKey if it isn't also
            // needed elsewhere. If not provided, a default key will be used.
            routes: <RouteBase>[
              GoRoute(
                // The screen to display as the root in the second tab of the
                // bottom navigation bar.
                path: '/b',
                builder: (BuildContext context, GoRouterState state) => const ChartsScreen(),
               
              ),
            ],
          ),

        ],
      ),
      GoRoute(
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const FilterChipDisplay(),
          );
        },
        path: AppConstants.routesPath.filter,
        // builder: (BuildContext context, GoRouterState state) => const 
        //     const DetailsScreen(label: 'A'),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "IndieFlow",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.contentColorP,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: AppColors.contentColorP,
      ),
      themeMode: ThemeMode.dark,
      routerConfig: _router,
      scaffoldMessengerKey: AppConstants.scaffoldMessengerKey,
    );
  }
}

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  // #docregion configuration-custom-shell
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The StatefulNavigationShell from the associated StatefulShellRoute is
      // directly passed as the body of the Scaffold.
      body: kIsWeb 
      ? Center(
          child: ClipRect(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500.0
              ),
              
              child: navigationShell,
            ),
          ),
        )
      : navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        // Here, the items of BottomNavigationBar are hard coded. In a real
        // world scenario, the items would most likely be generated from the
        // branches of the shell route, which can be fetched using
        // `navigationShell.route.branches`.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Characters'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Charts'),
        ],
        currentIndex: navigationShell.currentIndex,
        // Navigate to the current location of the branch at the provided index
        // when tapping an item in the BottomNavigationBar.
        onTap: (int index) => navigationShell.goBranch(index),
      ),
    );
  }
  // #enddocregion configuration-custom-shell

  /// NOTE: For a slightly more sophisticated branch switching, change the onTap
  /// handler on the BottomNavigationBar above to the following:
  /// `onTap: (int index) => _onTap(context, index),`
  // ignore: unused_element
  void _onTap(BuildContext context, int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
