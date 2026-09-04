import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import 'widgets/card_list.dart';
import 'widgets/card_tile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Settings')),
        CardList(
          children: [
            CardTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('General'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                context.pushNamed(RouteNames.generalSettings);
              },
            ),
            CardTile(
              leading: Icon(Icons.folder_outlined),
              title: Text('Local Storage'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                context.pushNamed(RouteNames.storageSettings);
              },
            ),
            CardTile(
              leading: Icon(Icons.palette_outlined),
              title: Text('Appearance'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                context.pushNamed(RouteNames.appearanceSettings);
              },
            ),
            CardTile(
              leading: Icon(Icons.menu_book_outlined),
              title: Text('Reader'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                context.pushNamed(RouteNames.readerSettings);
              },
            ),
          ],
        ),
      ],
    );
  }
}
