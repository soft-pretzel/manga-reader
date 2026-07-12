import 'package:flutter/material.dart';

import 'ui/screens/home/home_view.dart';
import 'ui/screens/library/library_view.dart';
import 'ui/screens/settings/settings_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga Reader',
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: <AppBar>[
        AppBar(title: Text('Home')),
        AppBar(title: Text('Library')),
        AppBar(title: Text('Settings')),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.folder), label: 'Library'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body: <Widget>[
        HomeView(),
        LibraryView(),
        SettingsView(),
      ][currentPageIndex],
    );
  }
}
