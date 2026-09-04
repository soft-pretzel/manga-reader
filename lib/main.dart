import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/providers.dart';
import 'routing/router.dart';
import 'ui/themes/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: providers,
      child: MaterialApp.router(
        theme: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: themeProvider.color,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: themeProvider.color,
            surface: (themeProvider.oledDarkMode) ? Colors.black : null,
          ),
        ),
        themeMode: themeProvider.mode,
        routerConfig: router,
      ),
    );
  }
}
