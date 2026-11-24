import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../library_view_model.dart';

class AddLibrary extends StatelessWidget {
  final BuildContext context;
  final LibraryViewModel viewModel;

  const AddLibrary({required this.context, super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        spacing: 0,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.folder_outlined),
            label: Align(alignment: .centerStart, child: Text('Local folder')),
            onPressed: () async {
              await viewModel.addLocalFolder.execute();
              if (context.mounted) {
                context.pop();
              }
            },
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.dns_rounded),
            label: Align(alignment: .centerStart, child: Text('Kavita server')),
            onPressed: () {
              context.pop();
              showModalBottomSheet(
                backgroundColor: ColorScheme.of(context).surfaceDim,
                builder: (context) {
                  return Padding(
                    padding: const .fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      mainAxisSize: .min,
                      spacing: 16,
                      children: [
                        TextField(
                          autofocus: true,
                          controller: viewModel.kavitaNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Name'),
                          ),
                        ),
                        TextField(
                          autofocus: true,
                          controller: viewModel.kavitaUrlController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Server URL'),
                          ),
                        ),
                        TextField(
                          controller: viewModel.kavitaApiKeyController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('API key'),
                          ),
                          obscureText: true,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            viewModel.saveKavitaServer.execute();
                            context.pop();
                          },

                          child: Text('Save'),
                        ),
                      ],
                    ),
                  );
                },
                context: context,
                showDragHandle: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
