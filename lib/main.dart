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
          colorSchemeSeed: themeProvider.themeColor,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: themeProvider.themeColor,
        ),
        themeMode: themeProvider.themeMode,
        routerConfig: router,
      ),
    );
  }
}
