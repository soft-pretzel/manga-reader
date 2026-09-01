import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import '../ui/screens/settings/appearance/appearance_settings_view.dart';
import '../ui/screens/settings/appearance/appearance_settings_view_model.dart';
import '../ui/screens/settings/general/general_settings_view.dart';
import '../ui/screens/settings/general/general_settings_view_model.dart';
import '../ui/screens/settings/reader/reader_settings_view.dart';
import '../ui/screens/settings/reader/reader_settings_view_model.dart';
import '../ui/screens/settings/storage/storage_settings_view.dart';
import '../ui/screens/settings/storage/storage_settings_view_model.dart';
import '../ui/screens/home/home_view.dart';
import '../ui/screens/home/home_view_model.dart';
import '../ui/screens/library/library_view_model.dart';
import '../ui/screens/library/library_view.dart';
import '../ui/screens/reader/reader_view.dart';
import '../ui/screens/reader/reader_view_model.dart';
import '../ui/screens/settings/settings_view.dart';
import '../ui/screens/settings/settings_view_model.dart';
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
                  settingsRepository: context.read(),
                );
                return LibraryView(viewModel: viewModel);
              },
              routes: [
                GoRoute(
                  name: RouteNames.series,
                  path: RoutePaths.series,
                  builder: (context, state) {
                    final viewModel = LibraryViewModel(
                      seriesId: state.pathParameters['seriesId'],
                      libraryRepository: context.read(),
                      settingsRepository: context.read(),
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
                final viewModel = SettingsViewModel(
                  settingsRepository: context.read(),
                );
                return SettingsView(viewModel: viewModel);
              },
              routes: [
                GoRoute(
                  name: RouteNames.generalSettings,
                  path: RoutePaths.generalSettings,
                  builder: (context, state) {
                    final viewModel = GeneralSettingsViewModel(
                      settingsRepository: context.read(),
                    );
                    return GeneralSettingsView(viewModel: viewModel);
                  },
                ),
                GoRoute(
                  name: RouteNames.storageSettings,
                  path: RoutePaths.storageSettings,
                  builder: (context, state) {
                    final viewModel = StorageSettingsViewModel(
                      settingsRepository: context.read(),
                    );
                    return StorageSettingsView(viewModel: viewModel);
                  },
                ),
                GoRoute(
                  name: RouteNames.appearanceSettings,
                  path: RoutePaths.appearanceSettings,
                  builder: (context, state) {
                    final viewModel = AppearanceSettingsViewModel(
                      themeProvider: context.read(),
                      settingsRepository: context.read(),
                    );
                    return AppearanceSettingsView(viewModel: viewModel);
                  },
                ),
                GoRoute(
                  name: RouteNames.readerSettings,
                  path: RoutePaths.readerSettings,
                  builder: (context, state) {
                    final viewModel = ReaderSettingsViewModel(
                      settingsRepository: context.read(),
                    );
                    return ReaderSettingsView(viewModel: viewModel);
                  },
                ),
              ],
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
          settingsRepository: context.read(),
        );
        return ReaderView(viewModel: viewModel);
      },
    ),
  ],
);
