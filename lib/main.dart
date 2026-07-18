import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/providers.dart';
import 'ui/screens/home/home_view.dart';
import 'ui/screens/library/library_view.dart';
import 'ui/screens/library/library_view_model.dart';
import 'ui/screens/settings/settings_view.dart';

void main() {
  runApp(
    MaterialApp(
      home: MultiProvider(
        providers: providers,
        child: MaterialApp(
          title: 'Manga Reader',
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
          home: MainApp(),
        ),
      ),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  final PageController _controller = PageController();

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _controller.animateToPage(
      index,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onDestinationSelected,
        selectedIndex: _selectedIndex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.folder), label: 'Library'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: _onPageChanged,
        children: [
          HomeView(),
          LibraryView(
            viewModel: LibraryViewModel(libraryRepository: context.read()),
          ),
          SettingsView(),
        ],
      ),
    );
  }
}
