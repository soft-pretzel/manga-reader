import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home/home_view_model.dart';
import 'library/library_view_model.dart';

class MainView extends StatelessWidget {
  const MainView({
    Key? key,
    required this.navigationShell,
    required this.homeViewModel,
    required this.libraryViewModel,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;
  final HomeViewModel homeViewModel;
  final LibraryViewModel libraryViewModel;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    if (index == 0) {
      homeViewModel.load.execute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: <AppBar>[
        AppBar(title: Text('Home')),
        AppBar(title: Text('Library')),
        AppBar(title: Text('Settings')),
      ][navigationShell.currentIndex],
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.folder), label: 'Library'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: <FloatingActionButton?>[
        null,
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            libraryViewModel.addFolder.execute();
          },
        ),
        null,
      ][navigationShell.currentIndex],
    );
  }
}
