import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import '../ui/screens/home/home_view.dart';
import '../ui/screens/library/library_view.dart';
import '../ui/screens/library/library_view_model.dart';
import '../ui/screens/reader/reader_view.dart';
import '../ui/screens/reader/reader_view_model.dart';
import '../ui/screens/settings/settings_view.dart';
import '../ui/widgets/scaffold_with_nested_navigation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _libraryNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'library');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

final router = GoRouter(
  initialLocation: Routes.home,
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) {
                return HomeView();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _libraryNavigatorKey,
          routes: [
            GoRoute(
              path: Routes.library,
              builder: (context, state) {
                final viewModel = LibraryViewModel(
                  libraryRepository: context.read(),
                );
                return LibraryView(viewModel: viewModel);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (context, state) {
                return SettingsView();
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.reader,
      builder: (context, state) {
        final viewModel = ReaderViewModel(libraryRepository: context.read());
        return ReaderView(viewModel: viewModel);
      },
    ),
  ],
);
