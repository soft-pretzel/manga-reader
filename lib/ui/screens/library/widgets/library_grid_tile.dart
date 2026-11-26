import 'package:material_ui/material_ui.dart';

import '../library_view_model.dart';

class LibraryGridTile extends StatelessWidget {
  const new({
    super.key,
    this.cover,
    required this.name,
    required this.viewModel,
  });

  final String? cover;
  final String name;
  final LibraryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: .bottomCenter,
            child: Card(child: SizedBox.expand()),
          ),
        ),
        Padding(
          padding: const .only(top: 6),
          child: Column(
            children: [
              RichText(
                maxLines: 1,
                overflow: .ellipsis,
                text: TextSpan(text: name),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
