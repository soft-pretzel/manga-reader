import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import '../ui/screens/home/home_view.dart';
import '../ui/screens/home/home_view_model.dart';
import '../ui/screens/library/library_view_model.dart';
import '../ui/screens/library/library_view.dart';
import '../ui/screens/reader/reader_view.dart';
import '../ui/screens/reader/reader_view_model.dart';
import '../ui/screens/settings/settings_view.dart';
import '../ui/widgets/scaffold_with_navigation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _libraryNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'library');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

final router = GoRouter(
  initialLocation: RoutePaths.home,
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              name: RouteNames.home,
              path: RoutePaths.home,
              builder: (context, state) {
                final viewModel = HomeViewModel(
                  libraryRepository: context.read(),
                );
                return HomeView(viewModel: viewModel);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _libraryNavigatorKey,
          routes: [
            GoRoute(
              name: RouteNames.library,
              path: RoutePaths.library,
              builder: (context, state) {
                final viewModel = LibraryViewModel(
                  libraryRepository: context.read(),
                );
                return LibraryView(viewModel: viewModel);
              },
              routes: [
                GoRoute(
                  name: RouteNames.folder,
                  path: RoutePaths.folder,
                  builder: (context, state) {
                    final viewModel = LibraryViewModel(
                      folderId: state.pathParameters['folderId'],
                      libraryRepository: context.read(),
                    );
                    return LibraryView(viewModel: viewModel);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              name: RouteNames.settings,
              path: RoutePaths.settings,
              builder: (context, state) {
                return SettingsView();
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: RouteNames.reader,
      path: RoutePaths.reader,
      builder: (context, state) {
        final viewModel = ReaderViewModel(
          bookId: state.pathParameters['bookId']!,
          libraryRepository: context.read(),
        );
        return ReaderView(viewModel: viewModel);
      },
    ),
  ],
);
