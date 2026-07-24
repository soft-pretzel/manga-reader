import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import '../ui/screens/main/home/home_view.dart';
import '../ui/screens/main/home/home_view_model.dart';
import '../ui/screens/main/library/library_view.dart';
import '../ui/screens/main/library/library_view_model.dart';
import '../ui/screens/reader/reader_view.dart';
import '../ui/screens/reader/reader_view_model.dart';
import '../ui/screens/main/settings/settings_view.dart';
import '../ui/screens/main/main_view.dart';

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
        final homeViewModel = HomeViewModel(libraryRepository: context.read());
        final libraryViewModel = LibraryViewModel(
          libraryRepository: context.read(),
        );
        return MainView(
          navigationShell: navigationShell,
          homeViewModel: homeViewModel,
          libraryViewModel: libraryViewModel,
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: Routes.home,
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
