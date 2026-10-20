import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavigation extends StatelessWidget {
  const ScaffoldWithNavigation({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey('ScaffoldWithNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) async {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Library'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        maintainBottomViewPadding: true,
        onDestinationSelected: _goBranch,
        selectedIndex: navigationShell.currentIndex,
      ),
    );
  }
}
