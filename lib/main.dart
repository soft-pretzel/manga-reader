import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/services/file_picker_service.dart';
import 'data/services/shared_preferences_service.dart';
import 'data/repositories/library_repository.dart';
import 'ui/screens/library/library_view_model.dart';
import 'ui/screens/library/library_view.dart';
import 'ui/screens/home/home_view.dart';
import 'ui/screens/settings/settings_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => FilePickerService()),
        Provider(create: (context) => SharedPreferencesService()),
        Provider(
          create: (context) => LibraryRepository(
            filePickerService: context.read(),
            sharedPreferencesService: context.read(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Manga Reader',
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.system,
        home: MainApp(),
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

  final List<NavigationDestination> _destinations = [
    NavigationDestination(icon: Icon(Icons.menu_book), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.folder), label: 'Library'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  final List<Widget> _body = [
    HomeView(),
    LibraryView(
      viewModel: LibraryViewModel(
        libraryRepository: LibraryRepository(
          filePickerService: FilePickerService(),
          sharedPreferencesService: SharedPreferencesService(),
        ),
      ),
    ),
    SettingsView(),
  ];

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
        destinations: _destinations,
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: _onPageChanged,
        children: _body,
      ),
    );
  }
}
