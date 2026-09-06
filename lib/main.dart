import 'package:dynamic_color/dynamic_color.dart';
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
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;
          if (lightDynamic != null &&
              darkDynamic != null &&
              themeProvider.dynamicMode) {
            lightColorScheme = lightDynamic.harmonized() as ColorScheme;
            darkColorScheme = darkDynamic.harmonized() as ColorScheme;
          } else {
            lightColorScheme = ColorScheme.fromSeed(
              seedColor: themeProvider.color,
            );
            darkColorScheme = ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: themeProvider.color,
            );
          }
          if (themeProvider.oledDarkMode) {
            darkColorScheme = darkColorScheme.copyWith(surface: Colors.black);
          }
          return MaterialApp.router(
            theme: ThemeData(colorScheme: lightColorScheme),
            darkTheme: ThemeData(colorScheme: darkColorScheme),
            themeMode: themeProvider.mode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
