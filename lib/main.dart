import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indieflow/models/character.dart';
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

void main() {
  runApp(IndieFlowApp());
}

class IndieFlowApp extends StatelessWidget {
  
  IndieFlowApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppConstants.routesPath.characters,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppConstants.routesPath.characters,
                builder: (BuildContext context, GoRouterState state) => CharactersScreen(detailsPath: "${AppConstants.routesPath.characters}/${AppConstants.routesPath.characterDetails}"),
                routes: <RouteBase>[
                  GoRoute(
                    path: AppConstants.routesPath.characterDetails,
                    pageBuilder: (context, state) {

                      ListItem listItem;

                      if (state.extra.runtimeType == ListItem) {
                        listItem = state.extra as ListItem;
                      } else {
                        Map<String,dynamic> map = state.extra as Map<String,dynamic>;
                        final json = map['character'] ;
                        Character character = Character.fromJson(json);
                        listItem = ListItem(identifier: character.identifier, character: character, colorScheme: ColorSchemes.getColorSchemes().randomElement()!);
                      }

                      return MaterialPage(
                        key: state.pageKey,
                        child: CharacterDetailsScreen(listItem: listItem),
                      );
                    },
                    
                  ),
                  GoRoute(
                    path: AppConstants.routesPath.filter,
                    pageBuilder: (context, state) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: const FilterChipDisplay(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          
          StatefulShellBranch(
            
            routes: <RouteBase>[
              GoRoute(
                path: AppConstants.routesPath.charts,
                builder: (BuildContext context, GoRouterState state) => const ChartsScreen(),
               
              ),
            ],
          ),

        ],
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
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Characters'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Charts'),
        ],
        currentIndex: navigationShell.currentIndex,

        onTap: (int index) => navigationShell.goBranch(index),
      ),
    );
  }

  void onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
