import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Settings')),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Card(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.all(0),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Icon(Icons.settings_outlined),
                      title: Text('General'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        context.pushNamed(RouteNames.generalSettings);
                      },
                    ),
                    Divider(height: 0),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Icon(Icons.folder_outlined),
                      title: Text('Local Storage'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        context.pushNamed(RouteNames.storageSettings);
                      },
                    ),
                    Divider(height: 0),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Icon(Icons.palette_outlined),
                      title: Text('Appearance'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        context.pushNamed(RouteNames.appearanceSettings);
                      },
                    ),
                    Divider(height: 0),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Icon(Icons.menu_book_outlined),
                      title: Text('Reader'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        context.pushNamed(RouteNames.readerSettings);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
