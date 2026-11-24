import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../data/models/opds_entry.dart';
import '../../../../routing/routes.dart';
import '../library_view_model.dart';

class OpdsEntryGridTile extends StatelessWidget {
  final OpdsEntry entry;
  final int index;
  final LibraryViewModel viewModel;

  const new({
    super.key,
    required this.entry,
    required this.index,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: .bottomCenter,
            child: GestureDetector(
              onTap: () {
                if (entry.entry.links
                    .where((link) => link.rel!.contains('acquisition'))
                    .isNotEmpty) {
                  context.pushNamed(RouteNames.reader);
                } else {
                  context.pushNamed(
                    RouteNames.opdsEntry,
                    pathParameters: {
                      'opdsId': entry.parentId,
                      'path': entry.entry.links.first.href,
                    },
                  );
                }
              },
              child: Card(margin: .all(0), child: SizedBox.expand()),
            ),
          ),
        ),
        Padding(
          padding: .only(
            top: viewModel.librarySpacing == .comfortable
                ? 8
                : viewModel.librarySpacing == .normal
                ? 6
                : 4,
          ),
          child: SizedBox(
            width: .infinity,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: .ellipsis,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    text: entry.entry.title,
                  ),
                ),
                // RichText(
                //   maxLines: 1,
                //   overflow: .ellipsis,
                //   text: TextSpan(
                //     style: DefaultTextStyle.of(context).style
                //         .apply(color: ColorScheme.of(context).outline),
                //     text: server.feed!.entries.isNotEmpty
                //         ? server.feed!.entries.length == 1
                //               ? '${server.feed!.entries.length} entry'
                //               : '${server.feed!.entries.length} entries'
                //         : null,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
