import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../data/services/database/tables.dart';
import '../library_view_model.dart';

class AddServer extends StatefulWidget {
  const new({super.key, required this.context, required this.viewModel});

  final BuildContext context;
  final LibraryViewModel viewModel;

  @override
  State<AddServer> createState() => _AddServerState();
}

class _AddServerState extends State<AddServer> {
  final _apiKey = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  ServerType? _type;
  final _url = TextEditingController();
  final _username = TextEditingController();

  @override
  void dispose() {
    _apiKey.dispose();
    _name.dispose();
    _password.dispose();
    _url.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        spacing: 16,
        children: [
          LayoutBuilder(
            builder: (_, constraints) {
              return DropdownMenu(
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: ServerType.kavita, label: 'Kavita'),
                  DropdownMenuEntry(value: ServerType.opds, label: 'OPDS'),
                  DropdownMenuEntry(value: ServerType.stump, label: 'Stump'),
                ],
                label: Text('Server type'),
                onSelected: (value) {
                  setState(() {
                    _type = value;
                  });
                },
                width: constraints.maxWidth,
              );
            },
          ),
          TextField(
            controller: _name,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Name'),
            ),
          ),
          TextField(
            controller: _url,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Server URL'),
            ),
          ),
          TextField(
            controller: _apiKey,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('API key'),
            ),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              if (_apiKey.value.text.isEmpty ||
                  _name.value.text.isEmpty ||
                  _type == null ||
                  _url.value.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Missing required fields')),
                );
              } else {
                widget.viewModel.addServer.execute((
                  _apiKey.value.text,
                  _name.value.text,
                  _type!,
                  _url.value.text,
                ));
                context.pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
