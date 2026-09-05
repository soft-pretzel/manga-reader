import 'package:flutter/material.dart';

import '../widgets/card_list.dart';
import '../widgets/card_tile.dart';
import 'storage_settings_view_model.dart';

class StorageSettingsView extends StatelessWidget {
  const StorageSettingsView({super.key, required this.viewModel});

  final StorageSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text("Local Storage")),
        Expanded(
          child: RefreshIndicator(
            onRefresh: viewModel.refresh.execute,
            child: CardList(
              children: [
                CardTile(
                  title: Text('Local folder'),
                  subtitle: LoadFolder(viewModel: viewModel),
                  trailing: IconButton(
                    onPressed: viewModel.setFolder.execute,
                    icon: Icon(Icons.edit),
                  ),
                ),
                CardTile(
                  title: Text('Cache size'),
                  trailing: LoadCacheSize(viewModel: viewModel),
                ),
                CardTile(
                  title: Text('Database size'),
                  trailing: LoadDbInfo(viewModel: viewModel),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LoadFolder extends StatefulWidget {
  const LoadFolder({super.key, required this.viewModel});

  final StorageSettingsViewModel viewModel;

  @override
  State<LoadFolder> createState() => _LoadFolderState();
}

class _LoadFolderState extends State<LoadFolder> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.loadFolder.running) {
          return SizedBox.shrink();
        }
        if (widget.viewModel.loadFolder.error) {
          return IconButton(
            onPressed: () => widget.viewModel.loadFolder.execute(),
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return Text(
          widget.viewModel.folder ?? 'No folder selected',
          style: Theme.of(context).textTheme.bodyMedium,
        );
      },
    );
  }
}

class LoadCacheSize extends StatefulWidget {
  const LoadCacheSize({super.key, required this.viewModel});

  final StorageSettingsViewModel viewModel;

  @override
  State<LoadCacheSize> createState() => _LoadCacheSizeState();
}

class _LoadCacheSizeState extends State<LoadCacheSize> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.loadCacheSize.running) {
          return SizedBox.shrink();
        }
        if (widget.viewModel.loadCacheSize.error) {
          return IconButton(
            onPressed: () => widget.viewModel.loadCacheSize.execute(),
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return Text(
          widget.viewModel.cacheSize,
          style: Theme.of(context).textTheme.bodyMedium,
        );
      },
    );
  }
}

class LoadDbInfo extends StatefulWidget {
  const LoadDbInfo({super.key, required this.viewModel});

  final StorageSettingsViewModel viewModel;

  @override
  State<LoadDbInfo> createState() => _LoadDbInfoState();
}

class _LoadDbInfoState extends State<LoadDbInfo> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.loadDatabaseSize.running) {
          return SizedBox.shrink();
        }
        if (widget.viewModel.loadDatabaseSize.error) {
          return IconButton(
            onPressed: () => widget.viewModel.loadDatabaseSize.execute(),
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return Text(
          widget.viewModel.dbSize,
          style: Theme.of(context).textTheme.bodyMedium,
        );
      },
    );
  }
}
